public with sharing class ProductController {
  private List<ProductDto> dtoList;
  private ProductLogic productLogic;

  public ProductController() {
    Map<String, String> parameters = ApexPages.currentPage().getParameters();
    
    // Contract_Application_Information__cの閲覧のみ
    String infoId = parameters.get('Id');
    
    if (String.isNotBlank(infoId)) {
			List<Contract_Application_Information__c> infoList = [SELECT o.shinkisyoudanflag__c,
			                                                             i.Service_Name__c
			                                                        FROM Contract_Application_Information__c i,
			                                                             Contract_Application_Information__c.Opportunity__r o
			                                                       WHERE i.Id = :infoId];

			// 不正ID対策
			if (!infoList.isEmpty()) {
				Contract_Application_Information__c info = infoList.get(0);

				productLogic = new ProductLogic();
				dtoList = productLogic.initializeProductDtoByInfoId(infoId, info.Service_Name__c, info.Opportunity__r.shinkisyoudanflag__c);
			}
    }
  }
  
  public List<ProductDto> getProductDtoList() {
  	return dtoList;
  }
}