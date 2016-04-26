@isTest
private class ContractApplicationControllerTest {
  @testSetup
  static void setUp() {
		User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', 
														CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
														ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert manager;

		User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', 
												 CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
												 ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id, SalesApprovalUser__c = manager.Id);
		insert user;

		Account account = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
																	Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
																	CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS',
																	CompanySize__c = '1～30人', BillingPostalCode = '000-0000');
		insert account;
		
		Account essAccount = new Account(name = 'Test Ess Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
																	   Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
																	   CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS',
																		 CompanySize__c = '1～30人', BillingPostalCode = '000-0000');
		insert essAccount;

		Opportunity op = new Opportunity();
		op.Name = 'TEST-ABCXYZ20150831';
		op.UseStartDate__c = Date.valueOf('2015-08-03');
		op.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		op.ProposedService__c = 'CRS';
		op.Type = '新規提案（過去未契約）';
		op.HirePlanMonths__c = 6;
		op.OwnerId = user.Id;
		op.ApplicationApprovalStatus__c = '';
		op.AccountId = account.Id;
		op.StageName = 'TEST';
		op.VisitChargeUser__c = user.Id;
		op.CloseDate = Date.today();
		op.ContactName__c = '新規_20150831';
		op.sample_case__c = '*';
		op.HiringPeriod__c = Date.today();
		op.Opportunity__c = '*';
		op.ContractCollectionDate__c = Date.today();
		op.useStartDate__c = Date.today().addDays(2);
		op.useEndDate__c = Date.today().addDays(120);
		op.ContractApplicationNo__c = '201601-000001';
		op.AppoChannel__c = 'メール';
		op.AppoAcquisitionDate__c = Date.today();
		op.AppoAcquisitionUser__c = user.Id;
    op.VisitChargeUser__c = user.Id;
		insert op;

		Opportunity essOp = new Opportunity();
		essOp.Name = 'TEST-ABCXYZ20150831';
		essOp.UseStartDate__c = Date.valueOf('2015-08-03');
		essOp.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		essOp.ProposedService__c = 'ESS';
		essOp.Type = '新規提案（過去未契約）';
		essOp.HirePlanMonths__c = 6;
		essOp.OwnerId = user.Id;
		essOp.ApplicationApprovalStatus__c = '';
		essOp.AccountId = essAccount.Id;
		essOp.StageName = 'TEST';
		essOp.VisitChargeUser__c = user.Id;
		essOp.CloseDate = Date.today();
		essOp.ContactName__c = '新規_20160228';
		essOp.sample_case__c = '*';
		essOp.HiringPeriod__c = Date.today();
		essOp.Opportunity__c = '*';
		essOp.ContractCollectionDate__c = Date.today();
		essOp.useStartDate__c = Date.today().addDays(2);
		essOp.useEndDate__c = Date.today().addDays(120);
		essOp.ContractApplicationNo__c = '201601-000002';
		insert essOp;

  	Product2 product = new Product2();
  	product.Name = '商品A';
  	product.Service__c = 'ビズリーチ';
  	product.HirePlanCategory__c = '固定';
  	product.ProposedService__c = 'CRS';
  	product.UpfrontFee__c = 50000;
  	product.BrRgSuccessFee__c = 5000;
  	product.ContractPeriod__c = 6;
  	product.DisplayNameForClient__c = 'テスト商品';
  	product.PlatinumScoutNumberOfFirstMonth__c = 50;
  	product.PlatinumScoutNumber__c = 1000;
  	product.SpecialInstruction__c = 'テスト';
  	product.isActive = true;
  	insert product;	
  	
  	Product2 essProduct = new Product2();
  	essProduct.Name = '商品A';
  	essProduct.Service__c = 'ビズリーチ';
  	essProduct.HirePlanCategory__c = '固定';
  	essProduct.ProposedService__c = 'ESS';
  	essProduct.UpfrontFee__c = 50000;
  	essProduct.BrRgSuccessFee__c = 5000;
  	essProduct.ContractPeriod__c = 6;
  	essProduct.DisplayNameForClient__c = 'テスト商品';
  	essProduct.PlatinumScoutNumberOfFirstMonth__c = 50;
  	essProduct.PlatinumScoutNumber__c = 1000;
  	essProduct.SpecialInstruction__c = 'テスト';
  	essProduct.isActive = true;
  	insert essProduct;	

  	Pricebook2 pricebook = new Pricebook2();
  	pricebook.Name = 'テスト価格表';
  	pricebook.isActive = true;
  	insert pricebook;
  	
  	PricebookEntry standardEntry = new PricebookEntry();
  	standardEntry.UnitPrice = 50000;
  	standardEntry.Pricebook2Id = Test.getStandardPricebookId();
  	standardEntry.Product2Id = product.Id;
  	standardEntry.isActive = true;
  	standardEntry.UseStandardPrice = false;
  	insert standardEntry;

  	PricebookEntry essStandardEntry = new PricebookEntry();
  	essStandardEntry.UnitPrice = 50000;
  	essStandardEntry.Pricebook2Id = Test.getStandardPricebookId();
  	essStandardEntry.Product2Id = essProduct.Id;
  	essStandardEntry.isActive = true;
  	essStandardEntry.UseStandardPrice = false;
  	insert essStandardEntry;

  	PricebookEntry entry = new PricebookEntry();
  	entry.UnitPrice = 50000;
  	entry.Pricebook2Id = pricebook.Id;
  	entry.Product2Id = product.Id;
  	entry.isActive = true;
  	entry.UseStandardPrice = false;
  	insert entry;

  	PricebookEntry essEntry = new PricebookEntry();
  	essEntry.UnitPrice = 50000;
  	essEntry.Pricebook2Id = pricebook.Id;
  	essEntry.Product2Id = essProduct.Id;
  	essEntry.isActive = true;
  	essEntry.UseStandardPrice = false;
  	insert essEntry;

		OpportunityLineItem item = new OpportunityLineItem();
		item.OpportunityId = op.Id;
		item.PricebookEntryId = entry.Id;
		item.Quantity = 1;
		item.UnitPrice = 50000;
		insert item;

		OpportunityLineItem essItem = new OpportunityLineItem();
		essItem.OpportunityId = essOp.Id;
		essItem.PricebookEntryId = essEntry.Id;
		essItem.Quantity = 1;
		essItem.UnitPrice = 50000;
		insert essItem;
  }

  static testMethod void loadTestNotOpportunityId() {
    ContractApplicationController controller = new ContractApplicationController();
    System.assertEquals(true, controller.productDtoList.isEmpty());
    System.assertEquals(true, controller.isAlive);
    System.assertEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(true, String.isBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getAttachmentList());
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertEquals(1, controller.getSelectPlatinumScoutTypeItems().size());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(true, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(false, controller.getIsDisplayParentContract());
    System.assertEquals(false, controller.getIsRegister());
  }

  static testMethod void loadTestExistsOpportunityId() {
    Opportunity o = getOpportunity();
    ApexPages.currentPage().getParameters().put('opportunityId', o.Id);
    ContractApplicationController controller = new ContractApplicationController();

    System.assertNotEquals(null, controller.productDtoList);
    System.assertEquals(true, controller.isAlive);
    System.assertNotEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(true, String.isBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(true, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(false, controller.getIsDisplayParentContract());
  }

  static testMethod void loadTestStandardController() {
  	createInfo();
    Contract_Application_Information__c i = getInfo();
    ApexPages.StandardController sc = new ApexPages.StandardController(i);
    ApexPages.currentPage().getParameters().put('Id', i.Id);
    ContractApplicationController controller = new ContractApplicationController(sc);

    System.assertNotEquals(null, controller.productDtoList);
    System.assertEquals(true, controller.isAlive);
    System.assertNotEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(true, String.isNotBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(true, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(false, controller.getIsDisplayParentContract());
  }

  static testMethod void loadTestExistsEssOpportunityId() {
    Opportunity o = getEssOpportunity();
    ApexPages.currentPage().getParameters().put('opportunityId', o.Id);
    ContractApplicationController controller = new ContractApplicationController();

    System.assertNotEquals(null, controller.productDtoList);
    System.assertEquals(true, controller.isAlive);
    System.assertNotEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(true, String.isBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(true, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(false, controller.getIsDisplayParentContract());
  }

  static testMethod void loadTestExistsInfoId() {
  	createInfo();
    Contract_Application_Information__c i = getInfo();
    ApexPages.currentPage().getParameters().put('infoId', i.Id);
    ContractApplicationController controller = new ContractApplicationController();

    System.assertNotEquals(null, controller.productDtoList);
    System.assertEquals(true, controller.isAlive);
    System.assertNotEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(false, String.isBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(true, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(false, controller.getIsDisplayParentContract());
  }

  static testMethod void loadTestExistsId() {
  	createInfo();
    Contract_Application_Information__c i = getInfo();
    ApexPages.currentPage().getParameters().put('Id', i.Id);
    ContractApplicationController controller = new ContractApplicationController();

    System.assertNotEquals(null, controller.productDtoList);
    System.assertEquals(true, controller.isAlive);
    System.assertNotEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(false, String.isBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(true, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(false, controller.getIsDisplayParentContract());
  }
  
  static testMethod void loadExistsParentContract() {
  	createInfo();
  	
  	Product2 product = new Product2();
  	product.Name = '商品B';
  	product.Service__c = 'ビズリーチRS';
  	product.HirePlanCategory__c = '固定';
  	product.ProposedService__c = 'CRS';
  	product.UpfrontFee__c = 50000;
  	product.BrRgSuccessFee__c = 5000;
  	product.ContractPeriod__c = 6;
  	product.DisplayNameForClient__c = 'テスト商品';
  	product.PlatinumScoutNumberOfFirstMonth__c = 50;
  	product.PlatinumScoutNumber__c = 1000;
  	product.SpecialInstruction__c = 'テスト';
  	product.isActive = true;
  	insert product;	
  	
  	Pricebook2 pricebook = new Pricebook2();
  	pricebook.Name = 'テスト価格表2';
  	pricebook.isActive = true;
  	insert pricebook;
  	
  	PricebookEntry standardEntry = new PricebookEntry();
  	standardEntry.UnitPrice = 50000;
  	standardEntry.Pricebook2Id = Test.getStandardPricebookId();
  	standardEntry.Product2Id = product.Id;
  	standardEntry.isActive = true;
  	standardEntry.UseStandardPrice = false;
  	insert standardEntry;

  	PricebookEntry entry = new PricebookEntry();
  	entry.UnitPrice = 50000;
  	entry.Pricebook2Id = pricebook.Id;
  	entry.Product2Id = product.Id;
  	entry.isActive = true;
  	entry.UseStandardPrice = false;
  	insert entry;
  	
  	Account ac = getAccount();
  	User user = getUser();
		Opportunity op = new Opportunity();
		op.Name = 'TEST-ABDXYZ20150831';
		op.UseStartDate__c = Date.valueOf('2015-08-03');
		op.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		op.ProposedService__c = 'CRS';
		op.Type = '新規提案（過去未契約）';
		op.HirePlanMonths__c = 6;
		op.OwnerId = user.Id;
		op.ApplicationApprovalStatus__c = '';
		op.AccountId = ac.Id;
		op.StageName = 'TEST';
		op.VisitChargeUser__c = user.Id;
		op.CloseDate = Date.today();
		op.ContactName__c = '新規_20150831';
		op.sample_case__c = '*';
		op.HiringPeriod__c = Date.today();
		op.Opportunity__c = '*';
		op.ContractCollectionDate__c = Date.today();
		op.useStartDate__c = Date.today().addDays(2);
		op.useEndDate__c = Date.today().addDays(120);
		op.ContractApplicationNo__c = '201601-000002';
		insert op;

		OpportunityLineItem item = new OpportunityLineItem();
		item.OpportunityId = op.Id;
		item.PricebookEntryId = entry.Id;
		item.Quantity = 1;
		item.UnitPrice = 50000;
		insert item;
  	
    ApexPages.currentPage().getParameters().put('opportunityId', op.Id);
    ContractApplicationController controller = new ContractApplicationController();

    System.assertNotEquals(null, controller.productDtoList);
    System.assertEquals(true, controller.isAlive);
    System.assertNotEquals(null, controller.getCompanyAndSalesPersonDto());
    System.assertNotEquals(null, controller.getEditBillingDto());
    System.assertEquals(true, String.isBlank(controller.getInfoId()));
    System.assertNotEquals(null, controller.getSelectPlatinumScoutTypeItems());
    System.assertNotEquals(null, controller.getContractOperatorMemoDto());
    System.assertNotEquals(null, controller.getSelectParentContractIds());
    System.assertEquals(false, controller.getSelectParentContractIds().isEmpty());
    System.assertEquals(true, controller.getIsDisplayParentContract());
  }
  
  static testMethod void CompanyAndSalesPersonDto() {
  	Opportunity o = getOpportunityWithAccount();
  	ContractApplicationController.CompanyAndSalesPersonDto dto = new ContractApplicationController.CompanyAndSalesPersonDto(o);
  	
  	System.assertEquals('', dto.errorSalesPersonName);
  	System.assertEquals('', dto.errorAppointmentType);
  	System.assertEquals('', dto.errorAppointmentAcquiredName);
  	// ロールの設定はできていない。
  	System.assertNotEquals('', dto.errorAppointmentAcquiredTeam);
  	System.assertEquals('', dto.errorAppointmentAcquiredType);
  	System.assertEquals('', dto.errorIndustryCd);
  	System.assertEquals(true, dto.hasError);
  }
  
  static testMethod void doRegister() {
    Opportunity o = getEssOpportunity();
    ApexPages.currentPage().getParameters().put('opportunityId', o.Id);
    ContractApplicationController controller = new ContractApplicationController();
    
    System.assertNotEquals(null, controller.doRegister());
    
    BillingDto billingDto = controller.getEditBillingDto();
    System.assertEquals('Test Ess Inc', billingDto.companyName);
    
    List<ProductDto> productDtoList = controller.productDtoList;
    System.assertEquals(false, productDtoList.isEmpty());
    System.assertEquals(1, productDtoList.size());
    System.assertEquals(50000, productDtoList.get(0).initialPrice);
  }

  static testMethod void doRegisterNotExistsProduct() {
    Opportunity o = getEssOpportunity();
    o.Id = null;
    insert o;
    
    ApexPages.currentPage().getParameters().put('opportunityId', o.Id);
    ContractApplicationController controller = new ContractApplicationController();
    
    System.assertEquals(null, controller.doRegister());
  }
  
  static testMethod void doEdit() {
  	createEssInfo();
    Contract_Application_Information__c i = getEssInfo();
    ApexPages.currentPage().getParameters().put('Id', i.Id);
    ContractApplicationController controller = new ContractApplicationController();
  	
  	String billingStr = '請求先';
  	BillingDto dto = controller.getEditBillingDto();
  	dto.address = billingStr;

  	System.assertNotEquals(null, controller.doEdit());
  	
  	i = getEssInfo();
  	System.assertEquals(billingStr, i.Billing_Address__c);
  }
  
  static testMethod void doDelete() {
  	createEssInfo();
    Contract_Application_Information__c i = getEssInfo();
    i.Approval_Status__c = '再申請待ち';
    update i;
    
    ApexPages.currentPage().getParameters().put('Id', i.Id);
    ContractApplicationController controller = new ContractApplicationController();

 		System.assertNotEquals(null, controller.doDelete());
 		i = getEssInfo();
 		System.assertEquals(true, i.Del_Flg__c);
  }
  
  static testMethod void validateTest() {
    Opportunity o = getEssOpportunity();
    ApexPages.currentPage().getParameters().put('opportunityId', o.Id);
    ContractApplicationController controller = new ContractApplicationController();
    
    BillingDto billingDto = controller.getEditBillingDto();
    billingDto.companyName = '';
    billingDto.zipCode = '';
    billingDto.address = '';
    billingDto.phoneNumber = '';
    billingDto.contactName = '';

    System.assertEquals(null, controller.doRegister());
  }
  
  static private void createInfo() {
  	Opportunity o = getOpportunity();
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = o.Id;
		info.Version_No__c = 5;
		info.Billing_Company_Name__c = 'Test Inc';
		info.Billing_Building_Name__c = 'hoge';
		info.Billing_Address__c = 'hoge';
		info.Billing_Contact_Name__c = 'hoge';
		info.Billing_Phone_Number__c = '090-0000-0000';
		info.Billing_Contact_Department__c = 'hoge';
		info.Billing_Contact_Position__c = 'hoge';
		info.Billing_Zip_Code__c = '000-0000';
		info.Service_Name__c = 'ビズリーチ';
  	insert info;
  }

  static private void createEssInfo() {
  	Opportunity o = getEssOpportunity();
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = o.Id;
		info.Version_No__c = 5;
		info.Billing_Company_Name__c = 'Test Ess Inc';
		info.Billing_Building_Name__c = 'hoge';
		info.Billing_Address__c = 'hoge';
		info.Billing_Contact_Name__c = 'hoge';
		info.Billing_Phone_Number__c = '090-0000-0000';
		info.Billing_Contact_Department__c = 'hoge';
		info.Billing_Contact_Position__c = 'hoge';
		info.Billing_Zip_Code__c = '000-0000';
		info.Service_Name__c = 'ビズリーチ';
  	insert info;
  }

  static private Account getAccount() {
    return [SELECT ID,
                   Name,
                   BillingState,
                   BillingCity,
                   BillingStreet,
                   Phone
              FROM Account
             WHERE Name = 'Test Inc'];
  }

  static private Opportunity getOpportunity() {
    return [SELECT ID,
                   ContractApplicationNo__c,
                   useStartDate__c,
                   useEndDate__c,
                   Type,
                   ContactName__c
              FROM Opportunity
             WHERE ContactName__c ='新規_20150831'];
  }

  static private Opportunity getOpportunityWithAccount() {
    return [SELECT o.ID,
                   a.ID,
                   o.ProposedService__c,
                   o.Type,
                   o.Owner.Name,
                   o.OwnerRoleDepartment__c,
                   o.OwnerRoleTerritory__c,
                   o.AppoChannel__c,
                   o.AppoAcquisitionDate__c,
                   o.AppoAcquisitionUserName__c,
                   o.apo_team__c,
                   o.apo_chanel__c,
                   o.inbound__c,
                   o.CompanyProfile__c,
                   a.CompanySize__c,
                   a.Website,
                   a.Field195__c,
                   a.Field38__c,
                   a.Field221__c
              FROM Opportunity o,
                   Opportunity.Account a
             WHERE o.ContactName__c ='新規_20150831'];
  }

  static private Opportunity getEssOpportunity() {
    return [SELECT ID,
                   Name,
                   StageName,
                   CloseDate,
                   ContractApplicationNo__c,
                   useStartDate__c,
                   useEndDate__c,
                   Type,
                   ContactName__c,
                   ProposedService__c,
                   AccountId
              FROM Opportunity
             WHERE ContactName__c ='新規_20160228'];
  }

  static private User getUser() {
  	return [SELECT ID
  	          FROM User
  	         WHERE username = 'test1@sutead.com'];
  }
  
  static private Contract_Application_Information__c getInfo() {
  	return [SELECT ID,
  	               Billing_Company_Name__c,
  	               Del_Flg__c
  	          FROM Contract_Application_Information__c
  	         WHERE Billing_Company_Name__c = 'Test Inc'];
  }

  static private Contract_Application_Information__c getEssInfo() {
  	return [SELECT ID,
  	               Billing_Address__c,
  	               Del_Flg__c
  	          FROM Contract_Application_Information__c
  	         WHERE Billing_Company_Name__c = 'Test Ess Inc'];
  }
}