/**
 * TST_BAT_PersonalKPIJissekiSyukeiBatch
 *
 * テスト対象
 * 1.BAT_PersonalKPIJissekiSyukeiBatch
 * 2.SCH_BatchScheduler
 * 3.SCH_PersonalKPIJissekiSyukeiBatch
 * 4.BAT_JobExecutor
 * 1商談複数化対応で一旦コメントアウトする.
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_BAT_PersonalKPIJissekiSyukeiBatch {

	/**
	 * セットアップ
	 * ユーザ,取引先データ登録
	 */
	@testSetup
	static void setUp() {
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		bjo.job1__c = BAT_JobExecutor.JOB_KPI_SYUKEI;
		bjo.StartJobNo__c = 1;
		bjo.FinishJobNo__c = 1;
		insert bjo;

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			UserRole userRole = new UserRole(name = 'Dymmy_Role', RollupDescription = 'Report_Name');
			insert userRole;
			User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com.abc', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
			User user2 = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com.abc', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
			User user3 = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com.abc', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
			User user4 = new User(LastName = 'TEST4', FirstName = 'TEST4', Username = 'test4@sutead.com.abc', Email = 'test4@sutead.com', Alias = 'test4', CommunityNickname = 'test4', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
			User user5 = new User(LastName = 'TEST5', FirstName = 'TEST5', Username = 'test5@sutead.com.abc', Email = 'test5@sutead.com', Alias = 'test5', CommunityNickname = 'test5', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
			List<User> userList = new List<User>();
			userList.add(user1);
			userList.add(user2);
			userList.add(user3);
			userList.add(user4);
			userList.add(user5);
			insert userList;
		}
		Account ac = new Account(name = 'Test Company', AccountType__c = 'CRS', Phone = '00-1111-2222', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = UserInfo.getLastName() + ' ' + UserInfo.getFirstName(), ownerid = UserInfo.getUserid(), careertreck_sales_representative__c = UserInfo.getUserid(), CrtSalesStaffForLink__c = UserInfo.getName(), BillingState = '東京都', BillingCity = '千代田区', BillingStreet = '千代田');
		insert ac;
	}

	/**
	 * サービス：キャリアトレック
	 * 個人別KPI：なし
	 * 商談：通常
	 * 申込書回収日の個人別KPI：あり
	 */
	static testMethod void testCareertrek1() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		Map<String, User> userMap = findUserMap();
		User user1 = userMap.get('test1@sutead.com.abc');
		User user2 = userMap.get('test2@sutead.com.abc');
		User user3 = userMap.get('test3@sutead.com.abc');

		Account ac = findAccount();
		Opportunity opp01 = createOpportunity(user1, ac);
		Opportunity opp02 = createOpportunity(user1, ac);
		Opportunity opp03 = createOpportunity(user1, ac);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp01);
		oppList.add(opp02);
		oppList.add(opp03);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate - 5;
		}
		opp02.AppoAcquisitionUser__c = user2.Id;
		opp03.AppoAcquisitionUser__c = user3.Id;

		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		PersonalKPI__c kpi01 = insertPersonalKPI(user1, targetDate - 5);
		PersonalKPI__c kpi02 = insertPersonalKPI(user2, targetDate);
		List<PersonalKPI__c> kpiList = new List<PersonalKPI__c>();
		kpiList.add(kpi01);
		kpiList.add(kpi02);
		insert kpiList;

		Test.startTest();
		String jobId = System.schedule('testCareertrek1','0 0 * * * ?', new SCH_PersonalKPIJissekiSyukeiBatch());
		Test.stopTest();

	}

	/**
	 * サービス：キャリアトレック
	 * 個人別KPI：あり
	 * 商談：削除済
	 * 申込書回収日の個人別KPI：なし
	 */
/*
	static testMethod void testCareertrek1Delete() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan01 = insertMstHirePlan('キャリアトレック', 'スタンダードプラン');
		MstHirePlan__c plan02 = insertMstHirePlan('キャリアトレック', 'トライアルプラン');
		MstHirePlan__c plan03 = insertMstHirePlan('キャリアトレック', 'プレミアムプラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan01);
		planList.add(plan02);
		planList.add(plan03);
		insert planList;

		Account ac = findAccount();
		Opportunity opp01 = createOpportunity(user, ac, plan01, null);
		Opportunity opp02 = createOpportunity(user, ac, plan02, null);
		Opportunity opp03 = createOpportunity(user, ac, plan03, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp01);
		oppList.add(opp02);
		oppList.add(opp03);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;
		delete oppList;

		insert insertPersonalKPI(user, targetDate);

		Test.startTest();
		String jobId = System.schedule('testCareertrek1Delete','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * サービス：キャリアトレック
	 * 個人別KPI：なし
	 * 商談：通常
	 * 申込書回収日の個人別KPI：なし
	 */
/*
	static testMethod void testCareertrek2() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan04 = insertMstHirePlan('キャリアトレック', '貴社特別プラン');
		MstHirePlan__c plan05 = insertMstHirePlan('キャリアトレック', '成功報酬プラン');
		MstHirePlan__c plan06 = insertMstHirePlan('キャリアトレック', 'エグゼクティブサーチサポート');
		MstHirePlan__c plan07 = insertMstHirePlan('キャリアトレック', 'キャリアトレックBOS');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan04);
		planList.add(plan05);
		planList.add(plan06);
		planList.add(plan07);
		insert planList;

		Account ac = findAccount();
		Opportunity opp04 = createOpportunity(user, ac, plan04, null);
		Opportunity opp05 = createOpportunity(user, ac, plan05, null);
		Opportunity opp06 = createOpportunity(user, ac, plan06, null);
		Opportunity opp07 = createOpportunity(user, ac, plan07, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp04);
		oppList.add(opp05);
		oppList.add(opp06);
		oppList.add(opp07);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate - 5;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		Test.startTest();
		String jobId = System.schedule('testCareertrek2','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * サービス：キャリアトレック
	 * 個人別KPI：あり
	 * 商談：削除済
	 * 申込書回収日の個人別KPI：あり
	 */
/*
	static testMethod void testCareertrek2Delete() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan04 = insertMstHirePlan('キャリアトレック', '貴社特別プラン');
		MstHirePlan__c plan05 = insertMstHirePlan('キャリアトレック', '成功報酬プラン');
		MstHirePlan__c plan06 = insertMstHirePlan('キャリアトレック', 'エグゼクティブサーチサポート');
		MstHirePlan__c plan07 = insertMstHirePlan('キャリアトレック', 'キャリアトレックBOS');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan04);
		planList.add(plan05);
		planList.add(plan06);
		planList.add(plan07);
		insert planList;

		Account ac = findAccount();
		Opportunity opp04 = createOpportunity(user, ac, plan04, null);
		Opportunity opp05 = createOpportunity(user, ac, plan05, null);
		Opportunity opp06 = createOpportunity(user, ac, plan06, null);
		Opportunity opp07 = createOpportunity(user, ac, plan07, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp04);
		oppList.add(opp05);
		oppList.add(opp06);
		oppList.add(opp07);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		PersonalKPI__c kpi01 = insertPersonalKPI(user, targetDate);
		PersonalKPI__c kpi02 = insertPersonalKPI(user, targetDate - 5);
		List<PersonalKPI__c> kpiList = new List<PersonalKPI__c>();
		kpiList.add(kpi01);
		kpiList.add(kpi02);
		insert kpiList;

		Test.startTest();
		String jobId = System.schedule('testCareertrek2Delete','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * サービス：ビズリーチ
	 * 個人別KPI：なし
	 * 商談：通常
	 * 申込書回収日の個人別KPI：なし
	 */
/*
	static testMethod void testBizreach1() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		Map<String, User> userMap = findUserMap();
		User user1 = userMap.get('test1@sutead.com.abc');
		User user2 = userMap.get('test2@sutead.com.abc');
		User user3 = userMap.get('test3@sutead.com.abc');

		MstHirePlan__c plan08 = insertMstHirePlan('ビズリーチ', 'スタンダードプラン');
		MstHirePlan__c plan09 = insertMstHirePlan('ビズリーチ', 'トライアルプラン');
		MstHirePlan__c plan10 = insertMstHirePlan('ビズリーチ', 'プレミアムプラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan08);
		planList.add(plan09);
		planList.add(plan10);
		insert planList;

		Account ac = findAccount();
		Opportunity opp08 = createOpportunity(user1, ac, plan08, null);
		Opportunity opp09 = createOpportunity(user1, ac, plan09, null);
		Opportunity opp10 = createOpportunity(user1, ac, plan10, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp08);
		oppList.add(opp09);
		oppList.add(opp10);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
		}
		opp09.AppoAcquisitionUser__c = user2.Id;
		opp10.AppoAcquisitionUser__c = user3.Id;
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		insert insertPersonalKPI(user2, targetDate);

		Test.startTest();
		String jobId = System.schedule('testBizreach1','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * サービス：ビズリーチ
	 * 個人別KPI：あり
	 * 商談：通常
	 * 申込書回収日の個人別KPI：なし
	 */
/*
	static testMethod void testBizreach2() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan11 = insertMstHirePlan('ビズリーチ', '貴社特別プラン');
		MstHirePlan__c plan12 = insertMstHirePlan('ビズリーチ', '成功報酬プラン');
		MstHirePlan__c plan13 = insertMstHirePlan('ビズリーチ', 'エグゼクティブサーチサポート');
		MstHirePlan__c plan14 = insertMstHirePlan('ビズリーチ', '公募プラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan11);
		planList.add(plan12);
		planList.add(plan13);
		planList.add(plan14);
		insert planList;

		Account ac = findAccount();
		Opportunity opp11 = createOpportunity(user, ac, plan11, null);
		Opportunity opp12 = createOpportunity(user, ac, plan12, null);
		Opportunity opp13 = createOpportunity(user, ac, plan13, null);
		Opportunity opp14 = createOpportunity(user, ac, plan14, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp11);
		oppList.add(opp12);
		oppList.add(opp13);
		oppList.add(opp14);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		insert insertPersonalKPI(user, targetDate);

		Test.startTest();
		String jobId = System.schedule('testBizreach2','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * サービス：ビズリーチ
	 * 個人別KPI：なし
	 * 商談：通常
	 * 申込書回収日の個人別KPI：あり
	 */
/*
	static testMethod void testBizreach3() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan15 = insertMstHirePlan('ビズリーチ', 'プラチナスカウト');
		MstHirePlan__c plan16 = insertMstHirePlan('ビズリーチ', 'その他');
		MstHirePlan__c plan17 = insertMstHirePlan('ビズリーチ', 'BOS');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan15);
		planList.add(plan16);
		planList.add(plan17);
		insert planList;

		Account ac = findAccount();
		Opportunity opp15 = createOpportunity(user, ac, plan15, null);
		Opportunity opp16 = createOpportunity(user, ac, plan16, null);
		Opportunity opp17 = createOpportunity(user, ac, plan17, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp15);
		oppList.add(opp16);
		oppList.add(opp17);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate - 5;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		insert insertPersonalKPI(user, targetDate - 5);

		Test.startTest();
		String jobId = System.schedule('testBizreach3','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * サービス：BOS,キャリアトレックBOS
	 * 個人別KPI：なし
	 * 商談：通常
	 * 申込書回収日の個人別KPI：なし
	 */
/*
	static testMethod void testBos() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan18 = insertMstHirePlan('BOS', '固定プラン');
		MstHirePlan__c plan19 = insertMstHirePlan('キャリアトレックBOS', '固定プラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan18);
		planList.add(plan19);
		insert planList;

		Account ac = findAccount();
		Opportunity opp18 = createOpportunity(user, ac, plan18, null);
		Opportunity opp19 = createOpportunity(user, ac, plan19, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp18);
		oppList.add(opp19);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		Test.startTest();
		String jobId = System.schedule('testBos','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * マイナス計上
	 * サービス：採用プランマスタ
	 * 商談：通常
	 * 個人別KPIデータ：なし
	 */
/*
	static testMethod void testAppropriateMinus() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan01 = insertMstHirePlan('キャリアトレック', 'スタンダードプラン');
		MstHirePlan__c plan02 = insertMstHirePlan('ビズリーチ', 'スタンダードプラン');
		MstHirePlan__c plan03 = insertMstHirePlan('BOS', 'スタンダードプラン');
		MstHirePlan__c plan04 = insertMstHirePlan('キャリアトレックBOS', 'スタンダードプラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan01);
		planList.add(plan02);
		planList.add(plan03);
		planList.add(plan04);
		insert planList;

		Account ac = findAccount();
		Opportunity opp01 = createOpportunity(user, ac, plan01, null);
		Opportunity opp02 = createOpportunity(user, ac, plan02, null);
		Opportunity opp03 = createOpportunity(user, ac, plan03, null);
		Opportunity opp04 = createOpportunity(user, ac, plan04, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp01);
		oppList.add(opp02);
		oppList.add(opp03);
		oppList.add(opp04);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
			opp.cancel_day__c = jissekiDate;
			opp.cancel_uriage__c = 500000;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		Test.startTest();
		String jobId = System.schedule('testAppropriateMinus','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * マイナス計上
	 * サービス：採用プランマスタ
	 * 商談：通常
	 * 個人別KPIデータ：あり
	 */
/*
	static testMethod void testAppropriateMinusKpi() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		Map<String, User> userMap = findUserMap();

		MstHirePlan__c plan01 = insertMstHirePlan('キャリアトレック', 'スタンダードプラン');
		MstHirePlan__c plan02 = insertMstHirePlan('ビズリーチ', 'スタンダードプラン');
		MstHirePlan__c plan03 = insertMstHirePlan('BOS', 'スタンダードプラン');
		MstHirePlan__c plan04 = insertMstHirePlan('キャリアトレックBOS', 'スタンダードプラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan01);
		planList.add(plan02);
		planList.add(plan03);
		planList.add(plan04);
		insert planList;

		Account ac = findAccount();
		Opportunity opp01 = createOpportunity(userMap.get('test1@sutead.com.abc'), ac, plan01, null);
		Opportunity opp02 = createOpportunity(userMap.get('test2@sutead.com.abc'), ac, plan02, null);
		Opportunity opp03 = createOpportunity(userMap.get('test3@sutead.com.abc'), ac, plan03, null);
		Opportunity opp04 = createOpportunity(userMap.get('test4@sutead.com.abc'), ac, plan04, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp01);
		oppList.add(opp02);
		oppList.add(opp03);
		oppList.add(opp04);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
			opp.cancel_day__c = jissekiDate;
			opp.cancel_uriage__c = 500000;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;

		PersonalKPI__c kpi1 = insertPersonalKPI(userMap.get('test1@sutead.com.abc'), targetDate);
		PersonalKPI__c kpi2 = insertPersonalKPI(userMap.get('test2@sutead.com.abc'), targetDate);
		PersonalKPI__c kpi3 = insertPersonalKPI(userMap.get('test3@sutead.com.abc'), targetDate);
		PersonalKPI__c kpi4 = insertPersonalKPI(userMap.get('test4@sutead.com.abc'), targetDate);
		List<PersonalKPI__c> kpiList = new List<PersonalKPI__c>();
		kpiList.add(kpi1);
		kpiList.add(kpi2);
		kpiList.add(kpi3);
		kpiList.add(kpi4);
		insert kpiList;

		Test.startTest();
		String jobId = System.schedule('testAppropriateMinusKpi','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * マイナス計上
	 * サービス：採用プランマスタ
	 * 商談：削除
	 */
/*
	static testMethod void testAppropriateMinusDelete() {

		Date targetDate = system.today();
		Date jissekiDate = Date.valueof(targetDate - 1);
		User user = findUser();

		MstHirePlan__c plan01 = insertMstHirePlan('キャリアトレック', 'スタンダードプラン');
		MstHirePlan__c plan02 = insertMstHirePlan('ビズリーチ', 'スタンダードプラン');
		MstHirePlan__c plan03 = insertMstHirePlan('BOS', 'スタンダードプラン');
		MstHirePlan__c plan04 = insertMstHirePlan('キャリアトレックBOS', 'スタンダードプラン');
		List<MstHirePlan__c> planList = new List<MstHirePlan__c>();
		planList.add(plan01);
		planList.add(plan02);
		planList.add(plan03);
		planList.add(plan04);
		insert planList;

		Account ac = findAccount();
		Opportunity opp01 = createOpportunity(user, ac, plan01, null);
		Opportunity opp02 = createOpportunity(user, ac, plan02, null);
		Opportunity opp03 = createOpportunity(user, ac, plan03, null);
		Opportunity opp04 = createOpportunity(user, ac, plan04, null);

		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(opp01);
		oppList.add(opp02);
		oppList.add(opp03);
		oppList.add(opp04);
		for (Opportunity opp : oppList) {
			opp.ContractCollectionDate__c = jissekiDate;
			opp.cancel_day__c = jissekiDate;
			opp.cancel_uriage__c = 500000;
		}
		insert oppList;
		for (Opportunity opp : oppList) {
			opp.AppoAcquisitionDate__c = jissekiDate;
			opp.VisitDate__c = jissekiDate;
			opp.ContractCollectionInputDate__c = jissekiDate;
		}
		update oppList;
		delete oppList;

		insert insertPersonalKPI(user, targetDate);

		Test.startTest();
		String jobId = System.schedule('testAppropriateMinusDelete','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();

	}

	/**
	 * ユーザテストデータ取得
	 * @return ユーザ
	 */
	static User findUser() {
		return [Select Id, Name, profile.Name, userRole.Name, userRole.RollupDescription From User Where Name = 'TEST1 TEST1' limit 1];
	}

	/**
	 * ユーザテストデータ取得
	 * @return ユーザMap
	 */
	static Map<String, User> findUserMap() {
		List<User> userList = [Select Id, Name, profile.Name, userRole.Name, userRole.RollupDescription, UserName From User Where UserName Like '%@sutead.com.abc'];
		Map<String, User> userMap = new Map<String, User>();
		for (User user : userList) {
			userMap.put(user.UserName, user);
		}
		return userMap;
	}

	/**
	 * 取引先テストデータ取得
	 * @return 取引先
	 */
	static Account findAccount() {
		return [Select Id, Name From Account Where Name = 'Test Company' limit 1];
	}

	/**
	 * 商談テストデータ作成
	 * @param user ユーザ
	 * @param ac 取引先
	 * @param mstPlan 採用プランマスタ
	 * @param notMstPlan 採用プラン
	 * @param 商談
	 */
	static Opportunity createOpportunity(User user, Account ac) {
		Opportunity opp = new Opportunity(
			name = 'testOp',
			CloseDate = system.today(),
			StageName = 'アポ獲得',
			VisitChargeUser__c = user.Id,
			AppoAcquisitionUser__c = user.Id,
			AccountId = ac.id,
			ProposedService__c = 'CRS',
			Amount = 1000000,
			hasCreatedCalendar__c = true,
			OwnerId = user.Id

		);
		return opp;
	}

	/**
	 * 個人別KPIテストデータ作成
	 * @param user ユーザ
	 * @param syukeiDate 集計日
	 * @param keyDate 個人別KPIキー項目
	 */
	static PersonalKPI__c insertPersonalKPI(User user, Date syukeiDate) {
		PersonalKPI__c kpi = new PersonalKPI__c(
			SyozokuTantouText__c = user.Name, Syozokutantou__c = user.Id, SyozokuTantouTeam__c = user.userRole.Name,
			Profile__c = user.profile.Name, OwnerId = user.Id, Yojitsukubun__c = '実績', Syukeibi__c = syukeiDate,
			BIZAposuu__c = null, BIZJiappo__c = null, BIZHoumonsuu__c = null, BIZKoteijyutsuukensuu__c = null,
			BIZSeikouhousyuukensuu__c = null, BIZMaejyutyuukingaku__c = null, CTAposuu__c = null, CTJiappo__c = null,
			CTHoumonsuu__c = null, CTKoteijyutsuukensuu__c = null, CTSeikouhousyuukensuu__c = null,
			CTMaejyutyuukingaku__c = null, BIZBOSMaekouteiKingaku__c = null, CTBOSMaekouteiKingaku__c = null,
			CTBOSKeiyakusyasuu__c = null, BIZBOSKeiyakusya__c = null, BIZKeiyakusyasuuKotei__c = null,
			BIZKeiyakusyasuuSeika__c = null, CTKeiyakusyasuuKotei__c = null, CTKeiyakusyasuuSeika__c = null);
		kpi.Key__c = '実績' + user.Name + String.valueOf(syukeiDate);
		return kpi;
	}

}