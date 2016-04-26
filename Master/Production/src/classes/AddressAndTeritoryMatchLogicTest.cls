@isTest
private class AddressAndTeritoryMatchLogicTest {

    static testMethod void myUnitTest() {

		User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		UserRole role;
		UserRole role2;
		System.runAs(usr) {
        	role =  new UserRole(Name = 'XXXX', RollupDescription = 'Report_Name');
        	role2 =  new UserRole(Name = 'XXXX2', RollupDescription = 'Report_Name2');
        	insert new UserRole[] { role, role2 };//振り分けマスタがない状態で取引先を保存する
		}

     	Account a = new account(name = 'Test', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '東京都', CompanyTeritory__c ='' , BillingCity = '渋谷区', BillingStreet = '渋谷');
    	insert a;

    	//振り分けマスタ作成
		HuriwakeMaster__c h1 = new HuriwakeMaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '渋谷区', Tyouiki__c = '渋谷', RoleID__c = role.Id, InboundRoleId__c = role2.Id);
        HuriwakeMaster__c h2 = new HuriwakeMaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '千代田区', Tyouiki__c = '飯田橋', RoleID__c = role.Id, InboundRoleId__c = role2.Id);
        HuriwakeMaster__c h3 = new HuriwakeMaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '千代田区', Tyouiki__c = '一番町', RoleID__c = role.Id, InboundRoleId__c = role2.Id);
        HuriwakeMaster__c h4 = new HuriwakeMaster__c(Todouhuken__c = '北海道', Shikutyouson__c = '', Tyouiki__c = '', RoleID__c = role.Id, InboundRoleId__c = role2.Id);
        List<HuriwakeMaster__c> hmList = new List<HuriwakeMaster__c>();
        hmList.add(h1);
        hmList.add(h2);
        hmList.add(h3);
        hmList.add(h4);
    	insert hmList;

        //振り分けマスタトリガーエラー用テストメソッド
        HuriwakeMaster__c h = new HuriwakeMaster__c(Todouhuken__c = '東京都', Shikutyouson__c = '渋谷区', Tyouiki__c = '渋谷', RoleID__c ='000000000000000000', InboundRoleId__c = role2.Id);

        try{
            insert h;
        } catch(Exception e){}

 		a.BillingCity = '東京都渋谷区渋谷';
		update a;

        Lead led1 = new Lead(Company = '株式会社祖川テスト1', state = '東京都', city = '渋谷区', street = '渋谷１－１－１', lastName = '祖川', firstName = '慎治', status = '新規', email = 'shinjisogawa1@sutead.com');
		Lead led2 = new Lead(Company = '株式会社祖川テスト2', state = '東京都', city = '渋谷区', street = '道玄坂１－１－１', lastName = '祖川', firstName = '慎治', status = '新規', email = 'shinjisogawa2@sutead.com');
		Lead led3 = new Lead(Company = '株式会社祖川テスト3', state = '東京都', city = '中野区', street = '中野１－１－１', lastName = '祖川', firstName = '慎治', status = '新規', email = 'shinjisogawa3@sutead.com');

        insert led1;
        insert led2;
        insert led3;

        Account a2 = new account(name = 'Test2', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '東京都', CompanyTeritory__c ='' , BillingCity = '渋谷区', BillingStreet = '渋谷', Ootetantoukigyou__c = false);
        Account a3 = new account(name = 'Test3', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '東京都', CompanyTeritory__c ='' , BillingCity = '千代田区', BillingStreet = '飯田橋', Ootetantoukigyou__c = false);
        Account a4 = new account(name = 'Test4', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '東京都', CompanyTeritory__c ='' , BillingCity = '千代田区', BillingStreet = '一番町', Ootetantoukigyou__c = false);
        Account a5 = new account(name = 'Test5', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '北海道', CompanyTeritory__c ='' , BillingCity = 'テストテストテスト区', BillingStreet = '99-99-99', Ootetantoukigyou__c = false);
        Account a6 = new account(name = 'Test6', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '北海道', CompanyTeritory__c ='札幌市' , BillingCity = '北区', BillingStreet = '88-88-88', Ootetantoukigyou__c = false);
        Account a7 = new account(name = 'Test7', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '東京都', CompanyTeritory__c ='' , BillingCity = 'テストテストテスト区', BillingStreet = '11-11-11', Ootetantoukigyou__c = false);
        Account a8 = new account(name = 'Test8', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '神奈川県', CompanyTeritory__c ='' , BillingCity = 'テストテストテスト区', BillingStreet = 'テスト', Ootetantoukigyou__c = false);
        Account a9 = new account(name = 'Test9', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = 'ロンドン', CompanyTeritory__c ='' , BillingCity = 'テストテストテスト区', BillingStreet = 'テスト', Ootetantoukigyou__c = false);
        Account a10 = new account(name = 'Test2', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = '東京都', CompanyTeritory__c ='' , BillingCity = '渋谷区', BillingStreet = '渋谷', Ootetantoukigyou__c = false);
        Account a11 = new account(name = 'Test9', phone = '00-0000-0000',Field221__c='I0001:インターネットサービス',BillingState = 'ワシントン', CompanyTeritory__c ='' , BillingCity = 'ニューヨーク', BillingStreet = 'ウォールストリート', Ootetantoukigyou__c = true);
        List<Account> accList = new List<Account>();
        accList.add(a2);
        accList.add(a3);
        accList.add(a4);
        accList.add(a5);
        accList.add(a6);
        accList.add(a7);
        accList.add(a8);
        accList.add(a9);
        accList.add(a10);
        accList.add(a11);
        insert accList;

        // テスト開始
        Test.startTest();

        // Apexをスケジュールに登録
        String jobId = System.schedule('KaisyaSyozaiTeritoryUpdateBatch','0 0 * * * ?', new KaisyaSyozaiTeritoryUpdateSchedule());

        // テスト終了（登録したスケジュールが実施される）
        Test.stopTest();

    }
}