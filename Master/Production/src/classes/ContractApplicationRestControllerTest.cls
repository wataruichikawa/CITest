@isTest
private class ContractApplicationRestControllerTest {
  @testSetup
  static void setUp() {
    User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
    insert manager;

    User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
    insert user;

		Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
		insert ac1;

    Account ac2 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
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
    op.useStartDate__c = Date.today().addDays(2);
    op.useEndDate__c = Date.today().addDays(120);
    insert op;

    Contract_Application_Information__c info = new Contract_Application_Information__c();
    info.Opportunity__c = op.Id;
    info.Contract_Application_Memo__c = '012345678901234567';
    info.Approval_Status__c = '承認済';
    insert info;

    ProductDto dto = new ProductDto();
    dto.serviceName = 'ビズリーチ';
    dto.serviceType = 'CRS';
    dto.initialPrice = 50000;
    dto.platinumScoutCount = 1000;
    dto.platinumScoutInitialCount = 50;
    dto.platinumScoutTypeName = 'タレント';
    dto.replaceFeeTypeName = '固定金額';

    ReplaceFeeDto feeDto = new ReplaceFeeDto();
    feeDto.labelName = 'ハイクラス';
    feeDto.replaceFee = 50000;
    feeDto.minimumFee = 10000;
    dto.replaceFeeList.add(feeDto);

    feeDto = new ReplaceFeeDto();
    feeDto.labelName = 'タレント';
    feeDto.replaceFee = 50000;
    feeDto.minimumFee = 10000;
    dto.replaceFeeList.add(feeDto);
  }

  static testMethod void getErrorTest() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/ContractApplication';
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;

    String result = ContractApplicationRestController.doGet();

    System.assertEquals('{"response":"error", "reason":"Required parameter serviceType and lastModifiedTimeStr"}', result);
  }

  static testMethod void getCorrectParameterTest() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/ContractApplication';
    req.httpMethod = 'GET';
    req.params.put('serviceType', 'BizReach');
    RestContext.request = req;
    RestContext.response = res;

    String result = ContractApplicationRestController.doGet();

    System.assertNotEquals('{"response":"error", "reason":"Required parameter serviceType and lastModifiedTimeStr"}', result);

  }

  static testMethod void postTest1() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/ContractApplication';
    req.httpMethod = 'POST';
    req.params.put('serviceType', 'BizReach');
    req.params.put('contractApplicationNos', '201601-000001');
    RestContext.request = req;
    RestContext.response = res;

    String result = '';
    result = ContractApplicationRestController.doPost();

    System.assertEquals(null, result);

  }

  static testMethod void postTest2() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/ContractApplication';
    req.httpMethod = 'POST';
    req.params.put('serviceType', 'BizReach');
    req.params.put('contractApplicationNos', '201601-000001,201601-000002');
    RestContext.request = req;
    RestContext.response = res;

    String result = '';
    result = ContractApplicationRestController.doPost();

    System.assertEquals(null, result);
  }
}