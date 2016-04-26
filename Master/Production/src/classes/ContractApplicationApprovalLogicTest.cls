@isTest
public without sharing class ContractApplicationApprovalLogicTest {

    private static final String GYOUSUI_ID = '00510000003Je8OAAS';
    private static final String APPROVAL_PROCESS_NAME = 'Approval_Contract_Hassei_Sales';
    private static final String CRS_ROLE_PREFIX = '01_02_';

    @testSetup
    static void setUp() {
        User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', 
                                CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
                                ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert manager;

        User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', 
                             CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', 
                             ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id, SalesApprovalUser__c = manager.Id);
        insert user;

        Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
                                  Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
                                  CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
        insert ac1;

        Account ac2 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', 
                                  Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, 
                                  CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
        insert ac2;

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
        op.ContractCollectionDate__c = Date.today();
        insert op;

        Contract_Application_Information__c info1 = new Contract_Application_Information__c();
        info1.Service_Name__c = 'ビズリーチ';
        info1.Opportunity__c = op.Id;
        info1.Version_No__c = 5;
        insert info1;

				Contract_Application_Product__c product1 = new Contract_Application_Product__c();
				product1.Service__c = 'ビズリーチ';
				product1.DisplayNameForClient__c = 'テスト商品';
				product1.ProposedService__c = 'CRS';
				product1.UnitPrice__c = 50000;
				product1.UpfrontFee__c = 50000;
				product1.Contract_Application_Information__c = info1.Id;
				insert product1;

        Opportunity opEss = op.clone(false,true,false,false);
        opEss.ProposedService__c = 'ESS';
        opEss.AccountId = ac2.Id;
        opEss.ContactName__c = '新規_20150831_ESS';
        opEss.ContractCollectionDate__c = Date.today();
        opEss.VisitChargeUser__c = user.Id;
        opEss.OwnerId = user.Id;
        insert opEss;

        Contract_Application_Information__c info2 = new Contract_Application_Information__c();
        info2.Service_Name__c = 'ビズリーチ';
        info2.Opportunity__c = opEss.Id;
        info2.Version_No__c = 10;
        insert info2;

				Contract_Application_Product__c product2 = new Contract_Application_Product__c();
				product2.Service__c = 'ビズリーチ';
				product2.DisplayNameForClient__c = 'テスト商品';
				product2.ProposedService__c = 'ESS';
				product2.UnitPrice__c = 50000;
				product2.UpfrontFee__c = 50000;
				product2.Contract_Application_Information__c = info2.Id;
				insert product2;

				Attachment att1 = new Attachment();
				att1.Name = 'test';
				att1.body = Blob.valueOf('Test');
				att1.parentId = op.Id;
				insert att1;
				
				Attachment att2 = new Attachment();
				att2.Name = 'test';
				att2.body = Blob.valueOf('Test');
				att2.parentId = op.Id;
				insert att2;

				Attachment att3 = new Attachment();
				att3.Name = 'test';
				att3.body = Blob.valueOf('Test');
				att3.parentId = op.Id;
				insert att3;

				// 本来はこのアップデートを実行しdoApproveのHttpRequestのテストをしたいのだが、このupdateを実行するとエラーが出るためテストできない。　
				/*
				op.Br_Contract_PDF_ID__c = att1.Id;
				op.Br_Rs_Contract_PDF_ID__c = att2.Id;
				op.Attach_PDF_ID__c = att3.Id;
				update op;
				*/
    }

    static testMethod void testSelectApprovalHistoryList(){
        Contract_Application_Information__c info = findInfo();
        Opportunity op = findOpportunity();
        User manager  = findManager();

        PageReference pageRef = Page.contractApplicationApproval;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(info);
        ApexPages.currentPage().getParameters().put('infoId', info.id);
        ContractApplicationApprovalLogic contractApplicationApprovalLogic = new ContractApplicationApprovalLogic(sc);

        test.startTest();

        //ケース1 1件も承認プロセスがない場合
        PageReference p = contractApplicationApprovalLogic.selectApprovalHistoryList();
        system.assertEquals(null,p);
        // system.assertEquals(0, contractApplicationApprovalLogic.dtoList.size());

        //ケース2 承認待ちがありの場合
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(info.Id); //契約内容と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId(APPROVAL_PROCESS_NAME);//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);

        contractApplicationApprovalLogic.selectApprovalHistoryList();
        system.assertEquals(2,contractApplicationApprovalLogic.dtoList.size());

        test.stopTest();
    }

    static testMethod void testShowProcessWorkItem(){
        Opportunity op = findOpportunity();
        User manager  = findManager();
        Contract_Application_Information__c info = findInfo();
        PageReference pageRef = Page.contractApplicationApproval;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('infoId', info.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(info);
        ContractApplicationApprovalLogic contractApplicationApprovalLogic = new ContractApplicationApprovalLogic(sc);

        test.startTest();
        //ケース2 承認待ち状態のものがない場合
        Attachment at = new Attachment(Name = 'テスト添付ファイル.pdf' , ParentId = op.Id, OwnerId = op.OwnerId, Body = Blob.valueOf('テスト文字列'),Description = 'レスト文字列');

        contractApplicationApprovalLogic.showProcessWorkItem();
        system.assertEquals('',contractApplicationApprovalLogic.detailDto.workItemId);

        //ケース3 承認待ち状態がある場合
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(info.Id); //契約内容と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId(APPROVAL_PROCESS_NAME);//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);

        ApexPages.currentPage().getParameters().put('id', op.Id); 
        System.runAs(manager){
            contractApplicationApprovalLogic.showProcessWorkItem();
        }

    }

    static testMethod void testDoApprove(){
        Opportunity op = findOpportunity();
        User manager  = findManager();
        Contract_Application_Information__c info = findInfo();

        PageReference pageRef = Page.contractApplicationApproval;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(info);
        ApexPages.currentPage().getParameters().put('infoId', info.id);
        ContractApplicationApprovalLogic contractApplicationApprovalLogic = new ContractApplicationApprovalLogic(sc);

        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(info.Id); //契約内容と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId(APPROVAL_PROCESS_NAME);//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);
        List<ID> id1List = submitResult.getNewWorkitemIds();
        ID id1 = id1List.get(0);

        test.startTest();
				Test.setMock(HttpCalloutMock.class, new AWSAccessHttpMock());
        system.runAs(manager){
            contractApplicationApprovalLogic.detailDto.workItemId = id1;
            contractApplicationApprovalLogic.detailDto.comments = '承認！';
            contractApplicationApprovalLogic.doApprove();
        }
        test.stopTest();

    }

    static testMethod void testDoReject(){
        Opportunity op = findOpportunity();
        User manager  = findManager();
        Contract_Application_Information__c info = findInfo();
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(info.Id); //契約内容と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId(APPROVAL_PROCESS_NAME);//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);
        List<ID> idList = submitResult.getNewWorkitemIds();
        ID id = idList.get(0);

				PageReference pageRef = Page.contractApplicationApproval;
				Test.setCurrentPage(pageRef);
				ApexPages.StandardController sc = new ApexPages.StandardController(info);
				ContractApplicationApprovalLogic contractApplicationApprovalLogic = new ContractApplicationApprovalLogic(sc);

        test.startTest();
        system.runAs(manager){
            contractApplicationApprovalLogic.detailDto.workItemId = id;
            contractApplicationApprovalLogic.detailDto.comments = '承認！';
            contractApplicationApprovalLogic.doReject();
        }

        test.stopTest();
    }


    static private Opportunity findOpportunity(){
        return [select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c,UseEndDate__c
                ,Type,OwnerId,HirePlanMonths__c,ContractCollectionDate__c,Amount
                 from Opportunity Where ContactName__c ='新規_20150831'];
    }

    static private Contract_Application_Information__c findInfo(){
        return [select i.Id, o.ProposedService__c, o.ContractApplicationNo__c, o.ContractCollectionDate__c, i.Contract_Transfer_Memo__c
                  from Contract_Application_Information__c i, Contract_Application_Information__c.Opportunity__r o
                 where i.Version_No__c = 5];
    }

    static private Contract_Application_Information__c findInfoEss(){
        return [select i.Id, o.ProposedService__c, o.ContractApplicationNo__c, o.ContractCollectionDate__c, i.Contract_Transfer_Memo__c
                  from Contract_Application_Information__c i, Contract_Application_Information__c.Opportunity__r o
                 where i.Version_No__c = 10];
    }

    static private Opportunity findOpportunityESS(){
        return [select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c,UseEndDate__c
                ,Type,OwnerId,HirePlanMonths__c,ContractCollectionDate__c,Amount
                 from Opportunity Where ContactName__c ='新規_20150831_ESS'];
    }

    static private User findManager(){
        return [Select Id From User Where Username = 'test1@sutead.com'];
    }

}