/**
 * BRS_BizReachSalesProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : W.Ichikawa
 * ----------------------------------------
 */
public class BRS_BizReachSalesProcess {

    /**
     * 共通処理
     * @param brsNewList BizReach売上リスト(トリガー無効データ除くtrriger.new)
     * @param brsOldList BizReach売上リスト(トリガー無効データ除くtrriger.old)
     * @param brsNewMap  BizReach売上マップ(トリガー無効データ除くtrriger.newMap)
     * @param brsOldMap  BizReach売上マップ(トリガー無効データ除くtrriger.oldMap)
     */
    public void commonProcess(List<BizReachSales__c> brsNewList, List<BizReachSales__c> brsOldList,
        Map<Id, BizReachSales__c> brsNewMap, Map<Id, BizReachSales__c> brsOldMap) {

        if (brsNewList.isEmpty()) return;

        Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
        Map<String, User> userNameMap = (Map<String, User>) umap.get(DAO_UserDao.MAP_KEY_NAME);

        List<String> appNoList = new List<String>();
        for (BizReachSales__c brs : brsNewList) {
            if (String.isNotBlank(brs.ContractApplicationNo__c)) {
                appNoList.add(brs.ContractApplicationNo__c);
            }
        }

        // 一旦存在する商談IDを取得する
        Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
        List<Opportunity> oppList = [SELECT Id, ContractApplicationNo__c FROM Opportunity WHERE ContractApplicationNo__c IN :appNoList];
        for (Opportunity opp : oppList) {
            oppMap.put(opp.ContractApplicationNo__c, opp);
        }

        String salesCon = Schema.SObjectType.BizReachSales__c.fields.SalesContact__c.Name;
        String salesConUser = Schema.SObjectType.BizReachSales__c.fields.SalesContactUser__c.Name;

        String operationCon = Schema.SObjectType.BizReachSales__c.fields.OperationContact__c.Name;
        String operationConUser = Schema.SObjectType.BizReachSales__c.fields.OperationContactUser__c.Name;

        for (BizReachSales__c bsr : brsNewList) {
            // 商談紐付け
            if (String.isEmpty(bsr.Opportunity__c)) {
                String appNo = bsr.ContractApplicationNo__c;
                if (oppMap.containsKey(appNo)) {
                    bsr.Opportunity__c = oppMap.get(appNo).Id;
                }
            }
            // 営業担当設定
            UTL_CommonUtil.convertUserNameToId(salesCon, salesConUser, bsr, null, userNameMap);

            // 運用担当設定
            UTL_CommonUtil.convertUserNameToId(operationCon, operationConUser, bsr, null, userNameMap);

        }

    }

}