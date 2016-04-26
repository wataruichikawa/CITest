/**
 * TST_TGR_CampaignMemberTrigger
 *
 * テスト対象
 * 1.TGR_CARequestTrigger
 * 2.CAR_CARequestProcess
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_CARequestTrigger {

	static testMethod void test() {
		Account a = new account(name = 'test', Phone = '00-0000-0000',Field221__c = 'test', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		Account b = new account(name = 'test999', Phone = '01-0000-0000',Field221__c = 'test999', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		List<Account> acList = new Account[] {a, b};
		insert acList;

		CARequest__c ca1 = new CARequest__c(Account__c = a.id, CAAccountMailGoNoGo__c = true);
		CARequest__c ca2 = new CARequest__c(Account__c = b.id, Status__c = '0.依頼',letter_type__c = 'テンプレート', letter_Count__c = 1, CARequestItem__c = '15.手紙', RecordTypeId = System.Label.CA_Tegami_RecordtypeId);
		List<CARequest__c> caList = new CARequest__c[] {ca1, ca2};


		Test.startTest();

		insert caList;

		ca1.User__c = UserInfo.getUserid();
		update ca1;

		ca1.TriggerInvalid__c = true;
		update ca1;

		ca2.Status__c = '3.完了';
		update ca2;

		Test.stopTest();

		system.assert(![SELECT Id, TriggerInvalid__c FROM CARequest__c WHERE Id = :ca1.Id].TriggerInvalid__c);

	}
}