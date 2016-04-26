global class UpdateAccountOpportunityVisitData implements Database.Batchable<sObject>{
	global String query;

	global Database.querylocator start(Database.BatchableContext BC){

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){

		List<Account> updAcList = new List<Account>();
		for(sObject s : scope){
			Account ac = (Account)s;
			List<Opportunity> ops = ac.opportunities;
			Opportunity op = null;
			if (ops != null) {
				op = ops[0];
				ac.LatestVisitChargeUser__c = op.VisitChargeUser__c;
			}
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