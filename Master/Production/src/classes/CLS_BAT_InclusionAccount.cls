/**
 * CLS_BAT_InclusionAccount
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class CLS_BAT_InclusionAccount implements Database.Batchable<SObject> {

	/** クエリ */
	global String query = 'SELECT Id FROM Account WHERE Field156__c = YESTERDAY';
	global Integer jobNo = -1;

	global CLS_BAT_InclusionAccount(Integer jobNo) {
		this.jobNo = jobNo;
	}

	/**
	 * 包括契約対象解除開始処理
	 * @param BC BatchableContextインターフェース
	 */
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	/**
	 * 包括契約対象解除処理
	 * @param BC BatchableContextインターフェース
	 * @param scope 取引先リスト
	 */
	global void execute(Database.BatchableContext BC, List<SObject> scope){
		List<Account> accList = (List<Account>) scope;
		List<Id> idList = new List<Id>();
		for (Account acc : accList) {
			idList.add(acc.Id);
		}
		if (!idList.isEmpty()) {
			List<Account> accUpList = [SELECT Id, InclusionAccount__c FROM Account WHERE InclusionAccount__c IN :idList];
			if (!accUpList.isEmpty()) {
				for (Account accUp : accUpList) {
					accUp.InclusionAccount__c = null;
				}
				update accUpList;
			}
		}
	}

	/**
	 * 包括契約対象解除終了処理
	 * @param BC BatchableContextインターフェース
	 */
	global void finish(Database.BatchableContext BC){
		BAT_JobExecutor.executeNextJob(jobNo);
	}

}