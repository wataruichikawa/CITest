/**
 * TST_CPM_LeadToCampaignMemberCopy
 * ----------------------------------------
 * @createdName      : Y.Yokoo
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
@isTest
public class TST_CPM_LeadToCampaignMemberCopy{

    /**
     * セットアップ
     * ユーザ、キャンペーン、リード、取引先、取引先担当者登録
     */
    @testSetup
    static void setUp() {
		//ユーザの登録
        List<User> userList = new List<User>();
        for (Integer i = 0; i < 1; i++) {
            userList.add(new User(
            	LastName = 'TEST' + i, FirstName = 'TEST' + i, 
            	Username = 'test' + i + '@sutead.com', 
            	Email = 'test' + i + '@sutead.com', Alias = 'test' + i, 
            	CommunityNickname = 'test' + i, TimeZoneSidKey = 'Asia/Tokyo', 
            	LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
            	ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja'));
        }
        insert userList;
		//キャンペーンの登録
		Campaign cTarget = new Campaign(
			OwnerId = userList[0].Id, Name = 'テストキャンペーン', OwnersDivision__c = 'ビズリーチ(CRS)', 
			Type = '自社セミナー', MediaOrganizer__c = 'ビズリーチ', ProposedService__c = 'CRS', 
			RecordTypeId = '01210000000UjVXAA0');
		insert cTarget;
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
     * キャンペーンメンバー情報生成
     * 必要最低限
     * @return CampaingMember
     */
    private static CampaignMember getCM(){
    	//リード取得
        Lead target = [select Id from Lead limit 1];
        //キャンペーン取得
        Campaign cTarget = [select Id from Campaign limit 1];
        //キャンペーンメンバー作成処理
        return new CampaignMember(CampaignId = cTarget.Id, LeadId = target.Id);
    }

    /**
     * キャンペーンメンバー情報生成
     * すべて
     * @return CampaingMember
     */
    private static CampaignMember getCMAllData(){
    	//リード取得
        Lead target = [select Id from Lead limit 1];
        //キャンペーン取得
        Campaign cTarget = [select Id from Campaign limit 1];
        //キャンペーンメンバー作成処理
        return new CampaignMember(CampaignId = cTarget.Id, LeadId = target.Id, 
        	trcd__c = 'MRKTBizBiz00008', Inquiry__c = 'その他', AdoptionTarget__c = '決まっていない', 
        	OpportunityProducts__c = 'ビズリーチ', AdoptionStatus__c = '未定', 
        	AdoptionSupportService__c = '新たに採用支援サービスの利用する予定はない', InquiryText__c = 'ご質問', 
        	Path__c = 'きっかけ', SingleSeminarDay__c = '12/9', InfluxRoute__c = 'ビズリーチ', 
        	ApplyForSeminar__c = 'その他', LeadSource__c = '日本の人事部');
    }

    /**
     * キャンペーンメンバー情報生成
     * リードなし
     * @return CampaingMember
     */
    private static CampaignMember getCMNoLeadData(){
        //キャンペーン取得
        Campaign cTarget = [select Id from Campaign limit 1];
        //取引先担当者取得
        Contact conTarget = [select Id from Contact limit 1];
        //キャンペーンメンバー作成処理
        return new CampaignMember(CampaignId = cTarget.Id, ContactId = conTarget.Id, 
        	trcd__c = 'MRKTBizBiz00008', Inquiry__c = 'その他', AdoptionTarget__c = '決まっていない', 
        	OpportunityProducts__c = 'ビズリーチ', AdoptionStatus__c = '未定', 
        	AdoptionSupportService__c = '新たに採用支援サービスの利用する予定はない', InquiryText__c = 'ご質問', 
        	Path__c = 'きっかけ', SingleSeminarDay__c = '12/9', InfluxRoute__c = 'ビズリーチ', 
        	ApplyForSeminar__c = 'その他', LeadSource__c = '日本の人事部');
    }

    /**
     * キャンペーンメンバーのテスト
     */
    static testMethod void insertOneTest() {
    	//キャンペーンメンバー情報取得
		CampaignMember cm = getCM();
		//テスト実施
        Test.startTest();
        //キャンペーンメンバーの登録処理
        insert cm;
        //テスト終了
        Test.stopTest();
    }

    /**
     * キャンペーンメンバー（オール入力版）のテスト
     */
    static testMethod void insertOneAllDataTest() {
    	//キャンペーンメンバー情報取得
		CampaignMember cm = getCMAllData();
		//テスト実施
        Test.startTest();
        //キャンペーンメンバーの登録処理
        insert cm;
        //テスト終了
        Test.stopTest();
    }

    /**
     * キャンペーンメンバー（リードなし）のテスト
     */
    static testMethod void insertOneNoLeadDataTest() {
    	//キャンペーンメンバー情報取得
		CampaignMember cm = getCMNoLeadData();
		//テスト実施
        Test.startTest();
        //キャンペーンメンバーの登録処理
        insert cm;
        //テスト終了
        Test.stopTest();
    }
    
    /**
     * キャンペーンメンバー（複数件）のテスト
     */
    static testMethod void insertListTest() {
    	//キャンペーンメンバーList情報取得
		List<CampaignMember> cmList = new List<CampaignMember>();
		cmList.add(getCMAllData());
		cmList.add(getCMNoLeadData());
		//テスト実施
        Test.startTest();
        //キャンペーンメンバーの登録処理
        insert cmList;
        //テスト終了
        Test.stopTest();
    }
    
}