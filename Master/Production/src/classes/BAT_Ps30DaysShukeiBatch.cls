/**
 * BAT_Ps30DaysShukeiBatch
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
global class BAT_Ps30DaysShukeiBatch implements Database.Batchable<sObject> {

	global String query = 'SELECT Id , ScoutSendDate__c , ListAddDate__c , Ps30DaysFlag__c , ListAdd30DaysFlag__c FROM CRS_TargetListDetail__c WHERE (ScoutSendDate__c >= :dt AND Ps30DaysFlag__c = false) OR (ScoutSendDate__c < :dt AND Ps30DaysFlag__c = true) OR (ListAddDate__c >= :dt AND ListAdd30DaysFlag__c = false) OR (ListAddDate__c < :dt AND ListAdd30DaysFlag__c = true)';
	global Datetime dt = Datetime.now().addDays(-30);
	global Integer jobNo = -1;

	global BAT_Ps30DaysShukeiBatch(Integer jobNo) {
		this.jobNo = jobNo;
	}

	/**
	 * PS送信日／TL追加日過去30日間フラグ開始処理
	 * @param BC BatchableContextインターフェース
	 */
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	/**
	 * PS送信日／TL追加日過去30日間フラグ処理
	 * @param BC BatchableContextインターフェース
	 */
	global void execute(Database.BatchableContext BC, List<sObject> scope){

		List<CRS_TargetListDetail__c> updCTLDlist = new List<CRS_TargetListDetail__c>();

		for(sObject s : scope){
			CRS_TargetListDetail__c ctld = new CRS_TargetListDetail__c();
			String ctldid = (String)s.get('Id');
			Datetime ctldps30dt = (Datetime)s.get('ScoutSendDate__c');
			Datetime ctldtl30dt = (Datetime)s.get('ListAddDate__c');
			Boolean ctlps30flag = (Boolean)s.get('Ps30DaysFlag__c');
			Boolean ctltl30flag = (Boolean)s.get('ListAdd30DaysFlag__c');
			ctld.Id = ctldid;
			if(dt <= ctldps30dt){
				ctld.Ps30DaysFlag__c = true;
			}else{
				ctld.Ps30DaysFlag__c = false;
			}
			if(dt <= ctldtl30dt){
				ctld.ListAdd30DaysFlag__c = true;
			}else{
				ctld.ListAdd30DaysFlag__c = false;
			}

			if(ctlps30flag != ctld.Ps30DaysFlag__c || ctltl30flag != ctld.ListAdd30DaysFlag__c){
				//元のチェックボックスON/OFFと違う結果になったレコードだけをupdate対象に追加する
				updCTLDlist.add(ctld);
			}

		}

		update updCTLDlist;
	}

	/**
	 * PS送信日／TL追加日過去30日間フラグ終了処理
	 * @param BC BatchableContextインターフェース
	 */
	global void finish(Database.BatchableContext BC){
		BAT_JobExecutor.executeNextJob(jobNo);
	}

}