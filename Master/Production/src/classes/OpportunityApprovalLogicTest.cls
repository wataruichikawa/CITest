@isTest
public without sharing class OpportunityApprovalLogicTest {

	private static final String GYOUSUI_ID = '00510000003Je8OAAS';

	@testSetup
    static void setUp() {
        User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert manager;

        User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
        insert user;

        Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
        insert ac1;

        Account ac2 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
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
        // op.Br_Contract_PDF_ID__c = '000000000000000000';
        // op.Br_Rs_Contract_PDF_ID__c = '000000000000000000';
        // op.Ct_Contract_PDF_ID__c = '000000000000000000';
        // op.Ct_Rs_Contract_PDF_ID__c = '000000000000000000';
        // op.Nr_Contract_PDF_ID__c = '000000000000000000';
        // op.Attach_PDF_ID__c = '000000000000000000';
        insert op;

        Opportunity opEss = op.clone(false,true,false,false);
        opEss.ProposedService__c = 'ESS';
        opEss.AccountId = ac2.Id;
        opEss.ContactName__c = '新規_20150831_ESS';
        insert opEss;

    }

    static testMethod void testSelectApprovalHistoryList(){
    	Opportunity op = findOpportunity();
    	User manager  = findManager();

        PageReference pageRef = Page.OpportunityApproval;
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(op);
        OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);
		ApexPages.currentPage().getParameters().put('id', op.id);

		test.startTest();

		//ケース1 1件も承認プロセスがない場合
		PageReference p = opportunityApprovalLogic.selectApprovalHistoryList();
		system.assertEquals(null,p);
		system.assertEquals(0, opportunityApprovalLogic.dtoList.size());

		//ケース2 承認待ちがありの場合
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(op.Id); //商談と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);

		opportunityApprovalLogic.selectApprovalHistoryList();
		system.assertEquals(2,opportunityApprovalLogic.dtoList.size());

		test.stopTest();
    }

    static testMethod void testShowProcessWorkItem(){
    	Opportunity op = findOpportunity();
    	User manager  = findManager();
        PageReference pageRef = Page.OpportunityApproval;
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(op);
        OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);

		test.startTest();
		//ケース2 承認待ち状態のものがない場合
		Attachment at = new Attachment(Name = 'テスト添付ファイル.pdf' , ParentId = op.Id, OwnerId = op.OwnerId, Body = Blob.valueOf('テスト文字列'),Description = 'レスト文字列');

		ApexPages.currentPage().getParameters().put('id', op.Id); 
		opportunityApprovalLogic.showProcessWorkItem();
		system.assertEquals('',opportunityApprovalLogic.detailDto.workItemId);

		//ケース3 承認待ち状態がある場合
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(op.Id); //商談と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);

		ApexPages.currentPage().getParameters().put('id', op.Id); 
		System.runAs(manager){
			opportunityApprovalLogic.showProcessWorkItem();
		}

    }

    static testMethod void testDoApprove(){
    	Opportunity op = findOpportunity();
    	User manager  = findManager();
        PageReference pageRef = Page.OpportunityApproval;
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(op);
        OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);

        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(op.Id); //商談と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);
        List<ID> id1List = submitResult.getNewWorkitemIds();
        ID id1 = id1List.get(0);

		test.startTest();
		system.runAs(manager){
			opportunityApprovalLogic.detailDto.workItemId = id1;
			opportunityApprovalLogic.detailDto.comments = '承認！';
			opportunityApprovalLogic.doApprove();
			// 2回目エラーテスト
			opportunityApprovalLogic.detailDto.workItemId = id1;
			opportunityApprovalLogic.detailDto.comments = '承認！';
			opportunityApprovalLogic.doApprove();
			System.assert(opportunityApprovalLogic.isError);
		}
		test.stopTest();

    }

    static testMethod void testDoReject(){
    	Opportunity op = findOpportunity();
    	User manager  = findManager();
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(op.Id); //商談と承認申請を紐付け
        psr.setComments('comments');//コメントを設定
        psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

        List<Id> nextApproverIds = new List<Id>();
        nextApproverIds.add(manager.Id);
        psr.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResult = Approval.process(psr);
        List<ID> idCRSList = submitResult.getNewWorkitemIds();
        ID idCRS = idCRSList.get(0);

    	Opportunity opEss = findOpportunityESS();
        Approval.ProcessSubmitRequest psrESS = new Approval.ProcessSubmitRequest();

        psrESS.setObjectId(opEss.Id); //商談と承認申請を紐付け
        psrESS.setComments('comments');//コメントを設定
        psrESS.setProcessDefinitionNameOrId('ESSApprovalProcessFirstSubmission');//承認プロセスを指定

        List<Id> nextApproverIdESS = new List<Id>();
        nextApproverIdESS.add(manager.Id);
        psrESS.setNextApproverIds(nextApproverIds);
        Approval.ProcessResult submitResultESS = Approval.process(psrESS);
        List<ID> idESSList = submitResultESS.getNewWorkitemIds();
        ID idESS = idESSList.get(0);


		test.startTest();
		system.runAs(manager){
	        PageReference pageRef = Page.OpportunityApproval;
	        Test.setCurrentPage(pageRef);
			ApexPages.StandardController sc = new ApexPages.StandardController(op);
	        OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);

			opportunityApprovalLogic.detailDto.workItemId = idCRS;
			opportunityApprovalLogic.detailDto.comments = '承認！';
			opportunityApprovalLogic.doReject();
			// 2回目エラーテスト
			opportunityApprovalLogic.detailDto.workItemId = idCRS;
			opportunityApprovalLogic.detailDto.comments = '承認！';
			opportunityApprovalLogic.doReject();
			System.assert(opportunityApprovalLogic.isError);

			sc = new ApexPages.StandardController(opEss);
	        opportunityApprovalLogic = new OpportunityApprovalLogic(sc);
			opportunityApprovalLogic.detailDto.workItemId = idESS;
			opportunityApprovalLogic.detailDto.comments = '承認！';
			opportunityApprovalLogic.doReject();
		}

		test.stopTest();
    }
    
    static testMethod void screenFlow() {
				User manager = findManager();
				User gyosui = findGyosui();
				User shinsa = findScreeningUser();

				Opportunity op = findOpportunity();
				Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

				psr.setObjectId(op.Id); //商談と承認申請を紐付け
				psr.setComments('comments');//コメントを設定
				psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

				List<Id> nextApproverIds = new List<Id>();
				nextApproverIds.add(manager.Id);
				psr.setNextApproverIds(nextApproverIds);
				Approval.ProcessResult submitResult = Approval.process(psr);
				List<ID> id1List = submitResult.getNewWorkitemIds();
				ID id1 = id1List.get(0);

				system.runAs(manager){
						op = findOpportunity();
						PageReference pageRef = Page.OpportunityApproval;
						Test.setCurrentPage(pageRef);
						ApexPages.StandardController sc = new ApexPages.StandardController(op);
						OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);
						opportunityApprovalLogic.op = op;

						opportunityApprovalLogic.detailDto.workItemId = id1;
						opportunityApprovalLogic.detailDto.comments = '承認！';
						System.assertNotEquals(null, opportunityApprovalLogic.doApprove());
				}
				
				// 先ほど承認した承認プロセスのworkitemIdを取得。
        List<ProcessInstanceWorkitem> workItemList=
        [SELECT ProcessInstance.ProcessDefinition.Name, Id, OriginalActor.Name,OriginalActor.Id,CreatedDate,ProcessInstanceId
            FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :op.Id and ActorId = :gyosui.Id];

				System.assertEquals(false, workItemList.isEmpty());
				system.runAs(gyosui) {
						op = findOpportunity();
						PageReference pageRef = Page.OpportunityApproval;
						Test.setCurrentPage(pageRef);
						ApexPages.StandardController sc = new ApexPages.StandardController(op);
						OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);
						opportunityApprovalLogic.op = op;

						opportunityApprovalLogic.detailDto.workItemId = workItemList.get(0).Id;
						opportunityApprovalLogic.detailDto.comments = '承認！';
						System.assertNotEquals(null, opportunityApprovalLogic.doApprove());
				}
				
				op = findOpportunity();
				System.assertNotEquals(null, op.ContractCollectionDate__c);
				
				// 先ほど承認した承認プロセスのworkitemIdを取得。
        workItemList=
        [SELECT ProcessInstance.ProcessDefinition.Name, Id, OriginalActor.Name,OriginalActor.Id,CreatedDate,ProcessInstanceId
            FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :op.Id and ActorId = :shinsa.Id];

				System.assertEquals(false, workItemList.isEmpty());
				system.runAs(shinsa) {
						op = findOpportunity();
						PageReference pageRef = Page.OpportunityApproval;
						Test.setCurrentPage(pageRef);
						ApexPages.StandardController sc = new ApexPages.StandardController(op);
						OpportunityApprovalLogic opportunityApprovalLogic = new OpportunityApprovalLogic(sc);
						opportunityApprovalLogic.op = op;

						opportunityApprovalLogic.detailDto.workItemId = workItemList.get(0).Id;
						opportunityApprovalLogic.detailDto.comments = '承認！';
						System.assertNotEquals(null, opportunityApprovalLogic.doApprove());
				}

				op = findOpportunity();
				System.assertNotEquals('承認済み', op.ApplicationApprovalStatus__c);
    }


    static private Opportunity findOpportunity(){
        return [select Id,Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c,UseEndDate__c
                ,Type,OwnerId,HirePlanMonths__c,ContractCollectionDate__c,Amount,CreditComment__c,
                ApplicationApprovalStatus__c
                 from Opportunity Where ContactName__c ='新規_20150831'];
    }

    static private Opportunity findOpportunityESS(){
        return [select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c,UseEndDate__c
                ,Type,OwnerId,HirePlanMonths__c,ContractCollectionDate__c,Amount
                 from Opportunity Where ContactName__c ='新規_20150831_ESS'];
    }
    
    static private User findManager(){
        return [Select Id From User Where Username = 'test1@sutead.com'];
    }
    
    static private User findGyosui() {
    		return [SELECT Id From User Where Name = '業務推進部'];
    }
    
    static private User findScreeningUser() {
    		return [SELECT Id From User Where Name = '審査部 アカウント'];
    }

}