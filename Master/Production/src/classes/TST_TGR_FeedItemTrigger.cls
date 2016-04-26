/**
 * TST_TGR_FeedItemTrigger
 *
 * テスト対象
 * 1.TGR_FeedItemTrigger
 * 2.FEI_FeedItemProcess
 * 3.UTL_StringUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_FeedItemTrigger {

	@TestSetUp
	static void setUp() {
		Account acc1 = new Account(Name = 'Test .Inc1', Phone = '03-0405-0601', Website = 'http://www.test.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		Account acc2 = new Account(Name = 'Test .Inc2', Phone = '03-0405-0602', Website = 'http://www.test.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		Account acc3 = new Account(Name = 'Test .Inc3', Phone = '03-0405-0603', Website = 'http://www.test.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		Account acc4 = new Account(Name = 'Test .Inc4', Phone = '03-0405-0604', Website = 'http://www.test.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		Account acc5 = new Account(Name = 'Test .Inc5', Phone = '03-0405-0605', Website = 'http://www.test.co.jp/', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
		insert new Account[] { acc1, acc2, acc3, acc4, acc5 };
		Opportunity opp = new Opportunity(AccountId = acc1.Id, Name = 'ビズリーチ商談', StageName = 'STEP3：アポ獲得@', CloseDate = system.today(), VisitChargeUser__c = UserInfo.getUserId(), AppoAcquisitionUser__c = UserInfo.getUserId());
		insert opp;
	}

	/**
	 * 取引先組織図登録日更新テスト
	 */
	static testMethod void testUpdateAccountOrganizationChart() {
		List<Account> accList = [SELECT Id FROM Account WHERE Name LIKE 'Test .Inc%' ORDER BY Name];
		List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE StageName = 'STEP3：アポ獲得@'];
		FeedItem fei1 = new FeedItem(ParentId = accList.get(0).Id, Type = 'TextPost', Title = 'Text Title', Body = 'Text Body');
		FeedItem fei2 = new FeedItem(ParentId = accList.get(1).Id, Type = 'ContentPost', ContentFileName = 'File.jpg', ContentData = Blob.valueOf('data'));
		FeedItem fei3 = new FeedItem(ParentId = accList.get(2).Id, Type = 'ContentPost', ContentFileName = 'File.png', ContentData = Blob.valueOf('data'));
		FeedItem fei4 = new FeedItem(ParentId = accList.get(3).Id, Type = 'ContentPost', ContentFileName = 'File.docx', ContentData = Blob.valueOf('data'));
		FeedItem fei5 = new FeedItem(ParentId = accList.get(4).Id, Type = 'ContentPost', ContentFileName = 'File', ContentData = Blob.valueOf('data'));
		FeedItem fei6 = new FeedItem(ParentId = oppList.get(0).Id, Type = 'ContentPost', ContentFileName = 'File.png', ContentData = Blob.valueOf('data'));

		Test.startTest();
		insert new FeedItem[] { fei1, fei2, fei3, fei4, fei5, fei6 };
		Test.stopTest();
	}

}