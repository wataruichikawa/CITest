@isTest
private class BizCrsSalesStepLogicTest {

	@TestSetup
	static void setUp() {
		Account acc = new Account(Name = 'Test Acc', Website = 'http://test.acc', Phone = '801-87-0091', BillingState = '東京都', BillingCity = '渋谷区', BillingStreet = '渋谷1-1-1');
		insert acc;
	}

	static testMethod void testStep21() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.CrsJoinedCountThisContract__c = 1;
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP21:内定承諾', step);
	}

	static testMethod void testStep20() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.CrsOfferCountThisContract__c = 1;
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP20:内定通知済1以上', step);
	}

	static testMethod void testStep19() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.CrsSecondInterviewCountLastM__c = 1;
		update acc;
		acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP19:終面1以上', step);
	}

	static testMethod void testStep18() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.CrsFirstInterviewCountLastM__c = 5;
		update acc;
		acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP18:1面設定済5以上', step);
	}

	static testMethod void testStep17() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.CrsDocumentScreeningOkCLastM__c  = 8;
		update acc;
		acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP17:書類OK8 以上', step);
	}

	static testMethod void testStep16() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.CrsPlatinumScoutSendCLastM__c = 1;
		update acc;
		acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP16:プラスカ送信済', step);
	}

	static testMethod void testStep15() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		acc.Field208__c = 1;
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP15:求人案内設定済', step);
	}

	static testMethod void testStep14() {
		Account acc = findAccount();
		insert new position__c(Field89__c = acc.Id, Field7__c = '募集中', jobid__c = '100');
		acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP14:求人登録（承認済）', step);
	}

	static testMethod void testStep11() {
		Account acc = findAccount();
		acc.Field156__c = System.today().addDays(1);
		acc.Field1__c = '承認済';
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP11:アカウント開設済', step);
	}

	static testMethod void testStep04() {
		Account acc = findAccount();
		insert new Opportunity(AccountId = acc.Id, Name = 'Test Opp', StageName = 'STEP04：訪問前準備', CloseDate = System.today(), VisitChargeUser__c = UserInfo.getUserId(), AppoAcquisitionUser__c = UserInfo.getUserId());
		acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP04:訪問前準備', step);
	}

	static testMethod void testStep03() {
		Account acc = findAccount();
		insert new Opportunity(AccountId = acc.Id, Name = 'Test Opp', StageName = 'STEP03：アポ獲得', CloseDate = System.today(), VisitChargeUser__c = UserInfo.getUserId(), AppoAcquisitionUser__c = UserInfo.getUserId());
		acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP03:アポ獲得', step);
	}

	static testMethod void testStep02() {
		Account acc = findAccount();
		acc.CrsLastTodoDatetime__c = System.today();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP02:コネクト', step);
	}

	static testMethod void testStep00() {
		Account acc = findAccount();
		Test.startTest();
		String step = BizCrsSalesStepLogic.getCurrentSalesStep(acc);
		Test.stopTest();
		System.assertEquals('STEP00:担当割り当て', step);
	}

	private static Account findAccount() {
		return [SELECT Id, Name, CrsDocumentScreeningOkCLastM__c, CrsDocumentScreeningOkCLastThisM__c, CrsDocumentScreeningOkCThisM__c, CrsFirstInterviewCountLastM__c, CrsFirstInterviewCountLastThisM__c,
			CrsFirstInterviewCountThisM__c, CrsJoinedCountThisContract__c, CrsLastInterviewCountLastM__c, CrsLastInterviewCountLastThisM__c, CrsLastInterviewCountThisM__c,
			CrsLastTodoDatetime__c, CrsLatestOpportunityStage__c, CrsOfferCountThisContract__c, CrsPlatinumScoutSendCLastM__c, CrsPlatinumScoutSendCLastThisM__c, CrsPlatinumScoutSendCThisM__c, CrsSecondInterviewCountLastM__c,
			CrsSecondInterviewCountLastThisM__c, CrsSecondInterviewCountThisM__c, Field1__c, Field156__c, Field208__c, Field226__c, last_visit_date__c, LastActivityDate,
			touroku_anken__c FROM Account WHERE Name = 'Test Acc' LIMIT 1];
	}

}