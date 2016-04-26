/**
 * CLS_TaskUpdateLogic
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
public class CLS_TaskUpdateLogic {

	public void setResponsibleFlg(List<Task> tmpTaskList) {
		List<Id> taskWhatList = new List<Id>();
		for (Task t : tmpTaskList) {
			taskWhatList.add(t.WhatId);
		}
		Map<Id, Account> acMap = new Map<Id, Account>();
		if (taskWhatList.size() > 0) {
			acMap = new Map<Id, Account>([SELECT Id, CrsSale_Representative__c, careertreck_representativeUser__c, CrsSales_RepresentativeMain__c, careertreck_sales_representative__c FROM Account where Id in :taskWhatList]);
		}
		if (!acMap.isEmpty()) {
			for (Task t : tmpTaskList) {
				Account ac = acMap.get(t.WhatId);
				if (ac != null) {
					t.CrsSale_RepresentativeFlg__c = (ac.CrsSale_Representative__c == t.OwnerId);
					t.CrsSales_RepresentativeMainFlg__c = (ac.CrsSales_RepresentativeMain__c == t.OwnerId);
					t.careertreck_representativeUserFlg__c = (ac.careertreck_representativeUser__c == t.OwnerId);
					t.careertreck_sales_representativeFlg__c = (ac.careertreck_sales_representative__c == t.OwnerId);
				}
			}
		}
	}
}