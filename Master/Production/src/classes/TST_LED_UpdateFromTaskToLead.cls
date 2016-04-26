/**
 * TST_LED_UpdateFromTaskToLead
 * ----------------------------------------
 * @createdName      : Y.Yokoo
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
@isTest
public class TST_LED_UpdateFromTaskToLead{

    /**
     * セットアップ
     * ユーザ、キャンペーン、リード、取引先、取引先担当者登録
     */
    @testSetup
    static void setUp() {
		//ユーザの登録
        List<User> userList = new List<User>();
        userList.add(new User(
        	LastName = 'test450', FirstName = 'test450', 
        	Username = 'test450@sutead.com', 
        	Email = 'test@sutead.com', Alias = 'test450', 
        	CommunityNickname = 'test', TimeZoneSidKey = 'Asia/Tokyo', 
        	LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
        	ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja'));
        insert userList;
		//リードの登録
		Lead target = new Lead(LastName = 'ラストネーム450', FirstName = 'ファーストネーム450', 
			Email = 'test-450@test.co.jp.test', Company = 'サンタクロース派遣センター日本支店', 
			City = '渋谷区', State = '東京都', Inbound_Trcd__c = '1234567890', OwnerId = userList[0].Id);
		insert target;
		//取引先の登録
		Account accTgt = new Account(Name = '取引先名', Field221__c = 'I0001:インターネットサービス', Phone = '03-9998-9998');
		insert  accTgt;
		//取引先担当者の登録
		Contact conTgt = new Contact(LastName = 'てすと用の取引先担当者450', AccountId = accTgt.Id);
		insert  conTgt;
    }
    /**
     * 活動情報情報生成
     * @param leadFlg Integer （1・・リード紐付け、2・・取引先担当者紐付け、3・・紐付けなし）
     * @param closedFlg boolean （true・・完了済みToDo、false・・未完了）
     * @param callFlg boolean （false・・「（GKブロック）断られた」、true・・その他）
     * @return Task
     */
    private static Task getTask(Integer leadFlg,boolean closedFlg,boolean callFlg){
    	Id whoId =null;
    	if(leadFlg == 1){
	        //リード取得
	        Lead lTarget = [select Id from Lead limit 1];
	        whoId = lTarget.Id;
    	}else if(leadFlg == 2){
	        //取引先担当者取得
	        Contact conTarget = [select Id from Contact limit 1];
	        whoId = conTarget.Id;
    	}
    	String statusStr = closedFlg ? '完了':'未着手';
    	String callStr = callFlg ? 'フォロー電話':System.label.TaskCallGKBlock;
        //活動作成処理
        return new Task(WhoId = whoId,Status = statusStr,call__c = callStr);
    }

    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：リード
     * 状況：完了
     */
    static testMethod void insertTestSuccess01() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
    	//ToDo情報取得
		Task task = getTask(1,true,true);
        System.runAs(user){
	        //ToDoの登録処理
	        insert task;
        }
        task = [select Id,action_time__c from Task where Id = :task.Id];
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,task.action_time__c);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：リード
     * 状況：未着手
     */
    static testMethod void insertTestError01() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(1,false,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：取引先担当者
     * 状況：完了
     */
    static testMethod void insertTestError02() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(2,true,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：取引先担当者
     * 状況：未着手
     */
    static testMethod void insertTestError03() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(2,false,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：なし
     * 状況：完了
     */
    static testMethod void insertTestError04() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(3,true,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：なし
     * 状況：未着手
     */
    static testMethod void insertTestError05() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(3,false,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者
     * 名前：リード
     * 状況：完了
     */
    static testMethod void insertTestError06() {
		User user = [select id from User where name = 'システム 管理者'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(1,true,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者
     * 名前：リード
     * 状況：未着手
     */
    static testMethod void insertTestError07() {
		User user = [select id from User where name = 'システム 管理者'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(1,false,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者
     * 名前：取引先担当者
     * 状況：完了
     */
    static testMethod void insertTestError08() {
		User user = [select id from User where name = 'システム 管理者'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(2,true,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者
     * 名前：取引先担当者
     * 状況：未着手
     */
    static testMethod void insertTestError09() {
		User user = [select id from User where name = 'システム 管理者'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(2,false,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者
     * 名前：なし
     * 状況：完了
     */
    static testMethod void insertTestError10() {
		User user = [select id from User where name = 'システム 管理者'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(2,true,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者
     * 名前：なし
     * 状況：未着手
     */
    static testMethod void insertTestError11() {
		User user = [select id from User where name = 'システム 管理者'];
		//テスト実施
        Test.startTest();
        System.runAs(user){
	    	//ToDo情報取得
			Task task = getTask(2,false,true);
	        //ToDoの登録処理
	        insert task;
        }
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * ToDoのテスト
     * ユーザ：システム管理者以外
     * 名前：リード
     * 状況：完了
     */
    static testMethod void insertTestError12() {
		User user = [select id from User where name = 'test450 test450'];
		//テスト実施
        Test.startTest();
    	//ToDo情報取得
		Task task = getTask(1,true,false);
        System.runAs(user){
	        //ToDoの登録処理
	        insert task;
        }
        task = [select Id,action_time__c from Task where Id = :task.Id];
        Lead lTarget = [select Id,Name,action_time__c from Lead limit 1];
        System.assertEquals(lTarget.action_time__c,null);
        //テスト終了
        Test.stopTest();
    }
    
}