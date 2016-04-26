/**
 * TST_TGR_HuriwakeMasterTrigger
 *
 * テスト対象
 * 1.TRG_HuriwakeMasterTrigger
 * 2.HWM_HuriwakeMasterProcess
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_HuriwakeMasterTrigger {

	@testSetup
	static void setUp() {
		UserRole role1 = new UserRole(Name = 'test_role1', RollupDescription = 'role1_rp');
		UserRole role2 = new UserRole(Name = 'test_role2', RollupDescription = 'role2_rp');
		insert new UserRole[] { role1, role2 };
	}

	static testMethod void test1() {
		List<UserRole> roleList = findUserRole();

		Huriwakemaster__c hwm = new Huriwakemaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '渋谷区', Tyouiki__c = '渋谷', RoleID__c = roleList.get(0).Id, InboundRoleId__c = roleList.get(1).Id);

		Test.StartTest();
		insert hwm;
		system.assert(String.isNotEmpty(hwm.Id));
		hwm.TriggerInvalid__c = true;
		update hwm;
		Test.StopTest();
		system.assert(![SELECT Id, TriggerInvalid__c FROM Huriwakemaster__c WHERE Id = :hwm.Id].TriggerInvalid__c);
	}

	static testMethod void test2() {
		List<UserRole> roleList = findUserRole();

		Huriwakemaster__c hwm = new Huriwakemaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '渋谷区', Tyouiki__c = '渋谷', RoleID__c = roleList.get(1).Id, InboundRoleId__c = roleList.get(0).Id);
		insert hwm;

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			delete roleList.get(1);
		}

		Test.StartTest();
		try {
			update hwm;
		} catch (Exception e) {
			system.assert(e.getMessage().contains(system.label.HuriwakeMasterErrorMessage));
		}
		hwm.RoleID__c = 'x';
		try {
			update hwm;
		} catch (Exception e) {
			system.assert(e.getMessage().contains(system.label.HuriwakeMasterErrorMessage));
		}
		Test.StopTest();
	}

	static testMethod void test3() {
		List<UserRole> roleList = findUserRole();

		Huriwakemaster__c hwm = new Huriwakemaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '渋谷区', Tyouiki__c = '渋谷', RoleID__c = roleList.get(0).Id, InboundRoleId__c = roleList.get(1).Id);
		insert hwm;

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(usr) {
			delete roleList.get(1);
		}

		Test.StartTest();
		try {
			update hwm;
		} catch (Exception e) {
			system.assert(e.getMessage().contains(system.label.HuriwakeMasterErrorMessage));
		}
		hwm.InboundRoleId__c = 'x';
		try {
			update hwm;
		} catch (Exception e) {
			system.assert(e.getMessage().contains(system.label.HuriwakeMasterErrorMessage));
		}
		Test.StopTest();
	}


	private static List<UserRole> findUserRole() {
		return [SELECT Id, Name, RollupDescription FROM UserRole Where Name LIKE 'test_role%' ORDER BY Name];
	}
}