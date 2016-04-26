/**
 * BAT_AccountOwner91DaysBatch
 * 商談の訪問予定日が91日過ぎた取引先の所有者を変更する
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class BAT_AccountOwner91DaysBatch implements Database.Batchable<AggregateResult> {

	/** クエリ */
	global String query = 'SELECT AccountId FROM Opportunity WHERE Account.AccountType__c = \'CRS\' AND (NOT Account.CompanyTeritory__c LIKE \'%その他%\') AND (NOT Account.Field1__c LIKE \'%承認%\') AND (NOT Account.Field252__c LIKE \'%承認%\') AND Account.Field14__c = false GROUP BY AccountId HAVING MAX(VisitDate__c) < LAST_90_DAYS';
	global Integer jobNo = -1;

	global BAT_AccountOwner91DaysBatch(Integer jobNo) {
		this.jobNo = jobNo;
	}

	/**
	 * 取引先所有者変更開始処理
	 * @param BC BatchableContextインターフェース
	 */
	global Iterable<AggregateResult> start(Database.BatchableContext BC) {
		AggregateResultIterable ari = new AggregateResultIterable();
		ari.query = query;
		return ari;
	}

	/**
	 * 取引先所有者変更処理
	 * @param BC BatchableContextインターフェース
	 * @param scope 商談リスト
	 */
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Id> acIdList = new List<Id>();
		for (sObject sobj : scope) {
			AggregateResult ar = (AggregateResult) sobj;
			acIdList.add((Id) ar.get('AccountId'));
		}
		if (!acIdList.isEmpty()) {
			User user = [SELECT Id FROM User WHERE userName = :system.Label.adminUserName];
			List<Account> acList = [SELECT Id, OwnerId FROM Account WHERE Id IN : acIdList];
			if (!acList.isEmpty()) {
				for (Account ac : acList) {
					ac.OwnerId = user.Id;
				}
				update acList;
			}
		}
	}

	/**
	 * 取引先所有者変更終了処理
	 * @param BC BatchableContextインターフェース
	 */
	global void finish(Database.BatchableContext BC){
		BAT_JobExecutor.executeNextJob(jobNo);
	}

}