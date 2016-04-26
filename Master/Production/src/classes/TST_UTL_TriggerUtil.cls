/**
 * TST_UTL_TriggerUtil
 *
 * テスト対象
 * 1.UTL_TriggerUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_UTL_TriggerUtil {

	/**
	 * トリガー無効フラグ振り分けテスト
	 */
	static testMethod void testCreateTriggerList() {
		List<Account> accList = new Account[] { new Account(TriggerInvalid__c = true), new Account(TriggerInvalid__c = false), new Account(TriggerInvalid__c = false) };

		Test.startTest();
		DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(true, false, false, accList, accList);
		system.assertEquals(0, dto.oldList.size());
		system.assertEquals(2, dto.newList.size());
		system.assertEquals(1, dto.invalidList.size());

		dto = UTL_TriggerUtil.createTriggerList(false, true, false, accList, accList);
		system.assertEquals(2, dto.oldList.size());
		system.assertEquals(2, dto.newList.size());
		system.assertEquals(1, dto.invalidList.size());

		dto = UTL_TriggerUtil.createTriggerList(false, false, true, accList, accList);
		system.assertEquals(3, dto.oldList.size());
		system.assertEquals(0, dto.newList.size());
		system.assertEquals(0, dto.invalidList.size());
		Test.stopTest();

	}

	/**
	 * トリガー無効フラグOFFテスト
	 */
	static testMethod void testUpdateTriggerInvalid() {
		Account acc = new Account(name = 'Test Inc1', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		insert acc;
		List<Id> idList = new Id[] { acc.Id };

		Test.startTest();
		system.assert(UTL_TriggerUtil.updateTriggerInvalid(idList, 'Account'));
		system.assert(!UTL_TriggerUtil.updateTriggerInvalid(idList, 'AccountError'));
		Test.stopTest();
	}

}