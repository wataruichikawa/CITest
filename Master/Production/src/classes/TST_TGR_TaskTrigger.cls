/**
 * TST_TGR_TaskTrigger
 *
 * テスト対象
 * 1.TGR_TaskTrigger
 * 2.ACC_AccountTaskUpdate
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
@isTest
private class TST_TGR_TaskTrigger {

	static testMethod void testTaskTrigger1(){
		User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user1;

		Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', billingCity = 'あああ', CrsSale_Representative__c = user1.Id);
		Account ac2 = new Account(name = 'Task to Contact Test Inc', Phone = '99-8787-7676', Field221__c = 'Internet', billingCity = 'Saitama-city');
		List<Account> accList = new Account[] {ac1, ac2};
		insert accList;

		Contact ct1 = new Contact(AccountId = ac1.id, lastname = 'TEST1', firstname = 'TARO1', email = 'test@test-sutead.com');
		Contact ct2 = new Contact(AccountId = ac2.id, lastname = 'TestYamada', firstname = 'Ichiro', email = 'testyamada@testbiz.co.jp', phone = '99-8787-7676');
		List<Contact> ctList = new Contact[] {ct1, ct2};
		insert ctList;

        RecordType[] recordTypeList = [select Name, DeveloperName, Id from RecordType where SobjectType='Task' and DeveloperName in ('CRS', 'CRS_DCS')];
         Id recordTypeIdCrs;
        Id recordTypeIdCrsDcs;
        for (RecordType recordType : recordTypeList) {
            if (recordType.DeveloperName == 'CRS') {
                recordTypeIdCrs = recordType.Id;
            } else if (recordType.DeveloperName == 'CRS_DCS') {
                recordTypeIdCrsDcs = recordType.Id;
            }
        }

 		Task task1 = new Task(WhatId = ac1.id, WhoId = ct1.id, Status = '完了', RecordTypeId = recordTypeIdCrs, Type = '継続提案', OwnerId = user1.Id, Field3__c = 'MEMO1', activityDate = system.today());
		Task task2 = new Task(WhatId = ac1.id, WhoId = ct1.id, Status = '完了', RecordTypeId = recordTypeIdCrs, Type = '振り返りMtg', OwnerId = user1.Id, Field3__c = 'MEMO2', activityDate = system.today());
		Task task3 = new Task(WhatId = ac1.id, WhoId = ct1.id, Status = '完了', RecordTypeId = recordTypeIdCrs, Type = '導入ミーティング（訪問）', OwnerId = user1.Id, Field3__c = 'MEMO3', activityDate = system.today());
		Task task4 = new Task(WhatId = ac1.id, WhoId = ct1.id, Status = '完了', RecordTypeId = recordTypeIdCrs, Type = '電話',  call__c = '（GKブロック）断られた', OwnerId = user1.Id, Field3__c = 'MEMO4', activityDate = system.today());
		Task task5 = new Task(WhatId = ac1.id, WhoId = ct1.id, Status = '完了', RecordTypeId = recordTypeIdCrs, Type = '電話',  call__c = '（GK突破）断られた', OwnerId = user1.Id, Field3__c = 'MEMO5', activityDate = system.today());
		Task task6 = new Task(WhatId = ac1.id, WhoId = ct1.id, RecordTypeId = recordTypeIdCrs, Type = 'その他', OwnerId = user1.Id, Field3__c = 'MEMO6', activityDate = system.today());
		Task task7 = new Task(WhatId = ac2.id, Status = '完了', RecordTypeId = recordTypeIdCrs, Type = '電話',  call__c = '（GK突破）断られた', OwnerId = user1.Id, tanto__c = 'TestYamada2', activityDate = system.today(), Get_Email__c = 'testyamada2@testbiz.co.jp', Get_Phone__c = '99-8787-7676');

		Task task8 = new Task(WhatId = ac1.id, WhoId = ct1.id, Status = '完了', RecordTypeId = recordTypeIdCrsDcs, Type = '電話', OwnerId = user1.Id, Field3__c = '不在なので記録されない', huzai_flag__c = true, activityDate = system.today());
		Task task9 = new Task(WhatId = ac2.id, WhoId = ct2.id, Status = '完了', RecordTypeId = recordTypeIdCrsDcs, Type = '電話', OwnerId = user1.Id, Field3__c = '記録される', activityDate = system.today());
		List<Task> tskList = new Task[] { task1, task2, task3, task4, task5, task6, task7, task8, task9 };

		Test.startTest();

		insert tskList;
		task1.type = '導入ミーティング（訪問）';
		update task1;
		task2.TriggerInvalid__c = true;
		update task2;

		Test.stopTest();

		system.assert(![SELECT Id, TriggerInvalid__c FROM Task WHERE Id = :task2.Id].TriggerInvalid__c);

		// Taskの動作の確認
		Account[] accountList = [SELECT Id, CrsDcsLastTodoDatetime__c, CrsDcsLastSalesActivities__c FROM Account WHERE Id in (:ac1.Id, :ac2.Id)];
		system.assert(accountList.size() > 0);
		for (Account a : accountList) {
			if (a.Id == ac1.Id) {
					system.assert(a.CrsDcsLastTodoDatetime__c == null);
					system.assert(a.CrsDcsLastSalesActivities__c == null);
				} else if (a.Id == ac2.Id) {
					system.assert(a.CrsDcsLastTodoDatetime__c != null);
					system.assert(a.CrsDcsLastSalesActivities__c != null);
				}
		}

		Task task = [SELECT Id, CrsSale_RepresentativeFlg__c FROM Task WHERE Id = :task1.Id];
		system.assert(task.CrsSale_RepresentativeFlg__c == true);
	}

}