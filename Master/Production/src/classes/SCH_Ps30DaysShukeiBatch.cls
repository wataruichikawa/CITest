/**
 * SCH_Ps30DaysShukeiBatch
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class SCH_Ps30DaysShukeiBatch implements Schedulable {
	global void execute (SchedulableContext sc){
		Database.executeBatch(new BAT_Ps30DaysShukeiBatch(-1), 1000);
	}
}