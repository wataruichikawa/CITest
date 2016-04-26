/**
 * TST_TGR_CampaignMemberTrigger
 *
 * テスト対象
 * 1.TGR_PersonalKPITrigger
 * 2.KPI_PersonalKPIProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_PersonalKPITrigger {

	static testMethod void testPersonalKPITrigger() {

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		UserRole userRole = new UserRole(name = 'Dymmy_Role', RollupDescription = 'Report_Name');
		System.runAs(usr) {
			insert userRole;
		}

		User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
		User user2 = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
		User user3 = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
		User user4 = new User(LastName = 'TEST4', FirstName = 'TEST4', Username = 'test4@sutead.com', Email = 'test4@sutead.com', Alias = 'test4', CommunityNickname = 'test4', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
		User user5 = new User(LastName = 'TEST5', FirstName = 'TEST5', Username = 'test5@sutead.com', Email = 'test5@sutead.com', Alias = 'test5', CommunityNickname = 'test5', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
		User user6 = new User(LastName = 'TEST6', FirstName = 'TEST6', Username = 'test6@sutead.com', Email = 'test6@sutead.com', Alias = 'test6', CommunityNickname = 'test6', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja', UserRoleId = userRole.id);
		List<User> userList = new User[] { user1, user2, user3, user4, user5, user6 };

		System.runAs(usr) {
			insert userList;
		}

		Date day = Date.today();
		PersonalKPI__c kpi1 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST1 TEST1',
			Syozokutantou__c = user1.Id, SyozokuTantouTeam__c = 'roleName',Profile__c = 'profileName',OwnerId = user1.Id,
			Yojitsukubun__c = '予算', Syukeibi__c = day);
		PersonalKPI__c kpi2 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST2 TEST2',
			SyozokuTantouTeam__c = 'roleName', Profile__c = 'profileName', OwnerId = user2.Id,
			Yojitsukubun__c = '予算', Syukeibi__c = day);
		PersonalKPI__c kpi3 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST3 TEST3',
			Syozokutantou__c = user3.Id, Profile__c = 'profileName', OwnerId = user3.Id,
			Yojitsukubun__c = '予算', Syukeibi__c = day);
		PersonalKPI__c kpi4 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST4 TEST4',
			Syozokutantou__c = user4.Id, SyozokuTantouTeam__c = 'roleName', OwnerId = user4.Id,
			Yojitsukubun__c = '予算', Syukeibi__c = day);
		PersonalKPI__c kpi5 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST5 TEST5',
			Syozokutantou__c = user5.Id, SyozokuTantouTeam__c = 'roleName', OwnerId = user4.Id,
			Yojitsukubun__c = '予算', Syukeibi__c = day);
		PersonalKPI__c kpi6 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST6 TEST6',
			Syozokutantou__c = user6.Id, SyozokuTantouTeam__c = 'roleName',Profile__c = 'profileName',OwnerId = user6.Id,
			Syukeibi__c = day);
		PersonalKPI__c kpi7 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST7 TEST7',
			Yojitsukubun__c = '予算', Syukeibi__c = day);
		PersonalKPI__c kpi8 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST8 TEST8',
			Syozokutantou__c = user1.Id, SyozokuTantouTeam__c = 'roleName',Profile__c = 'profileName',OwnerId = user1.Id,
			Yojitsukubun__c = '実績', Syukeibi__c = day, TriggerInvalid__c = true);
		PersonalKPI__c kpi9 = new PersonalKPI__c(SyozokuTantouText__c = 'TEST9 TEST9',
			Yojitsukubun__c = '予算', Syukeibi__c = day);

		List<PersonalKPI__c> kpiList = new PersonalKPI__c[] { kpi1, kpi2, kpi3, kpi4, kpi5, kpi6, kpi7, kpi8 };

		Test.startTest();

		insert kpiList;

		UTL_TriggerUtil.canRunPersonalKPI = false;
		insert kpi9;

		Test.stopTest();

		system.assert(![SELECT Id, TriggerInvalid__c FROM PersonalKPI__c WHERE Id = :kpi8.Id].TriggerInvalid__c);
	}

}