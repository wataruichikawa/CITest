global class ConvertCMJobToCustomObject3 implements Database.Batchable<sObject>{
	global String query;

	global Database.querylocator start(Database.BatchableContext BC){

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){

		Set<String> cnms = new Set<String>();
		for(sObject s : scope){
			CompetingMediumJob__c crs = (CompetingMediumJob__c)s;
			if (!cnms.contains(crs.CompanyName__c)) {
				cnms.add(crs.CompanyName__c);
			}
		}
		System.debug('cnms.Size()*******************************************');
		System.debug(cnms.Size());
		System.debug(cnms);
		System.debug('******************************************************');

		List<Account> dummyAc = [Select Name, Id From Account Where Name = '他社媒体掲載案件見振り分け取引先'];

		Map<String, Account> idMap = new Map<String, Account>();
		List<Account> acs = [Select Name, Id From Account Where Name in :cnms];
		for (Account ac : acs) {
			idMap.put(ac.Name, ac);
		}

		System.debug('idMap.Size()******************************************');
		System.debug(idMap.Size());
		System.debug(idMap);
		System.debug('******************************************************');
		List<Lead> lds = [Select Company From Lead Where Company in :cnms];
		Set<String> ldSet = new Set<String>();
		for (Lead ld : lds) {
			if (!ldSet.contains(ld.Company)) {
				ldSet.add(ld.Company);
			}
		}
		List<CompetingMediumJob__c> updCmjList = new List<CompetingMediumJob__c>();
		List<Lead> insCmjList = new List<Lead>();
		for(sObject s : scope){
			CompetingMediumJob__c cmj = (CompetingMediumJob__c)s;
			Account ac = idMap.get(cmj.CompanyName__c);
			//System.debug('cmj.CompanyName__c************************************');
			//System.debug(cmj.CompanyName__c);
			//System.debug('******************************************************');
			//System.debug('ac ***************************************************');
			//System.debug(ac);
			//System.debug('******************************************************');
			if (ac != null) {
				cmj.Account__c = ac.Id;
				cmj.DataImportFlg__c = true;
			} else {
				if (dummyAc.size() > 0) {
					cmj.Account__c = dummyAc[0].Id;
				}
				System.debug('ldSet ************************************************');
				System.debug(ldSet.contains(cmj.CompanyName__c) + ' ' +  cmj.CompanyName__c);
				System.debug('******************************************************');
				if (!ldSet.contains(cmj.CompanyName__c)) {
					Lead nl = new Lead();
					nl.LastName = '採用担当';
					nl.LeadSource = '他社媒体掲載ピックアップリード';
					nl.Company = cmj.CompanyName__c;
					nl.State = cmj.State__c;
					nl.City = cmj.City__c;
					nl.Street = (String.isNotEmpty(cmj.Street__c) ? cmj.Street__c : '') + (String.isNotEmpty(cmj.Other__c) ? cmj.Other__c : '');
					nl.Description = (String.isNotEmpty(cmj.Description__c) ? cmj.Description__c : '');
					nl.Phone = cmj.Phone__c;
					nl.Field6__c = cmj.ChargePost__c;
					nl.CompanyKana__c = cmj.CompanyNameKana__c;
					ldSet.add(cmj.CompanyName__c);
					insCmjList.add(nl);
				}
			}
			cmj.BatchExecFlg__c = true;
			updCmjList.add(cmj);
		}

		if (updCmjList.size() > 0) {
			System.debug('updCmjList.size()) ***********************************');
			System.debug(updCmjList.size());
			System.debug(updCmjList);
			System.debug('******************************************************');
			update updCmjList;
		}

		if (insCmjList.size() > 0) {
			System.debug('insCmjList.size()) ***********************************');
			System.debug(insCmjList.size());
			System.debug(insCmjList);
			System.debug('******************************************************');
			insert insCmjList;
		}
	}

	global void finish(Database.BatchableContext BC){
	}
}