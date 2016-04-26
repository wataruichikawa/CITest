/**
 * TST_TGR_AccountTrigger
 *
 * テスト対象
 * 1.TGR_AccountTrigger
 * 2.ACC_AccountProcess
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_AccountTrigger {

	@testSetUp
	static void setUp() {
		UserRole userRole = new UserRole(name = 'CRS_SR', RollupDescription = 'TEST_ROLE');
		insert userRole;
		List<UserRole> userRoleList = new List<UserRole>([select Id from UserRole Where name = 'CRS_SR' limit 1]);
		UserRole userRole1 = userRoleList[0];
		List<user> userlist = new List<User>();
		User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole1.Id);
		User user2 = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole1.Id);
		User user3 = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole1.Id);

		userList.add(user1);
		userList.add(user2);
		userList.add(user3);
		insert userList;

	}

	/**
	 * Insert
	 */
	static testMethod void testInsert() {

		List<User> userList = findUser();
		User user = userlist.get(0);

		Account acc = new Account(name = 'Test Inc Insert', website = 'http://www.dummyX.co.jp', WebsiteDomain__c = 'dummyX.co.jp', ownerid = user.id, Phone = '30-1234-5678' , Field224_Merge__c = false, Field221__c = 'Internet', Field107__c = null, AccountType__c = 'CRS', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');

		Test.startTest();
		insert acc;
		Test.stopTest();

	}

	/**
	 * キャリアトレック担当営業更新
	 */
	static testMethod void testCareertreckSalesUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertEquals(user1.Id, acc.careertreck_sales_representative__c);
		acc.CrtSalesStaffForLink__c = user2.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(user2.Id, acc.careertreck_sales_representative__c);

	}

	/**
	 * CRS担当営業更新
	 */
	static testMethod void testCrsSalesUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertEquals(user1.Id, acc.CrsSales_RepresentativeMain__c);
		acc.Field107__c = user2.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(user2.Id, acc.CrsSales_RepresentativeMain__c);

	}

	/**
	 * CRS担当運用更新
	 */
	static testMethod void testCrsStaffUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(3);

		system.assertEquals(user1.Id, acc.CrsSale_Representative__c);
		acc.CrsSalesStaffForLink__c = user2.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(3);
		system.assertEquals(user2.Id, acc.CrsSale_Representative__c);

	}

	/**
	 * キャリアトレック担当運用更新
	 */
	static testMethod void testCareertrecStaffUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(3);

		system.assertEquals(user1.Id, acc.careertreck_representativeUser__c);
		acc.careertreck_representative__c = user2.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(3);
		system.assertEquals(user2.Id, acc.careertreck_representativeUser__c);

	}

	/**
	 * CRS_BOSプランナー更新
	 */
	static testMethod void testCrsBosPlannerUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(1);

		system.assertEquals(user1.Id, acc.CRS_BOSPlanner__c);
		acc.CRS_RPOTantousya_BOS__c = user2.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(1);
		system.assertEquals(user2.Id, acc.CRS_BOSPlanner__c);

	}

	/**
	 * CT_BOS担当者更新
	 */
	static testMethod void testCtBosTantouUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(2);

		system.assertEquals(user1.Id, acc.CTBOSTantou__c);
		acc.CTBOSTantousya__c = user2.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(2);
		system.assertEquals(user2.Id, acc.CTBOSTantou__c);

	}

	/**
	 * CRS_前工程開拓担当者更新
	 */
	static testMethod void testCrsMaeTantouUpdate() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(2);

		acc.req_add_list_username__c = 'TEST1 TEST1';
		acc.add_list_request_picklist__c = '追加する';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(2);
		system.assertEquals(user1.Id, acc.CRS_MaeTantousya__c);
		system.assertEquals(acc.req_add_list_user__c, acc.CRS_MaeTantousya__c);

	}

	/**
	 * 所有者更新(CRS_担当営業)
	 */
	static testMethod void testOwnerUpdate1() {

		List<User> userList = findUser();
		User user = userlist.get(2);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertNotEquals(user.Id, acc.OwnerId);
		acc.Field107__c = user.Name;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(user.Id, acc.OwnerId);

	}

	/**
	 * 所有者更新(CRS_担当運用)
	 */
	static testMethod void testOwnerUpdate2() {

		List<User> userList = findUser();
		User user = userlist.get(2);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertNotEquals(user.Id, acc.OwnerId);
		acc.Field107__c = '';
		acc.CrsSale_Representative__c = user.Id;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(user.Id, acc.OwnerId);

	}

	/**
	 * 所有者更新(キャリアトレック_担当営業)
	 */
	static testMethod void testOwnerUpdate3() {

		List<User> userList = findUser();
		User user = userlist.get(2);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertNotEquals(user.Id, acc.OwnerId);
		acc.Field107__c = '';
		acc.CrsSale_Representative__c = null;
		acc.careertreck_sales_representative__c = user.Id;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(user.Id, acc.OwnerId);

	}

	/**
	 * 所有者更新(直近訪問予定者)
	 */
	//static testMethod void testOwnerUpdate4() {

	//	List<User> userList = findUser();
	//	User user = userlist.get(2);

	//	preInsertAccountList();
	//	List<Account> accList = findAccount();
	//	Account acc = accList.get(0);

	//	system.assertNotEquals(user.Id, acc.OwnerId);
	//	acc.Field107__c = '';
	//	acc.CrsSale_Representative__c = null;
	//	acc.careertreck_sales_representative__c = null;
	//	acc.LatestVisitChargeUser__c = user.Id;
	//	Test.startTest();
	//	update acc;
	//	Test.stopTest();

	//	accList = findAccount();
	//	acc = accList.get(0);
	//	system.assertEquals(user.Id, acc.OwnerId);

	//}

	/**
	 * 所有者更新(SRマネージャ)
	 */
	//static testMethod void testOwnerUpdate5() {

	//	List<User> userList = findUser();
	//	User user = userlist.get(2);

	//	preInsertAccountList();
	//	List<Account> accList = findAccount();
	//	Account acc = accList.get(4);

	//	system.assertNotEquals(user.Id, acc.OwnerId);
	//	acc.Field107__c = '';
	//	acc.CrsSale_Representative__c = null;
	//	acc.careertreck_sales_representative__c = null;
	//	acc.LatestVisitChargeUser__c = null;

	//	system.runAs(user) {
	//		Test.startTest();
	//		update acc;
	//		Test.stopTest();
	//	}

	//	accList = findAccount();
	//	acc = accList.get(4);
	//	system.assertEquals(user.Id, acc.OwnerId);

	//}

	/**
	 * 所有者更新(CRS_担当営業が存在しない)
	 */
	static testMethod void testOwnerUpdate6() {

		List<User> userList = findUser();
		User user = userlist.get(2);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertNotEquals(user.Id, acc.OwnerId);
		acc.Field107__c = user.Name + 'TEST';
		acc.CrsSale_Representative__c = null;
		acc.careertreck_sales_representative__c = null;
		acc.LatestVisitChargeUser__c = null;

		Id ownerId = acc.OwnerId;
		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(ownerId, acc.OwnerId);

	}

	/**
	 * 所有者更新(変更後所有者のロールがない)
	 */
	static testMethod void testOwnerUpdate7() {

		List<User> userList = findUser();
		User user1 = userlist.get(1);
		User user2 = userlist.get(2);

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		system.assertNotEquals(user2.Id, acc.OwnerId);
		acc.Field107__c = user1.Name;
		acc.CrsSale_Representative__c = null;
		acc.careertreck_sales_representative__c = null;
		acc.LatestVisitChargeUser__c = null;

		system.runAs(user2) {
			Test.startTest();
			update acc;
			Test.stopTest();
		}

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals(user1.Id, acc.OwnerId);

	}

	/**
	 * Webサイトドメイン、取引先種別、セールスフォース取引先ID
	 */
	static testMethod void testWebsiteTypeId1() {

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		acc.Website = 'https://ap.salesforce.com/home/home.jsp';
		acc.WebsiteDomain__c = '';
		acc.AccountType__c = 'ESS';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals('ap.salesforce.com', acc.WebsiteDomain__c);
		system.assertEquals('ESS', acc.AccountType__c);

	}

	/**
	 * Webサイトドメイン、取引先種別、セールスフォース取引先ID(WorkFlow)
	 */
	static testMethod void testWebsiteTypeId2() {

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		acc.Website = '';
		acc.WebsiteDomain__c = 'ap.salesforce.com';
		acc.AccountType__c = '';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assert(String.isBlank(acc.WebsiteDomain__c));
		system.assertEquals('CRS', acc.AccountType__c);

	}

	/**
	 * STEP更新
	 */
	static testMethod void testStep() {

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		acc.CrsCurrentStep__c = '';
		acc.CrsStepLastUpdDate__c = null;
		acc.CrsLatestOpportunityStage__c = 'STEP04：訪問前準備';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assert(String.isNotBlank(acc.CrsCurrentStep__c));
		system.assertNotEquals(null, acc.CrsStepLastUpdDate__c);

	}

	/**
	 * 住所クリーニング
	 */
	static testMethod void testAdressClean() {

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		acc.BillingState = '神奈川';
		acc.BillingCity = '県横浜市';
		acc.BillingStreet = '中区住吉町1-1-1';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals('神奈川県', acc.BillingState);
		system.assertEquals('横浜市中区', acc.BillingCity);
		system.assertEquals('住吉町1-1-1', acc.BillingStreet);

	}

	/**
	 * 住所クリーニング、会社所在テリトリー更新
	 */
	static testMethod void testAdressCleanTeritory() {

		List<User> userList = findUser();
		User user1 = userlist.get(1);
		HuriwakeMaster__c h = new HuriwakeMaster__c(Todouhuken__c = '神奈川県', Shikutyouson__c = '横浜市中区', Tyouiki__c = '住吉町1-1-1', RoleID__c = user1.UserRoleId, InboundRoleId__c = user1.UserRoleId);
		insert h;

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		acc.BillingState = '神奈川';
		acc.BillingCity = '県横浜市';
		acc.BillingStreet = '中区住吉町1-1-1';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assertEquals('神奈川県', acc.BillingState);
		system.assertEquals('横浜市中区', acc.BillingCity);
		system.assertEquals('住吉町1-1-1', acc.BillingStreet);
		system.assertEquals('TEST_ROLE', acc.CompanyTeritory__c);
	}

	/**
	 * マージ依頼メール
	 */
	static testMethod void testMergeMail() {

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(5);

		acc.Field224_Merge__c = true;
		acc.Field224_MergeReason__c = 'MergeReason';
		acc.Website = '';
		acc.WebsiteDomain__c = '';

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(5);
		system.assert(!acc.Field224_Merge__c);
	}

	/**
	 * トリガー無効フラグ
	 */
	static testMethod void testTriggerInvalid() {

		preInsertAccountList();
		List<Account> accList = findAccount();
		Account acc = accList.get(0);

		acc.TriggerInvalid__c = true;

		Test.startTest();
		update acc;
		Test.stopTest();

		accList = findAccount();
		acc = accList.get(0);
		system.assert(!acc.TriggerInvalid__c);
	}

	private static List<Account> findAccount() {
		return [SELECT Id, Name, OwnerId, CrtSalesStaffForLink__c, careertreck_sales_representative__c, Field107__c, CrsSales_RepresentativeMain__c,
			CrsSalesStaffForLink__c, CrsSale_Representative__c, careertreck_representative__c, careertreck_representativeUser__c, CRS_MaeTantousya__c,
			CRS_RPOTantousya_BOS__c, CRS_BOSPlanner__c, CTBOSTantousya__c, CTBOSTantou__c, LatestVisitChargeUser__c,
			Website, WebsiteDomain__c, AccountType__c, CrsCurrentStep__c, CrsStepLastUpdDate__c, req_add_list_user__c,
			BillingState, BillingCity, BillingStreet, CompanyTeritory__c, Field224_Merge__c, TriggerInvalid__c FROM Account WHERE Name LIKE 'Test Inc%' ORDER BY Name];
	}

	private static List<User> findUser() {
		return [SELECT Id, Name, FirstName, LastName, UserType, UserRoleId FROM User Where Username LIKE '%@sutead.com' ORDER BY Username];
	}

	private static void preInsertAccountList() {

		List<User> userList = findUser();
		User user1 = userlist.get(0);
		User user2 = userlist.get(1);
		User user3 = userlist.get(2);

		List<Account> updateAccountList = new List<Account>();
		Account ac1 = new Account(name = 'Test Inc1', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', CrsSales_RepresentativeMain__c = user1.Id, Field107__c = user1.Name, ownerid = user1.id, careertreck_sales_representative__c = user1.id, CrtSalesStaffForLink__c = user1.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
		Account ac2 = new Account(name = 'Test Inc2', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user2.LastName + ' ' + user2.FirstName, ownerid = user1.id, careertreck_sales_representative__c = user2.id, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx', CRS_RPOTantousya_BOS__c = user1.Name, CRS_BOSPlanner__c = user1.Id);
		Account ac3 = new Account(name = 'Test Inc3', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = null, ownerid = user1.id, CrtSalesStaffForLink__c = user1.lastName + ' ' + user1.firstName, careertreck_sales_representative__c = user2.id, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx', CTBOSTantousya__c = user1.Name, CTBOSTantou__c = user1.Id);
		Account ac4 = new Account(name = 'Test Inc4', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = null, ownerid = user1.id, CrsSalesStaffForLink__c = user1.lastName + ' ' + user1.firstName, CrsSale_Representative__c = user1.Id, CrtSalesStaffForLink__c = user1.lastName + ' ' + user1.firstName, careertreck_sales_representative__c = user2.id, careertreck_representative__c = user1.Name, careertreck_representativeUser__c = user1.Id, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
		Account ac5 = new Account(name = 'Test Inc5', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = null, ownerid = user1.id, CrsSalesStaffForLink__c = null, CrsSale_Representative__c = null, CrtSalesStaffForLink__c = null, careertreck_sales_representative__c = null, LatestVisitChargeUser__c = user2.Id, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
		Account ac6 = new Account(name = 'Test Inc MergeTest1 Inc', website = 'http://www.test1.co.jp', WebsiteDomain__c = 'test1.co.jp', ownerid = user1.id, Phone = '03-1234-5678' , Field224_Merge__c = false, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field221__c = 'Internet', Field107__c = null, AccountType__c = 'CRS');
		// AfterInsertかつPhone重複を試す
		Account ac7 = new Account(name = 'Test Inc MergeTest2 Inc', website = 'http://www.dummy1.co.jp', WebsiteDomain__c = 'dummy1.co.jp', ownerid = user1.id, Phone = '03-1234-5678' , Field224_Merge__c = true, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field221__c = 'Internet', Field107__c = null, AccountType__c = 'CRS');
		// AfterInsertかつWebsiteDomain__c重複を試す
		Account ac8 = new Account(name = 'Test Inc MergeTest3 Inc', website = 'http://www.test1.co.jp', WebsiteDomain__c = 'test1.co.jp', ownerid = user1.id, Phone = '03-9999-9999' , Field224_Merge__c = true, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field221__c = 'Internet', Field107__c = null, AccountType__c = 'ESS');
		// AfterUpdateかつWebsiteDomain__c重複を試す
		Account ac9 = new Account(name = 'Test Inc MergeTest4 Inc', website = 'http://www.test3.co.jp', WebsiteDomain__c = 'test3.co.jp', ownerid = user1.id, Phone = '03-8888-8888' , Field224_Merge__c = false, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field221__c = 'Internet', Field107__c = null, Field224_MergeReason__c = 'merge reason test message', AccountType__c = 'CRS');
		// PhoneがNullの時
		Account ac10 = new Account(name = 'Test Inc MergeTest5 Inc', website = 'http://www.test3.co.jp', WebsiteDomain__c = 'test4.co.jp', ownerid = user1.id, Field224_Merge__c = false, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field221__c = 'Internet', Field107__c = null, Field224_MergeReason__c = 'merge reason test message', AccountType__c = 'ESS');
		// WebsiteDomain__cがNullの時
		Account ac11 = new Account(name = 'Test Inc MergeTest6 Inc', website = 'http://www.test3.co.jp', ownerid = user1.id, Phone = '03-8888-8888' , Field224_Merge__c = false, BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field221__c = 'Internet', Field107__c = null);

		updateAccountList.add(ac1);
		updateAccountList.add(ac2);
		updateAccountList.add(ac3);
		updateAccountList.add(ac4);
		updateAccountList.add(ac5);
		updateAccountList.add(ac6);
		updateAccountList.add(ac7);
		updateAccountList.add(ac8);
		updateAccountList.add(ac9);
		updateAccountList.add(ac10);
		updateAccountList.add(ac11);

		insert updateAccountList;
	}

}