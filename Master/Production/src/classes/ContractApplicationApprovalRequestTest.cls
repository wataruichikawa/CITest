@isTest
private class ContractApplicationApprovalRequestTest {
  @testSetup
  static void setUp() {
			User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', 
															CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
															ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
			insert manager;

      User crsUser = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', 
                              CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
                              ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', SalesApprovalUser__c = manager.Id);
      insert crsUser;

      User essUser = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', 
                              CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
                              ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', SalesApprovalUser__c = manager.Id);
      insert essUser;

      Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
                                Field107__c = crsUser.LastName + ' ' + crsUser.FirstName, ownerid = crsUser.id, careertreck_sales_representative__c = crsUser.id, 
                                CrtSalesStaffForLink__c = crsUser.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',
                                AccountType__c='CRS');
      insert ac1;

      Account ac2 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
                                Field107__c = essUser.LastName + ' ' + essUser.FirstName, ownerid = essUser.id, careertreck_sales_representative__c = essUser.id, 
                                CrtSalesStaffForLink__c = essUser.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',
                                AccountType__c='ESS');
      insert ac2;

      Opportunity op1 = new Opportunity();
      op1.Name = 'TEST-ABCXYZ20150831';
      op1.UseStartDate__c = Date.today().addDays(8);
      op1.DounyuMtgDate__c = Datetime.now().addDays(6);
      op1.ProposedService__c = 'CRS';
      op1.Type = '新規提案（過去未契約）';
      op1.HirePlanMonths__c = 6;
      op1.OwnerId = crsUser.Id;
      op1.ApplicationApprovalStatus__c = '';
      op1.AccountId = ac1.Id;
      op1.StageName = 'TEST';
      op1.VisitChargeUser__c = crsUser.Id;
      op1.CloseDate = Date.today();
      op1.ContactName__c = '新規_20150831';
      op1.sample_case__c = '*';
      op1.HiringPeriod__c = Date.today();
      op1.Opportunity__c = '*';
      op1.ContractCollectionDate__c = Date.today().addDays(5);
      op1.ContractApplicationNo__c = '201601-000001';
      op1.VisitDate__c = Datetime.now().addDays(2);
      insert op1;

      Opportunity op2 = new Opportunity();
      op2.Name = 'TEST-ABDXYZ20150831';
      op2.UseStartDate__c = Date.today().addDays(8);
      op2.DounyuMtgDate__c = Datetime.now().addDays(6);
      op2.ProposedService__c = 'ESS';
      op2.Type = '新規提案（過去未契約）';
      op2.HirePlanMonths__c = 6;
      op2.OwnerId = essUser.Id;
      op2.ApplicationApprovalStatus__c = '';
      op2.AccountId = ac2.Id;
      op2.StageName = 'TEST';
      op2.VisitChargeUser__c = essUser.Id;
      op2.CloseDate = Date.today();
      op2.ContactName__c = '新規_20150822';
      op2.sample_case__c = '*';
      op2.HiringPeriod__c = Date.today();
      op2.Opportunity__c = '*';
      op2.ContractCollectionDate__c = Date.today().addDays(5);
      op2.ContractApplicationNo__c = '201601-000002';
      op2.VisitDate__c = Datetime.now().addDays(2);
      insert op2;

      Contract_Application_Information__c info1 = new Contract_Application_Information__c();
      info1.Opportunity__c = op1.Id;
      info1.Version_No__c = 10;
      info1.Approval_Status__c = '未申請';
      info1.Fetch_Date_In_Service__c = null;
      info1.Service_Name__c = 'ビズリーチ';
      insert info1;

      Contract_Application_Information__c info2 = new Contract_Application_Information__c();
      info2.Opportunity__c = op2.Id;
      info2.Version_No__c = 15;
      info2.Approval_Status__c = '未申請';
      info2.Fetch_Date_In_Service__c = null;
      info2.Service_Name__c = 'ビズリーチ';
      insert info2;

			Contract_Application_Product__c product1 = new Contract_Application_Product__c();
			product1.Service__c = 'ビズリーチ';
			product1.DisplayNameForClient__c = 'テスト商品';
			product1.ProposedService__c = 'CRS';
			product1.UnitPrice__c = 50000;
			product1.UpfrontFee__c = 50000;
			product1.Contract_Application_Information__c = info1.Id;
			insert product1;

			Contract_Application_Product__c product2 = new Contract_Application_Product__c();
			product2.Service__c = 'ビズリーチ';
			product2.DisplayNameForClient__c = 'テスト商品';
			product2.ProposedService__c = 'ESS';
			product2.UnitPrice__c = 50000;
			product2.UpfrontFee__c = 50000;
			product2.Contract_Application_Information__c = info2.Id;
			insert product2;
  }

  static testMethod void checkErrorResult() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    System.assertEquals(false, logic.approvalRequest(ID.valueOf('000000000000000000'), true));
  }

	static testMethod void testCrs() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    Contract_Application_Information__c i = getCrsInfo();
    System.assertEquals(true, logic.approvalRequest(i.ID, true));
	}

  static testMethod void testCtCrs() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    Contract_Application_Information__c i = getCrsInfo();
    i.Service_Name__c = 'キャリトレック';
    update i;
    
    Contract_Application_Product__c p = getCrsProduct();
    p.Service__c = 'キャリアトレック';
    update p;
    
    System.assertEquals(true, logic.approvalRequest(i.ID, true));
  }

  static testMethod void testNrCrs() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    Contract_Application_Information__c i = getCrsInfo();
    i.Service_Name__c = 'ニクリーチ';
    update i;
    
    Contract_Application_Product__c p = getCrsProduct();
    p.Service__c = 'ニクリーチ';
    update p;
    
    System.assertEquals(true, logic.approvalRequest(i.ID, true));
  }

  static testMethod void testEss() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    Contract_Application_Information__c i = getEssInfo();
    System.assertEquals(true, logic.approvalRequest(i.ID, true));
  }

  static testMethod void testEssReapply() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    Contract_Application_Information__c i = getEssInfo();
    i.Approval_Status__c = '再申請待ち';
    update i;
    
    System.assertEquals(true, logic.approvalRequest(i.ID, false));
  }

  static testMethod void testEssCancel() {
		ContractApplicationApprovalRequestLogic logic = new ContractApplicationApprovalRequestLogic();
    Contract_Application_Information__c i = getEssInfo();
    System.assertEquals(true, logic.approvalRequest(i.ID, true));
		String result = logic.tryCancelRequest(i.ID);
		System.assertNotEquals('', result);
		System.assertEquals(true, logic.isNewApprovalProcessName(result));
  }

  static Account getCrsAccount() {
    return [SELECT ID
              FROM Account
             WHERE Name = 'Test Inc'];
  }

  static Account getEssAccount() {
    return [SELECT ID
              FROM Account
             WHERE Name = 'Test Inc'];
  }

  static Contract_Application_Information__c getCrsInfo() {
    return [SELECT ID,
                   Approval_Status__c,
                   Fetch_Date_In_Service__c
              FROM Contract_Application_Information__c
             WHERE Version_No__c = 10];
  }

  static Contract_Application_Information__c getEssInfo() {
    return [SELECT ID,
                   Approval_Status__c,
                   Fetch_Date_In_Service__c
              FROM Contract_Application_Information__c
             WHERE Version_No__c = 15];
  }

  static Opportunity getCrsOpportunity() {
    return [SELECT ID,
                   ContractApplicationNo__c
              FROM Opportunity
             WHERE ContactName__c ='新規_20150831'];
  }

  static Opportunity getEssOpportunity() {
    return [SELECT ID,
                   ContractApplicationNo__c
              FROM Opportunity
             WHERE ContactName__c ='新規_20150822'];
  }
  
  static Contract_Application_Product__c getCrsProduct() {
  	return [SELECT ID
  	          FROM Contract_Application_Product__c
  	         WHERE DisplayNameForClient__c = 'テスト商品'
  	           AND ProposedService__c = 'CRS'];
  }
  
  static User getManager() {
  	return [SELECT ID
  	          FROM User
  	         WHERE Username = 'test1@sutead.com'];
  }
}