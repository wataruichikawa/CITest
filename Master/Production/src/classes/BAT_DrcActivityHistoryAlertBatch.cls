/**
 * BAT_DrcActivityHistoryAlertBatch
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class BAT_DrcActivityHistoryAlertBatch implements Database.Batchable<sObject> {

	global String query = 'SELECT Id, Account.CrsSales_RepresentativeMain__c FROM Task WHERE LastModifiedDate = YESTERDAY AND (What.Type = \'Account\' OR What.Type = \'Opportunity\') AND Account.CrsSales_RepresentativeMain__c != null';
	global Integer jobNo = -1;

	global BAT_DrcActivityHistoryAlertBatch(Integer jobNo) {
		this.jobNo = jobNo;
	}

	/**
	 * 活動履歴アラート開始処理
	 * @param BC BatchableContextインターフェース
	 */
	global Database.QueryLocator start(Database.BatchableContext BC) {
		if (Test.isRunningTest()) {
			// テストの時は今日日付に変更
			query = query.replace('YESTERDAY', 'TODAY');
		}
		return Database.getQueryLocator(query);
	}

	/**
	 * 活動履歴アラート処理
	 * @param BC BatchableContextインターフェース
	 * @param scope 商談リスト
	 */
	global void execute(Database.BatchableContext BC, List<sObject> scope) {

		List<Task> tskList = (List<Task>) scope;
		Set<Id> idSet = new Set<Id>();

		for (Task tsk : tskList) {
			// 念のため
			if (String.isNotEmpty(tsk.Account.CrsSales_RepresentativeMain__c)) {
				idSet.add(tsk.Account.CrsSales_RepresentativeMain__c);
			}
		}

		if (!idSet.isEmpty()) {
			new ACC_DrcAccountManagement().alertActivityHistory(idSet);
		}

	}

	/**
	 * 活動履歴アラート終了処理
	 * @param BC BatchableContextインターフェース
	 */
	global void finish(Database.BatchableContext BC) {
		BAT_JobExecutor.executeNextJob(jobNo);
	}

}