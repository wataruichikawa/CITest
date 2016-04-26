/**
 * TST_BAT_AccountLeadShukeiBatch
 *
 * テスト対象
 * 1.BAT_DrcActivityHistoryAlertBatch
 * 2.SCH_BatchScheduler
 * 3.SCH_DrcActivityHistoryAlertBatch
 * 4.BAT_JobExecutor
 * 5.ACC_DrcAccountManagement
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_BAT_DrcActivityHistoryAlertBatch {

	/**
	 * 関連先が取引先の活動履歴テスト(CRS_担当営業あり)
	 * レポートのデータが取得できないのでSeeAllData=trueを設定
	 */
	/*
	@isTest(SeeAllData=true)
	static void testExecuteAccount1() {
		User usr = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = UserInfo.getUserRoleId());
		insert usr;
		Account acc = new Account(Name = 'Test Company1', Phone = '001-0000-9999', Field221__c = 'インターネットサービス', CrsSales_RepresentativeMain__c = usr.Id);
		insert acc;
		Task tsk = new Task(WhatId = acc.Id, OwnerId = usr.Id);
		insert tsk;

		Test.startTest();
		String jobId = system.schedule('BAT_DrcActivityHistoryAlertBatch', '0 0 * * * ?', new SCH_DrcActivityHistoryAlertBatch());
		Test.stopTest();
	}
	*/

	/**
	 * 関連先が取引先の活動履歴テスト(CRS_担当営業なし)
	 */
	@isTest(SeeAllData=false)
	static void testExecuteAccount2() {
		Account acc = new Account(Name = 'Test Company1', Phone = '01-0001-0001', Field221__c = 'インターネットサービス', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		insert acc;
		Task tsk = new Task(WhatId = acc.Id);
		insert tsk;

		Test.startTest();
		String jobId = system.schedule('BAT_DrcActivityHistoryAlertBatch', '0 0 * * * ?', new SCH_DrcActivityHistoryAlertBatch());
		Test.stopTest();
	}

	/**
	 * 関連先が商談の活動履歴テスト
	 */
	@isTest(SeeAllData=false)
	static void testExecuteOpportunity() {
		User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		User usr;
		System.runAs(u) {
			usr = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = UserInfo.getUserRoleId());
			insert usr;
		}
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		bjo.job1__c = BAT_JobExecutor.JOB_AH_ALERT;
		bjo.StartJobNo__c = 1;
		bjo.FinishJobNo__c = 1;
		insert bjo;

		Account acc = new Account(Name = 'Test Company1', Phone = '01-0001-0001', Field221__c = 'インターネットサービス', CrsSales_RepresentativeMain__c = usr.Id, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		insert acc;
		Opportunity opp = new Opportunity(name = 'testOp1', CloseDate = system.today(), StageName = 'アポ獲得', VisitChargeUser__c = UserInfo.getUserId(), AppoAcquisitionUser__c = UserInfo.getUserId(), AccountId = acc.Id, ProposedService__c = 'CRS', hasCreatedCalendar__c = true, VisitDate__c = system.now());
		insert opp;
		Task tsk = new Task(WhatId = acc.Id);
		insert tsk;

		Test.startTest();
		String jobId = system.schedule('BAT_DrcActivityHistoryAlertBatch', '0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();
	}

}