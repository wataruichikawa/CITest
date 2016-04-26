/**
 * SCH_AccountOwner91DaysBatch
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class SCH_AccountOwner91DaysBatch implements Schedulable {

	/**
	 * スケジュール済みジョブ実行
	 * @param sc SchedulableContextインターフェース
	 */
	global void execute(SchedulableContext sc) {
		ID batchprocessid = Database.executeBatch(new BAT_AccountOwner91DaysBatch(-1));
	}

}