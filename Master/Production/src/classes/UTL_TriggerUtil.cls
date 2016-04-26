/**
 * UTL_TriggerUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
public class UTL_TriggerUtil {

    /** トリガー無効フラグ API参照名 */
    private static final String TRIGGER_INVALID = 'TriggerInvalid__c';

    // トリガー二重起動制御フラグ
    /** 取引先 */
    public static boolean canRunAccount = true;
    /** 取引先(スコープ内で起動しないようにするフラグ) */
    public static boolean scopeRunAccount = true;
    /** 取引先責任者 */
    public static boolean canRunContact = true;
    /** 商談 */
    public static boolean canRunOpportunity = true;
    /** ToDo */
    public static boolean canRunTask = true;
    /** リード */
    public static boolean canRunLead = true;
    /** キャンペーンメンバー */
    public static boolean canRunCampaignMember = true;
    /** BizReach売上 */
    public static boolean canRunBizReachSales = true;
    /** CA依頼 */
    public static boolean canRunCARequest = true;
    /** CA依頼 */
    public static boolean canRunHuriwakeMaster = true;
    /** CRS候補者(新) */
    public static boolean canRunCRSCandidate = true;
    /** 受講管理 */
    public static boolean canRunJyukouKanri = true;
    /** 個人別KPI */
    public static boolean canRunPersonalKPI = true;
    /** ケース */
    public static boolean canRunCase = true;
    /** 動画カテゴリ */
    public static boolean canRunVideoCategory = true;
    /** 商談商品 */
    public static boolean canRunOpportunityLineItem = true;
    /** 契約内容 */
    public static boolean canRunContractApplicationInformation = true;

    /**
     * trigger.new、trigger.oldのトリガー無効フラグを統合して判別
     * @param isInsert：trigger.isInsertを設定
     * @param isUpdate：trigger.isUpdateを設定
     * @param isDelete：trigger.isDeleteを設定
     * @param newObjLis：trigger.newのオブジェクトを設定
     * @param oldObjList：trigger.oldのオブジェクトを設定
     * @return トリガ実施対象のマップ
     *         キー：'0' 値：トリガ実施対象のOldリスト
     *         キー：'1' 値：トリガ実施対象のNewリスト
     *         キー：'2' 値：トリガ無効フラグTRUEのレコードのIdリスト
     */
    public static DTO_TriggerDto createTriggerList(boolean isInsert, boolean isUpdate, boolean isDelete,
        List<sObject> newObjList, List<sObject> oldObjList){

        DTO_TriggerDto dto = new DTO_TriggerDto();

        if (isInsert || isUpdate) {
            for (Integer i = 0; i < newObjList.size(); i++) {
                sObject tmpNew = newObjList.get(i);
                sObject tmpOld;
                if(isUpdate){
                    tmpOld = oldObjList.get(i);
                }
                if (doTriggerProcess(isInsert, tmpNew, tmpOld)){
                    // トリガ実施対象の場合
                    dto.newList.add(tmpNew);
                    if(isUpdate){
                    // UPDATE時はOLD作成
                        dto.oldList.add(tmpOld);
                    }
                } else if(UTL_CommonUtil.toBoolean(tmpNew.get(TRIGGER_INVALID))){
                    // トリガ無効フラグがTrueの場合
                    dto.invalidList.add(tmpNew.id);
                }
            }
        } else if (isDelete) {
            for (sObject tmpOld : oldObjList) {
                dto.oldList.add(tmpOld);
            }
        }

        return dto;
    }

    /**
     * trigger.new、trigger.oldのトリガー無効フラグを統合して判別
     * @param isInsert：trigger.isInsertを設定
     * @param newObj  ：trigger.newのオブジェクトを設定
     * @param oldObj  ：trigger.oldのオブジェクトを設定
     * @return true ：処理を実施する
     *         false：処理を実施しない
     */
    public static boolean doTriggerProcess(boolean isInsert, sObject newObj, sObject oldObj){
        return (!UTL_CommonUtil.toBoolean(newObj.get(TRIGGER_INVALID)))
            && (isInsert || (!UTL_CommonUtil.toBoolean(oldObj.get(TRIGGER_INVALID))));
    }

    /**
     * トリガー無効フラグがFalseではないレコードに対して、Updateをかける
     * @param       idList：トリガー無効フラグをUpdateするレコードのIDリスト
     * @param       objApi  ：UpdateするオブジェクトのAPI参照名
     * @return      true    ：Update成功
     * @return      false   ：Update失敗
     * @throws
     */
    public static boolean updateTriggerInvalid(list<id> idList, string objApi){
        try{
            string soqlStr = 'SELECT Id, ' + TRIGGER_INVALID + ' FROM ' + objApi + ' WHERE Id IN (';
            for (string idStr : idList) {
                soqlStr += '\'' + idStr + '\',';
            }
            soqlStr = soqlStr.subString(0, soqlStr.length() - 1) + ')';
            List<sObject> sObjList = Database.query(soqlStr);
            for (sObject sObj : sObjList){
                sObj.put(TRIGGER_INVALID, false);
            }
            if (!sObjList.isEmpty()) update sObjList;
        } catch (Exception e) {
            system.debug(e.getMessage());
            return false;
        }
        return true;
    }

}