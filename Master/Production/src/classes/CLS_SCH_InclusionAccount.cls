/**
 * CLS_SCH_InclusionAccount
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class CLS_SCH_InclusionAccount implements Schedulable {
	global void execute(SchedulableContext sc) {
		Id batchprocessid = Database.executeBatch(new CLS_BAT_InclusionAccount(-1));
	}
}