@isTest
public with sharing class OpportunityApprovalIncompleteListTest {
    static testMethod void testSelectIncompleteList(){
        User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert manager;

        User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
        insert user;

        Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
        insert ac1;

        Opportunity op = new Opportunity();
        op.Name = 'TEST-ABCXYZ20150831';
        op.UseStartDate__c = Date.valueOf('2015-08-03');
        op.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
        op.ProposedService__c = 'CRS';
        op.Type = '新規提案（過去未契約）';
        op.HirePlanMonths__c = 6;
        op.OwnerId = user.Id;
        op.ApplicationApprovalStatus__c = '';
        op.AccountId = ac1.Id;
        op.StageName = 'TEST';
        op.VisitChargeUser__c = user.Id;
        op.CloseDate = Date.today();
        op.ContactName__c = '新規_20150831';
        op.sample_case__c = '*';
        op.HiringPeriod__c = Date.today();
        op.Opportunity__c = '*';
        insert op;

        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
        psr.setObjectId(op.Id); //商談と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);

        Opportunity op2 = op.clone(false,true,false,false);
        insert op2;

        Approval.ProcessSubmitRequest psr2 = new Approval.ProcessSubmitRequest();
        psr2.setObjectId(op2.Id); //商談と承認申請を紐付け
        psr2.setComments('comments');//コメントを設定
        psr2.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

        nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr2.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult2 = Approval.process(psr2);

        test.startTest();
        //ログインユーザが商談所有者での場合
        System.runAs(manager) {
            //新規契約の商談の場合
            PageReference pageRef = Page.OpportunityRequestApproval;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(op);
            OpportunityApprovalIncompleteList opportunityApprovalIncompleteList = new OpportunityApprovalIncompleteList(sc);
            opportunityApprovalIncompleteList.selectIncompleteList();

            List<Opportunity> oppList = opportunityApprovalIncompleteList.oppList;
            System.assertEquals(2,oppList.size());
        }
        test.stopTest();
    }

}