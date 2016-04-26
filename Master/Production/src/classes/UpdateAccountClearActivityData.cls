global class UpdateAccountClearActivityData implements Database.Batchable<sObject>{
	global String query;

	global Database.querylocator start(Database.BatchableContext BC){

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){

		List<Account> updAcList = new List<Account>();
		for(sObject s : scope){
			Account ac = (Account)s;

			// CRS
			ac.CrsPlatinumScoutSendCThisM__c = 0;
			ac.CrsPlatinumScoutSendCLastM__c = 0;
			ac.CrsPlatinumScoutReturnCThisM__c = 0;
			ac.CrsPlatinumScoutReturnCLastM__c = 0;
			ac.CrsLoginCThisM__c = 0;
			ac.CrsLoginCLastM__c = 0;
			ac.CrsApplyCThisMonth__c = 0;
			ac.CrsApplyCLastMonth__c = 0;
			ac.CrsJoinedTotalPriceThisContract__c = 0;
			ac.CrsJoinedCThisM__c = 0;
			ac.CrsJoinedCLastM__c = 0;
			ac.CrsJoinedCountThisContract__c = 0;
			ac.CrsAutoScoutSendCThisMonth__c = 0;
			ac.CrsAutoScoutSendCLastMonth__c = 0;
			ac.CrsAutoScoutReturnCThisM__c = 0;
			ac.CrsAutoScoutReturnCLastM__c = 0;
			ac.CrsDocumentScreeningOkCThisM__c = 0;
			ac.CrsDocumentScreeningOkCLastM__c = 0;
			ac.CrsJobCount__c = 0;
			ac.CrsActiveJobCount__c = 0;
			ac.CrsFirstInterviewCountThisM__c = 0;
			ac.CrsFirstInterviewCountLastM__c = 0;
			ac.CrsSecondInterviewCountThisM__c = 0;
			ac.CrsSecondInterviewCountLastM__c = 0;
			ac.CrsLastInterviewCountThisM__c = 0;
			ac.CrsLastInterviewCountLastM__c = 0;
			ac.CrsOfferCountThisMonth__c = 0;
			ac.CrsOfferCountLastMonth__c = 0;
			ac.CrsOfferCountThisContract__c = 0;
			ac.CrsPlatinumScoutRemainingC__c = 0;
			ac.CrsPlatinumScoutSendCMonthBL__c = 0;
			ac.CrsPlatinumScoutReturnCMonthBL__c = 0;

			// ESS
			ac.EssActiveRecCThisMonth__c = 0;
			ac.EssActiveRecCLastMonth__c = 0;
			ac.EssActiveRecCMonthBL__c = 0;
			ac.EssPlatinumScoutRemainingC__c = 0;
			ac.EssAutoScoutSettingC__c = 0;
			ac.EssJoinedCRGThisMonth__c = 0;
			ac.EssJoinedCRGLastMonth__c = 0;
			ac.EssJoinedPriceRGThisMonth__c = 0;
			ac.EssJoinedPriceRGLastMonth__c = 0;
			ac.EssJoinedCTTThisM__c = 0;
			ac.EssJoinedCTTLastM__c = 0;
			ac.EssJoinedPriceTTThisMonth__c = 0;
			ac.EssJoinedPriceTTLastMonth__c = 0;
			ac.EssLoginCThisMonth__c = 0;
			ac.EssOpenJobC__c = 0;
			ac.EssClosedJobC__c = 0;

			updAcList.add(ac);
		}

		if (updAcList.size() > 0) {
			System.debug('updAcList.size()) ***********************************');
			System.debug(updAcList.size());
			System.debug(updAcList);
			System.debug('******************************************************');
			update updAcList;
		}

	}

	global void finish(Database.BatchableContext BC){
	}
}