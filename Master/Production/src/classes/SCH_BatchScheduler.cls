/**
 * SCH_BatchScheduler
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class SCH_BatchScheduler implements Schedulable {
	/**
	 * スケジュール済みジョブ実行
	 * @param SC SchedulableContextインターフェース
	 */
	global void execute(SchedulableContext SC){
		BAT_JobExecutor.executeNextJob(BatchJobOrder__c.getOrgDefaults().StartJobNo__c.intValue() - 1);
	}
}