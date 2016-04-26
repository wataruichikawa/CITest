@isTest
private class BIZTaskListTest {

	@isTest static void test_method() {

	PageReference pageRef = Page.BizTaskList;

	Test.setCurrentPage(pageRef);

	BizTask__c BT = new BizTask__c(Name = 'TEST');

	ApexPages.StandardController stdController = new ApexPages.StandardController(BT);

	BizTaskListController BTLC = new BizTaskListController(stdController);

    system.assertNotEquals(null, BTLC.getBizTaskList());
    system.assert(String.isNotEmpty(BTLC.getNameLabel()));

	}

}