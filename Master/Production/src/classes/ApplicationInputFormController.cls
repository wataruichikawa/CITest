public with sharing class ApplicationInputFormController {
	private ContractLogic contractLogic;
	private ApplicationInputFormDto dto;
	
	public ApplicationInputFormController() {
  	contractLogic = new ContractLogic();

  	dto = new ApplicationInputFormDto();

    Map<String, String> parameters = ApexPages.currentPage().getParameters();
    
    // 登録時とその他で取得できるパラメータが異なる。
    String opportunityId = parameters.get('opportunityId');
    String infoId = parameters.get('infoId');
    
    // いずれも取れないときはContract_Application_Information__cの編集・閲覧経由
    if(String.isBlank(opportunityId) && String.isBlank(infoId)) {
    	infoId = parameters.get('id');
    }
    
    if (String.isBlank(opportunityId) && String.isNotBlank(infoId)) {
			List<Contract_Application_Information__c> infoList = [SELECT Opportunity__c FROM Contract_Application_Information__c WHERE Id = :infoId];
			// 不正ID対策
			if (!infoList.isEmpty()) {
				opportunityId = infoList.get(0).Opportunity__c;
			}
    }
    
    if (String.isNotBlank(opportunityId)) {
      Opportunity opportunity = contractLogic.searchOpportunityById(opportunityId);
      dto.convertFromOpportunity(opportunity);
    }
	}   
	
	public ApplicationInputFormDto getInputFormDto() {
		return dto;
	}
}