/**
 * LED_ConvertFromLeadToAccount
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */

public class LED_ConvertFromLeadToAccount {

    /**
     * 取引開始処理
     * @param ledNewList リードリスト(トリガー無効データ除くtrriger.new)
     * @param ledOldList リードリスト(トリガー無効データ除くtrriger.old)
     * @param ledNewMap  リードマップ(トリガー無効データ除くtrriger.newMap)
     * @param ledOldMap  リードマップ(トリガー無効データ除くtrriger.oldMap)
     */
    public void startConvertFromLeadToAccount(List<Lead> ledNewList, List<Lead> ledOldList, Map<Id, Lead> ledNewMap,
        Map<Id, Lead> ledOldMap) {

        if (ledNewList.isEmpty()) return;

        Set<Id> accIdSet = new Set<Id>();
        Map<Id, Account> accIdMap = new Map<Id, Account>();
        for(Lead led : ledNewList){
            if (String.isNotBlank(led.LeadCategoryAccount__c)) {
                accIdSet.add(led.LeadCategoryAccount__c);
            }
        }

        if (!accIdSet.isEmpty()) {
            List<Account> accList = [SELECT Id, AccountType__c, Field221__c, iInboundApproach__c FROM Account WHERE Id IN :accIdSet AND IsDeleted = false AND AccountType__c = 'CRS'];
            if (!accList.isEmpty()) accIdMap = new Map<Id, Account>(accList);
        }

        // ユーザ情報の取得
        Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
        Map<String, User> userNameMap = (Map<String, User>) umap.get(DAO_UserDao.MAP_KEY_NAME);

        List<Contact> conUpdateList = new List<Contact>();
        
		//表示ラベルより、リード状況がインバウンド対応中のものだけを対象とする
		Set<String> leadStatusSet = new Set<String>();
		for(String statusStr:(system.label.LeadStatus_Completion).split(',',0)){
			leadStatusSet.add(statusStr);
		}
        for (Lead led : ledNewList) {
            system.debug('***** led.status : ' + led.Status);
            system.debug('***** led.leadSource : ' + led.LeadSource);
            System.debug('***** led.IsConverted : ' + led.IsConverted);
            if (led.IsConverted) {
                // 取引先責任者更新
                conUpdateList.add(new Contact(Id = led.ConvertedContactId, Department = led.Field6__c));
                // 取引先のリード情報更新
                setAccountLeadInfo(led, accIdMap);
            }
            // インバウンドフラグON
            system.debug('***** led.LeadCategoryAccount__c : ' + led.LeadCategoryAccount__c);
            //リード状況がインバウンド対応中のものだけを対象とする
            if (accIdMap.containsKey(led.LeadCategoryAccount__c) 
            	&& !leadStatusSet.contains(led.Status)) {
                Account acc = accIdMap.get(led.LeadCategoryAccount__c);
                LED_LeadProcess.setProhibitedApproach(acc);
                accIdMap.put(acc.Id, acc);
            }
        }

        if (!conUpdateList.isEmpty()) {
            update conUpdateList;
        }

        if (!accIdMap.isEmpty()) {
            update accIdMap.values();
        }

    }

    /**
     * 特定のリードソースの場合、取引先のリード情報を更新
     * @param led リード
     * @param accIdMap 取引先マップ
     */
    private void setAccountLeadInfo(Lead led, Map<Id, Account> accIdMap) {

        List<Account> accList = [SELECT Id, AccountType__c, Field221__c FROM Account WHERE Id = :led.ConvertedAccountId];
        if (!accList.isEmpty()) {
            Account acc = accList.get(0);
            if (String.isNotEmpty(led.LeadSource)) {
                if (led.LeadSource.equals('他社媒体掲載ピックアップリード')) {
                    setAccountLeadUpdate(acc, led, accIdMap, '他社媒体掲載案件');
                } else if (led.LeadSource.equals('BtoBサイトWeb問い合わせリードソース')) {
                    setAccountLeadUpdate(acc, led, accIdMap, 'インバウンド（問い合わせ）');
                } else if (led.LeadSource.equals('BtoBサイトWeb資料請求リードソース')) {
                    setAccountLeadUpdate(acc, led, accIdMap, 'インバウンド（資料請求）');
                } else if (led.LeadSource.equals(system.label.LeadLeadSourceAcademy)) {
                    setAccountLeadUpdate(acc, led, accIdMap, system.label.LeadLeadSourceAcademy);
                } else if (led.LeadSource.equals(system.label.LeadLeadSourceDirectRecruitingSeminor)) {
                    setAccountLeadUpdate(acc, led, accIdMap, system.label.LeadLeadSourceDirectRecruitingSeminor);
                } else if (led.LeadSource.equals(system.label.LeadLeadSourceSeikouJireiKyouyuSeminor)) {
                    setAccountLeadUpdate(acc, led, accIdMap, system.label.LeadLeadSourceSeikouJireiKyouyuSeminor);
                } else if (led.LeadSource.equals('ESS媒体')) {
                    acc.AccountType__c = 'ESS';
                    acc.Field221__c = 'I0062:その他(教育・官公庁)/その他';
                    setAccountLeadUpdate(acc, led, accIdMap, 'ESS媒体');
                } else if (led.LeadSource.equals('ESS労働局')) {
                    acc.AccountType__c = 'ESS';
                    acc.Field221__c = 'I0062:その他(教育・官公庁)/その他';
                    setAccountLeadUpdate(acc, led, accIdMap, 'ESS労働局');
                }
            }
        }

    }

    /**
     * 取引先のリード情報を設定
     * @param acc 取引先
     * @param led リード
     * @param accIdMap 取引先マップ
     * @param updateSource リード更新元
     */
    private void setAccountLeadUpdate(Account acc, Lead led, Map<Id, Account> accIdMap, String updateSource) {
        acc.Id = led.ConvertedAccountId;
        accIdMap.put(acc.Id, acc);
    }

}