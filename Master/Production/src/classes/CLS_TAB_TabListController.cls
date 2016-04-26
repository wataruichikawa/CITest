/**
 * CLS_TAB_TabListController
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
public class CLS_TAB_TabListController {

    /**
     * フィールド変数(getter , setter)
     */
    public String adminTabObjApi {get;set;}
    //public String xxxxxTabObjApi {get;set;}

    /**
     * コンストラクタ
     */
    public CLS_TAB_TabListController(){
        //初期値設定

        //管理者用タブ
        adminTabObjApi = 'HuriwakeMaster__c';
        //○○用タブ
        //xxxxxTabObjApi = 'xxxxxxxxxx__c';
    }

    /**
	 * 管理者用タブ　選択リスト
	 * @return List<SelectOption>
	 */
    public List<SelectOption> adminTabPickList{
        get{
            List<SelectOption> options = new List<SelectOption>();

            // API参照名とオブジェクト名を追加
            // 項目を増やしたらテストメソッドも増やす！！-> TST_TAB_TabListController.cls
            options.add(new SelectOption('HuriwakeMaster__c', '振り分けマスタ'));
            options.add(new SelectOption('SyainMaster__c', '社員マスタ'));
            options.add(new SelectOption('CompetingMediumJob__c', '他社媒体掲載案件'));

            return options;
        }
    }

    /**
	 * ○○用タブ　選択リスト
	 * @return List<SelectOption>
	 */
    /*
    public List<SelectOption> xxxxxTabPickList{
        get{
            List<SelectOption> options = new List<SelectOption>();

            // API参照名とオブジェクト名を追加
            // 項目を増やしたらテストメソッドも増やす！！-> TST_TAB_TabListController.cls
            options.add(new SelectOption('xxxxxxxxxx__c', '○○○'));
            options.add(new SelectOption('xxxxxxxxxx__c', '○○○'));
            options.add(new SelectOption('xxxxxxxxxx__c', '○○○'));
            options.add(new SelectOption('xxxxxxxxxx__c', '○○○'));

            return options;
        }
    }
    */

}