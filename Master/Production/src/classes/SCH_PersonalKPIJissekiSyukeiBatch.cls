/**
 * SCH_PersonalKPIJissekiSyukeiBatch
 * ----------------------------------------
 * @createdName      : S.Sogawa
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class SCH_PersonalKPIJissekiSyukeiBatch implements Schedulable {
	global void execute(SchedulableContext sc) {
		ID batchprocessid = Database.executeBatch(new BAT_PersonalKPIJissekiSyukeiBatch(-1));
	}
}