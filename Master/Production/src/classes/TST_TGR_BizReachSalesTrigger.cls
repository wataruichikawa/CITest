/**
 * TST_TGR_AccountTrigger
 *
 * テスト対象
 * 1.TGR_BizReachSalesTrigger
 * 2.BRS_BizReachSalesProcess
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_BizReachSalesTrigger {

    static testMethod void testBizReachSalesTrigger() {

        Account ac = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
        insert ac;

        Contact ct1 = new Contact(AccountId = ac.id, lastname = 'TEST1', firstname = 'TARO1');
        insert ct1;

        User user1 = new User(LastName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert user1;

        Opportunity opp = new Opportunity();
        opp.AccountId = ac.Id;
        opp.Name = 'TEST';
        opp.StageName = 'TEST';
        opp.OwnerId = user1.Id;
        opp.VisitChargeUser__c = user1.Id;
        opp.CloseDate = Date.newInstance(2014, 3, 10);
        insert opp;

        List<Opportunity> nopp = [Select Id, OpportunityNumber__c from Opportunity where id = :opp.Id];

        BizReachSales__c bizSales = new BizReachSales__c();
        bizSales.ContractApplicationNo__c = nopp.get(0).OpportunityNumber__c;
        bizSales.BizReachSalesId__c = '201402-130162120140612834INI';
        bizSales.ContractApplicationType__c = 'CRS';
        bizSales.ContractApplicationProductId__c = 12834;
        bizSales.ContractApplicationProductMasterId__c = 384;
        bizSales.ContractProductName__c = 'CRS_300-000N  [CRS] エンタープライズ 300-0 6ヶ月 /600通(初月なし）';
        bizSales.ContractRequestDate__c = Date.newInstance(2014, 6, 3);
        bizSales.ContractStartDate__c = Date.newInstance(2014, 6, 9);
        bizSales.ContractEndDate__c = Date.newInstance(2014, 12, 8);
        bizSales.ContractTerm__c = 6;
        bizSales.ContractType__c = '固定';
        bizSales.SalesContact__c = 'TEST1';
        bizSales.SalesProductType__c = '初期';
        bizSales.HasseiYearMonth__c = '201406';
        bizSales.HasseiDate__c = Date.newInstance(2014, 6, 3);
        bizSales.FirstHasseiDate__c = Date.newInstance(2014, 6, 3);
        bizSales.SalesPrice__c = 3000000;
        bizSales.SalesRate__c = NULL;
        bizSales.SalesRemarks__c = '初期費用';
        bizSales.ApprovalRequestStatus__c = '';
        bizSales.Account__c = ac.Id;
        bizSales.PreHighClassContractApplicationNo__c = nopp.get(0).OpportunityNumber__c;
        bizSales.PreHighClassContractStartDate__c = NULL;
        bizSales.PreHighClassContractEndDate__c = NULL;
        bizSales.PreHighClassInterval__c = NULL;
        bizSales.PreTalentContractApplicationNo__c = NULL;
        bizSales.PreTalentContractStartDate__c = NULL;
        bizSales.PreTalentContractEndDate__c = NULL;
        bizSales.PreTalentInterval__c = NULL;
        bizSales.RecruiterReplaceReportId__c = NULL;
        bizSales.RecruiterReplaceStatus__c = NULL;
        bizSales.ProgressId__c = NULL;
        bizSales.RecruiterId__c = NULL;
        bizSales.RecruiterName__c = NULL;
        bizSales.CandidateId__c = NULL;
        bizSales.CandidateRegistDate__c = NULL;
        bizSales.CandidateTrcd__c = NULL;
        bizSales.CandidateClassCd__c = '';
        bizSales.FirstHandshakeDate__c = NULL;
        bizSales.HireDate__c = NULL;
        bizSales.ReplaceIncome__c = NULL;
        bizSales.ReferralFee__c = NULL;
        bizSales.BillRate__c = NULL;
        bizSales.SeikyuYearMonth__c = NULL;
        bizSales.applyTm__c = NULL;
        bizSales.SalesConfirmedDate__c = NULL;
        bizSales.OperatorMemo__c = NULL;
        bizSales.LastUpdActorType__c = NULL;
        bizSales.LastUpdActorId__c = NULL;
        bizSales.LastUpdDate__c = NULL;
        bizSales.NewOrContinue__c = '新規';
        bizSales.NumberCount__c = 1;
        bizSales.ProcessType__c = '前工程';
        bizSales.HireChannel__c = '求人案内';
        bizSales.OperationContact__c = 'テスト ユーザ';

        Test.startTest();

        insert bizSales;
        update bizSales;
        bizSales.TriggerInvalid__c = true;
        update bizSales;

        Test.stopTest();

//        system.assert(![SELECT Id, TriggerInvalid__c FROM BizReachSales__c WHERE Id = :bizSales.Id].TriggerInvalid__c);
//        system.assertEquals(rslt.OperationContactUser__r.Name,rslt.hassei_tantou__c);
        BizReachSales__c rslt = [SELECT id,name,OperationContact__c,OperationContactUser__r.Name FROM BizReachSales__c WHERE Id = :bizSales.Id];
        system.assertEquals(rslt.OperationContact__c,rslt.OperationContactUser__r.Name);
        
    }
}