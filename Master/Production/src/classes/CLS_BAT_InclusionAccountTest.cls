/**
 * CLS_BAT_InclusionAccountTest
 *
 * テスト対象
 * 1.CLS_SCH_InclusionAccount
 * 2.SCH_BatchScheduler
 * 3.BAT_JobExecutor
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class CLS_BAT_InclusionAccountTest {

	@testSetUp
	static void setUp() {
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		bjo.job1__c = BAT_JobExecutor.JOB_INCLUSION;
		bjo.StartJobNo__c = 1;
		bjo.FinishJobNo__c = 1;
		insert bjo;

		Account parent1 = new Account(Name = 'ParentInc1', Phone = '1111-00-0001', Website = 'http://parentinc1.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field156__c = System.today() - 1);
		Account parent2 = new Account(Name = 'ParentInc2', Phone = '1111-00-0002', Website = 'http://parentinc2.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', Field156__c = System.today());
		insert new Account[] { parent1, parent2 };
		Account child11 = new Account(Name = 'ChildInc11', Phone = '1111-00-0003', Website = 'http://childinc11.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', InclusionAccount__c = parent1.Id);
		Account child12 = new Account(Name = 'ChildInc12', Phone = '1111-00-0004', Website = 'http://childinc12.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', InclusionAccount__c = parent1.Id);
		Account child21 = new Account(Name = 'ChildInc21', Phone = '1111-00-0005', Website = 'http://childinc21.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9', InclusionAccount__c = parent2.Id);
		insert new Account[] { child11, child12, child21 };
	}

	/**
	 * 包括契約対象解除
	 */
	static testMethod void testInclusionAccount1() {
		Test.startTest();
		String jobId = System.schedule('InclusionAccount1','0 0 * * * ?', new CLS_SCH_InclusionAccount());
		Test.stopTest();
	}

	/**
	 * 包括契約対象解除対象なし
	 */
	static testMethod void testInclusionAccount2() {
		Account parent1 = [SELECT Id, Field156__c FROM Account WHERE Name = 'ParentInc1'];
		parent1.Field156__c = System.today();
		update parent1;
		Test.startTest();
		String jobId = System.schedule('InclusionAccount2','0 0 * * * ?', new SCH_BatchScheduler());
		Test.stopTest();
	}

}