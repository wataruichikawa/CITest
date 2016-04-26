public with sharing class ContractOperatorMemoController {
	private ContractOperatorMemoDto dto;
	
	public ContractOperatorMemoController() {
		dto = new ContractOperatorMemoDto();	

    Map<String, String> parameters = ApexPages.currentPage().getParameters();
    String infoId = parameters.get('Id');
    
    if (String.isNotBlank(infoId)) {
			List<Contract_Application_Information__c> infoList = [SELECT Opportunity__c,
			                                                             Parent_Contract_Application_No__c,
			                                                             Contract_Application_Memo__c,
			                                                             Contract_Transfer_Memo__c
			                                                        FROM Contract_Application_Information__c
			                                                       WHERE Id = :infoId];

			if (!infoList.isEmpty()) {
				Contract_Application_Information__c info = infoList.get(0);
				dto.ParentContractApplicationNo = info.Parent_Contract_Application_No__c;
				dto.memo = info.Contract_Application_Memo__c;
				dto.transferMemo = info.Contract_Transfer_Memo__c;
			}
    }
	}
	
	public ContractOperatorMemoDto getContractOperatorMemoDto() {
		return dto;
	}
}