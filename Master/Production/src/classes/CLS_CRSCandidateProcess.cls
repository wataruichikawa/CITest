/**
 * CLS_CRSCandidateProcess
 * ----------------------------------------
 * @createdName      : W.Ichikawa
 * @lastModifiedName : W.Ichikawa
 * ----------------------------------------
 */
public class CLS_CRSCandidateProcess {

    /**
     * 担当者名設定処理
     * @param crsNewList CRS候補者リスト(トリガー無効データ除くtrriger.new)
     * @param crsOldList CRS候補者リスト(トリガー無効データ除くtrriger.old)
     * @param crsNewMap  CRS候補者マップ(トリガー無効データ除くtrriger.newMap)
     * @param crsOldMap  CRS候補者マップ(トリガー無効データ除くtrriger.oldMap)
     */
    public void setUserNameProcess(List<CRSCandidate__c> crsNewList, List<CRSCandidate__c> crsOldList,
        Map<Id, CRSCandidate__c> crsNewMap, Map<Id, CRSCandidate__c> crsOldMap) {

        if (crsNewList.isEmpty()) return;

        Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
        Map<String, User> userNameMap = (Map<String, User>) umap.get(DAO_UserDao.MAP_KEY_NAME);

        String salesCon = Schema.SObjectType.CRSCandidate__c.fields.Field1__c.Name;
        String salesConUser = Schema.SObjectType.CRSCandidate__c.fields.OccurrenceSalesContactUser__c.Name;

        String operationCon = Schema.SObjectType.CRSCandidate__c.fields.hassei_tantou__c.Name;
        String operationConUser = Schema.SObjectType.CRSCandidate__c.fields.OccurrenceOperationContactUser__c.Name;

        for (CRSCandidate__c crs : crsNewList) {

            // 営業担当設定
            UTL_CommonUtil.convertUserNameToId(salesCon, salesConUser, crs, null, userNameMap);

            // 運用担当設定
            UTL_CommonUtil.convertUserNameToId(operationCon, operationConUser, crs, null, userNameMap);
        }

    }

}