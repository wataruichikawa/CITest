/**
 * TST_CHA_ChatterFollow
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
@isTest
private class TST_CHA_ChatterFollow {

    /**
     * セットアップ
     * ユーザ、取引先、商談、採用プランマスタ登録
     */
    @testSetup
    static void setUp() {
        List<User> userList = new List<User>();
        for (Integer i = 0; i < 10; i++) {
            userList.add(new User(LastName = 'TEST' + i, FirstName = 'TEST' + i, Username = 'test' + i + '@sutead.com', Email = 'test' + i + '@sutead.com', Alias = 'test' + i, CommunityNickname = 'test' + i, TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja'));
        }
        insert userList;
        userList = findUser();

        List<Account> accList = new List<Account>();
        accList.add(new Account(name = 'Test Inc1', Phone = '03-3333-3331', website = 'http://www.bizreach1.co.jp',
            CrsSales_RepresentativeMain__c = userList.get(0).id, CrsSale_Representative__c = userList.get(1).id,
            CRS_MaeTantousya__c = userList.get(2).id, CRS_BOSPlanner__c = userList.get(3).id,
            careertreck_sales_representative__c = userList.get(4).id, careertreck_representativeUser__c = userList.get(5).id,
            BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9',
            CTBOSTantou__c = userList.get(6).id, OwnerId = userList.get(7).id));
            //CT_MaeTantousya__c項目削除によるコメントアウト
            //CT_MaeTantousya__c = userList.get(6).id, CTBOSTantou__c = userList.get(7).id, OwnerId = userList.get(8).id));

        accList.add(new Account(name = 'Test Inc2', Phone = '03-3333-3332', website = 'http://www.bizreach2.co.jp',
            CrsSales_RepresentativeMain__c = null, CrsSale_Representative__c = null,
            CRS_MaeTantousya__c = null, CRS_BOSPlanner__c = null,
            careertreck_sales_representative__c = null, careertreck_representativeUser__c = null,
            BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9',
            CTBOSTantou__c = null, OwnerId = userList.get(7).id));
            //項目削除によるコメントアウト
            //CT_MaeTantousya__c = null, CTBOSTantou__c = null, OwnerId = userList.get(8).id));

        insert accList;
        accList = findAccount();

        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(new Opportunity(name = 'testOp', CloseDate = system.today(), StageName = 'STEP03：アポ獲得@',
            VisitChargeUser__c = userList.get(0).Id, AppoAcquisitionUser__c = userList.get(0).Id,
            AccountId = accList.get(0).id, ProposedService__c = 'CRS',
            hasCreatedCalendar__c = true, BCS__c = userList.get(1).Id,
            OwnerId = userList.get(2).Id));
        oppList.add(new Opportunity(name = 'testOp', CloseDate = system.today(), StageName = 'STEP03：アポ獲得@',
            VisitChargeUser__c = null, AppoAcquisitionUser__c = userList.get(0).Id,
            AccountId = accList.get(0).id, ProposedService__c = 'CRS',
            hasCreatedCalendar__c = true, BCS__c = null,
            OwnerId = userList.get(2).Id));
        insert oppList;
    }

    /**
     * 取引先登録時のフォロー登録のテスト
     */
    static testMethod void insertFollowAccountTest() {
        List<User> userList = findUser();
        List<Account> accList = findAccount();
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : accList) {
            accMap.put(acc.Id, acc);
        }

        List<EntitySubscription> tsList = [Select Id From EntitySubscription Where ParentId = :accMap.keySet()];
        if (!tsList.isEmpty()) {
            delete tsList;
        }

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.insertFollowAccount(accList, accMap);

        Test.stopTest();

        tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :accMap.keySet() order by ParentId, SubscriberId];

        //system.assertEquals(8, tsList.size());
        system.assertEquals(7, tsList.size());
        Id accId = accList.get(0).Id;
        for (Integer i = 0; i < tsList.size(); i++) {
            EntitySubscription es = tsList.get(i);
            system.assertEquals(accId, es.ParentId);
            system.assertEquals(userList.get(i).Id, es.SubscriberId);
        }

    }

    /**
     * 取引先登録、無効ユーザのテスト
     */
    static testMethod void insertFollowAccountInvalidUserTest() {
        List<User> userList = findUser();
        List<Account> accList = findAccount();
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : accList) {
            accMap.put(acc.Id, acc);
        }

        List<EntitySubscription> tsList = [Select Id From EntitySubscription Where ParentId = :accMap.keySet()];
        if (!tsList.isEmpty()) {
            delete tsList;
        }
        for (User u : userList) {
            u.isActive = false;
        }
        update userList;

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.insertFollowAccount(accList, accMap);

        Test.stopTest();

        tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :accMap.keySet() order by ParentId, SubscriberId];

        system.assertEquals(0, tsList.size());

    }

    /**
     * 取引先更新時のフォロー登録・解除のテスト
     */
    static testMethod void updateFollowAccountTest() {

        List<User> userList = findUser();
        List<Account> accList = findAccount();
        Map<Id, Account> accMap = new Map<Id, Account>();
        List<Account> accOldList = new List<Account>();
        Map<Id, Account> accOldMap = new Map<Id, Account>();
        for (Account acc : accList) {
            accMap.put(acc.Id, acc);
            Account accOld = acc.clone();
            accOld.Id = acc.Id;
            accOld.CrsSales_RepresentativeMain__c = userList.get(9).Id;
            accOld.CrsSale_Representative__c = null;
            accOldList.add(accOld);
            accOldMap.put(accOld.Id, accOld);
        }

        insert new EntitySubscription(ParentId = accOldList.get(0).Id, SubscriberId = userList.get(9).Id);
        delete [Select Id From EntitySubscription Where ParentId = :accOldList.get(0).Id And SubscriberId = :userList.get(6).id];

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.updateFollowAccount(accList, accMap, accOldList, accOldMap);

        List<EntitySubscription> tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :accMap.keySet() order by ParentId, SubscriberId];

        //system.assertEquals(8, tsList.size());
        system.assertEquals(7, tsList.size());
        Id accId = accList.get(0).Id;
        for (Integer i = 0; i < tsList.size(); i++) {
            EntitySubscription es = tsList.get(i);
            system.assertEquals(accId, es.ParentId);
            system.assertEquals(userList.get(i).Id, es.SubscriberId);
        }

        //フォロー対象・フォロー変更なしでEntitySubscriptionに登録されていない場合のパターン
        tsList = [Select Id From EntitySubscription Where ParentId = :accMap.keySet()];
        if (!tsList.isEmpty()) {
            delete tsList;
        }
        insert new EntitySubscription(ParentId = accOldList.get(0).Id, SubscriberId = userList.get(9).Id);

        cf.updateFollowAccount(accList, accMap, accOldList, accOldMap);

        tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :accMap.keySet() order by ParentId, SubscriberId];

        //system.assertEquals(8, tsList.size());
        system.assertEquals(7, tsList.size());
        for (Integer i = 0; i < tsList.size(); i++) {
            EntitySubscription es = tsList.get(i);
            system.assertEquals(accId, es.ParentId);
            system.assertEquals(userList.get(i).Id, es.SubscriberId);
        }

        //フォロー対象でEntitySubscriptionに登録されていない場合のパターン2
        tsList = [Select Id From EntitySubscription Where ParentId = :accMap.keySet()];
        if (!tsList.isEmpty()) {
            delete tsList;
        }
        insert new EntitySubscription(ParentId = accOldList.get(0).Id, SubscriberId = userList.get(0).Id);

        cf.updateFollowAccount(accList, accMap, accOldList, accOldMap);

        tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :accMap.keySet() order by ParentId, SubscriberId];

        //system.assertEquals(8, tsList.size());
        system.assertEquals(7, tsList.size());

        for (Integer i = 0; i < tsList.size(); i++) {
            EntitySubscription es = tsList.get(i);
            system.assertEquals(accId, es.ParentId);
            system.assertEquals(userList.get(i).Id, es.SubscriberId);
        }

        Test.stopTest();
    }

    /**
     * 取引先更新、無効ユーザのテスト
     */
    static testMethod void updateFollowAccountInvalidUserTest() {
        List<User> userList = findUser();
        List<Account> accList = findAccount();
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : accList) {
            accMap.put(acc.Id, acc);
        }

        for (User u : userList) {
            u.isActive = false;
        }
        update userList;

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.updateFollowAccount(accList, accMap, accList.clone(), accMap.clone());

        Test.stopTest();

        List<EntitySubscription> tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :accMap.keySet() order by ParentId, SubscriberId];

        system.assertEquals(0, tsList.size());

    }

    /**
     * 商談登録時のフォロー登録のテスト
     */
    static testMethod void insertFollowOpportunityTest() {
        List<User> userList = findUser();
        List<Opportunity> oppList = findOpportunity();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : oppList) {
            oppMap.put(opp.Id, opp);
        }

        List<EntitySubscription> tsList = [Select Id From EntitySubscription Where ParentId = :oppMap.keySet()];
        if (!tsList.isEmpty()) {
            delete tsList;
        }

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.insertFollowOpportunity(oppList, oppMap);

        Test.stopTest();

        tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :oppMap.keySet() order by ParentId, SubscriberId];

        system.assertEquals(2, tsList.size());
        Id oppId = oppList.get(0).Id;
        for (Integer i = 0; i < tsList.size(); i++) {
            EntitySubscription es = tsList.get(i);
            system.assertEquals(oppId, es.ParentId);
            system.assertEquals(userList.get(i).Id, es.SubscriberId);
        }

    }

    /**
     * 商談登録、無効ユーザのテスト
     */
    static testMethod void insertFollowOpportunityInvalidUserTest() {
        List<User> userList = findUser();
        List<Opportunity> oppList = findOpportunity();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : oppList) {
            oppMap.put(opp.Id, opp);
        }

        List<EntitySubscription> tsList = [Select Id From EntitySubscription Where ParentId = :oppMap.keySet()];
        if (!tsList.isEmpty()) {
            delete tsList;
        }

        for (User u : userList) {
            u.isActive = false;
        }
        update userList;

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.insertFollowOpportunity(oppList, oppMap);

        Test.stopTest();

        tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :oppMap.keySet() order by ParentId, SubscriberId];

        system.assertEquals(0, tsList.size());

    }

    /**
     * 商談更新時のフォロー登録・解除のテスト
     */
    static testMethod void updateFollowOpportunityTest() {
        List<User> userList = findUser();
        List<Opportunity> oppList = findOpportunity();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : oppList) {
            oppMap.put(opp.Id, opp);
        }

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.updateFollowOpportunity(oppList, oppMap, oppList.clone(), oppMap.clone());

        Test.stopTest();

        List<EntitySubscription> tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :oppMap.keySet() order by ParentId, SubscriberId];

        system.assertEquals(2, tsList.size());
        Id oppId = oppList.get(0).Id;
        for (Integer i = 0; i < tsList.size(); i++) {
            EntitySubscription es = tsList.get(i);
            system.assertEquals(oppId, es.ParentId);
            system.assertEquals(userList.get(i).Id, es.SubscriberId);
        }

    }

    /**
     * 商談更新、無効ユーザのテスト
     */
    static testMethod void updateFollowOpportunityInvalidUserTest() {
        List<User> userList = findUser();
        List<Opportunity> oppList = findOpportunity();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : oppList) {
            oppMap.put(opp.Id, opp);
        }
        for (User u : userList) {
            u.isActive = false;
        }
        update userList;

        Test.startTest();

        CHA_ChatterFollow cf = new CHA_ChatterFollow();
        cf.updateFollowOpportunity(oppList, oppMap, oppList.clone(), oppMap.clone());

        Test.stopTest();

        List<EntitySubscription> tsList = [Select Id, ParentId, SubscriberId From EntitySubscription
            Where ParentId = :oppMap.keySet() order by ParentId, SubscriberId];

        system.assertEquals(0, tsList.size());

    }

    /**
     * ユーザ検索
     */
    static List<User> findUser() {
        return [Select Id, isActive From User Where Username like '%@sutead.com' order by Id];
    }

    /**
     * 取引先検索
     */
    static List<Account> findAccount() {
        return [Select Id, CrsSales_RepresentativeMain__c, CrsSale_Representative__c, CRS_MaeTantousya__c,
            CRS_BOSPlanner__c, careertreck_sales_representative__c, careertreck_representativeUser__c,
            CTBOSTantou__c From Account Where name like 'Test Inc%' order by Id];
            //項目削除によるコメントアウト
            //CT_MaeTantousya__c, CTBOSTantou__c From Account Where name like 'Test Inc%' order by Id];
    }

    /**
     * 商談検索
     */
    static List<Opportunity> findOpportunity() {
        return [Select Id, VisitChargeUser__c, BCS__c From Opportunity Where StageName = 'STEP03：アポ獲得@'];
    }

}