/**
 * TST_TGR_OpportunityTrigger
 *
 * テスト対象
 * 1.TGR_OpportunityTrigger
 * 2.OPP_OpportunityProcess
 * 3.ACC_DrcAccountManagement
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
 @isTest
private class TST_TGR_OpportunityTrigger {

	static void setUp(Boolean isInsertOli) {

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		User user1;
		User user2;
		User user3;
		User user4;
		User user5; 
		System.runAs(usr) {
			UserRole role =  new UserRole(Name = 'XXXX', RollupDescription = 'Report_Name');
			insert role;
	
			user1 = new User(LastName = 'TEST1', UserRoleId = role.Id, Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
			user2 = new User(LastName = 'TEST2', UserRoleId = role.Id, Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
			user3 = new User(LastName = 'TEST3', UserRoleId = role.Id, Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
			user4 = new User(LastName = 'TEST4', UserRoleId = role.Id, Username = 'test4@sutead.com', Email = 'test4@sutead.com', Alias = 'test4', CommunityNickname = 'test4', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
			user5 = new User(LastName = 'TEST5', UserRoleId = role.Id, Username = 'test5@sutead.com', Email = 'test5@sutead.com', Alias = 'test5', CommunityNickname = 'test5', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
			List<User> userList = new User[] { user1, user2, user3, user4, user5 };
			insert userList;
		}

		Account acc = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx', CrsSales_RepresentativeMain__c = user1.Id, CrsSale_Representative__c = user2.Id, careertreck_sales_representative__c = user3.Id, careertreck_representativeUser__c = user4.Id);
		insert acc;

		Contact ct1 = new Contact(AccountId = acc.id, lastname = 'TEST1', firstname = 'TARO1');
		Contact ct2 = new Contact(AccountId = acc.id, lastname = 'TEST2', firstname = 'TARO2');
		List<Contact> ctList = new Contact[] { ct1, ct2 };
		insert ctList;

		List<RecordType> rts = [select SobjectType, NamespacePrefix, Name, LastModifiedDate, LastModifiedById, Id, DeveloperName, Description, BusinessProcessId from RecordType where name = '人材採用塾'];
		Campaign cp11 = new Campaign(name = 'Campaign11', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp21 = new Campaign(name = 'Campaign21', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp31 = new Campaign(name = 'Campaign31', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp12 = new Campaign(name = 'Campaign12', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp22 = new Campaign(name = 'Campaign22', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp32 = new Campaign(name = 'Campaign32', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp41 = new Campaign(name = 'Campaign41', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp42 = new Campaign(name = 'Campaign42', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp51 = new Campaign(name = 'Campaign51', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp52 = new Campaign(name = 'Campaign52', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp61 = new Campaign(name = 'Campaign61', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp62 = new Campaign(name = 'Campaign62', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp71 = new Campaign(name = 'Campaign71', RecordTypeid = rts[0].id, Type = '人材採用塾');
		Campaign cp72 = new Campaign(name = 'Campaign72', RecordTypeid = rts[0].id, Type = '人材採用塾');
		List<Campaign> cpList = new Campaign[] { cp11, cp21, cp31, cp12, cp22, cp32, cp41, cp42, cp51, cp52, cp61, cp62, cp71, cp72 };
		insert cpList;

		Opportunity oppBiz = new Opportunity(AccountId = acc.Id, Name = 'ビズリーチ商談', StageName = 'STEP3：アポ獲得@', CloseDate = system.today(), OwnerId = user1.Id, VisitChargeUser__c = user5.Id, AppoAcquisitionUser__c = user5.Id, contact__c = ct1.Id);
		Opportunity oppCrt = new Opportunity(AccountId = acc.Id, Name = 'キャリアトレック商談', StageName = 'STEP3：アポ獲得@', CloseDate = system.today(), OwnerId = user1.Id, VisitChargeUser__c = user5.Id, AppoAcquisitionUser__c = user5.Id, contact__c = ct1.Id);
		List<Opportunity> oppList = new Opportunity[] { oppBiz, oppCrt };
		insert oppList;

		if (isInsertOli) {
			PriceBook2 pb2s = [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
			PriceBook2 pb2c = new PriceBook2(Name = 'Custom Price Book', IsActive = true);
			insert pb2c;
			Product2 pd2Biz = new Product2(Name = 'ビズ商品', ProductCode = 'biz', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
				ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
				DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = '継続インセンティブ 固定', Service__c = 'ビズリーチ', ProposedService__c = 'CRS', Remarks__c = 'biz備考');
			Product2 pd2Crt = new Product2(Name = 'キャリトレ商品', ProductCode = 'ctr', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
				ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
				DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = '成功報酬', Service__c = 'キャリアトレック', ProposedService__c = 'CRS', Remarks__c = 'ctr備考');
			insert new Product2[] { pd2Biz, pd2Crt };
			PriceBookEntry pbe1 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2Biz.Id, UseStandardPrice = false, UnitPrice = 850000);
			PriceBookEntry pbe2 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2Crt.Id, UseStandardPrice = false, UnitPrice = 850000);
			PriceBookEntry pbe3 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2Biz.Id, UseStandardPrice = false, UnitPrice = 850000);
			PriceBookEntry pbe4 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2Crt.Id, UseStandardPrice = false, UnitPrice = 850000);
			insert new PriceBookEntry[] { pbe1, pbe2, pbe3, pbe4 };
			OpportunityLineItem oliBiz = new OpportunityLineItem(OpportunityId = oppBiz.Id, PricebookEntryId = pbe3.Id, Quantity = 1, UnitPrice = 850000);
			OpportunityLineItem oliCrt = new OpportunityLineItem(OpportunityId = oppCrt.Id, PricebookEntryId = pbe4.Id, Quantity = 1, UnitPrice = 850000);
			insert new OpportunityLineItem[] { oliBiz, oliCrt };
		}

	}

	/**
	 * After Insert / Updateテスト
	 */
	static testMethod void testAfterInsertUpdateProcess1() {
		setUp(false);
		Opportunity opp = findOpportunity().get(0);
		//opp.StageName = 'STEP10：契約';
		opp.ApplicationApprovalStatus__c = '申請中';
		opp.ProposedService__c = 'CRS';

		update opp;

		Opportunity opp2 = opp.clone(true, false);
		opp2.cancel_uriage__c = -100000;
		opp2.sales_all__c = 900000;
		opp2.UseStartDate__c = Date.today();
		opp2.UseEndDate__c = Date.today();
		opp2.cancel_day__c = Date.today();
		opp2.cancel_reason__c = 'xxx';
		//opp2.StageName = 'STEP10：契約';
		opp2.ApplicationApprovalStatus__c = '申請中';

		Test.startTest();
		update opp2;
		Test.stopTest();

	}

	/**
	 * After Insert 非同期テスト
	 * CRS_担当運用/CT_担当運用への通知なし
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess() {
		setUp(true);
		ACC_DrcAccountManagement.representativeNotice = new String[] {'false', 'false', 'false', 'false', 'false', 'false', 'false', 'false', 'false', 'false', 'false', 'false', 'false'};

		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		List<Opportunity> oppInsList = new List<Opportunity>();
		for (Opportunity op : oppList) {
			Opportunity opp = op.clone();
			opp.StageName = 'STEP3：アポ獲得@';
			opp.CloseDate = system.today();
			opp.UseStartDate__c = system.today();
			opp.UseStartProgressDate__c = opp.UseStartDate__c.addDays(30);
			opp.UseEndDate30Ago__c = system.today();
			opp.FirstInterview__c = true;
			opp.FirstUnofficially__c = true;
			opp.FirstDecision__c = true;
			opp.JobNotCreated10__c = true;
			opp.ListNonEaluation14__c = true;
			opp.PurasukaNonReply7__c = true;
			opp.InterviewUnadjusted7__c = true;
			opp.Undecided33__c = true;
			oppInsList.add(opp);
		}

		Test.startTest();
		insert oppInsList;
		Test.stopTest();

		List<Id> idList = new Id[] {userList.get(1).Id, userList.get(3).Id};
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		List<BizTask__c> taskList = [SELECT Id, Account__c, Opportunity__c, Name, Tantousya__c, Status__c, Kigen__c, Syousai__c, OwnerId FROM BizTask__c WHERE Tantousya__c IN :idList];
		system.assert(itemList.isEmpty());
		system.assert(taskList.isEmpty());
	}

	/**
	 * After Update 非同期テスト
	 * 【定期連絡】契約開始30日経過状況連絡
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess1() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[0]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.UseStartDate__c = system.today();
			opp.UseStartProgressDate__c = opp.UseStartDate__c.addDays(30);
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		Map<Id, FeedItem> itemMap = new Map<Id, FeedItem>();
		for (FeedItem item : itemList) {
			itemMap.put(item.ParentId, item);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assertEquals(null, opp.UseStartProgressDate__c);
		}

		for (Id key : idList) {
			FeedItem item = itemMap.get(key);
			system.assertEquals('LinkPost', item.Type);
			system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppMap.get(key).Id, item.LinkUrl);
			system.assertEquals(oppMap.get(key).Name, item.Title);
			system.assertEquals(String.format(system.label.ContractProgressBody, new String[]{'30'}), item.Body);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【定期連絡】契約開始60日経過状況連絡
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess2() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[1]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.UseStartDate__c = system.today();
			opp.UseStartProgressDate__c = opp.UseStartDate__c.addDays(60);
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		Map<Id, FeedItem> itemMap = new Map<Id, FeedItem>();
		for (FeedItem item : itemList) {
			itemMap.put(item.ParentId, item);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assertEquals(null, opp.UseStartProgressDate__c);
		}

		for (Id key : idList) {
			FeedItem item = itemMap.get(key);
			system.assertEquals('LinkPost', item.Type);
			system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppMap.get(key).Id, item.LinkUrl);
			system.assertEquals(oppMap.get(key).Name, item.Title);
			system.assertEquals(String.format(system.label.ContractProgressBody, new String[]{'60'}), item.Body);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【定期連絡】契約開始90日経過状況連絡
	 */
	 @IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess3() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[2]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.UseStartDate__c = system.today();
			opp.UseStartProgressDate__c = opp.UseStartDate__c.addDays(90);
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		Map<Id, FeedItem> itemMap = new Map<Id, FeedItem>();
		for (FeedItem item : itemList) {
			itemMap.put(item.ParentId, item);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assertEquals(null, opp.UseStartProgressDate__c);
		}

		for (Id key : idList) {
			FeedItem item = itemMap.get(key);
			system.assertEquals('LinkPost', item.Type);
			system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppMap.get(key).Id, item.LinkUrl);
			system.assertEquals(oppMap.get(key).Name, item.Title);
			system.assertEquals(String.format(system.label.ContractProgressBody, new String[]{'90'}), item.Body);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【定期連絡】契約開始120日経過状況連絡
	 */
	 @IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess4() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[3]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.UseStartDate__c = system.today();
			opp.UseStartProgressDate__c = opp.UseStartDate__c.addDays(120);
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		Map<Id, FeedItem> itemMap = new Map<Id, FeedItem>();
		for (FeedItem item : itemList) {
			itemMap.put(item.ParentId, item);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assertEquals(null, opp.UseStartProgressDate__c);
		}

		for (Id key : idList) {
			FeedItem item = itemMap.get(key);
			system.assertEquals('LinkPost', item.Type);
			system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppMap.get(key).Id, item.LinkUrl);
			system.assertEquals(oppMap.get(key).Name, item.Title);
			system.assertEquals(String.format(system.label.ContractProgressBody, new String[]{'120'}), item.Body);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【再契約提案】契約終了30日前再提案連絡
	 */
	 @IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess5() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[4]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.UseEndDate30Ago__c = system.today();
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		Map<Id, FeedItem> itemMap = new Map<Id, FeedItem>();
		for (FeedItem item : itemList) {
			itemMap.put(item.ParentId, item);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assertEquals(null, opp.UseEndDate30Ago__c);
		}

		for (Id key : idList) {
			FeedItem item = itemMap.get(key);
			system.assertEquals('LinkPost', item.Type);
			system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppMap.get(key).Id, item.LinkUrl);
			system.assertEquals(oppMap.get(key).Name, item.Title);
			system.assertEquals(system.label.ContractUseEnd, item.Body);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【初面談】初めての面談
	 */
	 @IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess6() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[5]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.FirstInterview__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.FirstInterview__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.FirstInterviewTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.FirstInterviewDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【初内定】初めての内定
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess7() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[6]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.FirstUnofficially__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.FirstUnofficially__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.FirstUnofficiallyTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.FirstUnofficiallyDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【初決定】初めての決定
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess8() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[7]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.FirstDecision__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.FirstDecision__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.FirstDecisionTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.FirstDecisionDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【進捗アラート】求人未作成
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess9() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[8]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.JobNotCreated10__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.JobNotCreated10__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.JobNotCreatedTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.JobNotCreatedDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【進捗アラート】リスト未評価
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess10() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[9]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.ListNonEaluation14__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.ListNonEaluation14__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.ListNonEaluationTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.ListNonEaluationDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【進捗アラート】プラスカ未返信
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess11() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[10]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.PurasukaNonReply7__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.PurasukaNonReply7__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.PurasukaNonReplyTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.PurasukaNonReplyDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【進捗アラート】面談日程未調整
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess12() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[11]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.InterviewUnadjusted7__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.InterviewUnadjusted7__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.InterviewUnadjustedTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.InterviewUnadjustedDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【進捗アラート】未決定状況確認
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess13() {
		setUp(true);
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[12]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.Undecided33__c = true;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		oppList = findOpportunity();
		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		Map<Id, BizTask__c> taskMap = new Map<Id, BizTask__c>();
		for (BizTask__c task : taskList) {
			taskMap.put(task.Tantousya__c, task);
		}
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(userList.get(0).Id, oppList.get(0));
		oppMap.put(userList.get(2).Id, oppList.get(1));
		if (notice) {
			oppMap.put(userList.get(1).Id, oppList.get(0));
			oppMap.put(userList.get(3).Id, oppList.get(1));
		}

		for (Opportunity opp : oppList) {
			system.assert(!opp.Undecided33__c);
		}

		Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

		for (Id key : idList) {
			BizTask__c task = taskMap.get(key);
			Opportunity opp = oppMap.get(key);
			system.assertEquals(opp.AccountId, task.Account__c);
			system.assertEquals(opp.Id, task.Opportunity__c);
			system.assertEquals(String.format(system.label.UndecidedTitle, new String[]{opp.Account.Name}), task.Name);
			system.assertEquals('未実施', task.Status__c);
			system.assertEquals(system.today(), task.Kigen__c);
			system.assertEquals(system.label.UndecidedDetail, task.Syousai__c);
			system.assertEquals(key, task.OwnerId);
			system.assertEquals(recTypeId, task.RecordTypeId);
		}
	}

	/**
	 * After Update 非同期テスト
	 * 【再契約提案】契約終了30日前再提案連絡 無効ユーザ
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess14() {
		setUp(true);
		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[4]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.UseEndDate30Ago__c = system.today();
		}
		for (User u : userList) {
			u.isActive = false;
		}
		System.runAs(usr) {
			update userList;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<FeedItem> itemList = [SELECT Id, ParentId, Type, LinkUrl, Title, Body FROM FeedItem WHERE ParentId IN :idList];
		system.assert(itemList.isEmpty());

	}

	/**
	 * After Update 非同期テスト
	 * 【初面談】初めての面談 無効ユーザ
	 */
	@IsTest(SeeAllData=true)
	static void testAfterInsertUpdateAsyncProcess15() {
		setUp(true);
		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);
		boolean notice = boolean.valueOf(representativeNotice[12]);
		List<User> userList = findUser();
		List<Opportunity> oppList = findOpportunity();
		for (Opportunity opp : oppList) {
			opp.FirstInterview__c = true;
		}
		
		for (User u : userList) {
			u.isActive = false;
		}
		System.runAs(usr) {
			update userList;
		}

		Test.startTest();
		update oppList;
		Test.stopTest();

		List<Id> idList;
		if (notice) {
			idList = new Id[] {userList.get(0).Id, userList.get(1).Id, userList.get(2).Id, userList.get(3).Id};
		} else {
			idList = new Id[] {userList.get(0).Id, userList.get(2).Id};
		}
		List<BizTask__c> taskList = findBizTask(idList);
		system.assert(taskList.isEmpty());

	}

	/**
	 * トリガー無効フラグ
	 */
	static testMethod void testTriggerInvalid() {
		setUp(false);
		Opportunity opp = findOpportunity().get(0);
		opp.TriggerInvalid__c = true;

		Test.startTest();
		update opp;
		Test.stopTest();

		opp = findOpportunity().get(0);
		system.assert(!opp.TriggerInvalid__c);
	}

	private static List<User> findUser() {
		return [SELECT Id, isActive FROM User WHERE Username LIKE '%@sutead.com' ORDER BY Username];
	}

	private static List<Opportunity> findOpportunity() {
		return [SELECT Id, Name, UseStartDate__c, UseStartProgressDate__c, UseEndDate30Ago__c, FirstInterview__c, FirstUnofficially__c,
			FirstDecision__c, JobNotCreated10__c, ListNonEaluation14__c, PurasukaNonReply7__c, InterviewUnadjusted7__c,
			Undecided33__c, AccountId, Account.Name, TriggerInvalid__c FROM Opportunity WHERE StageName = 'STEP3：アポ獲得@'];
	}

	private static List<BizTask__c> findBizTask(List<Id> idList) {
		return [SELECT Id, Account__c, Opportunity__c, Name, Tantousya__c, Status__c, Kigen__c, Syousai__c, OwnerId, RecordTypeId FROM BizTask__c WHERE Tantousya__c IN :idList];
	}


}