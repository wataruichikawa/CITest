// 標準価格表が作成できないのでseeAllData=true
@isTest(SeeAllData=true)
private class PrintApplicationPDFTest{

    //@testSetup
    static void setUp() {
        Account ac = new Account();
        ac.Name = 'TEST-XXX';
        ac.CrsSecondInterviewCountLastM__c = 1;
        ac.CrsSecondInterviewCountThisM__c = 1;
        ac.CrsLastInterviewCountLastM__c = 1;
        ac.CrsLastInterviewCountThisM__c = 1;
        ac.Field156__c = date.today();
        ac.Field1__c = '承認';
        ac.CrsJoinedCountThisContract__c = 1;
        ac.CrsOfferCountThisContract__c = 1;
        ac.CrsFirstInterviewCountLastM__c = 0;
        ac.CrsFirstInterviewCountThisM__c = 5;
        ac.CrsDocumentScreeningOkCLastM__c = 0;
        ac.CrsDocumentScreeningOkCThisM__c = 8;
        ac.CrsPlatinumScoutSendCLastM__c = 0;
        ac.CrsPlatinumScoutSendCThisM__c = 1;
        ac.Field208__c = 1;
        ac.CrsLatestOpportunityStage__c = 'STEP10：契約';
        ac.Phone = '03-3333-3333';
        ac.BillingState = '横浜市磯子区森1-1-1';
        ac.BillingCity = 'City';
        ac.BillingStreet = 'Street';
        ac.BillingPostalCode = '235-0001';
        ac.Field157__c = 'ティディビィトリヒキサキカナ';
        insert ac;

        Contact ct1 = new Contact(AccountId = ac.id, lastname = 'TEST1', firstname = 'TARO1', email = 'test@test-sutead.com');
        insert ct1;

		PriceBook2 pb2s = [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
		PriceBook2 pb2c = new PriceBook2(Name = 'Custom Price Book', IsActive = true);
		insert pb2c;

		Product2 pd2Biz = new Product2(Name = 'ビズ商品', ProductCode = 'biz', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = '継続インセンティブ 固定', Service__c = 'ビズリーチ', ProposedService__c = 'CRS', Remarks__c = 'biz備考');
		Product2 pd2Ctr = new Product2(Name = 'キャリトレ商品', ProductCode = 'ctr', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = '成功報酬', Service__c = 'キャリアトレック', ProposedService__c = 'CRS', Remarks__c = 'ctr備考');
		Product2 pd2Bos = new Product2(Name = 'BOS商品', ProductCode = 'bos', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = '固定', Service__c = 'ビズリーチRS', ProposedService__c = 'CRS', Remarks__c = 'bos備考');
		Product2 pd2CtrOp = new Product2(Name = 'キャリトレオプション', ProductCode = 'ctrop', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = 'オプション', Service__c = 'キャリアトレック', ProposedService__c = 'CRS', Remarks__c = 'ctrop備考');
		insert new Product2[] { pd2Biz, pd2Ctr, pd2Bos, pd2CtrOp };

		PriceBookEntry pbe1 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2Biz.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe2 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2Ctr.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe3 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2Bos.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe4 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2CtrOp.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe5 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2Biz.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe6 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2Ctr.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe7 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2Bos.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe8 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2CtrOp.Id, UseStandardPrice = false, UnitPrice = 850000);
		insert new PriceBookEntry[] { pbe1, pbe2, pbe3, pbe4, pbe5, pbe6, pbe7, pbe8 };

        User user1 = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert user1;
    }

	static testmethod void testdoPrintQuotation(){
		setUp();
        Account ac = findAccount();
        User user1 = findUser();
        PriceBookEntry pbe = findPriceBookEntry('biｚ');

    	Opportunity opt = new Opportunity();
    	opt.AccountId = ac.Id;
    	opt.Name = 'TEST';
    	opt.StageName = 'TEST';
    	opt.OwnerId = user1.Id;
    	opt.VisitChargeUser__c = user1.Id;
    	opt.CloseDate = Date.today();
    	opt.VisitDate__c =  Date.today();
    	opt.VisitCompletion__c = true;
    	opt.sample_case__c = '*';
    	opt.HiringPeriod__c = date.today();
    	opt.Opportunity__c = '*';
		opt.ProposedService__c = 'CRS';
    	insert opt;


		PageReference pageRef = Page.PrintApplicationPDF;
		Test.setCurrentPage(pageRef);
    	ApexPages.StandardController sc = new ApexPages.StandardController(opt);
		PrintApplicationPDF printApplicationPDF = new PrintApplicationPDF(sc);
		ApexPages.currentPage().getParameters().put('id', opt.id);

        Opportunity opp = [Select Id, QuotationExpireDate__c From Opportunity Where Id = :opt.Id];

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opt.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 850000);
        insert oli;

		test.startTest();

        PageReference p = printApplicationPDF.initPrintApplicationInput();
        system.assertEquals(null, p);
        system.assertEquals(ac.Name, printApplicationPDF.dto.companyName);
        system.assertEquals(ac.Field157__c, printApplicationPDF.dto.companyNameKana);
        system.assertEquals(ac.BillingPostalCode, printApplicationPDF.dto.companyPostCode);
        system.assertEquals(ac.BillingState + ac.BillingCity + ac.BillingStreet, printApplicationPDF.dto.companyAddress);
        system.assertEquals(ac.Phone, printApplicationPDF.dto.companyPhone);
        system.assertEquals(system.today(), printApplicationPDF.dto.opp2.CloseDate);
        system.assertEquals(false, printApplicationPDF.dto.usageEnd);

        printApplicationPDF = new PrintApplicationPDF(sc);
        p = printApplicationPDF.initPrintQuotationInput();
        system.assertEquals(null, p);
        system.assertEquals(opp.QuotationExpireDate__c, printApplicationPDF.dto.opp.CloseDate);

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.doPrintQuotation();
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_quotationExpireDate'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.dto.opp.CloseDate = Date.valueOf('2000-01-31');
        printApplicationPDF.doPrintQuotation();
        system.assertEquals('2000-01-31', printApplicationPDF.rc.getParms().get('p_quotationExpireDate'));

		test.stopTest();

	}

    static testmethod void testdoPrintApplicationBizReach(){
		setUp();
        Account ac = findAccount();
        User user1 = findUser();
        PriceBookEntry pbe = findPriceBookEntry('biz');

        Opportunity opt = new Opportunity();
        opt.AccountId = ac.Id;
        opt.Name = 'TEST';
        opt.StageName = 'TEST';
        opt.OwnerId = user1.Id;
        opt.VisitChargeUser__c = user1.Id;
        opt.CloseDate = Date.today();
        opt.VisitDate__c =  Date.today();
        opt.VisitCompletion__c = true;
        opt.sample_case__c = '*';
        opt.HiringPeriod__c = date.today();
        opt.Opportunity__c = '*';
        opt.ProposedService__c = 'CRS';
        insert opt;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opt.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 850000);
        insert oli;

        PageReference pageRef = Page.PrintApplicationPDF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opt);
        PrintApplicationPDF printApplicationPDF = new PrintApplicationPDF(sc);
        ApexPages.currentPage().getParameters().put('id', opt.id);
        ApexPages.currentPage().getParameters().put('svc', 'ビズリーチ');

        Opportunity opp = [Select Id, QuotationExpireDate__c From Opportunity Where Id = :opt.Id];

        test.startTest();

        PageReference p = printApplicationPDF.initPrintApplicationInput();
        system.assertEquals(null, p);
        system.assertEquals(ac.Name, printApplicationPDF.dto.companyName);
        system.assertEquals(ac.Field157__c, printApplicationPDF.dto.companyNameKana);
        system.assertEquals(ac.BillingPostalCode, printApplicationPDF.dto.companyPostCode);
        system.assertEquals(ac.BillingState + ac.BillingCity + ac.BillingStreet, printApplicationPDF.dto.companyAddress);
        system.assertEquals(ac.Phone, printApplicationPDF.dto.companyPhone);
        system.assertEquals(system.today(), printApplicationPDF.dto.opp2.CloseDate);
        system.assertEquals(false, printApplicationPDF.dto.usageEnd);

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.serviceName = 'ビズリーチ';
        printApplicationPDF.doPrintApplication();
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyName'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyNameKana'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyPostCode'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyAddress'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyPhone'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_department'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_name'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_nameKana'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_email'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingPostCode'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingAddress'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingPhone'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingDepartment'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingName'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingNameKana'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_continuation'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_fixedFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_successFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_optionFlg'));
        system.assertEquals('biz備考', printApplicationPDF.rc.getParms().get('p_remarks'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.serviceName = 'ビズリーチ';
        printApplicationPDF.dto.opp.CloseDate = Date.valueOf('2000-01-31');
        printApplicationPDF.dto.opp2.CloseDate = Date.valueOf('2001-12-01');
        printApplicationPDF.dto.opp3.CloseDate = Date.valueOf('2002-06-15');
        printApplicationPDF.dto.companyName = '会社名';
        printApplicationPDF.dto.companyNameKana = 'カイシャメイカナ';
        printApplicationPDF.dto.companyPostCode = '100-0001';
        printApplicationPDF.dto.companyAddress = '会社住所';
        printApplicationPDF.dto.companyPhone = '03-0000-0001';
        printApplicationPDF.dto.department = '部署・役職';
        printApplicationPDF.dto.name = '担当者名';
        printApplicationPDF.dto.nameKana = 'タントウシャメイカナ';
        printApplicationPDF.dto.email = 'test@mail.com';
        printApplicationPDF.dto.billingPostCode = '100-0002';
        printApplicationPDF.dto.billingAddress = '請求先住所';
        printApplicationPDF.dto.billingPhone = '03-0000-0002';
        printApplicationPDF.dto.billingDepartment = '請求先部署・役職';
        printApplicationPDF.dto.billingName = '請求先担当者名';
        printApplicationPDF.dto.billingNameKana = 'セイキュウサキタントウシャメイカナ';
        printApplicationPDF.dto.usageEnd = true;
        printApplicationPDF.doPrintApplication();
        system.assertEquals('2001', printApplicationPDF.rc.getParms().get('p_proposalDateYYYY'));
        system.assertEquals('12', printApplicationPDF.rc.getParms().get('p_proposalDateMM'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_proposalDateDD'));
        system.assertEquals('2000', printApplicationPDF.rc.getParms().get('p_usageStartDateYYYY'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_usageStartDateMM'));
        system.assertEquals('31', printApplicationPDF.rc.getParms().get('p_usageStartDateDD'));
        system.assertEquals('2002', printApplicationPDF.rc.getParms().get('p_usageEndDateYYYY'));
        system.assertEquals('6', printApplicationPDF.rc.getParms().get('p_usageEndDateMM'));
        system.assertEquals('15', printApplicationPDF.rc.getParms().get('p_usageEndDateDD'));
        system.assertEquals('会社名', printApplicationPDF.rc.getParms().get('p_companyName'));
        system.assertEquals('カイシャメイカナ', printApplicationPDF.rc.getParms().get('p_companyNameKana'));
        system.assertEquals('100-0001', printApplicationPDF.rc.getParms().get('p_companyPostCode'));
        system.assertEquals('会社住所', printApplicationPDF.rc.getParms().get('p_companyAddress'));
        system.assertEquals('03-0000-0001', printApplicationPDF.rc.getParms().get('p_companyPhone'));
        system.assertEquals('部署・役職', printApplicationPDF.rc.getParms().get('p_department'));
        system.assertEquals('担当者名', printApplicationPDF.rc.getParms().get('p_name'));
        system.assertEquals('タントウシャメイカナ', printApplicationPDF.rc.getParms().get('p_nameKana'));
        system.assertEquals('test@mail.com', printApplicationPDF.rc.getParms().get('p_email'));
        system.assertEquals('100-0002', printApplicationPDF.rc.getParms().get('p_billingPostCode'));
        system.assertEquals('請求先住所', printApplicationPDF.rc.getParms().get('p_billingAddress'));
        system.assertEquals('03-0000-0002', printApplicationPDF.rc.getParms().get('p_billingPhone'));
        system.assertEquals('請求先部署・役職', printApplicationPDF.rc.getParms().get('p_billingDepartment'));
        system.assertEquals('請求先担当者名', printApplicationPDF.rc.getParms().get('p_billingName'));
        system.assertEquals('セイキュウサキタントウシャメイカナ', printApplicationPDF.rc.getParms().get('p_billingNameKana'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_continuation'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_fixedFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_successFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_optionFlg'));
        system.assertEquals('biz備考', printApplicationPDF.rc.getParms().get('p_remarks'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.doPrintReportBeforeVisit();

        test.stopTest();

    }


    static testmethod void testdoPrintApplicationCareertrek(){
		setUp();
        Account ac = findAccount();
        User user1 = findUser();
        PriceBookEntry pbe1 = findPriceBookEntry('ctr');
        PriceBookEntry pbe2 = findPriceBookEntry('ctrop');

        Opportunity opt = new Opportunity();
        opt.AccountId = ac.Id;
        opt.Name = 'TEST';
        opt.StageName = 'TEST';
        opt.OwnerId = user1.Id;
        opt.VisitChargeUser__c = user1.Id;
        opt.CloseDate = Date.today();
        opt.VisitDate__c =  Date.today();
        opt.VisitCompletion__c = true;
        opt.sample_case__c = '*';
        opt.HiringPeriod__c = date.today();
        opt.Opportunity__c = '*';
        opt.ProposedService__c = 'CRS';
        insert opt;

        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opt.Id, PricebookEntryId = pbe1.Id, Quantity = 1, UnitPrice = 850000);
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opt.Id, PricebookEntryId = pbe2.Id, Quantity = 1, UnitPrice = 850000);
        insert new OpportunityLineItem[] { oli1, oli2 };

        PageReference pageRef = Page.PrintApplicationPDF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opt);
        PrintApplicationPDF printApplicationPDF = new PrintApplicationPDF(sc);
        ApexPages.currentPage().getParameters().put('id', opt.id);
        ApexPages.currentPage().getParameters().put('svc', 'キャリアトレック');

        Opportunity opp = [Select Id, QuotationExpireDate__c From Opportunity Where Id = :opt.Id];

        test.startTest();

        PageReference p = printApplicationPDF.initPrintApplicationInput();
        system.assertEquals(null, p);
        system.assertEquals(ac.Name, printApplicationPDF.dto.companyName);
        system.assertEquals(ac.Field157__c, printApplicationPDF.dto.companyNameKana);
        system.assertEquals(ac.BillingPostalCode, printApplicationPDF.dto.companyPostCode);
        system.assertEquals(ac.BillingState + ac.BillingCity + ac.BillingStreet, printApplicationPDF.dto.companyAddress);
        system.assertEquals(ac.Phone, printApplicationPDF.dto.companyPhone);
        system.assertEquals(system.today(), printApplicationPDF.dto.opp2.CloseDate);
        system.assertEquals(false, printApplicationPDF.dto.usageEnd);

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.serviceName = 'キャリアトレック';
        printApplicationPDF.doPrintApplication();
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyName'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyNameKana'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyPostCode'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyAddress'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyPhone'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_department'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_name'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_nameKana'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_email'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingPostCode'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingAddress'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingPhone'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingDepartment'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingName'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingNameKana'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_continuation'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_fixedFlg'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_successFlg'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_optionFlg'));
        system.assertEquals('ctr備考', printApplicationPDF.rc.getParms().get('p_remarks'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.serviceName = 'キャリアトレック';
        printApplicationPDF.dto.opp.CloseDate = Date.valueOf('2000-01-31');
        printApplicationPDF.dto.opp2.CloseDate = Date.valueOf('2001-12-01');
        printApplicationPDF.dto.opp3.CloseDate = Date.valueOf('2002-06-15');
        printApplicationPDF.dto.companyName = '会社名';
        printApplicationPDF.dto.companyNameKana = 'カイシャメイカナ';
        printApplicationPDF.dto.companyPostCode = '100-0001';
        printApplicationPDF.dto.companyAddress = '会社住所';
        printApplicationPDF.dto.companyPhone = '03-0000-0001';
        printApplicationPDF.dto.department = '部署・役職';
        printApplicationPDF.dto.name = '担当者名';
        printApplicationPDF.dto.nameKana = 'タントウシャメイカナ';
        printApplicationPDF.dto.email = 'test@mail.com';
        printApplicationPDF.dto.billingPostCode = '100-0002';
        printApplicationPDF.dto.billingAddress = '請求先住所';
        printApplicationPDF.dto.billingPhone = '03-0000-0002';
        printApplicationPDF.dto.billingDepartment = '請求先部署・役職';
        printApplicationPDF.dto.billingName = '請求先担当者名';
        printApplicationPDF.dto.billingNameKana = 'セイキュウサキタントウシャメイカナ';
        printApplicationPDF.dto.usageEnd = true;
        printApplicationPDF.doPrintApplication();
        system.assertEquals('2001', printApplicationPDF.rc.getParms().get('p_proposalDateYYYY'));
        system.assertEquals('12', printApplicationPDF.rc.getParms().get('p_proposalDateMM'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_proposalDateDD'));
        system.assertEquals('2000', printApplicationPDF.rc.getParms().get('p_usageStartDateYYYY'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_usageStartDateMM'));
        system.assertEquals('31', printApplicationPDF.rc.getParms().get('p_usageStartDateDD'));
        system.assertEquals('2002', printApplicationPDF.rc.getParms().get('p_usageEndDateYYYY'));
        system.assertEquals('6', printApplicationPDF.rc.getParms().get('p_usageEndDateMM'));
        system.assertEquals('15', printApplicationPDF.rc.getParms().get('p_usageEndDateDD'));
        system.assertEquals('会社名', printApplicationPDF.rc.getParms().get('p_companyName'));
        system.assertEquals('カイシャメイカナ', printApplicationPDF.rc.getParms().get('p_companyNameKana'));
        system.assertEquals('100-0001', printApplicationPDF.rc.getParms().get('p_companyPostCode'));
        system.assertEquals('会社住所', printApplicationPDF.rc.getParms().get('p_companyAddress'));
        system.assertEquals('03-0000-0001', printApplicationPDF.rc.getParms().get('p_companyPhone'));
        system.assertEquals('部署・役職', printApplicationPDF.rc.getParms().get('p_department'));
        system.assertEquals('担当者名', printApplicationPDF.rc.getParms().get('p_name'));
        system.assertEquals('タントウシャメイカナ', printApplicationPDF.rc.getParms().get('p_nameKana'));
        system.assertEquals('test@mail.com', printApplicationPDF.rc.getParms().get('p_email'));
        system.assertEquals('100-0002', printApplicationPDF.rc.getParms().get('p_billingPostCode'));
        system.assertEquals('請求先住所', printApplicationPDF.rc.getParms().get('p_billingAddress'));
        system.assertEquals('03-0000-0002', printApplicationPDF.rc.getParms().get('p_billingPhone'));
        system.assertEquals('請求先部署・役職', printApplicationPDF.rc.getParms().get('p_billingDepartment'));
        system.assertEquals('請求先担当者名', printApplicationPDF.rc.getParms().get('p_billingName'));
        system.assertEquals('セイキュウサキタントウシャメイカナ', printApplicationPDF.rc.getParms().get('p_billingNameKana'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_continuation'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_fixedFlg'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_successFlg'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_optionFlg'));
        system.assertEquals('ctr備考', printApplicationPDF.rc.getParms().get('p_remarks'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.doPrintReportBeforeVisit();

        test.stopTest();

    }

    static testmethod void testdoPrintApplicationBOS(){
		setUp();
        Account ac = findAccount();
        User user1 = findUser();
        PriceBookEntry pbe = findPriceBookEntry('bos');

        Opportunity opt = new Opportunity();
        opt.AccountId = ac.Id;
        opt.Name = 'TEST';
        opt.StageName = 'TEST';
        opt.OwnerId = user1.Id;
        opt.VisitChargeUser__c = user1.Id;
        opt.CloseDate = Date.today();
        opt.VisitDate__c =  Date.today();
        opt.VisitCompletion__c = true;
        opt.sample_case__c = '*';
        opt.HiringPeriod__c = date.today();
        opt.Opportunity__c = '*';
        opt.ProposedService__c = 'CRS';
        insert opt;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opt.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 850000);
        insert oli;

        PageReference pageRef = Page.PrintApplicationPDF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opt);
        PrintApplicationPDF printApplicationPDF = new PrintApplicationPDF(sc);
        ApexPages.currentPage().getParameters().put('id', opt.id);
        ApexPages.currentPage().getParameters().put('svc', 'ビズリーチRS');

        Opportunity opp = [Select Id, QuotationExpireDate__c From Opportunity Where Id = :opt.Id];

        test.startTest();

        PageReference p = printApplicationPDF.initPrintApplicationInput();
        system.assertEquals(null, p);
        system.assertEquals(ac.Name, printApplicationPDF.dto.companyName);
        system.assertEquals(ac.Field157__c, printApplicationPDF.dto.companyNameKana);
        system.assertEquals(ac.BillingPostalCode, printApplicationPDF.dto.companyPostCode);
        system.assertEquals(ac.BillingState + ac.BillingCity + ac.BillingStreet, printApplicationPDF.dto.companyAddress);
        system.assertEquals(ac.Phone, printApplicationPDF.dto.companyPhone);
        system.assertEquals(system.today(), printApplicationPDF.dto.opp2.CloseDate);
        system.assertEquals(true, printApplicationPDF.dto.usageEnd);

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.serviceName = 'ビズリーチRS';
        printApplicationPDF.doPrintApplication();
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_proposalDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageStartDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateYYYY'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateMM'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_usageEndDateDD'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyName'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyNameKana'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyPostCode'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyAddress'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_companyPhone'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_department'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_name'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_nameKana'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_email'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingPostCode'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingAddress'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingPhone'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingDepartment'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingName'));
        system.assertEquals('', printApplicationPDF.rc.getParms().get('p_billingNameKana'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_continuation'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_fixedFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_successFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_optionFlg'));
        system.assertEquals('bos備考', printApplicationPDF.rc.getParms().get('p_remarks'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.serviceName = 'ビズリーチRS';
        printApplicationPDF.dto.opp.CloseDate = Date.valueOf('2000-01-31');
        printApplicationPDF.dto.opp2.CloseDate = Date.valueOf('2001-12-01');
        printApplicationPDF.dto.opp3.CloseDate = Date.valueOf('2002-06-15');
        printApplicationPDF.dto.companyName = '会社名';
        printApplicationPDF.dto.companyNameKana = 'カイシャメイカナ';
        printApplicationPDF.dto.companyPostCode = '100-0001';
        printApplicationPDF.dto.companyAddress = '会社住所';
        printApplicationPDF.dto.companyPhone = '03-0000-0001';
        printApplicationPDF.dto.department = '部署・役職';
        printApplicationPDF.dto.name = '担当者名';
        printApplicationPDF.dto.nameKana = 'タントウシャメイカナ';
        printApplicationPDF.dto.email = 'test@mail.com';
        printApplicationPDF.dto.billingPostCode = '100-0002';
        printApplicationPDF.dto.billingAddress = '請求先住所';
        printApplicationPDF.dto.billingPhone = '03-0000-0002';
        printApplicationPDF.dto.billingDepartment = '請求先部署・役職';
        printApplicationPDF.dto.billingName = '請求先担当者名';
        printApplicationPDF.dto.billingNameKana = 'セイキュウサキタントウシャメイカナ';
        printApplicationPDF.dto.usageEnd = true;
        printApplicationPDF.doPrintApplication();
        system.assertEquals('2001', printApplicationPDF.rc.getParms().get('p_proposalDateYYYY'));
        system.assertEquals('12', printApplicationPDF.rc.getParms().get('p_proposalDateMM'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_proposalDateDD'));
        system.assertEquals('2000', printApplicationPDF.rc.getParms().get('p_usageStartDateYYYY'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_usageStartDateMM'));
        system.assertEquals('31', printApplicationPDF.rc.getParms().get('p_usageStartDateDD'));
        system.assertEquals('2002', printApplicationPDF.rc.getParms().get('p_usageEndDateYYYY'));
        system.assertEquals('6', printApplicationPDF.rc.getParms().get('p_usageEndDateMM'));
        system.assertEquals('15', printApplicationPDF.rc.getParms().get('p_usageEndDateDD'));
        system.assertEquals('会社名', printApplicationPDF.rc.getParms().get('p_companyName'));
        system.assertEquals('カイシャメイカナ', printApplicationPDF.rc.getParms().get('p_companyNameKana'));
        system.assertEquals('100-0001', printApplicationPDF.rc.getParms().get('p_companyPostCode'));
        system.assertEquals('会社住所', printApplicationPDF.rc.getParms().get('p_companyAddress'));
        system.assertEquals('03-0000-0001', printApplicationPDF.rc.getParms().get('p_companyPhone'));
        system.assertEquals('部署・役職', printApplicationPDF.rc.getParms().get('p_department'));
        system.assertEquals('担当者名', printApplicationPDF.rc.getParms().get('p_name'));
        system.assertEquals('タントウシャメイカナ', printApplicationPDF.rc.getParms().get('p_nameKana'));
        system.assertEquals('test@mail.com', printApplicationPDF.rc.getParms().get('p_email'));
        system.assertEquals('100-0002', printApplicationPDF.rc.getParms().get('p_billingPostCode'));
        system.assertEquals('請求先住所', printApplicationPDF.rc.getParms().get('p_billingAddress'));
        system.assertEquals('03-0000-0002', printApplicationPDF.rc.getParms().get('p_billingPhone'));
        system.assertEquals('請求先部署・役職', printApplicationPDF.rc.getParms().get('p_billingDepartment'));
        system.assertEquals('請求先担当者名', printApplicationPDF.rc.getParms().get('p_billingName'));
        system.assertEquals('セイキュウサキタントウシャメイカナ', printApplicationPDF.rc.getParms().get('p_billingNameKana'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_continuation'));
        system.assertEquals('1', printApplicationPDF.rc.getParms().get('p_fixedFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_successFlg'));
        system.assertEquals('0', printApplicationPDF.rc.getParms().get('p_optionFlg'));
        system.assertEquals('bos備考', printApplicationPDF.rc.getParms().get('p_remarks'));

        printApplicationPDF = new PrintApplicationPDF(sc);
        printApplicationPDF.doPrintReportBeforeVisit();

        test.stopTest();

    }

	static private Account findAccount() {
	    return [Select Id, Name, Phone, BillingState, BillingCity, BillingStreet, BillingPostalCode, Field157__c From Account Where Name = 'TEST-XXX'];
	}

	static private user findUser() {
	    return [Select Id From User Where Username = 'test1@sutead.com'];
	}

	static private PriceBookEntry findPriceBookEntry(String productCode) {
		return [SELECT Id FROM PriceBookEntry WHERE productCode = :productCode LIMIT 1];
	}	

}