global class KaisyaSyozaiTeritoryUpdateBatch implements Database.Batchable<sObject> {

	global String query;

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<Account> updateaccountlist = new List<Account>();
		List<Account> accountList = (List<Account>)scope;
		Map<id, account> newAcMap = new Map<id,account>();

		system.debug('scope = ' + accountlist.size());

   		String changeTeritory;

   		for(Account a: accountList){
   			newAcMap.put(a.id,a);
   		}

   		AddressAndTeritoryMatchLogic ad = new AddressAndTeritoryMatchLogic(accountList);

   		for (String key : newAcMap.keySet()) {
			// 会社所在テリトリー更新 ////////////////////////////////////////////////////
			Account newAc = newAcMap.get(key);
   			Account a = newAc.clone(true, false);
			a.CompanyTeritory__c = ad.matchAddressAndTeritoryAccount(newAc.address_all__c, newAc.BillingState, newAc.BillingCity, newAc.Ootetantoukigyou__c);

			updateaccountlist.add(a);
		}

   		system.debug('updateaccountlist size = '+updateaccountlist.size());
   		update updateaccountlist;
	}

	global void finish(Database.BatchableContext BC) {

	}

}