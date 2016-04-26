@isTest
private class ProductLogicTest {
  @testSetup
  static void setUp() {
      User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', 
                              TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
      insert manager;

      User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', 
                           TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',
                           ManagerId=manager.Id);
      insert user;

      Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, 
                                ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingPostalCode='000-0000', BillingState = '東京都', 
                                BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
      insert ac1;

      Account ac2 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, 
                                ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingPostalCode='000-0000', BillingState = '東京都', 
                                BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
      insert ac2;


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
      op.ContactName__c = '新規_20150831';
      op.sample_case__c = '*';
      op.HiringPeriod__c = Date.today();
      op.Opportunity__c = '*';
      op.ContractCollectionDate__c = Date.today();
      op.ContractApplicationNo__c = '201601-000001';
      op.VisitDate__c = Datetime.now().addDays(2);
      op.Br_Contract_PDF_ID__c = '00000000000000000';
      op.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
      op.Ct_Contract_PDF_ID__c = '00000000000000000';
      op.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
      op.Nr_Contract_PDF_ID__c = '00000000000000000';
      op.Attach_PDF_ID__c = '00000000000000000';
      insert op;

      Contract_Application_Information__c brInfo = new Contract_Application_Information__c();
      brInfo.Name = 'BrInfo';
      brInfo.Opportunity__c = op.Id;
      brInfo.Service_Name__c = System.Label.ServiceBiz;
      brInfo.Version_No__c = 1;
      brInfo.Approval_Status__c = '承認済';
      brInfo.Fetch_Date_In_Service__c = null;
      insert brInfo;

			Contract_Application_Product__c brProduct = new Contract_Application_Product__c();
			brProduct.Service__c = System.Label.ServiceBiz;
			brProduct.DisplayNameForClient__c = 'テスト商品';
			brProduct.ProposedService__c = 'CRS';
			brProduct.hirePlanCategory__c = '固定';
			brProduct.UnitPrice__c = 50000;
			brProduct.UpfrontFee__c = 50000;
			brProduct.BrRgSuccessFee__c = 50000;
			brProduct.Contract_Application_Information__c = brInfo.Id;
			insert brProduct;
			
      Contract_Application_Information__c ctInfo = new Contract_Application_Information__c();
      ctInfo.Opportunity__c = op.Id;
      ctInfo.Service_Name__c = 'キャリアトレック';
      ctInfo.Version_No__c = 1;
      ctInfo.Approval_Status__c = '承認済';
      ctInfo.Fetch_Date_In_Service__c = null;
      insert ctInfo;

			Contract_Application_Product__c ctProduct = new Contract_Application_Product__c();
			ctProduct.Service__c = 'キャリアトレック';
			ctProduct.DisplayNameForClient__c = 'テスト商品';
			ctProduct.ProposedService__c = 'CRS';
			ctProduct.hirePlanCategory__c = '固定';
			ctProduct.UnitPrice__c = 50000;
			ctProduct.UpfrontFee__c = 50000;
			ctProduct.CtSuccessFee__c = 50000;
			ctProduct.Contract_Application_Information__c = ctInfo.Id;
			insert ctProduct;

      Contract_Application_Information__c nrInfo = new Contract_Application_Information__c();
      nrInfo.Opportunity__c = op.Id;
      nrInfo.Service_Name__c = System.Label.ServiceNk;
      nrInfo.Version_No__c = 1;
      nrInfo.Approval_Status__c = '承認済';
      nrInfo.Fetch_Date_In_Service__c = null;
      insert nrInfo;

			Contract_Application_Product__c nrProduct = new Contract_Application_Product__c();
			nrProduct.Service__c = System.Label.ServiceNk;
			nrProduct.DisplayNameForClient__c = 'テスト商品';
			nrProduct.ProposedService__c = 'CRS';
			nrProduct.hirePlanCategory__c = '固定';
			nrProduct.UnitPrice__c = 50000;
			nrProduct.UpfrontFee__c = 50000;
			nrProduct.Contract_Application_Information__c = nrInfo.Id;
			nrProduct.NrSuccessFee__c = 50000;
			insert nrProduct;

			Product2 brProduct2 = new Product2();
			brProduct2.Name = '商品A';
			brProduct2.Service__c = 'ビズリーチ';
			brProduct2.HirePlanCategory__c = '固定';
			brProduct2.ProposedService__c = 'CRS';
			brProduct2.UpfrontFee__c = 50000;
			brProduct2.BrRgSuccessFee__c = 5000;
			brProduct2.BrTtSuccessFee__c = 5000; 
			brProduct2.ContractPeriod__c = 6;
			brProduct2.DisplayNameForClient__c = 'テスト商品';
			brProduct2.PlatinumScoutNumberOfFirstMonth__c = 50;
			brProduct2.PlatinumScoutNumber__c = 1000;
			brProduct2.SpecialInstruction__c = 'テスト';
			brProduct2.isActive = true;
			insert brProduct2;	
			
			Product2 ctProduct2 = new Product2();
			ctProduct2.Name = '商品A';
			ctProduct2.Service__c = 'キャリアトレック';
			ctProduct2.HirePlanCategory__c = '固定';
			ctProduct2.ProposedService__c = 'CRS';
			ctProduct2.UpfrontFee__c = 50000;
			ctProduct2.CtSuccessFee__c = 5000;
			ctProduct2.ContractPeriod__c = 6;
			ctProduct2.DisplayNameForClient__c = 'テスト商品';
			ctProduct2.PlatinumScoutNumberOfFirstMonth__c = 50;
			ctProduct2.PlatinumScoutNumber__c = 1000;
			ctProduct2.SpecialInstruction__c = 'テスト';
			ctProduct2.isActive = true;
			insert ctProduct2;	
			
			Product2 nrProduct2 = new Product2();
			nrProduct2.Name = '商品A';
			nrProduct2.Service__c = 'ニクリーチ';
			nrProduct2.HirePlanCategory__c = '固定';
			nrProduct2.ProposedService__c = 'CRS';
			nrProduct2.UpfrontFee__c = 50000;
			nrProduct2.NrSuccessFee__c = 5000;
			nrProduct2.ContractPeriod__c = 6;
			nrProduct2.DisplayNameForClient__c = 'テスト商品';
			nrProduct2.PlatinumScoutNumberOfFirstMonth__c = 50;
			nrProduct2.PlatinumScoutNumber__c = 1000;
			nrProduct2.SpecialInstruction__c = 'テスト';
			nrProduct2.isActive = true;
			insert nrProduct2;	

			Pricebook2 pricebook = new Pricebook2();
			pricebook.Name = 'テスト価格表';
			pricebook.isActive = true;
			insert pricebook;
			
			PricebookEntry brStandardEntry = new PricebookEntry();
			brStandardEntry.UnitPrice = 50000;
			brStandardEntry.Pricebook2Id = Test.getStandardPricebookId();
			brStandardEntry.Product2Id = brProduct2.Id;
			brStandardEntry.isActive = true;
			brStandardEntry.UseStandardPrice = false;
			insert brStandardEntry;

			PricebookEntry ctStandardEntry = new PricebookEntry();
			ctStandardEntry.UnitPrice = 50000;
			ctStandardEntry.Pricebook2Id = Test.getStandardPricebookId();
			ctStandardEntry.Product2Id = ctProduct2.Id;
			ctStandardEntry.isActive = true;
			ctStandardEntry.UseStandardPrice = false;
			insert ctStandardEntry;

			PricebookEntry nrStandardEntry = new PricebookEntry();
			nrStandardEntry.UnitPrice = 50000;
			nrStandardEntry.Pricebook2Id = Test.getStandardPricebookId();
			nrStandardEntry.Product2Id = nrProduct2.Id;
			nrStandardEntry.isActive = true;
			nrStandardEntry.UseStandardPrice = false;
			insert nrStandardEntry;

			PricebookEntry brEntry = new PricebookEntry();
			brEntry.UnitPrice = 50000;
			brEntry.Pricebook2Id = pricebook.Id;
			brEntry.Product2Id = brProduct2.Id;
			brEntry.isActive = true;
			brEntry.UseStandardPrice = false;
			insert brEntry;

			PricebookEntry ctEntry = new PricebookEntry();
			ctEntry.UnitPrice = 50000;
			ctEntry.Pricebook2Id = pricebook.Id;
			ctEntry.Product2Id = ctProduct2.Id;
			ctEntry.isActive = true;
			ctEntry.UseStandardPrice = false;
			insert ctEntry;

			PricebookEntry nrEntry = new PricebookEntry();
			nrEntry.UnitPrice = 50000;
			nrEntry.Pricebook2Id = pricebook.Id;
			nrEntry.Product2Id = nrProduct2.Id;
			nrEntry.isActive = true;
			nrEntry.UseStandardPrice = false;
			insert nrEntry;

			OpportunityLineItem brItem = new OpportunityLineItem();
			brItem.OpportunityId = op.Id;
			brItem.PricebookEntryId = brEntry.Id;
			brItem.Quantity = 1;
			brItem.UnitPrice = 50000;
			insert brItem;

			OpportunityLineItem ctItem = new OpportunityLineItem();
			ctItem.OpportunityId = op.Id;
			ctItem.PricebookEntryId = ctEntry.Id;
			ctItem.Quantity = 1;
			ctItem.UnitPrice = 50000;
			insert ctItem;

			OpportunityLineItem nrItem = new OpportunityLineItem();
			nrItem.OpportunityId = op.Id;
			nrItem.PricebookEntryId = nrEntry.Id;
			nrItem.Quantity = 1;
			nrItem.UnitPrice = 50000;
			insert nrItem;
  }
  
  static testMethod void productDtoInitializeAndConvert() {
  	ProductLogic logic = new ProductLogic();
  	Opportunity o = getOpportunity();
  	List<ProductDto> brProductDtoList = logic.initializeProductDtoByOpportunityId(o.Id, System.Label.ServiceBiz, true);
  	System.assertEquals(false, brProductDtoList.isEmpty());
  	List<ProductDto> ctProductDtoList = logic.initializeProductDtoByOpportunityId(o.Id, System.Label.ServiceCt, true);
  	System.assertEquals(false, ctProductDtoList.isEmpty());
  	List<ProductDto> nrProductDtoList = logic.initializeProductDtoByOpportunityId(o.Id, System.Label.ServiceNk, true);
  	System.assertEquals(false, nrProductDtoList.isEmpty());
  	
  	System.assertNotEquals(null, logic.convertFromDtoToContractApplicationProduct(brProductDtoList.get(0)));
  	System.assertNotEquals(null, logic.convertFromDtoToContractApplicationProduct(ctProductDtoList.get(0)));
  	System.assertNotEquals(null, logic.convertFromDtoToContractApplicationProduct(nrProductDtoList.get(0)));
  }
  
  static testMethod void productDtoInitializeByInfo() {
  	Contract_Application_Information__c brInfo = getBrInfo();
  	Contract_Application_Information__c ctInfo = getCtInfo();
  	Contract_Application_Information__c nrInfo = getNrInfo();
  	ProductLogic logic = new ProductLogic();

  	List<ProductDto> brProductDtoList = logic.initializeProductDtoByInfoId(brInfo.Id, System.Label.ServiceBiz, true);
  	System.assertEquals(false, brProductDtoList.isEmpty());
  	List<ProductDto> ctProductDtoList = logic.initializeProductDtoByInfoId(ctInfo.Id, System.Label.ServiceCt, true);
  	System.assertEquals(false, ctProductDtoList.isEmpty());
  	List<ProductDto> nrProductDtoList = logic.initializeProductDtoByInfoId(nrInfo.Id, System.Label.ServiceNk, true);
  	System.assertEquals(false, nrProductDtoList.isEmpty());
  	
 		Contract_Application_Product__c product = getBrProduct();
 		System.assertEquals(true, product.IsActive__c);
 		logic.switchProductActiveStatusByInfoId(brInfo.Id);
 		product = getBrProduct();
 		System.assertEquals(false, product.IsActive__c);
  }

  static Opportunity getOpportunity() {
    return [SELECT ID
              FROM Opportunity
             WHERE ContactName__c ='新規_20150831'];
  }
  
  static Contract_Application_Information__c getBrInfo() {
  	return [SELECT ID
  	          FROM Contract_Application_Information__c
  	         WHERE Service_Name__c = :System.Label.ServiceBiz];
  }

  static Contract_Application_Information__c getCtInfo() {
  	return [SELECT ID
  	          FROM Contract_Application_Information__c
  	         WHERE Service_Name__c = :System.Label.ServiceCt];
  }

  static Contract_Application_Information__c getNrInfo() {
  	return [SELECT ID
  	          FROM Contract_Application_Information__c
  	         WHERE Service_Name__c = :System.Label.ServiceNk];
  }
  
  static Contract_Application_Product__c getBrProduct() {
  	return [SELECT ID,
  	               IsActive__c
  	          FROM Contract_Application_Product__c
  	         WHERE Service__c = :System.Label.ServiceBiz];
  }
}