@isTest
private class ProductControllerTest {
	static testMethod void getProductDto() {
    PageReference pageRef = Page.productView;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('Id', getInfoId());

  	ProductController controller = new ProductController();

  	System.assertNotEquals(null, controller.getProductDtoList());
  	System.assertEquals(1, controller.getProductDtoList().size());
  	System.assertEquals(50000, controller.getProductDtoList().get(0).initialPrice);
  	System.assertEquals(500000, controller.getProductDtoList().get(0).replaceFeeList.get(0).replaceFee);
  	System.assertEquals(500000, controller.getProductDtoList().get(0).replaceFeeList.get(1).replaceFee);
	}

  @testSetup
  static void setUp() {
      User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
      insert manager;

      User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
      insert user;

      Account ac1 = new Account(name = 'Test Inc.', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
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
      op.ContactName__c = '新規_20150831';
      op.sample_case__c = '*';
      op.HiringPeriod__c = Date.today();
      op.Opportunity__c = '*';
      op.ContractCollectionDate__c = Date.today();
      op.useStartDate__c = Date.today().addDays(2);
      op.useEndDate__c = Date.today().addDays(120);
      insert op;

      Contract_Application_Information__c info = new Contract_Application_Information__c();
      info.Opportunity__c = op.Id;
      info.Version_No__c = 5;
      info.Billing_Company_Name__c = 'Test Inc.';
      info.Billing_Building_Name__c = 'hoge';
      info.Billing_Address__c = 'hoge';
      info.Billing_Contact_Name__c = 'hoge';
      info.Billing_Phone_Number__c = '090-0000-0000';
      info.Billing_Contact_Department__c = 'hoge';
      info.Billing_Contact_Position__c = 'hoge';
      info.Billing_Zip_Code__c = '000-0000';
      insert info;
      
      Contract_Application_Product__c product = new Contract_Application_Product__c();
      product.Contract_Application_Information__c = info.Id;
      product.Name = '商品A';
      product.Service__c = 'ビズリーチ';
      product.ProposedService__c = 'CRS';
      product.UpfrontFee__c = 50000;
      product.BrRgSuccessFee__c = 500000;
      product.BrTtSuccessFee__c = 500000;
      insert product;
  }
  
  static private ID getInfoId() {
  	return [SELECT ID FROM Contract_Application_Information__c WHERE Billing_Company_Name__c = 'Test Inc.'].Id;
  }
  
  static private Contract_Application_Product__c getProduct() {
  	return [SELECT ID,
  	               Name,
  	               UpfrontFee__c
  	          FROM Contract_Application_Product__c
  	         WHERE Name = '商品A'];
  }
    
}