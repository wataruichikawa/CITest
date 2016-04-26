@isTest
private class TaskAllUpdateTest {

    static testMethod void testTaskAllUpdateTest() {
		Account ac = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', billingCity = 'あああ');
    	insert ac;

    	Contact ct1 = new Contact(AccountId = ac.id, lastname = 'TEST1', firstname = 'TARO1', email = 'test@test-sutead.com');
    	insert ct1;

		User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user1;

		Task task1 = new Task(WhatId = ac.id, WhoId = ct1.id, Type = '継続提案', OwnerId = user1.Id, Field3__c = 'メモ');
		insert task1;

		Task task2 = new Task(WhatId = ac.id, WhoId = ct1.id, Type = '振り返りMtg', OwnerId = user1.Id);
		insert task2;

		Task task3 = new Task(WhatId = ac.id, WhoId = ct1.id, Type = '導入ミーティング（訪問）', OwnerId = user1.Id);
		insert task3;

		Task task4 = new Task(WhatId = ac.id, WhoId = ct1.id, Type = '（GKブロック）断られた', OwnerId = user1.Id);
		insert task4;

		Test.StartTest();
		TaskAllUpdate batch = new TaskAllUpdate();
		batch.query = 'Select Id, DataUpdFlgForTrigger__c from task where DataUpdFlgForTrigger__c = false order by createddate asc limit 50000';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
    }
}