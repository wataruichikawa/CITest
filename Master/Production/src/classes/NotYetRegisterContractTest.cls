@isTest
private class NotYetRegisterContractTest {
	static private String CONTACT_NAME = 'テスト太郎';
	
	@testSetup
	static void setUP() {
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
	}

  static testMethod void notExistsOpportunity() {
    PageReference pageRef = Page.NotYetRegisterContract;
    Test.setCurrentPage(pageRef);
    Opportunity emptyOpportunity = new Opportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyOpportunity);
    NotYetRegisterContractList controller = new NotYetRegisterContractList(sc);
    System.assertEquals(null, controller.selectList());
    System.assertEquals(true, controller.getDtoList().isEmpty());
  } 

  static testMethod void notExistsContracts() {
  	createOpportunity(CONTACT_NAME);
  	Opportunity o = getOpportunity(CONTACT_NAME);
  	
    PageReference pageRef = Page.NotYetRegisterContract;
    Test.setCurrentPage(pageRef);
    Opportunity emptyOpportunity = new Opportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyOpportunity);
    NotYetRegisterContractList controller = new NotYetRegisterContractList(sc);
    System.assertEquals(null, controller.selectList());
    System.assertNotEquals(true, controller.getDtoList().isEmpty());
  } 
  
  static testMethod void existsAppliedContracts() {
  	createOpportunity(CONTACT_NAME);
  	Opportunity o = getOpportunity(CONTACT_NAME);
  	
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = o.Id;
    info.Contract_Application_Memo__c = '012345678901234567';
    info.Approval_Status__c = '承認済';
    insert info;

    PageReference pageRef = Page.NotYetRegisterContract;
    Test.setCurrentPage(pageRef);
    Opportunity emptyOpportunity = new Opportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyOpportunity);
    NotYetRegisterContractList controller = new NotYetRegisterContractList(sc);
    System.assertEquals(null, controller.selectList());
    System.assertEquals(true, controller.getDtoList().isEmpty());
  } 
  
  static testMethod void existsDisapprovalContracts() {
  	createOpportunity(CONTACT_NAME);
  	Opportunity o = getOpportunity(CONTACT_NAME);
  	
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = o.Id;
    info.Contract_Application_Memo__c = '012345678901234567';
    info.Approval_Status__c = '不承認';
    insert info;
  	
    PageReference pageRef = Page.NotYetRegisterContract;
    Test.setCurrentPage(pageRef);
    Opportunity emptyOpportunity = new Opportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyOpportunity);
    NotYetRegisterContractList controller = new NotYetRegisterContractList(sc);
    System.assertEquals(null, controller.selectList());
    System.assertNotEquals(true, controller.getDtoList().isEmpty());
  } 

  static testMethod void existsWaitReApplyContracts() {
  	createOpportunity(CONTACT_NAME);
  	Opportunity o = getOpportunity(CONTACT_NAME);
  	
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = o.Id;
    info.Contract_Application_Memo__c = '012345678901234567';
    info.Approval_Status__c = '再申請待ち';
    insert info;
  	
    PageReference pageRef = Page.NotYetRegisterContract;
    Test.setCurrentPage(pageRef);
    Opportunity emptyOpportunity = new Opportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyOpportunity);
    NotYetRegisterContractList controller = new NotYetRegisterContractList(sc);
    System.assertEquals(null, controller.selectList());
    System.assertNotEquals(true, controller.getDtoList().isEmpty());
  } 

  static testMethod void correctDisplayOrder() {
  	// テストデータの作成。商談は6個必要。
  	for (Integer i = 1; i <= 6; i++) {
  		createOpportunity(CONTACT_NAME + i.format());
  	}

  	Opportunity o1 = getOpportunity(CONTACT_NAME + '1');

  	Opportunity o2 = getOpportunity(CONTACT_NAME + '2');
  	o2.useStartDate__c = Date.today().addDays(-2);
  	update o2;
  	
  	Opportunity o3 = getOpportunity(CONTACT_NAME + '3');
  	o3.ApplicationApprovalDate__c = Date.today().addDays(-7);
  	update o3;

  	Contract_Application_Information__c info3 = new Contract_Application_Information__c();
  	info3.Opportunity__c = o3.Id;
  	info3.Approval_Status__c = '再申請待ち';
  	insert info3;
  	
  	Opportunity o4 = getOpportunity(CONTACT_NAME + '4');
  	o4.ApplicationApprovalDate__c = Date.today().addDays(-1);
  	update o4;

  	Contract_Application_Information__c info4 = new Contract_Application_Information__c();
  	info4.Opportunity__c = o4.Id;
  	info4.Approval_Status__c = '再申請待ち';
  	insert info4;

  	Opportunity o5 = getOpportunity(CONTACT_NAME + '5');
  	o5.ApplicationApprovalDate__c = Date.today().addDays(-7);
  	update o5;

  	Contract_Application_Information__c info5 = new Contract_Application_Information__c();
  	info5.Opportunity__c = o5.Id;
  	info5.Approval_Status__c = '不承認';
  	insert info5;

  	Opportunity o6 = getOpportunity(CONTACT_NAME + '6');
  	o6.ApplicationApprovalDate__c = Date.today().addDays(-1);
  	update o6;

  	Contract_Application_Information__c info6 = new Contract_Application_Information__c();
  	info6.Opportunity__c = o6.Id;
  	info6.Approval_Status__c = '不承認';
  	insert info6;

    PageReference pageRef = Page.NotYetRegisterContract;
    Test.setCurrentPage(pageRef);
    Opportunity emptyOpportunity = new Opportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(emptyOpportunity);
    NotYetRegisterContractList controller = new NotYetRegisterContractList(sc);
    System.assertEquals(null, controller.selectList());
    System.assertNotEquals(true, controller.getDtoList().isEmpty());
    System.assertEquals(6, controller.getDtoList().size());
    System.assertEquals(o6.Id, controller.getDtoList().get(0).opportunityId);
    System.assertEquals(o5.Id, controller.getDtoList().get(1).opportunityId);
    System.assertEquals(o4.Id, controller.getDtoList().get(2).opportunityId);
    System.assertEquals(o3.Id, controller.getDtoList().get(3).opportunityId);
    System.assertEquals(o2.Id, controller.getDtoList().get(4).opportunityId);
    System.assertEquals(o1.Id, controller.getDtoList().get(5).opportunityId);
  } 

  static private void createOpportunity(String contactName) {
  	User user = getUser();
  	Account account = getAccount();
  	
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
    op.ApplicationApprovalStatus__c = '申請中';
    op.useStartDate__c = Date.today();
    op.useEndDate__c = Date.today().addDays(122);
    op.ContactName__c = contactName;
    insert op;
  }
  
  static private Opportunity getOpportunity(String contactName) {
  	return [SELECT Id,
  	               ApplicationApprovalStatus__c
  	          FROM Opportunity
  	         WHERE ContactName__c = :contactName];
  }
  
  static private User getUser() {
  	return [SELECT ID
  	          FROM User
  	         WHERE username = 'test1@sutead.com'];
  }
  
  static private Account getAccount() {
  	return [SELECT Id
  	          FROM Account
  	         WHERE Name = 'Test Inc'];
  }
}