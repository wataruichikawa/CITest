/**
 * TST_TGR_CaseTrigger
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
 @isTest
private class TST_TGR_CaseTrigger {

	@testSetup
	static void setUp() {
		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			UserRole userRole = new UserRole(name = 'Dymmy_Role', RollupDescription = 'Report_Name');
			insert userRole;

			List<User> userList = new List<User>();
			User user1 = new User(LastName = 'AC_TEST', FirstName = 'USER', Username = 'auto_create_test@example.com', Email = 'case_trigger_test@example.com', Alias = 'ac_test', CommunityNickname = 'ac_test', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000hgMn', LanguageLocaleKey = 'ja', UserRoleId = userRole.Id);
			userList.add(user1);

			User user2 = new User(LastName = 'AC_TEST', FirstName = 'USER', Username = 'auto_create_test2@example.com', Email = 'case_trigger_test2@example.com', Alias = 'ac_test2', CommunityNickname = 'ac_test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000hgMn', LanguageLocaleKey = 'ja', UserRoleId = userRole.Id);
			userList.add(user2);
			insert userList;
		}
	}

	static testMethod void test() {
		User user1 = [Select Id, UserRoleId, UserName From User Where Username = 'auto_create_test@example.com'];
		User user2 = [Select Id, UserRoleId, UserName From User Where Username = 'auto_create_test2@example.com'];

		Account a = new Account(name = 'test', Phone = '00-0000-0000',Field221__c = 'test', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', CrsSale_Representative__c = user1.Id, CrsSales_RepresentativeMain__c = user2.Id);
		insert new Account[] {a};

		Contact c = new Contact(FirstName = 'てすと', LastName = 'ケース');
		insert new Contact[] {c};

		Test.startTest();
		// 取引先担当者名が入っていないやつ
		Case caseObj1 = new Case(AccountId = a.Id, Status = '担当営業/営業へ', Origin = '電子メール', Type = '操作手順', Reason = '機能に課題がある(処理ロジック)', Description = '担当はいってない');
		// 取引先担当者名がはいっているやつ
		Case caseObj2 = new Case(AccountId = a.Id, Status = '担当営業/営業へ', Origin = '電子メール', Type = '操作手順', Reason = '機能に課題がある(処理ロジック)', Description = '担当はいってる', ContactId = c.Id);
		// 状況が違う
		Case caseObj3 = new Case(AccountId = a.Id, Status = '新規', Origin = '電子メール', Type = '操作手順', Reason = '機能に課題がある(処理ロジック)', Description = '状況は別', ContactId = c.Id);

		insert new Case[] {caseObj1, caseObj2, caseObj3};

		// 至急をつける
		caseObj2.ClaimFlg__c = true;
		update new Case[] {caseObj2};

		// 状況の変更
		caseObj2.Status = '新規';
		update new Case[] {caseObj2};

		caseObj2.Status = '担当営業/営業へ';
		update new Case[] {caseObj2};

		caseObj2.Status = 'クローズ';
		caseObj3.Status = 'クローズ';
		update new Case[] {caseObj1, caseObj2, caseObj3};

		Test.stopTest();
	}
}