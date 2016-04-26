@isTest
private class ContractLogicTest {
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

			
  }

  static testMethod void searchContract() {
  	createBrTestData();
  	createEssData();
  	createEssData2();
  	createEssData3();
  	createEssData4();
    ContractLogic logic = new ContractLogic();
    String result = logic.searchContract('BizReach');
    System.assertNotEquals(0, result.length());
  }

  static testMethod void searchCtContract() {
  	createCtTestData();
  	createEssData();
  	createEssData2();
  	createEssData3();
  	createEssData4();
    ContractLogic logic = new ContractLogic();
    String result = logic.searchContract('Careertrek');
    System.assertNotEquals(0, result.length());
  }

  static testMethod void searchNrContract() {
  	createNrTestData();
    ContractLogic logic = new ContractLogic();
    String result = logic.searchContract('NikuReach');
    System.assertNotEquals(0, result.length());
  }

  static testMethod void searchContractError() {
  	createNrTestData(); 
  	ContractLogic logic = new ContractLogic();
    String result = logic.searchContract('Niku');
    System.assertEquals('', result);
  }

  static testMethod void searchOpportunityById() {
  	createBrTestData();
    Opportunity o = getOpportunity();
    ContractLogic logic = new ContractLogic();
    Opportunity validationOpportunity = logic.searchOpportunityById(o.Id);
    System.assertNotEquals(null, validationOpportunity);
    System.assertEquals(o.Id, validationOpportunity.Id);
  }

  static testMethod void updateFetchContract() {
  	createBrTestData();
    Opportunity o = getOpportunity();
    ContractLogic logic = new ContractLogic();
    Contract_Application_Information__c info = getInfo();
    System.assertEquals(1, info.Version_No__c);
    System.assertEquals('承認済', info.Approval_Status__c);
    System.assertEquals(null, info.Fetch_Date_In_Service__c);

    List<String> args = new List<String>();
    args.add(o.ContractApplicationNo__c);
    logic.updateFetchedContract('BizReach', args);
    info = getInfo();
    System.assertEquals(2, info.Version_No__c);
    System.assertEquals('承認済', info.Approval_Status__c);
    System.assertNotEquals(null, info.Fetch_Date_In_Service__c);
  }
  
  static testMethod void updateFailedFetchContract() {
  	createBrTestData();
    Opportunity o = getOpportunity();
    ContractLogic logic = new ContractLogic();
    Contract_Application_Information__c info = getInfo();
    System.assertEquals(1, info.Version_No__c);
    System.assertEquals('承認済', info.Approval_Status__c);
    System.assertEquals(null, info.Fetch_Date_In_Service__c);

    List<String> args = new List<String>();
    args.add(o.ContractApplicationNo__c);
    logic.updateFetchedContract('BizSeach', args);
    info = getInfo();
    System.assertNotEquals(2, info.Version_No__c);
    System.assertEquals('承認済', info.Approval_Status__c);
    System.assertEquals(null, info.Fetch_Date_In_Service__c);
  }
  
  static testMethod void getBillingSourceByAccoutIdNull() {
  	createBrTestData();
    ContractLogic logic = new ContractLogic();
  	System.assertEquals(null, logic.getBillingSource(null, null));
  }
  
  static testMethod void getBillingSourceByOpportunityIdNull() {
  	createBrTestData();
  	Account a = getAccount();
    ContractLogic logic = new ContractLogic();
    Opportunity result = logic.getBillingSource(a.Id, null);
  	System.assertNotEquals(null, result);
  	System.assertEquals('Test Inc', result.Account.Name);
  }
  
  static testMethod void getBillingSource() {
  	createBrTestData();
  	Account a = getAccount();
  	Opportunity o = getOpportunity();
    ContractLogic logic = new ContractLogic();
    Opportunity result = logic.getBillingSource(a.Id, o.Id);
  	System.assertNotEquals(null, result);
  	System.assertEquals('Test Inc', result.Account.Name);
  	System.assertEquals('新規_20150831', result.ContactName__c);
  }
  
  static testMethod void isAgencyContractWithOpperatorIdNull() {
    ContractLogic logic = new ContractLogic();
 		System.assertEquals(false, logic.isAgencyContract(null));
  }

  static testMethod void isAgencyContract() {
  	createBrTestData();
  	Opportunity o = getOpportunity();
    ContractLogic logic = new ContractLogic();
 		System.assertEquals(false, logic.isAgencyContract(o.Id));
  }
  
  static testMethod void getAttachmentList() {
  	createBrTestData();
  	Opportunity o = getOpportunity();
    ContractLogic logic = new ContractLogic();
    System.assertNotEquals(null, logic.getAttachmentList(o, System.Label.ServiceBiz));
    System.assertNotEquals(null, logic.getAttachmentList(o, System.Label.ServiceCt));
    System.assertNotEquals(null, logic.getAttachmentList(o, System.Label.ServiceNk));
  }
  
  static void createBrTestData() {
  	Opportunity op = getOpportunity();

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
		
		Contract_Application_Product__c brOptProduct = new Contract_Application_Product__c();
		brOptProduct.Service__c = System.Label.ServiceBiz;
		brOptProduct.DisplayNameForClient__c = 'テスト商品';
		brOptProduct.ProposedService__c = 'CRS';
		brOptProduct.hirePlanCategory__c = 'オプション';
		brOptProduct.UnitPrice__c = 50000;
		brOptProduct.UpfrontFee__c = 50000;
		brOptProduct.Contract_Application_Information__c = brInfo.Id;
		insert brOptProduct;
  }
  
  static void createCtTestData() {
  	Opportunity op = getOpportunity();

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
  }
  
  static void createNrTestData() {
  	Opportunity op = getOpportunity();
  	
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
  }
  
  static void createEssData() {
  	User user = getUser();
		Account ac2 = getAccountEss();

		Opportunity essOp1 = new Opportunity();
		essOp1.Name = 'TEST-ABCXYZ20150832';
		essOp1.UseStartDate__c = Date.valueOf('2015-08-03');
		essOp1.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		essOp1.ProposedService__c = 'ESS';
		essOp1.Type = '新規提案（過去未契約）';
		essOp1.HirePlanMonths__c = 6;
		essOp1.OwnerId = user.Id;
		essOp1.ApplicationApprovalStatus__c = '';
		essOp1.AccountId = ac2.Id;
		essOp1.StageName = 'TEST';
		essOp1.VisitChargeUser__c = user.Id;
		essOp1.CloseDate = Date.today();
		essOp1.ContactName__c = '新規_20150834';
		essOp1.sample_case__c = '*';
		essOp1.HiringPeriod__c = Date.today();
		essOp1.Opportunity__c = '*';
		essOp1.ContractCollectionDate__c = Date.today();
		essOp1.ContractApplicationNo__c = '201601-000001';
		essOp1.VisitDate__c = Datetime.now().addDays(2);
		essOp1.Br_Contract_PDF_ID__c = '00000000000000000';
		essOp1.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp1.Ct_Contract_PDF_ID__c = '00000000000000000';
		essOp1.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp1.Nr_Contract_PDF_ID__c = '00000000000000000';
		essOp1.Attach_PDF_ID__c = '00000000000000000';
		insert essOp1;

		Contract_Application_Information__c brEssInfo1 = new Contract_Application_Information__c();
		brEssInfo1.Opportunity__c = essOp1.Id;
		brEssInfo1.Service_Name__c = System.Label.ServiceBiz;
		brEssInfo1.Version_No__c = 1;
		brEssInfo1.Approval_Status__c = '承認済';
		brEssInfo1.Fetch_Date_In_Service__c = null;
		insert brEssInfo1;

		Contract_Application_Product__c brEssProduct1 = new Contract_Application_Product__c();
		brEssProduct1.Service__c = System.Label.ServiceBiz;
		brEssProduct1.DisplayNameForClient__c = 'テスト商品';
		brEssProduct1.ProposedService__c = 'ESS';
		brEssProduct1.hirePlanCategory__c = '成功報酬';
		brEssProduct1.UnitPrice__c = 50000;
		brEssProduct1.UpfrontFee__c = 50000;
		brEssProduct1.BrRgVolumeDiscount1__c = 30;
		brEssProduct1.BrRgVolumeDiscount2__c = 25;
		brEssProduct1.BrRgVolumeDiscount3__c = 20;
		brEssProduct1.Contract_Application_Information__c = brEssInfo1.Id;
		insert brEssProduct1;

		Contract_Application_Information__c ctInfo1 = new Contract_Application_Information__c();
		ctInfo1.Opportunity__c = essOp1.Id;
		ctInfo1.Service_Name__c = 'キャリアトレック';
		ctInfo1.Version_No__c = 1;
		ctInfo1.Approval_Status__c = '承認済';
		ctInfo1.Fetch_Date_In_Service__c = null;
		insert ctInfo1;

		Contract_Application_Product__c ctProduct1 = new Contract_Application_Product__c();
		ctProduct1.Service__c = 'キャリアトレック';
		ctProduct1.DisplayNameForClient__c = 'テスト商品';
		ctProduct1.ProposedService__c = 'ESS';
		ctProduct1.hirePlanCategory__c = '成功報酬';
		ctProduct1.UnitPrice__c = 50000;
		ctProduct1.UpfrontFee__c = 50000;
		ctProduct1.CtSuccessFeeRatio__c = 50000;
		ctProduct1.Contract_Application_Information__c = ctInfo1.Id;
		insert ctProduct1;
  }
  
  static void createEssData2() {
  	User user = getUser();
  	Account ac2 = getAccountEss();

		Opportunity essOp2 = new Opportunity();
		essOp2.Name = 'TEST-ABCXYZ20250833';
		essOp2.UseStartDate__c = Date.valueOf('2015-08-03');
		essOp2.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		essOp2.ProposedService__c = 'ESS';
		essOp2.Type = '新規提案（過去未契約）';
		essOp2.HirePlanMonths__c = 6;
		essOp2.OwnerId = user.Id;
		essOp2.ApplicationApprovalStatus__c = '';
		essOp2.AccountId = ac2.Id;
		essOp2.StageName = 'TEST';
		essOp2.VisitChargeUser__c = user.Id;
		essOp2.CloseDate = Date.today();
		essOp2.ContactName__c = '新規_20250833';
		essOp2.sample_case__c = '*';
		essOp2.HiringPeriod__c = Date.today();
		essOp2.Opportunity__c = '*';
		essOp2.ContractCollectionDate__c = Date.today();
		essOp2.ContractApplicationNo__c = '202602-000002';
		essOp2.VisitDate__c = Datetime.now().addDays(2);
		essOp2.Br_Contract_PDF_ID__c = '00000000000000000';
		essOp2.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp2.Ct_Contract_PDF_ID__c = '00000000000000000';
		essOp2.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp2.Nr_Contract_PDF_ID__c = '00000000000000000';
		essOp2.Attach_PDF_ID__c = '00000000000000000';
		insert essOp2;

		Contract_Application_Information__c brEssInfo2 = new Contract_Application_Information__c();
		brEssInfo2.Opportunity__c = essOp2.Id;
		brEssInfo2.Service_Name__c = System.Label.ServiceBiz;
		brEssInfo2.Version_No__c = 1;
		brEssInfo2.Approval_Status__c = '承認済';
		brEssInfo2.Fetch_Date_In_Service__c = null;
		insert brEssInfo2;

		Contract_Application_Product__c brEssProduct2 = new Contract_Application_Product__c();
		brEssProduct2.Service__c = System.Label.ServiceBiz;
		brEssProduct2.DisplayNameForClient__c = 'テスト商品';
		brEssProduct2.ProposedService__c = 'ESS';
		brEssProduct2.hirePlanCategory__c = '特別';
		brEssProduct2.UnitPrice__c = 50000;
		brEssProduct2.UpfrontFee__c = 50000;
		brEssProduct2.BrRgVolumeDiscount1__c = 30;
		brEssProduct2.BrRgVolumeDiscount2__c = 25;
		brEssProduct2.BrRgVolumeDiscount3__c = 20;
		brEssProduct2.Contract_Application_Information__c = brEssInfo2.Id;
		insert brEssProduct2;

		Contract_Application_Information__c ctInfo2 = new Contract_Application_Information__c();
		ctInfo2.Opportunity__c = essOp2.Id;
		ctInfo2.Service_Name__c = 'キャリアトレック';
		ctInfo2.Version_No__c = 2;
		ctInfo2.Approval_Status__c = '承認済';
		ctInfo2.Fetch_Date_In_Service__c = null;
		insert ctInfo2;

		Contract_Application_Product__c ctProduct2 = new Contract_Application_Product__c();
		ctProduct2.Service__c = 'キャリアトレック';
		ctProduct2.DisplayNameForClient__c = 'テスト商品';
		ctProduct2.ProposedService__c = 'ESS';
		ctProduct2.hirePlanCategory__c = '特別';
		ctProduct2.UnitPrice__c = 50000;
		ctProduct2.UpfrontFee__c = 50000;
		ctProduct2.CtSuccessFeeRatio__c = 50000;
		ctProduct2.Contract_Application_Information__c = ctInfo2.Id;
		insert ctProduct2;
  }
  
  static void createEssData3() {
  	User user = getUser();
  	Account ac2 = getAccountEss();
  	
		Opportunity essOp3 = new Opportunity();
		essOp3.Name = 'TEST-ABCXYZ20250833';
		essOp3.UseStartDate__c = Date.valueOf('2015-08-03');
		essOp3.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
		essOp3.ProposedService__c = 'ESS';
		essOp3.Type = '新規提案（過去未契約）';
		essOp3.HirePlanMonths__c = 6;
		essOp3.OwnerId = user.Id;
		essOp3.ApplicationApprovalStatus__c = '';
		essOp3.AccountId = ac2.Id;
		essOp3.StageName = 'TEST';
		essOp3.VisitChargeUser__c = user.Id;
		essOp3.CloseDate = Date.today();
		essOp3.ContactName__c = '新規_20250833';
		essOp3.sample_case__c = '*';
		essOp3.HiringPeriod__c = Date.today();
		essOp3.Opportunity__c = '*';
		essOp3.ContractCollectionDate__c = Date.today();
		essOp3.ContractApplicationNo__c = '202602-000002';
		essOp3.VisitDate__c = Datetime.now().addDays(2);
		essOp3.Br_Contract_PDF_ID__c = '00000000000000000';
		essOp3.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp3.Ct_Contract_PDF_ID__c = '00000000000000000';
		essOp3.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp3.Nr_Contract_PDF_ID__c = '00000000000000000';
		essOp3.Attach_PDF_ID__c = '00000000000000000';
		insert essOp3;

		Contract_Application_Information__c brEssInfo3 = new Contract_Application_Information__c();
		brEssInfo3.Opportunity__c = essOp3.Id;
		brEssInfo3.Service_Name__c = System.Label.ServiceBiz;
		brEssInfo3.Version_No__c = 1;
		brEssInfo3.Approval_Status__c = '承認済';
		brEssInfo3.Fetch_Date_In_Service__c = null;
		insert brEssInfo3;

		Contract_Application_Product__c brEssProduct3 = new Contract_Application_Product__c();
		brEssProduct3.Service__c = System.Label.ServiceBiz;
		brEssProduct3.DisplayNameForClient__c = 'テスト商品';
		brEssProduct3.ProposedService__c = 'ESS';
		brEssProduct3.hirePlanCategory__c = '成功報酬';
		brEssProduct3.UnitPrice__c = 50000;
		brEssProduct3.UpfrontFee__c = 50000;
		brEssProduct3.BrRgSuccessFeeRatio__c = 30;
		brEssProduct3.BrTtSuccessFeeRatio__c = 30;
		brEssProduct3.Contract_Application_Information__c = brEssInfo3.Id;
		insert brEssProduct3;

		Contract_Application_Information__c ctInfo3 = new Contract_Application_Information__c();
		ctInfo3.Opportunity__c = essOp3.Id;
		ctInfo3.Service_Name__c = 'キャリアトレック';
		ctInfo3.Version_No__c = 3;
		ctInfo3.Approval_Status__c = '承認済';
		ctInfo3.Fetch_Date_In_Service__c = null;
		insert ctInfo3;

		Contract_Application_Product__c ctProduct3 = new Contract_Application_Product__c();
		ctProduct3.Service__c = 'キャリアトレック';
		ctProduct3.DisplayNameForClient__c = 'テスト商品';
		ctProduct3.ProposedService__c = 'ESS';
		ctProduct3.hirePlanCategory__c = '特別';
		ctProduct3.UnitPrice__c = 50000;
		ctProduct3.UpfrontFee__c = 50000;
		ctProduct3.CtSuccessFee__c = 50000;
		ctProduct3.Contract_Application_Information__c = ctInfo3.Id;
		insert ctProduct3;
  }

  static void createEssData4() {
  	User user = getUser();
  	Account ac2 = getAccountEss();
  	
		Opportunity essOp4 = new Opportunity();
		essOp4.Name = 'TEST-ABCXYZ20250844';
		essOp4.UseStartDate__c = Date.valueOf('2015-08-04');
		essOp4.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:40:00');
		essOp4.ProposedService__c = 'ESS';
		essOp4.Type = '新規提案（過去未契約）';
		essOp4.HirePlanMonths__c = 6;
		essOp4.OwnerId = user.Id;
		essOp4.ApplicationApprovalStatus__c = '';
		essOp4.AccountId = ac2.Id;
		essOp4.StageName = 'TEST';
		essOp4.VisitChargeUser__c = user.Id;
		essOp4.CloseDate = Date.today();
		essOp4.ContactName__c = '新規_20250844';
		essOp4.sample_case__c = '*';
		essOp4.HiringPeriod__c = Date.today();
		essOp4.Opportunity__c = '*';
		essOp4.ContractCollectionDate__c = Date.today();
		essOp4.ContractApplicationNo__c = '202602-000002';
		essOp4.VisitDate__c = Datetime.now().addDays(2);
		essOp4.Br_Contract_PDF_ID__c = '00000000000000000';
		essOp4.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp4.Ct_Contract_PDF_ID__c = '00000000000000000';
		essOp4.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		essOp4.Nr_Contract_PDF_ID__c = '00000000000000000';
		essOp4.Attach_PDF_ID__c = '00000000000000000';
		insert essOp4;

		Contract_Application_Information__c brEssInfo4 = new Contract_Application_Information__c();
		brEssInfo4.Opportunity__c = essOp4.Id;
		brEssInfo4.Service_Name__c = System.Label.ServiceBiz;
		brEssInfo4.Version_No__c = 1;
		brEssInfo4.Approval_Status__c = '承認済';
		brEssInfo4.Fetch_Date_In_Service__c = null;
		insert brEssInfo4;

		Contract_Application_Product__c brEssProduct4 = new Contract_Application_Product__c();
		brEssProduct4.Service__c = System.Label.ServiceBiz;
		brEssProduct4.DisplayNameForClient__c = 'テスト商品';
		brEssProduct4.ProposedService__c = 'ESS';
		brEssProduct4.hirePlanCategory__c = '特別';
		brEssProduct4.UnitPrice__c = 50000;
		brEssProduct4.UpfrontFee__c = 50000;
		brEssProduct4.BrRgSuccessFeeRatio__c = 40;
		brEssProduct4.BrTtSuccessFeeRatio__c = 40;
		brEssProduct4.Contract_Application_Information__c = brEssInfo4.Id;
		insert brEssProduct4;
  }
  
  static void createTestNrData() {
  	User user = getUser();
  	Account ac1 = getAccount();

		Opportunity nrOp1 = new Opportunity();
		nrOp1.Name = 'TEST-ABCXYZ20250844';
		nrOp1.UseStartDate__c = Date.valueOf('2015-08-04');
		nrOp1.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:40:00');
		nrOp1.ProposedService__c = 'CRS';
		nrOp1.Type = '新規提案（過去未契約）';
		nrOp1.HirePlanMonths__c = 6;
		nrOp1.OwnerId = user.Id;
		nrOp1.ApplicationApprovalStatus__c = '';
		nrOp1.AccountId = ac1.Id;
		nrOp1.StageName = 'TEST';
		nrOp1.VisitChargeUser__c = user.Id;
		nrOp1.CloseDate = Date.today();
		nrOp1.ContactName__c = '新規_20250844';
		nrOp1.sample_case__c = '*';
		nrOp1.HiringPeriod__c = Date.today();
		nrOp1.Opportunity__c = '*';
		nrOp1.ContractCollectionDate__c = Date.today();
		nrOp1.ContractApplicationNo__c = '202602-000002';
		nrOp1.VisitDate__c = Datetime.now().addDays(2);
		nrOp1.Br_Contract_PDF_ID__c = '00000000000000000';
		nrOp1.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		nrOp1.Ct_Contract_PDF_ID__c = '00000000000000000';
		nrOp1.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		nrOp1.Nr_Contract_PDF_ID__c = '00000000000000000';
		nrOp1.Attach_PDF_ID__c = '00000000000000000';
		insert nrOp1;

		Contract_Application_Information__c nrInfo1 = new Contract_Application_Information__c();
		nrInfo1.Opportunity__c = nrOp1.Id;
		nrInfo1.Service_Name__c = System.Label.ServiceNk;
		nrInfo1.Version_No__c = 1;
		nrInfo1.Approval_Status__c = '承認済';
		nrInfo1.Fetch_Date_In_Service__c = null;
		insert nrInfo1;

		Contract_Application_Product__c nrProduct1 = new Contract_Application_Product__c();
		nrProduct1.Service__c = System.Label.ServiceNk;
		nrProduct1.DisplayNameForClient__c = 'テスト商品';
		nrProduct1.ProposedService__c = 'CRS';
		nrProduct1.hirePlanCategory__c = '成功報酬';
		nrProduct1.UnitPrice__c = 50000;
		nrProduct1.UpfrontFee__c = 50000;
		nrProduct1.NrSuccessFeeRatio__c = 40;
		nrProduct1.Contract_Application_Information__c = nrInfo1.Id;
		insert nrProduct1;
  }
  
  static void createNr2Data() {
  	User user = getUser();
  	Account ac1 = getAccount();
  	
		Opportunity nrOp2 = new Opportunity();
		nrOp2.Name = 'TEST-ABCXYZ20250844';
		nrOp2.UseStartDate__c = Date.valueOf('2015-08-04');
		nrOp2.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:40:00');
		nrOp2.ProposedService__c = 'CRS';
		nrOp2.Type = '新規提案（過去未契約）';
		nrOp2.HirePlanMonths__c = 6;
		nrOp2.OwnerId = user.Id;
		nrOp2.ApplicationApprovalStatus__c = '';
		nrOp2.AccountId = ac1.Id;
		nrOp2.StageName = 'TEST';
		nrOp2.VisitChargeUser__c = user.Id;
		nrOp2.CloseDate = Date.today();
		nrOp2.ContactName__c = '新規_20250844';
		nrOp2.sample_case__c = '*';
		nrOp2.HiringPeriod__c = Date.today();
		nrOp2.Opportunity__c = '*';
		nrOp2.ContractCollectionDate__c = Date.today();
		nrOp2.ContractApplicationNo__c = '202602-000002';
		nrOp2.VisitDate__c = Datetime.now().addDays(2);
		nrOp2.Br_Contract_PDF_ID__c = '00000000000000000';
		nrOp2.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		nrOp2.Ct_Contract_PDF_ID__c = '00000000000000000';
		nrOp2.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		nrOp2.Nr_Contract_PDF_ID__c = '00000000000000000';
		nrOp2.Attach_PDF_ID__c = '00000000000000000';
		insert nrOp2;

		Contract_Application_Information__c nrInfo2 = new Contract_Application_Information__c();
		nrInfo2.Opportunity__c = nrOp2.Id;
		nrInfo2.Service_Name__c = System.Label.ServiceNk;
		nrInfo2.Version_No__c = 1;
		nrInfo2.Approval_Status__c = '承認済';
		nrInfo2.Fetch_Date_In_Service__c = null;
		insert nrInfo2;

		Contract_Application_Product__c nrProduct2 = new Contract_Application_Product__c();
		nrProduct2.Service__c = System.Label.ServiceNk;
		nrProduct2.DisplayNameForClient__c = 'テスト商品';
		nrProduct2.ProposedService__c = 'CRS';
		nrProduct2.hirePlanCategory__c = '特別';
		nrProduct2.UnitPrice__c = 50000;
		nrProduct2.UpfrontFee__c = 50000;
		nrProduct2.NrSuccessFeeRatio__c = 40;
		nrProduct2.Contract_Application_Information__c = nrInfo2.Id;
		insert nrProduct2;
  }

  static void createNr3Data() {
  	User user = getUser();
  	Account ac1 = getAccount();
  	
		Opportunity nrOp3 = new Opportunity();
		nrOp3.Name = 'TEST-ABCXYZ20250844';
		nrOp3.UseStartDate__c = Date.valueOf('2015-08-04');
		nrOp3.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:40:00');
		nrOp3.ProposedService__c = 'CRS';
		nrOp3.Type = '新規提案（過去未契約）';
		nrOp3.HirePlanMonths__c = 6;
		nrOp3.OwnerId = user.Id;
		nrOp3.ApplicationApprovalStatus__c = '';
		nrOp3.AccountId = ac1.Id;
		nrOp3.StageName = 'TEST';
		nrOp3.VisitChargeUser__c = user.Id;
		nrOp3.CloseDate = Date.today();
		nrOp3.ContactName__c = '新規_20250844';
		nrOp3.sample_case__c = '*';
		nrOp3.HiringPeriod__c = Date.today();
		nrOp3.Opportunity__c = '*';
		nrOp3.ContractCollectionDate__c = Date.today();
		nrOp3.ContractApplicationNo__c = '202602-000002';
		nrOp3.VisitDate__c = Datetime.now().addDays(2);
		nrOp3.Br_Contract_PDF_ID__c = '00000000000000000';
		nrOp3.Br_Rs_Contract_PDF_ID__c = '00000000000000000';
		nrOp3.Ct_Contract_PDF_ID__c = '00000000000000000';
		nrOp3.Ct_Rs_Contract_PDF_ID__c = '00000000000000000';
		nrOp3.Nr_Contract_PDF_ID__c = '00000000000000000';
		nrOp3.Attach_PDF_ID__c = '00000000000000000';
		insert nrOp3;

		Contract_Application_Information__c nrInfo3 = new Contract_Application_Information__c();
		nrInfo3.Opportunity__c = nrOp3.Id;
		nrInfo3.Service_Name__c = System.Label.ServiceNk;
		nrInfo3.Version_No__c = 1;
		nrInfo3.Approval_Status__c = '承認済';
		nrInfo3.Fetch_Date_In_Service__c = null;
		insert nrInfo3;

		Contract_Application_Product__c nrProduct3 = new Contract_Application_Product__c();
		nrProduct3.Service__c = System.Label.ServiceNk;
		nrProduct3.DisplayNameForClient__c = 'テスト商品';
		nrProduct3.ProposedService__c = 'CRS';
		nrProduct3.hirePlanCategory__c = '特別';
		nrProduct3.UnitPrice__c = 50000;
		nrProduct3.UpfrontFee__c = 50000;
		nrProduct3.NrSuccessFee__c = 40;
		nrProduct3.Contract_Application_Information__c = nrInfo3.Id;
		insert nrProduct3;
  }

  static Account getAccount() {
    return [SELECT ID
              FROM Account
             WHERE Name = 'Test Inc'];
  }

  static Account getAccountEss() {
    return [SELECT ID
              FROM Account
             WHERE Name = 'Test Inc 5673'];
  }

  static Contract_Application_Information__c getInfo() {
    return [SELECT ID,
                   Approval_Status__c,
                   Fetch_Date_In_Service__c,
                   Version_No__c
              FROM Contract_Application_Information__c
             WHERE Name = 'BrInfo'];
  }

  static Opportunity getOpportunity() {
    return [SELECT ID,
                   ContractApplicationNo__c,
                   Br_Contract_PDF_ID__c,
                   Br_Rs_Contract_PDF_ID__c,
                   Ct_Contract_PDF_ID__c,
                   Ct_Rs_Contract_PDF_ID__c,
                   Nr_Contract_PDF_ID__c,
                   Attach_PDF_ID__c
              FROM Opportunity
             WHERE ContactName__c ='新規_20150831'];
  }
  
  static User getUser() {
  	return [SELECT ID
  	          FROM User
  	         WHERE Username = 'test2@sutead.com'];
  }
}