/**
 * ACC_AccountTaskUpdate
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
public class ACC_AccountTaskUpdate {

    /**
     * ToDoの情報を取引先に設定
     * @param tskNewList ToDoリスト(トリガー無効データ除くtrriger.new)
     * @param tskOldList ToDoリスト(トリガー無効データ除くtrriger.old)
     * @param tskNewMap  ToDoマップ(トリガー無効データ除くtrriger.newMap)
     * @param tskOldMap  ToDoマップ(トリガー無効データ除くtrriger.oldMap)
     */
    public void updateTaskInfo(List<Task> tskNewList, List<Task> tskOldList, Map<Id, Task> tskNewMap,
        Map<Id, Task> tskOldMap) {

        if (tskNewList.isEmpty()) return;

        Set<String> taskAccIdSet = new Set<String>();
        for (Task tsk : tskNewList) {
            if (tsk.AccountId != null && !taskAccIdSet.contains(tsk.AccountId)) {
                taskAccIdSet.add(tsk.AccountId);
            }
        }

        // 登録済み未完了ToDo取得
        Map<Id, Task> taskMap = new Map<Id, Task>();
        if (!taskAccIdSet.isEmpty()) {
            List<Task> taskList = [SELECT Id, AccountId, ActivityDate, Field3__c, Subject FROM Task WHERE ActivityDate != null AND Status != '完了' AND What.type = 'Account' AND AccountId IN :taskAccIdSet ORDER BY ActivityDate DESC];
            for (Task tsk : taskList) {
                taskMap.put(tsk.AccountId, tsk);
            }
        }

        Map<Id, Account> accUpdateMap = new Map<Id, Account>();
        String keyPrefix = User.sObjectType.getDescribe().getKeyPrefix();

		List<RecordType> recordTypeList = [select Name, DeveloperName, Id from RecordType where SobjectType='Task' and DeveloperName in ('CRS', 'CRS_DCS')];

        for (Task newTask : tskNewList) {
            // 活動履歴登録・更新で取引先項目更新
            // 新規の場合は更新、更新の場合は変更があれば更新
            if (newTask.AccountId != null) {
                Account acc = new Account(Id = newTask.AccountId);
                boolean upFlg = false;
                system.debug('***** newTask.status : ' + newTask.status);
                if ('完了'.equals(newTask.Status)) {
                    finishTaskProcess(newTask, acc, taskMap, keyPrefix, recordTypeList);
                    upFlg = true;
                }
                if (upFlg) {
                    accUpdateMap.put(acc.Id, acc);
                }
            }
        }

        if (!accUpdateMap.isEmpty()) {
            UTL_TriggerUtil.canRunAccount = false;
            update accUpdateMap.values();
        }

    }

    /**
     * 登録済み完了ToDoから、連絡先を取得できた担当者の取引先担当者引き当ておよび取引先担当者作成
     * @param tskNewList ToDoリスト(トリガー無効データ除くtrriger.new)
     * @param tskNewMap  ToDoマップ(トリガー無効データ除くtrriger.newMap)
     */
    public void insertContactFromFinishedTask(List<Task> tskNewList, Map<Id, Task> tskNewMap) {

        if (tskNewList.isEmpty()) return;

        Set<String> taskAccIdSet = new Set<String>();
        List<Task> taskList = new List<Task>();
        for (Task tsk : tskNewList) {
            if (String.isNotBlank(tsk.AccountId) && String.isNotBlank(tsk.WhatId)
                && tsk.WhatId.equals(tsk.AccountId) && String.isNotBlank(tsk.OwnerId)
                && String.isNotBlank(tsk.tanto__c) && tsk.Status.equals('完了')
                && (String.isNotBlank(tsk.Get_Email__c) || String.isNotBlank(tsk.Get_Phone__c)) ) {
                if (!taskAccIdSet.contains(tsk.AccountId)){
                    taskAccIdSet.add(tsk.AccountId);
                }
                taskList.add(tsk);
                system.debug('taskList.size()='+taskList.size()+'  **********************************');
            }
        }

        system.debug('finished: taskList.add() *****************************');

        // 登録済み完了ToDoのAccountIdに関連している取引先担当者を取得
        List<Contact> contactList = new List<Contact>();
        if (!taskAccIdSet.isEmpty()){
            contactList = [SELECT AccountId, LastName, Email, Phone FROM Contact WHERE (Email != null OR Phone != null) AND AccountId IN :taskAccIdSet order by CreatedDate desc];
            system.debug('contactList.size()='+contactList.size());
        }

        system.debug('finished: query to get contact list  ************************************');

        // 完了ToDoと取引先担当者におけるメールアドレス一致または電話番号一致かつ重複登録フラグがOFFの時、アラート表示して中断する
        // 上記条件かつ登録フラグがONの場合はアラート表示せずに保存をする
        // ToDoの担当者情報と取引先担当者の重複チェック
        List<Contact> upsertContactList = new List<Contact>();
        if (!taskList.isEmpty()){
            for (Task t : taskList){
                Boolean dupFlag = false;
                String cId = '';
                if (!contactList.isEmpty()){
                    for (Contact c : contactList){
                        if (t.AccountId.equals(c.AccountId)){
                            if (dupFlag == false){
                                dupFlag = duplicateCheckTaskAndContact(t, c);
                            }else if (dupFlag == true){
                                cId = c.Id;
                            }
                            system.debug('*******************  cId='+cId);
                        }
                    }
                }
                upsertContactList.add(convertTaskToContact(t, dupFlag, cId));
            }
        }
        system.debug('upsertContactList.size()='+upsertContactList.size()+'  **********************************');
        upsert upsertContactList;
        system.debug('finished: upsertContactList  ***************************************');

    }


    /**
     * 状況が完了の場合の処理
     * @param newTask ToDo
     * @param acc 取引先
     * @param taskMap 未完了ToDoマップ
     * @param keyPrefix ユーザオブジェクトのキープレフィックス(005)
     */
    private void finishTaskProcess(Task newTask, Account acc, Map<Id, Task> taskMap, String keyPrefix, List<RecordType> recordTypeList) {

        Date actionDate = newTask.action_time__c != null ? newTask.action_time__c.date() : null;
        String newType = newTask.type != null ? newTask.type : '';

        Id recordTypeIdCrs;
        Id recordTypeIdCrsDcs;
        for (RecordType recordType : recordTypeList) {
            if (recordType.DeveloperName == 'CRS') {
                recordTypeIdCrs = recordType.Id;
            } else if (recordType.DeveloperName == 'CRS_DCS') {
                recordTypeIdCrsDcs = recordType.Id;
            }
        }


        // CRS_直近活動日（不在除く）
        // 不在フラグON＆コール結果「（GKブロック）断られた」を除く、最新の活動日
        if (!newTask.huzai_flag__c && !(String.isNotBlank(newTask.call__c) && newTask.call__c.equals('（GKブロック）断られた')) && String.isNotBlank(newTask.call__c)
                && recordTypeIdCrs == newTask.RecordTypeId) {
            acc.CrsLastTodoDatetime__c = newTask.action_time__c;
            system.debug('***** newTask.Field3__c : ' + newTask.Field3__c + '|' + newTask.Id);
            if (String.isNotBlank(newTask.Field3__c)) {
                acc.CrsLastSalesActivities__c = newTask.Field3__c;
            } else {
                acc.CrsLastSalesActivities__c = null;
            }
            system.debug('***** newTask.Owner.Id : ' + newTask.Owner.Id);
            String tskOwnerId = newTask.OwnerId;
            if (String.isNotBlank(tskOwnerId) && tskOwnerId.startsWith(keyPrefix)) {
                acc.CrsLastSalesActivitiesOwner__c = newTask.OwnerId;
            }
        } else if (!newTask.huzai_flag__c && recordTypeIdCrsDcs == newTask.RecordTypeId) {
            acc.CrsDcsLastTodoDatetime__c = newTask.action_time__c;
            system.debug('***** newTask.Field3__c : ' + newTask.Field3__c + '|' + newTask.Id);
            if (String.isNotBlank(newTask.Field3__c)) {
                acc.CrsDcsLastSalesActivities__c = newTask.Field3__c;
            } else {
                acc.CrsDcsLastSalesActivities__c = null;
            }
            system.debug('***** newTask.Owner.Id : ' + newTask.Owner.Id);
            String tskOwnerId = newTask.OwnerId;
            if (String.isNotBlank(tskOwnerId) && tskOwnerId.startsWith(keyPrefix)) {
                acc.CrsDcsLastSalesActivitiesOwner__c = newTask.OwnerId;
            }

        }

    }

    /**
     * ToDoと取引先担当者の連絡先重複チェック
     * @param t ToDo
     * @param c 取引先担当者
     * @return メールアドレスまたは電話番号の重複あり：true、重複無し：false
     */
    private Boolean duplicateCheckTaskAndContact(Task t, Contact c ) {
        if( (String.isNotBlank(t.Get_Email__c) && t.Get_Email__c == c.Email) || (String.isNotBlank(t.Get_Phone__c) && t.Get_Phone__c == c.Phone) ){
            system.debug('duplicateCheckTaskAndContact: true   *****************************************');
            return true;
        }else{
            system.debug('duplicateCheckTaskAndContact: false   *****************************************');
            return false;
        }
    }

    /**
     * ToDoから必要項目を取得し、取引先担当者へInsertするためのContactを返す
     * @param t ToDo
     * @param flag 重複有無のフラグ
     * @return Contact
     */
    private Contact convertTaskToContact(Task t, Boolean flag, String cId){ // FlagがTrueだったらId取得すること。
        Contact c = new Contact();
        if (flag == TRUE && String.isNotBlank(cId)){
            c.Id = cId;
            system.debug('*******************  c.Id='+c.Id);
        }
        if (String.isNotBlank(t.AccountId)){
            c.AccountId = t.AccountId;
        }
        if (String.isNotBlank(t.OwnerId)){
            c.Address_GetOwner__c = t.OwnerId;
        }
        if (String.isNotBlank(t.tanto__c)){
            // 空白除去、語尾の'様'、'さん'、'さま'を除去
            c.LastName = t.tanto__c.deleteWhitespace().removeEnd('様').removeEnd('さま').removeEnd('さん');
        }
        if (String.isNotBlank(t.Get_Email__c)){
            c.Email = t.Get_Email__c;
        }
        if (String.isNotBlank(t.Get_Phone__c)){
            c.Phone = t.Get_Phone__c;
        }
        c.GetAddressFlag__c = true;
        system.debug('convertTaskToContact: c.AccountId, LastName, Email, Phone, GetAddressFlag__c, AddrDupFlag__c, Address_GetOwner__c ='+c.AccountId+', '+c.LastName+', '+c.Email+', '+c.Phone+', '+c.GetAddressFlag__c+', '+c.Address_GetOwner__c+'  *************************************');
        return c;
    }
}