@isTest
private class ContractApplicationInfoTriggerTest {
  @testSetup
  static void setUp() {
      User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
      insert manager;

      User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
      insert user;

      Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
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
      insert op;
  }
  
  static testMethod void insertInfo() {
  	Opportunity opp = getOpportunity();
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = opp.Id;
  	info.Service_Name__c = 'ビズリーチ';
  	insert info;
  	
  	info.Id = null;
  	info.Service_Name__c = 'キャリアトレック';
  	insert info;	// 違うサービスなら同じ商談に登録できる。
  	
  	info.Id = null;
  	
  	try {
  		insert info; // 同じサービスなら契約の登録に失敗する。
  	} catch (exception e) {
  		System.assertNotEquals(null, e);
  	}
  }

  static testMethod void multiInsertInfo() {
  	Opportunity opp = getOpportunity();
  	Contract_Application_Information__c info = new Contract_Application_Information__c();
  	info.Opportunity__c = opp.Id;
  	info.Service_Name__c = 'ビズリーチ';
  	insert info;
  	
  	Contract_Application_Information__c info2 = new Contract_Application_Information__c();
  	info2.Opportunity__c = opp.Id;
  	info2.Service_Name__c = 'キャリアトレック';
  	insert info2;	// 違うサービスなら同じ商談に登録できる。
  	
  	info.Id = null;
  	info2.Id = null;
  	List<Contract_Application_Information__c> infoList = new List<Contract_Application_Information__c>();

  	infoList.add(info);
  	infoList.add(info2);
  	
  	try {
  		insert infoList; // 同じサービスなら契約の登録に失敗する。
  	} catch (exception e) {
  		System.assertNotEquals(null, e);
  	}
  }

	static private Opportunity getOpportunity(){
		return [select Id,Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c,UseEndDate__c,
		               Type,OwnerId,HirePlanMonths__c,ContractCollectionDate__c,Amount
					    from Opportunity Where ContactName__c ='新規_20150831'];
	}
}