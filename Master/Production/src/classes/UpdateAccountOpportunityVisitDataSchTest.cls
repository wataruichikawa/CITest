@isTest
private class UpdateAccountOpportunityVisitDataSchTest {
    static testMethod void testUpdateAccountOpportunityVisitDataSchTest() {  
        // User u;
        // Account a;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {
            UserRole role = new UserRole(Name = 'XXXX');
            User u = new User(LastName = 'TEST1', UserRoleId = role.Id, Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
            insert u;
            Account a = new Account(REC_COMPANY_ID__c = 1000, Name = 'TEST', Phone = '03-3333-3333', Field221__c = 'インターネットサービス', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
            insert a;

            Test.startTest();

            Opportunity crs = new Opportunity();
            crs.AccountId = a.Id;
            crs.Name = 'TEST';
            crs.StageName = 'TEST';
            crs.OwnerId = u.Id;
            crs.VisitCompletion__c = true;
            crs.VisitDate__c = Date.today();
            crs.VisitChargeUser__c = u.Id;
            crs.CloseDate = Date.today();
            crs.sample_case__c = '*';
            crs.HiringPeriod__c = date.today();
            crs.Opportunity__c = '*';
            System.debug('******************************');
            System.debug(crs);
            insert crs;

            String jobId = System.schedule('test hello world', '0 0 * * * ?', new UpdateAccountOpportunityVisitDataSch());
            System.debug('***** job id : ' + jobId + ' ***** ***** *****');

            Test.stopTest();
        }
    }
}