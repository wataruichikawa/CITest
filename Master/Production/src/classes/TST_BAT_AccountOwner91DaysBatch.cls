/**
 * TST_BAT_AccountOwner91DaysBatch
 *
 * テスト対象
 * 1.BAT_AccountOwner91DaysBatch
 * 2.SCH_BatchScheduler
 * 3.SCH_AccountOwner91DaysBatch
 * 4.BAT_JobExecutor
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_BAT_AccountOwner91DaysBatch {


	@testSetup
	static void setUp() {
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		bjo.job1__c = BAT_JobExecutor.JOB_ACC_91;
		bjo.StartJobNo__c = 1;
		bjo.FinishJobNo__c = 1;
		insert bjo;

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			UserRole userRole = new UserRole(name = 'Dymmy_Role', RollupDescription = 'Report_Name');
			insert userRole;
			User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.Id);
			List<User> userList = new List<User>();
			userList.add(user1);

			List<User> confirmUser = [Select Id, Name From User Where userName = :system.Label.adminUserName];
			User user2;
			if (confirmUser.isEmpty()) {
				user2 = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = system.Label.adminUserName, Email = 'test1@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = UserInfo.getUserRoleId());
				userList.add(user2);
			}
			insert userList;
		}
	}

	static testMethod void testExecute() {
		DateTime sysTime = system.now();

		List<String> unList = new List<String>();
		unList.add('test1@sutead.com');
		unList.add(system.Label.adminUserName);
		User user = [Select Id, UserRoleId, UserName From User Where Username = 'test1@sutead.com'];

		HuriwakeMaster__c hm = new HuriwakeMaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '千代田区', Tyouiki__c = '千代田', TodouhukenShikutyouson__c = '東京都千代田区', RoleID__c = user.UserRoleId, InboundRoleId__c = user.UserRoleId);
		insert hm;

		Account ac1 = new Account(name = 'Test Company1', AccountType__c = 'CRS', Phone = '00-1111-2222', website = 'http://www.bizreach1.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false);
		Account ac2 = new Account(name = 'Test Company2', AccountType__c = 'CRS', Phone = '00-1111-2223', website = 'http://www.bizreach2.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false);
		Account ac3 = new Account(name = 'Test Company3', AccountType__c = 'CRS', Phone = '00-1111-2224', website = 'http://www.bizreach3.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false);
		List<Account> acList = new Account[] { ac1, ac2, ac3 };
		insert acList;

		Opportunity opp1 = new Opportunity(name = 'testOp1', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac1.Id, ProposedService__c = 'CRS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = sysTime);
		Opportunity opp2 = new Opportunity(name = 'testOp2', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac2.Id, ProposedService__c = 'CRS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = sysTime);
		Opportunity opp3 = new Opportunity(name = 'testOp3', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac3.Id, ProposedService__c = 'CRS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = sysTime);
		List<Opportunity> oppList = new Opportunity[] { opp1, opp2, opp3 };
		insert oppList;

		opp1.VisitDate__c = sysTime.addDays(-89);
		opp2.VisitDate__c = sysTime.addDays(-90);
		opp3.VisitDate__c = sysTime.addDays(-91);
		update oppList;

		Test.startTest();
		String jobId = System.schedule('executeTest1','0 0 * * * ?', new SCH_BatchScheduler());
		jobId = System.schedule('executeTest2','0 0 * * * ?', new SCH_AccountOwner91DaysBatch());
		Test.stopTest();

    }

}