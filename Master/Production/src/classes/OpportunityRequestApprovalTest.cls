@isTest
private class OpportunityRequestApprovalTest {

    static void setUp() {
        User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert manager;

        User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
        insert user;

        Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
        insert ac1;

        Account ac2 = new Account(name = 'Test Inc 6757', Phone = '03-1981-6757', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
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
        op.Introduction__c = 'Introduction__c';
        op.AccountInfo__c = 'AccountInfo__c';
        op.AppPositionRecruitTarget__c = 'AppPositionRecruitTarget__c';
        insert op;

        Opportunity opNewEss = op.clone(false,true,false,false);
        opNewEss.ProposedService__c = 'ESS';
        opNewEss.ContactName__c = '新規_20150831_ESS';
        opNewEss.AccountId = ac2.Id;
        insert opNewEss;

        Opportunity opRepeat = new Opportunity();
        opRepeat.Name = 'TEST-Opps-Repeat';
        opRepeat.UseStartDate__c = Date.valueOf('2015-08-03');
        opRepeat.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
        opRepeat.ProposedService__c = 'CRS';
        opRepeat.Type = '既存提案（リピート・継続）';
        opRepeat.HirePlanMonths__c = 6;
        opRepeat.OwnerId = user.Id;
        opRepeat.ApplicationApprovalStatus__c = '';
        opRepeat.AccountId = ac1.Id;
        opRepeat.StageName = 'TEST';
        opRepeat.VisitChargeUser__c = user.Id;
        opRepeat.CloseDate = Date.today();
        opRepeat.ContactName__c = '継続_20150831';
        opRepeat.sample_case__c = '*';
        opRepeat.HiringPeriod__c = Date.today();
        opRepeat.Opportunity__c = '*';
        opRepeat.Introduction__c = 'Introduction__c';
        opRepeat.AccountInfo__c = 'AccountInfo__c';
        opRepeat.AppPositionRecruitTarget__c = 'AppPositionRecruitTarget__c';
        insert opRepeat;

        Opportunity opRepeatEss = opRepeat.clone(false,true,false,false);
        opRepeatEss.ProposedService__c = 'ESS';
        opRepeatEss.ContactName__c = '継続_20150831_ESS';
        opRepeatEss.AccountId = ac2.Id;
        opRepeatEss.OwnerId = manager.Id;
        insert opRepeatEss;

    }

    static testMethod void testRequestApproval(){
    	setUp();
        Opportunity opNewContract = findNewOpportunity();
        Opportunity opRepeat = findRepeatOpportunity();
        User owner = findOpOwner();

        PageReference pageRef = Page.OpportunityRequestApproval;
        Test.setCurrentPage(pageRef);


        test.startTest();
        //ログインユーザが商談所有者での場合
        System.runAs(owner) {
            //新規契約の商談の場合
            ApexPages.StandardController sc = new ApexPages.StandardController(opNewContract);
            OpportunityRequestApproval opportunityRequestApproval = new OpportunityRequestApproval(sc);

            //既に申請中の申込書ありの場合
            Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

            psr.setObjectId(opNewContract.Id); //商談と承認申請を紐付け
            psr.setComments('comments');//コメントを設定
            psr.setProcessDefinitionNameOrId('CRSApprovalProcessFirstSubmission');//承認プロセスを指定

            List<Id> nextApproverIds = new List<Id>();
            nextApproverIds.add(owner.Id);
            psr.setNextApproverIds(nextApproverIds);

            ApexPages.currentPage().getParameters().put('id', opNewContract.Id);
            PageReference p = opportunityRequestApproval.requestApproval();
            Approval.ProcessResult submitResult = Approval.process(psr);

            system.assertEquals(true, opportunityRequestApproval.canRequest);
            system.assertEquals(true, opportunityRequestApproval.isNewContract);

            //却下された申請がある場合
            List<ID> newIds = submitResult.getNewWorkitemIds();
            ID newId = newIds.get(0);
            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setWorkitemId(newId);
            pwr.setAction('Reject');
            pwr.setComments('却下');
            Approval.process(pwr);

            ApexPages.currentPage().getParameters().put('id', opNewContract.Id);
            p = opportunityRequestApproval.requestApproval();

            system.assertEquals(true, opportunityRequestApproval.canRequest);
            system.assertEquals(true, opportunityRequestApproval.isNewContract);

            //リピート契約の商談の場合
            sc = new ApexPages.StandardController(opRepeat);
            opportunityRequestApproval = new OpportunityRequestApproval(sc);

            ApexPages.currentPage().getParameters().put('id', opRepeat.Id);
            p = opportunityRequestApproval.requestApproval();

            system.assertEquals(true, opportunityRequestApproval.canRequest);
            system.assertEquals(false, opportunityRequestApproval.isNewContract);
        }

        //ログインユーザが商談所有者でない場合
        User nonOwner = findNonOwner();
        System.runAs(nonOwner) {
            ApexPages.StandardController sc = new ApexPages.StandardController(opNewContract);
            OpportunityRequestApproval opportunityRequestApproval = new OpportunityRequestApproval(sc);

            //既に申請中の申込書ありの場合
            ApexPages.currentPage().getParameters().put('id', opNewContract.Id);
            PageReference p = opportunityRequestApproval.requestApproval();
            system.assertEquals(null, p);
            system.assertEquals(false, opportunityRequestApproval.canRequest);
        }
        test.stopTest();

    }

    static testMethod void testDoRequest(){
    	setUp();
        Opportunity op1 = findNewOpportunity();
        Opportunity op2 = findRepeatOpportunity();
        Opportunity op3 = findNewOpportunityESS();
        User member = findOpOwner();
        User manager = findNonOwner();

        test.startTest();
        //メンバーが申請したケース
        System.runAs(member) {
            ApexPages.StandardController sc = new ApexPages.StandardController(op1);
            OpportunityRequestApproval opportunityRequestApproval = new OpportunityRequestApproval(sc);
            opportunityRequestApproval.op.UseStartDate__c = Date.valueOf('2015-08-03');
            opportunityRequestApproval.op.HirePlanMonths__c = 6;
            opportunityRequestApproval.op.Id = op1.Id;
            opportunityRequestApproval.op.Introduction__c = op1.Introduction__c;
            opportunityRequestApproval.op.AccountInfo__c = op1.AccountInfo__c;
            opportunityRequestApproval.op.AppPositionRecruitTarget__c = op1.AppPositionRecruitTarget__c;

            //CRSで再申請プロセスに回るケース
            opportunityRequestApproval.applicationForm.Name = 'テスト申込書';
            opportunityRequestApproval.applicationFormBlob = Blob.valueOf('テスト申込書の内容');

            opportunityRequestApproval.evidence.Name = 'テストエビデンス';
            opportunityRequestApproval.evidenceBlob = Blob.valueOf('テストエビデンスの内容');

            opportunityRequestApproval.certification.Name = 'テスト人材紹介免許';
            opportunityRequestApproval.certificationBlob = Blob.valueOf('テスト人材紹介免許の内容');

            opportunityRequestApproval.agreement.Name = 'テスト規約への同意書';
            opportunityRequestApproval.agreementBlob = Blob.valueOf('テスト規約への同意書の内容');

            ApexPages.currentPage().getParameters().put('id', op1.Id);
            opportunityRequestApproval.op.ApplicationApprovalStatus__c = '却下';
            opportunityRequestApproval.op.ProposedService__c = 'CRS';
            opportunityRequestApproval.doRequest();

            //CRSで初回申請プロセスに回るケース
            sc = new ApexPages.StandardController(op2);
            opportunityRequestApproval = new OpportunityRequestApproval(sc);
            ApexPages.currentPage().getParameters().put('id', op2.Id);

            opportunityRequestApproval.applicationForm.Name = 'テスト申込書';
            opportunityRequestApproval.applicationFormBlob = Blob.valueOf('テスト申込書の内容');

            opportunityRequestApproval.op.UseStartDate__c = Date.valueOf('2015-08-03');
            opportunityRequestApproval.op.HirePlanMonths__c = 6;
            opportunityRequestApproval.op.ApplicationApprovalStatus__c = '';
            opportunityRequestApproval.op.ProposedService__c = 'CRS';
            opportunityRequestApproval.op.Id = op2.Id;
            opportunityRequestApproval.op.Introduction__c = op2.Introduction__c;
            opportunityRequestApproval.op.AccountInfo__c = op2.AccountInfo__c;
            opportunityRequestApproval.op.AppPositionRecruitTarget__c = op2.AppPositionRecruitTarget__c;
            opportunityRequestApproval.doRequest();

            //ESSで再申請プロセスに回るケース
            sc = new ApexPages.StandardController(op3);
            opportunityRequestApproval = new OpportunityRequestApproval(sc);
            ApexPages.currentPage().getParameters().put('id', op3.Id);

            opportunityRequestApproval.applicationForm.Name = 'テスト申込書';
            opportunityRequestApproval.applicationFormBlob = Blob.valueOf('テスト申込書の内容');

            opportunityRequestApproval.op.UseStartDate__c = Date.valueOf('2015-08-03');
            opportunityRequestApproval.op.HirePlanMonths__c = 6;
            opportunityRequestApproval.op.ApplicationApprovalStatus__c = '却下';
            opportunityRequestApproval.op.ProposedService__c = 'ESS';
            opportunityRequestApproval.op.Id = op3.Id;
            opportunityRequestApproval.doRequest();
        }

        test.stopTest();
    }

	static testMethod void testDoRequestCreditManagerCRS() {
		setUp();
		Opportunity op = findNewOpportunity();
		op.CreditManagerApproval__c = true;
		update op;
		OpportunityRequestApproval opportunityRequestApproval =
			new OpportunityRequestApproval(new ApexPages.StandardController(op));
		opportunityRequestApproval.op = op;
		opportunityRequestApproval.applicationForm.Name = 'テスト申込書';
		opportunityRequestApproval.applicationFormBlob = Blob.valueOf('テスト申込書の内容');
		ApexPages.currentPage().getParameters().put('id', op.Id);
		User member = findOpOwner();
		System.runAs(member) {
			Test.startTest();
			opportunityRequestApproval.doRequest();
			Test.stopTest();
		}

		Id pdId = [SELECT Id FROM ProcessDefinition WHERE TableEnumOrId = 'Opportunity'
			AND DeveloperName = 'CRSApprovalProcessResubmit' LIMIT 1].Id;
		List<ProcessInstance> piList = [SELECT Id, Status FROM ProcessInstance WHERE
			ProcessDefinitionId = :pdId AND TargetObjectId = :op.Id];
		System.assert(piList.size() == 1);
	}

	static testMethod void testDoRequestCreditManagerESS() {
		setUp();
		Opportunity op = findNewOpportunityESS();
		op.CreditManagerApproval__c = true;
		update op;
		OpportunityRequestApproval opportunityRequestApproval =
			new OpportunityRequestApproval(new ApexPages.StandardController(op));
		opportunityRequestApproval.op = op;
		opportunityRequestApproval.applicationForm.Name = 'テスト申込書';
		opportunityRequestApproval.applicationFormBlob = Blob.valueOf('テスト申込書の内容');
		ApexPages.currentPage().getParameters().put('id', op.Id);
		User member = findOpOwner();
		System.runAs(member) {
			Test.startTest();
			opportunityRequestApproval.doRequest();
			Test.stopTest();
		}

		Id pdId = [SELECT Id FROM ProcessDefinition WHERE TableEnumOrId = 'Opportunity'
			AND DeveloperName = 'ESSApprovalProcessResubmit' LIMIT 1].Id;
		List<ProcessInstance> piList = [SELECT Id, Status FROM ProcessInstance WHERE
			ProcessDefinitionId = :pdId AND TargetObjectId = :op.Id];
		System.assert(piList.size() == 1);
	}

	@IsTest(SeeAllData=true)
	static void testDoRequestIrregularPlan() {
		setUp();
		Opportunity op = findNewOpportunity();
		PriceBook2 pb2s = [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
		PriceBook2 pb2c = new PriceBook2(Name = 'Custom Price Book', IsActive = true);
		insert pb2c;
		Product2 pd2 = new Product2(Name = 'イレギュラー', ProductCode = 'irr', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = ' 固定', Service__c = 'ビズリーチ', ProposedService__c = 'CRS', Remarks__c = 'irr備考', IrregularPlan__c = true);
		insert pd2;
		PriceBookEntry pbe1 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe2 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2.Id, UseStandardPrice = false, UnitPrice = 850000);
		insert new PriceBookEntry[] { pbe1, pbe2 };
		insert new OpportunityLineItem(OpportunityId = op.Id, PricebookEntryId = pbe2.Id, Quantity = 1, UnitPrice = 850000);
		op = findNewOpportunity();

		OpportunityRequestApproval opportunityRequestApproval =
			new OpportunityRequestApproval(new ApexPages.StandardController(op));
		opportunityRequestApproval.op = op;
		opportunityRequestApproval.applicationForm.Name = 'テスト申込書';
		opportunityRequestApproval.applicationFormBlob = Blob.valueOf('テスト申込書の内容');
		ApexPages.currentPage().getParameters().put('id', op.Id);
		User member = findOpOwner();
		System.runAs(member) {
			Test.startTest();
			opportunityRequestApproval.doRequest();
			Test.stopTest();
		}

		Id pdId = [SELECT Id FROM ProcessDefinition WHERE TableEnumOrId = 'Opportunity'
			AND DeveloperName = 'CRSApprovalProcessResubmit' LIMIT 1].Id;
		List<ProcessInstance> piList = [SELECT Id, Status FROM ProcessInstance WHERE
			ProcessDefinitionId = :pdId AND TargetObjectId = :op.Id];
		System.assertEquals(1, piList.size());
	}

    static testMethod void testDoRequestValidateNew() {
    	setUp();
        //CRSの承認前チェックケース
        Opportunity op = findNewOpportunity();
        User member = findOpOwner();
        System.runAs(member) {
            ApexPages.StandardController sc = new ApexPages.StandardController(op);
            OpportunityRequestApproval opportunityRequestApproval = new OpportunityRequestApproval(sc);
            opportunityRequestApproval.op.UseStartDate__c = Date.valueOf('2015-08-03');
            opportunityRequestApproval.op.HirePlanMonths__c = 6;
            opportunityRequestApproval.op.Id = op.Id;
            opportunityRequestApproval.op.ProposedService__c = 'CRS';

            Test.startTest();
            opportunityRequestApproval.doRequest();
            Test.stopTest();
        }
        String msg = 'を入力してください。';
        system.assert(ApexPages.hasMessages());
        system.assertEquals(Schema.SObjectType.Opportunity.fields.Introduction__c.Label + msg, ApexPages.getMessages()[0].getDetail());
        system.assertEquals(Schema.SObjectType.Opportunity.fields.AccountInfo__c.Label + msg, ApexPages.getMessages()[1].getDetail());
        system.assertEquals(Schema.SObjectType.Opportunity.fields.AppPositionRecruitTarget__c.Label + msg, ApexPages.getMessages()[2].getDetail());
    }

    static testMethod void testDoRequestValidateRepeat() {
    	setUp();
        //CRSの承認前チェックケース
        Opportunity op = findRepeatOpportunity();
        User member = findOpOwner();
        System.runAs(member) {
            ApexPages.StandardController sc = new ApexPages.StandardController(op);
            OpportunityRequestApproval opportunityRequestApproval = new OpportunityRequestApproval(sc);
            opportunityRequestApproval.op.UseStartDate__c = Date.valueOf('2015-08-03');
            opportunityRequestApproval.op.HirePlanMonths__c = 6;
            opportunityRequestApproval.op.Id = op.Id;
            opportunityRequestApproval.op.ProposedService__c = 'CRS';
            opportunityRequestApproval.isNewContract = false;
            opportunityRequestApproval.op.DounyuMtgDate__c = null;
            opportunityRequestApproval.op.IntroductionMTGDateIsBlank__c = false;

            Test.startTest();
            opportunityRequestApproval.doRequest();
        	system.assert(ApexPages.hasMessages());
        	system.assertEquals('導入MTG日時、' + Schema.SObjectType.Opportunity.fields.IntroductionMTGDateIsBlank__c.Label
        		+ 'のどちらかを入力してください。', ApexPages.getMessages()[0].getDetail());

            opportunityRequestApproval.op.DounyuMtgDate__c = system.now();
            opportunityRequestApproval.op.IntroductionMTGDateIsBlank__c = true;
        	system.assert(ApexPages.hasMessages());
        	system.assertEquals('導入MTG日時、' + Schema.SObjectType.Opportunity.fields.IntroductionMTGDateIsBlank__c.Label
        		+ 'のどちらかを入力してください。', ApexPages.getMessages()[0].getDetail());
            Test.stopTest();
        }

    }

	static testMethod void testCalcUseEndDate() {
		setUp();
		Opportunity opp = findNewOpportunity();
		OpportunityRequestApproval ora =
			new OpportunityRequestApproval(new ApexPages.StandardController(findNewOpportunity()));

		Date resultDate;
		Test.startTest();
		//月初
		ora.op.UseStartDate__c = Date.newInstance(2016, 1, 1);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 1, 31));
		//月中
		ora.op.UseStartDate__c = Date.newInstance(2016, 1, 15);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 2, 14));
		//月末(閏日)1
		ora.op.UseStartDate__c = Date.newInstance(2016, 1, 31);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 2, 29));
		//月末(閏日)2
		ora.op.UseStartDate__c = Date.newInstance(2016, 1, 30);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 2, 29));
		//月末(閏日)3
		ora.op.UseStartDate__c = Date.newInstance(2016, 1, 29);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 2, 28));
		//月末1
		ora.op.UseStartDate__c = Date.newInstance(2015, 1, 31);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2015, 2, 28));
		//月末2
		ora.op.UseStartDate__c = Date.newInstance(2015, 1, 29);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2015, 2, 28));
		//月末3
		ora.op.UseStartDate__c = Date.newInstance(2015, 1, 28);
		ora.op.HirePlanMonths__c = 1;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2015, 2, 27));
		//月末30 - 30
		ora.op.UseStartDate__c = Date.newInstance(2016, 4, 30);
		ora.op.HirePlanMonths__c = 5;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 9, 29));
		//月末30 - 31
		ora.op.UseStartDate__c = Date.newInstance(2016, 4, 30);
		ora.op.HirePlanMonths__c = 3;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 7, 29));
		//月末31 - 30
		ora.op.UseStartDate__c = Date.newInstance(2016, 5, 31);
		ora.op.HirePlanMonths__c = 6;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 11, 30));
		//月末31 - 31
		ora.op.UseStartDate__c = Date.newInstance(2016, 5, 31);
		ora.op.HirePlanMonths__c = 3;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 8, 30));
		//小数点 +14日1
		ora.op.UseStartDate__c = Date.newInstance(2016, 5, 31);
		ora.op.HirePlanMonths__c = 3.47;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 9, 13));
		//小数点 +14日2
		ora.op.UseStartDate__c = Date.newInstance(2016, 5, 1);
		ora.op.HirePlanMonths__c = 1.47;
		resultDate = ora.calcUseEndDate();
		System.assertEquals(resultDate, Date.newInstance(2016, 6, 14));
		Test.stopTest();
	}

	static testMethod void testGetMaxFileSize() {
		setUp();
		OpportunityRequestApproval opportunityRequestApproval =
			new OpportunityRequestApproval(new ApexPages.StandardController(findNewOpportunity()));
		System.assertEquals(1024 * 1024 * 10, opportunityRequestApproval.getMaxFileSize());
	}

    static private Opportunity findNewOpportunity(){
        return [Select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c
                ,Type,OwnerId,HirePlanMonths__c,ApplicationApprovalStatus__c
                ,Introduction__c, AccountInfo__c, AppPositionRecruitTarget__c
                ,CreditManagerApproval__c, UseEndDate__c
                ,(SELECT Id, Product2Name__c, IrregularPlan__c FROM OpportunityLineItems ORDER BY SortOrder)
                From Opportunity Where ContactName__c ='新規_20150831'];
    }

    static private Opportunity findRepeatOpportunity(){
        return [Select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c
                ,Type,OwnerId,HirePlanMonths__c,ApplicationApprovalStatus__c
                ,Introduction__c, AccountInfo__c, AppPositionRecruitTarget__c
                From Opportunity Where ContactName__c ='継続_20150831'];
    }

    static private Opportunity findNewOpportunityESS(){
        return [Select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c
                ,Type,OwnerId,HirePlanMonths__c,ApplicationApprovalStatus__c
                 From Opportunity Where ContactName__c ='新規_20150831_ESS'];
    }

    static private Opportunity findRepeatOpportunityESS(){
        return [Select Name,UseStartDate__c,DounyuMtgDate__c,ProposedService__c
                ,Type,OwnerId,HirePlanMonths__c,ApplicationApprovalStatus__c
                 From Opportunity Where ContactName__c ='継続_20150831_ESS'];
    }

    static private User findOpOwner(){
        return [Select Id,ManagerId From User Where Username = 'test2@sutead.com'];
    }

    static private User findNonOwner(){
        return [Select Id,ManagerId From User Where Username = 'test1@sutead.com'];
    }

}