@isTest
private class ContractOperatorMemoControllerTest {
	static private String MEMO = 'memo';
	
  @testSetup
  static void setUp() {
		User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', 
														CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
														ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert manager;

		User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', 
												 CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
												 ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
		insert user;

		Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
															Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
															CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
		insert ac1;

		Opportunity op = new Opportunity();
		op.Name = 'TEST-ABCXYZ20150831';
		op.UseStartDate__c = Date.valueOf('2015-08-03');
		op.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		op.ProposedService__c = 'CRS';
		op.Type = '新規提案（過去未契約）';
		op.HirePlanMonths__c = 6;
		op.OwnerId = user.Id;
		op.ApplicationApprovalStatus__c = '';
		op.AccountId = ac1.Id;
		op.StageName = 'TEST';
		op.VisitChargeUser__c = user.Id;
		op.CloseDate = Date.today();
		op.ContactName__c = '新規 太郎';
		op.sample_case__c = '*';
		op.HiringPeriod__c = Date.today();
		op.Opportunity__c = '*';
		op.ContractCollectionDate__c = Date.today();
		op.useStartDate__c = Date.today().addDays(2);
		op.useEndDate__c = Date.today().addDays(120);
		op.ContractApplicationNo__c = '201601-000001';
		insert op;

  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Service_Name__c = 'ビズリーチ';
  	info.Opportunity__c = op.Id;
  	info.Contract_Application_Memo__c = MEMO;
  	info.Contract_Transfer_Memo__c = MEMO;
  	info.Parent_Contract_Application_No__c = '201601-000002';
    info.Version_No__c = 5;
    insert info;
  }
  
  static testMethod void initializeById() {
  	ID infoId = getInfoId();

    ApexPages.currentPage().getParameters().put('Id', infoId);
  	ContractOperatorMemoController controller = new ContractOperatorMemoController();
    
    ContractOperatorMemoDto dto = controller.getContractOperatorMemoDto();
    System.assertEquals(MEMO, dto.memo);
    System.assertEquals(MEMO, dto.transferMemo);
    System.assertEquals('201601-000002', dto.parentContractApplicationNo);
  }
  
  static ID getOpportunityId() {
		return [SELECT ID FROM Opportunity WHERE ContactName__c = '新規 太郎'].ID;
  }
  
  static ID getInfoId() {
  	ID opportunityId = getOpportunityId();
  	return [SELECT ID FROM Contract_Application_Information__c WHERE Opportunity__c = :opportunityId].ID;
  }
}