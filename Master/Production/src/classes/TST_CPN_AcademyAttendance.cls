/**
 * TST_CPN_AcademyAttendance
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
@isTest
private class TST_CPN_AcademyAttendance {
	@testSetup
	static void setUp() {
		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			UserRole userRole = new UserRole(name = 'Dymmy_Role', RollupDescription = 'Report_Name');
			insert userRole;

			User user1 = new User(LastName = 'AC_TEST', FirstName = 'USER', Username = 'auto_create_test@example.com', Email = 'case_trigger_test@example.com', Alias = 'ac_test', CommunityNickname = 'ac_test', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000hgMn', LanguageLocaleKey = 'ja', UserRoleId = userRole.Id);

			User user2 = new User(LastName = 'AC_TEST', FirstName = 'USER', Username = 'auto_create_test2@example.com', Email = 'case_trigger_test2@example.com', Alias = 'ac_test2', CommunityNickname = 'ac_test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000hgMn', LanguageLocaleKey = 'ja', UserRoleId = userRole.Id);
			insert new User[]{ user1, user2 };
		}
	}

	static testMethod void test() {
		User user1 = [Select Id, UserRoleId, UserName From User Where Username = 'auto_create_test@example.com'];
		User user2 = [Select Id, UserRoleId, UserName From User Where Username = 'auto_create_test2@example.com'];

		Account a = new Account(name = 'test', Phone = '00-0000-0000',Field221__c = 'test', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', CrsSale_Representative__c = user1.Id, CrsSales_RepresentativeMain__c = user2.Id);
		insert new Account[]{ a };

		Date today = System.today();
		Campaign cam1 = new Campaign(Name = '有効なキャンペーン', OwnersDivision__c = 'ビズリーチ(CRS)', Type = '自社セミナー', MediaOrganizer__c = 'ビズリーチ', ProposedService__c = 'CRS', SeminarStartDatetime__c = today.addDays(1));
		Campaign cam2 = new Campaign(Name = '無効なキャンペーン', OwnersDivision__c = 'ビズリーチ(CRS)', Type = '自社セミナー', MediaOrganizer__c = 'ビズリーチ', ProposedService__c = 'CRS', SeminarStartDatetime__c = today.addDays(-10));
		insert new Campaign[]{ cam1, cam2 };

		Lead lead1 = new Lead(Status = '新規', FirstName = 'テスト', LastName = 'メンバー', Company = '会社', LeadCategoryAccount__c = a.Id);
		insert new Lead[]{ lead1 };

		CampaignMember cm1 = new CampaignMember(CampaignId = cam1.Id, LeadId = lead1.Id, Status = '送信');
		insert new CampaignMember[]{ cm1 };

		Test.startTest();
		CLS_CPN_AcademyAttendance ccaa = new CLS_CPN_AcademyAttendance();
		// 初期状態作成
		ccaa.init();
		// キャンペーンを検索
		ccaa.campaignId = cam1.Id;
		ccaa.search();
		// イベント参加状況を変更して更新
		for (CampaignMember cm : ccaa.campaignMemberList) { 
			cm.academy_status__c = '参加';
		}
		ccaa.save();
		Test.stopTest();
	}
}