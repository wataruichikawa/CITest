/**
 * TST_TGR_AccountTrigger
 *
 * テスト対象
 * 1.TGR_CRSCandidateTrigger
 * 2.CLS_CRSCandidate
 * ----------------------------------------
 * @createdName      : W.Ichikawa
 * @lastModifiedName : W.Ichikawa
 * ----------------------------------------
 */
@isTest
private class TST_TGR_CRSCandidateTrigger {

    static testMethod void testCRSCandidateTrigger() {

        Account ac = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
        insert ac;

        User user1 = new User(LastName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert user1;

        position__c pos = new position__c();
        pos.Name = '111';
        pos.Field89__c = ac.Id;
        pos.Jobid__c = '222';
        insert pos;

        CRSCandidate__c crsCandidate = new CRSCandidate__c();
        crsCandidate.Shimei__c = 'TEST USER';
        crsCandidate.Field49__c = '26';
        crsCandidate.seibetu__c = '男性';
        crsCandidate.PhoneNumber__c = '03-1234-5678';
        crsCandidate.Field50__c = NULL;
        crsCandidate.Gensyokumei__c = 'BizReach';
        crsCandidate.Field8__c = '00000001';
        crsCandidate.Field62__c = '0001';
        crsCandidate.CandidateCd__c = '001';
        crsCandidate.Field7__c = '平社員';
        crsCandidate.Field62__c = '0001';
        crsCandidate.Field48__c = 'プラチナスカウト';
        crsCandidate.OubokeiroNew__c = NULL;
        crsCandidate.Field47__c = 'プレミアム';
        crsCandidate.Field67__c = 'CRS';

        crsCandidate.Account__c = ac.Id;
        crsCandidate.position__c = pos.Id;
        crsCandidate.Field28__c = NULL;
        crsCandidate.Field4__c = 1234;
        crsCandidate.Field5__c = '市川 亘';
        crsCandidate.AutoExclude__c = false;
        crsCandidate.Field1__c = 'テスト ユーザ';
        crsCandidate.hassei_tantou__c = '吉田 大一';
        crsCandidate.Field43__c = NULL;
        crsCandidate.Field63__c = NULL;
        crsCandidate.Field10__c = '書類選考';
        crsCandidate.ProgressStatus__c = '書類選考';
        crsCandidate.ProgressWorkCount__c = '10';
        crsCandidate.ProgressStatusFinish__c = NULL;
        crsCandidate.Field26__c = 0;
        crsCandidate.Field27__c = 'テストテキスト';
        crsCandidate.ProgressWorkCount__c = '5';
        crsCandidate.Field27__c = 'テストテキスト';
        crsCandidate.ProgressStatusFinish__c = NULL;
        crsCandidate.Field11__c = NULL;
        crsCandidate.JobEntryDate__c = NULL;
        crsCandidate.Field15__c = NULL;
        crsCandidate.JobEntryDate__c = NULL;
        crsCandidate.Field59__c = NULL;
        crsCandidate.Field57__c = NULL;
        crsCandidate.Field16__c = NULL;
        crsCandidate.BOSDaikouDenwaMendanTyousei__c = NULL;
        crsCandidate.BOS__c = NULL;
        crsCandidate.RejyumeKakutokubi__c = NULL;
        crsCandidate.BOSSuisenbi__c = NULL;
        crsCandidate.Field37__c = NULL;
        crsCandidate.First_Interview_Insert_Date__c = NULL;
        crsCandidate.Field18__c = NULL;
        crsCandidate.Second_Interview_Insert_Date__c = NULL;
        crsCandidate.Field44__c = NULL;
        crsCandidate.Third_Interview_Insert_Date__c = NULL;
        crsCandidate.Field45__c = NULL;
        crsCandidate.Fourth_Interview_Insert_Date__c = NULL;
        crsCandidate.Field46__c = NULL;
        crsCandidate.Final_Interview_Insert_Date__c = NULL;
        crsCandidate.Field19__c = NULL;
        crsCandidate.Field21__c = NULL;
        crsCandidate.Field22__c = NULL;
        crsCandidate.Field42__c = NULL;
        crsCandidate.Field35__c = NULL;
        crsCandidate.Field23__c = NULL;
        crsCandidate.Field25__c = NULL;
        crsCandidate.Field24__c = NULL;
        crsCandidate.Field36__c = NULL;
        crsCandidate.Field32__c = 30000;
        crsCandidate.Field33__c = 3;
        crsCandidate.Field53__c = 300000;
        crsCandidate.AgencyFee__c = 2000;

        crsCandidate.RecruiterMustResponseFlg__c = true;
        crsCandidate.LastAdjustmentWorkTm__c = NULL;
        crsCandidate.Field12__c = NULL;
        crsCandidate.Field13__c = NULL;

        crsCandidate.drop_sales_date__c = NULL;
        crsCandidate.drop_sales_price__c = NULL;
        crsCandidate.Field29__c = NULL;
        crsCandidate.drop_sales_reason__c = NULL;

        crsCandidate.Field55__c = '受注';
        crsCandidate.Field56__c = 10000;
        crsCandidate.CloseDate__c = NULL;
        crsCandidate.MgrYomi__c = false;
        crsCandidate.SV_memo__c = NULL;
        crsCandidate.BOSCoordinatorBikou__c = NULL;
        crsCandidate.CompanyFeeling__c = NULL;
        crsCandidate.CandidateFeeling__c = NULL;
        crsCandidate.SelectionPhase__c = NULL;
        crsCandidate.SelectionPhaseSchedule__c = NULL;
        crsCandidate.DecisionAcceptTerm__c = NULL;
        crsCandidate.BOSCordinatorStatus__c = NULL;

        crsCandidate.syoruiOK__c = false;
        crsCandidate.Field66__c = false;

        crsCandidate.Prerecorded__c = false;
        crsCandidate.ContractReplaceCondition__c = '固定利率';

        crsCandidate.CS_Researcher__c = NULL;
        crsCandidate.CS_capture__c = false;
        crsCandidate.CS_Pledge__c = false;
        crsCandidate.CS_URL__c = NULL;
        crsCandidate.CS_URL2__c = NULL;
        crsCandidate.Field69__c = false;
        crsCandidate.CS_check__c = false;
        crsCandidate.CS__c = NULL;
        crsCandidate.CS_PlaceDate__c = NULL;
        crsCandidate.CS_comment__c = NULL;
        crsCandidate.DRC__c = false;
        crsCandidate.DRC_Result__c = NULL;

        crsCandidate.TaskHuridasiMukouFlag__c = false;
        crsCandidate.TriggerInvalid__c = false;

        Test.startTest();

        insert crsCandidate;
        update crsCandidate;

        crsCandidate.TriggerInvalid__c = true;
        update crsCandidate;

        Test.stopTest();

        CRSCandidate__c rslt = [SELECT id,name,Field1__c,OccurrenceSalesContactUser__r.Name,hassei_tantou__c,OccurrenceOperationContactUser__r.Name FROM CRSCandidate__c WHERE Id = :crsCandidate.Id];
        system.assertEquals(rslt.OccurrenceSalesContactUser__r.Name,rslt.Field1__c);
        system.assertEquals(rslt.OccurrenceOperationContactUser__r.Name,rslt.hassei_tantou__c);

    }
}