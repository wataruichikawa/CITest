public with sharing class OpportunityApprovalIncompleteList {
	public List<Opportunity> oppList{get;set;}

	public OpportunityApprovalIncompleteList(ApexPages.StandardController stdController) {
        oppList = new List<Opportunity>();
    }

    /*
    	承認待ち申込書一覧を表示するエントリポイント
     */
	public PageReference selectIncompleteList(){
		Id loginId = UserInfo.getUserId();
		List<ProcessInstanceWorkitem> wortItemList= 
			[SELECT ProcessInstance.TargetObjectId 
				FROM ProcessInstanceWorkitem where ActorId =:loginId];

		Set<String> oppIdList= new Set<String>();
		for (ProcessInstanceWorkitem piwi : wortItemList){
			System.debug('TargetObjectId is ' + piwi.ProcessInstance.TargetObjectId);
			oppIdList.add(piwi.ProcessInstance.TargetObjectId);
		}

		oppList = 
			[SELECT Name, Id, Owner.Name, ContractCollectionDate__c,UseStartDate__c,Amount,Account.Name 
				FROM Opportunity where id in :oppIdList ORDER BY UseStartDate__c, Account.Name];
		return null;
	}

}