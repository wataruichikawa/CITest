/**
 * TST_BAT_KpiSyukeiCandi_Batch
 *
 * テスト対象
 * 1.TST_BAT_KpiSyukeiCandi_Batch
 * ----------------------------------------
 * @createdName      : Ye
 * @lastModifiedName : Ye
 * ----------------------------------------
 */

@isTest
private class TST_BAT_KpiSyukeiCandi_Batch{

	@testSetup
	static void setUp() {
		
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
		
		Date sysdate = system.today();

		User user = [Select Id, UserRoleId, UserName From User Where Username = 'test1@sutead.com'];

		Account ac1 = new Account(name = 'Test Company1',CrsSale_Representative__c = user.Id);
		Account ac2 = new Account(name = 'Test Company2',CrsSale_Representative__c = null);
		Account ac3 = new Account(name = 'Test Company3', CrsSale_Representative__c = user.Id);
		List<Account> acList = new Account[] { ac1, ac2, ac3 };
		insert acList;
		
		position__c ps1  = new position__c(name= 'kyujin1',Jobid__c = 'jobid1', Field89__c = ac1.Id);
		position__c ps2  = new position__c(name= 'kyujin2',Jobid__c = 'jobid2', Field89__c = ac2.Id);
		position__c ps3  = new position__c(name= 'kyujin3',Jobid__c = 'jobid3', Field89__c = ac3.Id);
		List<position__c> psList = new position__c[] { ps1, ps2, ps3 };
		insert psList;
		
		CrsCandidate__c crs1 = new CrsCandidate__c(Shimei__c = 'shimei1', Account__c = ac1.id, position__c = ps1.Id, Field36__c = sysdate.addDays(-1),Field53__c = 1000);
		CrsCandidate__c crs2 = new CrsCandidate__c(Shimei__c = 'shimei2', Account__c = ac2.id, position__c = ps2.Id, Field36__c = sysdate.addDays(-1),Field53__c = 2000);
		CrsCandidate__c crs3 = new CrsCandidate__c(Shimei__c = 'shimei3', Account__c = ac3.id, position__c = ps3.Id, drop_sales_date__c = sysdate.addDays(-1),drop_sales_price__c = 500,drop_sales_reason__c = '理由');
		List<CrsCandidate__c> crsList = new CrsCandidate__c[] { crs1, crs2, crs3 };
		insert crsList;
		

		Test.startTest();
		String jobId1 = Database.executeBatch(new BAT_CreatePersonalKPIJissekiSyukeiBatch(-1));
		String jobId2 = Database.executeBatch(new BAT_KpiSyukeiCandi_Batch(-1));
		
		Test.stopTest();

    }

}