/**
 * TST_BAT_AutoCreateOfOpportunityBatch
 *
 * テスト対象
 * 1.BAT_AutoCreateOfOpportunityBatch
 * 2.SCH_BatchScheduler
 * 3.SCH_AutoCreateOfOpportunityBatch
 * 4.BAT_JobExecutor
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
 @isTest
private class TST_BAT_AutoCreateOfOpportunityBatch {

	@testSetup
	static void setUp() {
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		bjo.job1__c = BAT_JobExecutor.JOB_AC_O;
		bjo.StartJobNo__c = 1;
		bjo.FinishJobNo__c = 1;
		insert bjo;

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			User user = new User(LastName = 'AC_TEST', FirstName = 'USER', Username = 'auto_create_test@example.com', Email = 'auto_create_test@example.com', Alias = 'ac_test', CommunityNickname = 'ac_test', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000hXeV', LanguageLocaleKey = 'ja', UserRoleId = '00E10000000i5R3');
			insert user;
		}
	}

	static testMethod void testExecute() {
		Date today = system.today();
		Date afterday = (today + Integer.valueOf(system.Label.AutomationCreateOfOpportuniyBeforeDay));

		User user = [Select Id, UserRoleId, UserName From User Where Username = 'auto_create_test@example.com'];

		// 契約終了日がない
		Account ac1 = new Account(name = 'Test Company1', AccountType__c = 'ESS', Phone = '00-1111-2222', website = 'http://www.bizreach1.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false);
		Account ac2 = new Account(name = 'Test Company2', AccountType__c = 'ESS', Phone = '00-1111-2223', website = 'http://www.bizreach2.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false);
		Account ac3 = new Account(name = 'Test Company3', AccountType__c = 'ESS', Phone = '00-1111-2224', website = 'http://www.bizreach3.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false);

		// ビズの契約終了日あり
		Account ac4 = new Account(name = 'Test Company4', AccountType__c = 'ESS', Phone = '00-1111-2225', website = 'http://www.bizreach4.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false, Field156__c = afterday);
		// キャリトレの契約終了日あり
		Account ac5 = new Account(name = 'Test Company5', AccountType__c = 'ESS', Phone = '00-1111-2226', website = 'http://www.bizreach5.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false, CT_CurrentContractTermEndDate__c = afterday);
		// ビズとキャリトレの契約終了日あり
		Account ac6 = new Account(name = 'Test Company6', AccountType__c = 'ESS', Phone = '00-1111-2227', website = 'http://www.bizreach6.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false, Field156__c = afterday, CT_CurrentContractTermEndDate__c = afterday);
		Account ac7 = new Account(name = 'Test Company7', AccountType__c = 'ESS', Phone = '00-1111-2228', website = 'http://www.bizreach7.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = user.Id, careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田', CompanyTeritory__c = '', Field1__c = '', Field252__c = '', Field14__c = false, Field156__c = afterday, CT_CurrentContractTermEndDate__c = afterday);

		List<Account> acList = new Account[] { ac1, ac2, ac3, ac4, ac5, ac6, ac7 };
		insert acList;

		RecordType recordType = [SELECT Id FROM RecordType WHERE IsActive = true AND SobjectType = 'Opportunity' AND DeveloperName = 'ESS'];
		/** ビズリーチデータ */
		// 一日前
		Opportunity opp1 = new Opportunity(name = 'testOp1', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac1.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = (afterday - 1), RecordTypeId = recordType.Id);
		// ターゲット日
		Opportunity opp2 = new Opportunity(name = 'testOp2', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac2.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = afterday, RecordTypeId = recordType.Id);
		// 一日後
		Opportunity opp3 = new Opportunity(name = 'testOp3', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac3.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = (afterday + 1), RecordTypeId = recordType.Id);
		// ターゲット日 だけど、商談自動作成フラグが true
		Opportunity opp4 = new Opportunity(name = 'testOp4', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac2.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = afterday, RecordTypeId = recordType.Id, NextOpportunityAutomaticCreated__c = true);
		/** キャリトレデータ */
		// ターゲット日
		Opportunity opp5 = new Opportunity(name = 'testOp5', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac2.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = afterday, RecordTypeId = recordType.Id);

		// ビズ契約終了をつける
		Opportunity opp6 = new Opportunity(name = 'testOp6', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac4.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = (afterday - 1), RecordTypeId = recordType.Id);
		// キャリトレ契約終了をつける
		Opportunity opp7 = new Opportunity(name = 'testOp7', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac5.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = (afterday - 1), RecordTypeId = recordType.Id);
		// ビズ・キャリトレ契約終了をつける
		Opportunity opp8 = new Opportunity(name = 'testOp8', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = user.Id, AppoAcquisitionUser__c = user.Id, AccountId = ac6.Id, ProposedService__c = 'ESS', hasCreatedCalendar__c = true, OwnerId = user.Id, VisitDate__c = today, UseStartDate__c = today, UseEndDate__c = (afterday - 1), RecordTypeId = recordType.Id);
		List<Opportunity> oppList = new Opportunity[] { opp1, opp2, opp3, opp4, opp5, opp6, opp7, opp8 };
		insert oppList;

		system.debug('debug before');
		system.debug(oppList);
		
		Test.startTest();
		String jobId = System.schedule('executeTest1','0 0 * * * ?', new SCH_BatchScheduler());
		jobId = System.schedule('executeTest2','0 0 * * * ?', new SCH_AutoCreateOfOpportunityBatch());
		Test.stopTest();
	}
}