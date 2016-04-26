/**
 * SCH_DrcActivityHistoryAlertBatch
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class SCH_DrcActivityHistoryAlertBatch implements Schedulable {
	global void execute(SchedulableContext SC){
		ID batchprocessid = Database.executeBatch(new BAT_DrcActivityHistoryAlertBatch(-1));
	}
}