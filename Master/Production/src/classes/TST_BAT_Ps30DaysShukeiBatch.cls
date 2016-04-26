/**
 * TST_BAT_Ps30DaysShukeiBatch
 *
 * テスト対象
 * 1.BAT_Ps30DaysShukeiBatch
 * 2.SCH_BatchScheduler
 * 3.SCH_Ps30DaysShukeiBatch
 * 4.BAT_JobExecutor
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_BAT_Ps30DaysShukeiBatch {

	@testSetUp
	static void setUp() {
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		bjo.job1__c = BAT_JobExecutor.JOB_PS_30;
		bjo.StartJobNo__c = 1;
		bjo.FinishJobNo__c = 1;
		insert bjo;
	}

	static testMethod void testExecute() {

		Account ac1 = new Account(name = 'PS/TL集計テスト企業1', Phone = '99-7777-0001', Field221__c = 'I0001:インターネットサービス', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		insert ac1;

		Account acid = [select id from Account where name = 'PS/TL集計テスト企業1' ];

		position__c po1 = new position__c(Field89__c = acid.Id, name = '12345', Jobid__c = '23456' );
		insert po1;

		position__c poid = [select id from position__c where name = '12345'];

		CRS_TargetList__c tl1 = new CRS_TargetList__c ( TargetListName__c = '887766', TargetListId__c = 11223344, position__c = poid.Id, TargetListDetailCnt__c = 3);
		insert tl1;

		CRS_TargetList__c tlid = [select id from CRS_TargetList__c where TargetListId__c = 11223344 and TargetListName__c = '887766' ];
		DateTime sysTime1 = system.now();
		DateTime sysTime2 = sysTime1.addDays(-31);

		CRS_TargetListDetail__c tld1 = new CRS_TargetListDetail__c (TargetListDetailId__c = 76543, TargetList__c = tlid.Id, CandidateId__c = 65432, ScoutSendDate__c = sysTime1, ListAddDate__c = sysTime2 , TargetListJobCanId__c = '565656');
		CRS_TargetListDetail__c tld2 = new CRS_TargetListDetail__c (TargetListDetailId__c = 87654, TargetList__c = tlid.Id, CandidateId__c = 54321, ScoutSendDate__c = sysTime2, ListAddDate__c = sysTime1 , TargetListJobCanId__c = '757575');

		insert tld1;
		insert tld2;

		Test.startTest();
		String jobId = System.schedule('testExecute1', '0 0 * * * ?', new SCH_BatchScheduler());
		jobId = System.schedule('testExecute2', '0 0 * * * ?', new SCH_Ps30DaysShukeiBatch());
		Test.stopTest();

	}

}