/**
 * SCH_AutoCreateOfOpportunityBatch
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
global class SCH_AutoCreateOfOpportunityBatch implements Schedulable {

    /**
     * スケジュール済みジョブ実行
     * @param sc SchedulableContextインターフェース
     */
    global void execute(SchedulableContext sc) {
        ID batchprocessid = Database.executeBatch(new BAT_AutoCreateOfOpportunityBatch(-1));
    }

}