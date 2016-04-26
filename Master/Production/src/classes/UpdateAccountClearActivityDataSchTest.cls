@isTest
private class UpdateAccountClearActivityDataSchTest {

    static testMethod void testUpdateAccountClearActivityDataSchTest() {
		Test.StartTest();

    	Account ac = new Account(REC_COMPANY_ID__c = 1000, name = 'TEST', Phone = '03-3333-3333', Field221__c = 'インターネットサービス', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
    	insert ac;

		String jobId = System.schedule('test hello world', '0 0 * * * ?', new UpdateAccountClearActivityDataSch());
        System.debug('***** job id : ' + jobId + ' ***** ***** *****');

        Test.stopTest();
    }
}