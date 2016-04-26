/**
 * JKK_JyukouKanriProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class JKK_JyukouKanriProcess {

    /**
     * 共通処理
     * @param jkkNewList 受講管理リスト(トリガー無効データ除くtrriger.new)
     * @param jkkOldList 受講管理リスト(トリガー無効データ除くtrriger.old)
     * @param jkkNewMap  受講管理マップ(トリガー無効データ除くtrriger.newMap)
     * @param jkkOldMap  受講管理マップ(トリガー無効データ除くtrriger.oldMap)
     */
    public void commonProcess(List<JyukouKanri__c> jkkNewList, List<JyukouKanri__c> jkkOldList,
        Map<Id, JyukouKanri__c> jkkNewMap, Map<Id, JyukouKanri__c> jkkOldMap) {

        if (jkkNewList.isEmpty()) return;

        for(JyukouKanri__c jkk : jkkNewList){
            jkk.OwnerID = jkk.SyouyuusyaID__c;
        }

    }

}