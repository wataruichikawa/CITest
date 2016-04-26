@isTest
private class TST_TGR_OpportunityLineItemTrigger {

	@IsTest(SeeAllData=true)
	static void testOpportunityLineItemTrigger() {
		Account acc = new Account(name = 'Test Inc', Phone = '03-3333-8888', Field221__c = 'Internet', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx', Website = 'http://test.co.jp');
		insert acc;
		Opportunity opp1 = new Opportunity(AccountId = acc.Id, Name = 'ビズリーチ商談', StageName = 'STEP3：アポ獲得@', CloseDate = system.today(), OwnerId = UserInfo.getUserId(), VisitChargeUser__c = UserInfo.getUserId(), AppoAcquisitionUser__c = UserInfo.getUserId());
		Opportunity opp2 = new Opportunity(AccountId = acc.Id, Name = 'ビズリーチ商談', StageName = 'STEP3：アポ獲得@', CloseDate = system.today(), OwnerId = UserInfo.getUserId(), VisitChargeUser__c = UserInfo.getUserId(), AppoAcquisitionUser__c = UserInfo.getUserId());
		insert new Opportunity[] { opp1, opp2 };
		PriceBook2 pb2s = [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
		PriceBook2 pb2c = new PriceBook2(Name = 'Custom Price Book', IsActive = true);
		insert pb2c;
		Product2 pd21 = new Product2(Name = 'ビズ商品', ProductCode = 'biz', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = ' 固定', Service__c = 'ビズリーチ', ProposedService__c = 'CRS', Remarks__c = 'biz備考');
		Product2 pd22 = new Product2(Name = 'ビズ商品', ProductCode = 'biz', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = '成功報酬', Service__c = 'ビズリーチ', ProposedService__c = 'CRS', Remarks__c = 'biz備考');
		Product2 pd2Op = new Product2(Name = 'ビズ商品', ProductCode = 'biz', IsActive = true, PlatinumScoutNumberOfFirstMonth__c = 50, PlatinumScoutNumber__c = 250,
			ContractPeriod__c = 6, UpfrontFee__c = 850000, SpecialInstruction__c = 'テスト特記欄',
			DisplayNameForClient__c = 'テストサービス名欄', HirePlanCategory__c = 'オプション', Service__c = 'ビズリーチ', ProposedService__c = 'CRS', Remarks__c = 'biz備考');
		insert new Product2[] { pd21, pd22, pd2Op };
		PriceBookEntry pbe1 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd21.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe2 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd22.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe3 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2s.Id, Product2Id = pd2Op.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe4 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd21.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe5 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd22.Id, UseStandardPrice = false, UnitPrice = 850000);
		PriceBookEntry pbe6 = new PriceBookEntry(IsActive = true, Pricebook2Id = pb2c.Id, Product2Id = pd2Op.Id, UseStandardPrice = false, UnitPrice = 850000);
		insert new PriceBookEntry[] { pbe1, pbe2, pbe3, pbe4, pbe5, pbe6 };
		OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp1.Id, PricebookEntryId = pbe4.Id, Quantity = 1, UnitPrice = 850000);
		OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp1.Id, PricebookEntryId = pbe5.Id, Quantity = 1, UnitPrice = 850000);
		OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId = opp1.Id, PricebookEntryId = pbe6.Id, Quantity = 1, UnitPrice = 850000);
		OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp2.Id, PricebookEntryId = pbe4.Id, Quantity = 1, UnitPrice = 850000);
		OpportunityLineItem oli5 = new OpportunityLineItem(OpportunityId = opp2.Id, PricebookEntryId = pbe6.Id, Quantity = 1, UnitPrice = 850000);
		OpportunityLineItem oli6 = new OpportunityLineItem(OpportunityId = opp2.Id, PricebookEntryId = pbe4.Id, Quantity = 1, UnitPrice = 850000);

		Test.startTest();
		Database.SaveResult[] srs1 = Database.insert(new OpportunityLineItem[] { oli1, oli2, oli3, oli4, oli5 }, false);
		Database.SaveResult sr1 = Database.insert(oli6, false);
		oli5.TriggerInvalid__c = true;
		Database.SaveResult[] srs2 = Database.update(new OpportunityLineItem[] { oli4, oli5 }, false);
		Test.stopTest();

		System.assert(!srs1[0].isSuccess());
		System.assertEquals('同一サービスで固定・成果報酬・特別プランの重複、及び同時に選択する事はできません。', srs1[0].getErrors()[0].getMessage());
		System.assert(!srs1[1].isSuccess());
		System.assertEquals('同一サービスで固定・成果報酬・特別プランの重複、及び同時に選択する事はできません。', srs1[1].getErrors()[0].getMessage());
		System.assert(srs1[2].isSuccess());
		System.assert(srs1[3].isSuccess());
		System.assert(srs1[4].isSuccess());
		System.assert(!sr1.isSuccess());
		System.assertEquals('同一サービスで固定・成果報酬・特別プランの重複、及び同時に選択する事はできません。', sr1.getErrors()[0].getMessage());
		System.assert(srs2[0].isSuccess());
		System.assert(srs2[1].isSuccess());

	}

}