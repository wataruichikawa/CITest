/**
 * TST_TAB_TabListController
 *
 * テスト対象
 * 1.CLS_TAB_TabListController
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
@isTest
public class TST_TAB_TabListController {

	/**
	 * 管理者用タブ　テスト
	 */
	public static testMethod void testAdminTabList() {
        PageReference pageRef = Page.VFP_TAB_AdminTabList;
        Test.setCurrentPage(pageRef);

        //テスト対象Visualforceで使うコントローラのオブジェクト化
        CLS_TAB_TabListController controller = new CLS_TAB_TabListController();

		List<SelectOption> testAdminTabPickList = controller.adminTabPickList;

		testAdminTabPickList.add(new SelectOption('HuriwakeMaster__c', '振り分けマスタ'));
		testAdminTabPickList.add(new SelectOption('SyainMaster__c', '社員マスタ'));
		testAdminTabPickList.add(new SelectOption('CompetingMediumJob__c', '他社媒体掲載案件'));

	}

	/**
	 * ○○用タブ　テスト
	 */
	/*
	public static testMethod void testXxxxxTabList() {
        PageReference pageRef = Page.VFP_TAB_XxxxxTabList;
        Test.setCurrentPage(pageRef);

        //テスト対象Visualforceで使うコントローラのオブジェクト化
        CLS_TAB_TabListController controller = new CLS_TAB_TabListController();

		List<SelectOption> testXxxxxTabPickList = controller.xxxxxTabPickList;

		testAdminTabPickList.add(new SelectOption('xxxxx__c', '○○'));
		testAdminTabPickList.add(new SelectOption('xxxxx__c', '○○'));
		testAdminTabPickList.add(new SelectOption('xxxxx__c', '○○'));
		testAdminTabPickList.add(new SelectOption('xxxxx__c', '○○'));
		testAdminTabPickList.add(new SelectOption('xxxxx__c', '○○'));

	}
	*/
}