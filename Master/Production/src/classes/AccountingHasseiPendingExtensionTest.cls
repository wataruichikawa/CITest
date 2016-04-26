@isTest
private class AccountingHasseiPendingExtensionTest {
	private static String REQUEST_PROCESS_NAME = 'Approval_Contract_Hassei_Sales';
	private static String RE_REQUEST_PROCESS_NAME = 'ReApproval_Contract_Hassei_Sales';

	@testSetup
	static void setup() {
    User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', 
                         CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
                         ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
    insert manager;
	}
	
  static testMethod void notExistsApprovalRequest() {
  	User manager = getManager();
  	System.assertNotEquals(null, manager);

    PageReference pageRef = Page.AccountingHasseiPendingList;
    Test.setCurrentPage(pageRef);
    Contract_Application_Information__c emptyInfo = new Contract_Application_Information__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyInfo);
    AccountingHasseiPendingExtension controller = new AccountingHasseiPendingExtension(sc);
    
    Test.startTest();
    System.runAs(manager) {
			System.assertEquals(null, controller.selectList());
			System.assertEquals(true, controller.getDtoList().isEmpty());
    }
    Test.stopTest();
  }  
   
  static testMethod void existsBrApprovalRequest() {
  	User manager = getManager();
  	System.assertNotEquals(null, manager);

    PageReference pageRef = Page.AccountingHasseiPendingList;
    Test.setCurrentPage(pageRef);
    Contract_Application_Information__c emptyInfo = new Contract_Application_Information__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyInfo);
    AccountingHasseiPendingExtension controller = new AccountingHasseiPendingExtension(sc);

		createData(System.Label.ServiceBiz);
		
    Test.startTest();
    System.runAs(manager) {
			System.assertEquals(null, controller.selectList());
			System.assertEquals(false, controller.getDtoList().isEmpty());
    }
    Test.stopTest();
  }
   
  static testMethod void existsCtApprovalRequest() {
  	User manager = getManager();
  	System.assertNotEquals(null, manager);

    PageReference pageRef = Page.AccountingHasseiPendingList;
    Test.setCurrentPage(pageRef);
    Contract_Application_Information__c emptyInfo = new Contract_Application_Information__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyInfo);
    AccountingHasseiPendingExtension controller = new AccountingHasseiPendingExtension(sc);

		createData(System.Label.ServiceCt);
		
    Test.startTest();
    System.runAs(manager) {
			System.assertEquals(null, controller.selectList());
			System.assertEquals(false, controller.getDtoList().isEmpty());
    }
    Test.stopTest();
  }

  static testMethod void existsNrApprovalRequest() {
  	User manager = getManager();
  	System.assertNotEquals(null, manager);

    PageReference pageRef = Page.AccountingHasseiPendingList;
    Test.setCurrentPage(pageRef);
    Contract_Application_Information__c emptyInfo = new Contract_Application_Information__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyInfo);
    AccountingHasseiPendingExtension controller = new AccountingHasseiPendingExtension(sc);

		createData(System.Label.ServiceNk);
		
    Test.startTest();
    System.runAs(manager) {
			System.assertEquals(null, controller.selectList());
			System.assertEquals(false, controller.getDtoList().isEmpty());
    }
    Test.stopTest();
  }

  static testMethod void displayOrder() {
  	User manager = getManager();
  	System.assertNotEquals(null, manager);

    PageReference pageRef = Page.AccountingHasseiPendingList;
    Test.setCurrentPage(pageRef);
    Contract_Application_Information__c emptyInfo = new Contract_Application_Information__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyInfo);
    AccountingHasseiPendingExtension controller = new AccountingHasseiPendingExtension(sc);

		createData(System.Label.ServiceBiz);
		
		Contract_Application_Information__c info = getInfo();
		info.Approval_Status__c = '再申請待ち';
		update info;
		
		Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

		psr.setObjectId(info.Id); //契約内容と承認申請を紐付け
		psr.setComments('');//コメントを設定
		psr.setProcessDefinitionNameOrId(RE_REQUEST_PROCESS_NAME);//承認プロセスを指定
		psr.setSubmitterId(manager.Id);

		List<Id> nextApproverIds = new List<Id>();
		nextApproverIds.add(manager.Id);
		psr.setNextApproverIds(nextApproverIds);

		try {
			Approval.ProcessResult submitResult = Approval.process(psr);// プロセス実行
		} catch (Exception e) {
		}

    Test.startTest();
    System.runAs(manager) {
			System.assertEquals(null, controller.selectList());
			System.assertEquals(false, controller.getDtoList().isEmpty());
			System.assertEquals(2, controller.getDtoList().size());
			System.assertEquals(info.Id, controller.getDtoList().get(0).infoId);
    }
    Test.stopTest();
  }
   
  static private void createData(string serviceName) {
    User manager = getManager();
    
    User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', 
                         CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
                         ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id, SalesApprovalUser__c = manager.Id);
    insert user;

    Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
                              Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
                              CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
    insert ac1;

    Account ac2 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
                              Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
                              CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
    insert ac2;

    Opportunity op = new Opportunity();
    op.Name = 'TEST-ABCXYZ20150831';
    op.UseStartDate__c = Date.valueOf('2015-08-03');
    op.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
    op.ProposedService__c = 'ESS';
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
    op.ApplicationApprovalStatus__c = '申請中';
    op.useStartDate__c = Date.today().addDays(2);
    op.useEndDate__c = Date.today().addDays(122);
    op.ContactName__c = 'TEST1';
    insert op;

    Opportunity op2 = new Opportunity();
    op2.Name = 'TEST-ABDXYZ20150831';
    op2.UseStartDate__c = Date.valueOf('2015-08-03');
    op2.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
    op2.ProposedService__c = 'ESS';
    op2.Type = '新規提案（過去未契約）';
    op2.HirePlanMonths__c = 6;
    op2.OwnerId = user.Id;
    op2.ApplicationApprovalStatus__c = '';
    op2.AccountId = ac2.Id;
    op2.StageName = 'TEST';
    op2.VisitChargeUser__c = user.Id;
    op2.CloseDate = Date.today();
    op2.ContactName__c = '新規_20150831';
    op2.sample_case__c = '*';
    op2.HiringPeriod__c = Date.today();
    op2.Opportunity__c = '*';
    op2.ContractCollectionDate__c = Date.today();
    op2.ApplicationApprovalStatus__c = '申請中';
    op2.useStartDate__c = Date.today().addDays(2);
    op2.useEndDate__c = Date.today().addDays(122);
    op2.ContactName__c = 'TEST2';
    insert op2;
   	
  	Contract_Application_Information__c info1 = new Contract_Application_Information__c();
  	info1.Service_Name__c = serviceName;
  	info1.Opportunity__c = op.Id;
    info1.Version_No__c = 5;
    insert info1;
  	
    ProductDto dto = new ProductDto();
    dto.serviceName = serviceName;
    dto.serviceType = 'ESS';
    dto.initialPrice = 50000;
    dto.platinumScoutCount = 1000;
    dto.platinumScoutInitialCount = 50;
    dto.platinumScoutTypeName = '全クラス';
    dto.replaceFeeTypeName = '固定金額';

    ReplaceFeeDto feeDto = new ReplaceFeeDto();
    feeDto.replaceFee = 50000;
    dto.replaceFeeList.add(feeDto);
    
    ProductLogic logic = new ProductLogic();
    Contract_Application_Product__c product = logic.convertFromDtoToContractApplicationProduct(dto);
    product.Contract_Application_Information__c = info1.Id;
    insert product;

  	Contract_Application_Information__c info2 = new Contract_Application_Information__c();
  	info2.Service_Name__c = serviceName;
  	info2.Opportunity__c = op2.Id;
    info2.Version_No__c = 15;
    insert info2;
  	
    product = logic.convertFromDtoToContractApplicationProduct(dto);
    product.Contract_Application_Information__c = info2.Id;
    insert product;

		Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

		psr.setObjectId(info2.Id); //契約内容と承認申請を紐付け
		psr.setComments('');//コメントを設定
		psr.setProcessDefinitionNameOrId(REQUEST_PROCESS_NAME);//承認プロセスを指定
		psr.setSubmitterId(user.Id);

		List<Id> nextApproverIds = new List<Id>();
		nextApproverIds.add(manager.Id);
		psr.setNextApproverIds(nextApproverIds);

		try {
			Approval.ProcessResult submitResult = Approval.process(psr);// プロセス実行
		} catch (Exception e) {
		}
  }
   
  static private User getManager() {
		return [SELECT Id
              FROM User
             Where Username = 'test1@sutead.com'];
  }
  
  static private Contract_Application_Information__c getInfo() {
  	return [SELECT Id
  	          FROM Contract_Application_Information__c
  	         WHERE Version_No__c = 5];
  }
}