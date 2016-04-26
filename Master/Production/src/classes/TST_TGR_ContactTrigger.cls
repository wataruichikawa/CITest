/**
 * TST_TGR_CampaignMemberTrigger
 *
 * テスト対象
 * 1.TGR_ContactTrigger
 * 2.CON_ContactProcess
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_ContactTrigger {

	static testMethod void testContactTrigger() {
		Account ac = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', billingCity = 'あああ');
		insert ac;

		Contact ct = new Contact(AccountId = ac.id, lastname = 'TEST1', firstname = 'TARO1', email = 'test@test-sutead.com');

		Test.startTest();
		insert ct;

		ct.email = null;
		update ct;

		ct.TriggerInvalid__c = true;
		update ct;
		Test.stopTest();

		system.assert(![SELECT Id, TriggerInvalid__c FROM Contact WHERE Id = :ct.Id].TriggerInvalid__c);
	}

}