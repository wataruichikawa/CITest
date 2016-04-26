/**
 * TGR_AccountTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_AccountTrigger on Account (before insert, before update, after insert, after update) {

    // トリガー起動制御
    if (!UTL_TriggerUtil.scopeRunAccount) return;
    if (!UTL_TriggerUtil.canRunAccount) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunAccount = true;
        }
        return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
        trigger.isDelete, trigger.new, trigger.old);
    List<Account> tmpOldList = (List<Account>) dto.oldList;
    List<Account> tmpNewList = (List<Account>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, Account> tempOldMap;
    Map<Id, Account> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, Account>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, Account>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, Account>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, Account>();
    }

    ACC_AccountProcess accProcess = new ACC_AccountProcess();

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
        // 取引先共通処理
        accProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap, trigger.isInsert);
    }
    // before update
    if (trigger.isBefore && trigger.isUpdate) {
        // 取引先共通処理
        accProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap, trigger.isInsert);
    }
    // before delete
    if (trigger.isBefore && trigger.isDelete) {
    }
    // after insert
    if (trigger.isAfter && trigger.isInsert) {
        // 取引先フォロー
        new CHA_ChatterFollow().insertFollowAccount(tmpNewList, tempNewMap);
        // マージ依頼メール
        accProcess.mergeMailRequest(tmpNewList);
    }
    // after update
    if (trigger.isAfter && trigger.isUpdate) {
        // 取引先フォロー
        new CHA_ChatterFollow().updateFollowAccount(tmpNewList, tempNewMap, tmpOldList, tempOldMap);
        // マージ依頼メール
        accProcess.mergeMailRequest(tmpNewList);
    }
    // after delete
    if (trigger.isAfter && trigger.isDelete) {

    }

    // トリガー無効フラグ(FALSE)更新処理
    if(trigger.isAfter && !invalidList.isEmpty()) {
        UTL_TriggerUtil.canRunAccount = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }

}