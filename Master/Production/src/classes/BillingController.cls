public with sharing class BillingController {
  private BillingDto dto;
  private List<SelectOption> selectBillingItems;
	private ContractLogic contractLogic;

	public Account agencyAccount {get; set;}
    
  public BillingController() {
  	contractLogic = new ContractLogic();

  	dto = new BillingDto();
  	selectBillingItems = new List<SelectOption>();
		agencyAccount = new Account();

    Map<String, String> parameters = ApexPages.currentPage().getParameters();
    
    // Contract_Application_Information__cの閲覧時のみこの画面は使用される。
		String infoId = parameters.get('id');
    
    // 請求先情報は契約内容オブジェクトに登録されているものを使用する。
    if (String.isNotBlank(infoId)) {
    	Contract_Application_Information__c info = contractLogic.searchContractInfoById(infoId);
    	dto.convertFromInfo(info);
    }
  }
  
  public BillingDto getBillingDto() {
  	return dto;
  }
}