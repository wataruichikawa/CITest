/**
 * ACC_DrcAccountManagement
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class ACC_DrcAccountManagement {

    /** 契約開始日経過状況連絡の通知日 */
    private static final Integer[] PROGRESS_DAYS = new Integer[] {30, 60, 90, 120};

    @TestVisible
    private static String[] representativeNotice = system.label.RepresentativeNotice.split(',', 0);

    private static Map<Id, User> userMap;

    /**
     * 初めてアラート、進捗アラート通知
     * @param oppIdSet 商談IDセット
     */
    @future
    public static void alertDrcAccountManagement(Set<Id> oppIdSet) {

        List<Opportunity> oppList = [
            SELECT Id, Name, UseStartDate__c, UseStartProgressDate__c, UseEndDate30Ago__c, FirstInterview__c, FirstUnofficially__c,
            FirstDecision__c, JobNotCreated10__c, ListNonEaluation14__c, PurasukaNonReply7__c, InterviewUnadjusted7__c,
            Undecided33__c, AccountId, Account.Name, Account.CrsSales_RepresentativeMain__c, Account.CrsSale_Representative__c,
            Account.careertreck_sales_representative__c, Account.careertreck_representativeUser__c,
            (SELECT Id, Service__c FROM OpportunityLineItems WHERE HirePlanCategory__c != 'オプション' AND HirePlanCategory__c != 'プラスカ')
            FROM Opportunity WHERE Id IN :oppIdSet];

        if (oppList.isEmpty()) return;

        userMap = (Map<Id, User>) DAO_UserDao.findStdActiveUserMap().get(DAO_UserDao.MAP_KEY_ID);

        Id recTypeId = DAO_RecordTypeDao.findRecordTypeId(Schema.SObjectType.BizTask__c.Name, 'DRC');

        List<FeedItem> itemList = new List<FeedItem>();
        List<BizTask__c> taskList = new List<BizTask__c>();
        List<Opportunity> oppUpList = new List<Opportunity>();
        List<Id> userIdList;

        for (Opportunity opp : oppList) {
        	String service = opp.OpportunityLineItems.isEmpty() ? '' : opp.OpportunityLineItems.get(0).Service__c;
            if (String.isNotBlank(service)) {
                boolean upFlg = false;
                if ('ビズリーチ'.equals(service)) {
                    userIdList = new List<Id>();
                    userIdList.add(opp.Account.CrsSales_RepresentativeMain__c);
                    userIdList.add(opp.Account.CrsSale_Representative__c);
                    upFlg |= alertChatterProcess(itemList, oppUpList, opp, userIdList);
                    upFlg |= alertBizTaskProcess(taskList, oppUpList, opp, userIdList, recTypeId);
                } else if ('キャリアトレック'.equals(service)) {
                    userIdList = new List<Id>();
                    userIdList.add(opp.Account.careertreck_sales_representative__c);
                    userIdList.add(opp.Account.careertreck_representativeUser__c);
                    upFlg |= alertChatterProcess(itemList, oppUpList, opp, userIdList);
                    upFlg |= alertBizTaskProcess(taskList, oppUpList, opp, userIdList, recTypeId);
                }
                if (upFlg) {
                    oppUpList.add(opp);
                }
            }
        }

        if (!taskList.isEmpty()) {
            insert taskList;
        }
        if (!itemList.isEmpty()) {
            insert itemList;
        }
        if (!oppUpList.isEmpty()) {
            UTL_TriggerUtil.canRunOpportunity = false;
            update oppUpList;
        }

    }

    /**
     * 活動履歴アラート通知
     * @param idSet ユーザIDセット(CRS_担当営業)
     */
    public void alertActivityHistory(Set<Id> idSet) {

        Map<Id, User> usrMap = (Map<Id, User>) DAO_UserDao.findStdActiveUserMap().get(DAO_UserDao.MAP_KEY_ID);

        List<Folder> folList = [SELECT Id FROM Folder WHERE Type = 'Report' AND DeveloperName = 'DRCAccountManagement'];
        if (folList.isEmpty()) return;

        List<Report> repList = [SELECT Id, Name FROM Report WHERE OwnerId = :folList.get(0).Id AND DeveloperName = 'DrcActivityHistoryAlertReport'];
        if (repList.isEmpty()) return;
        Report rep = repList.get(0);

        List<FeedItem> itemList = new List<FeedItem>();
        String day = system.now().addDays(-1).format('yyyy年MM月dd日', UserInfo.getTimeZone().getID());
        for (Id usrId : idSet) {
            if (usrMap.containsKey(usrId)) {
                User usr = usrMap.get(usrId);
                itemList.add(new FeedItem(ParentId = usrId, Type = 'LinkPost', LinkUrl =
                    URL.getSalesforceBaseUrl().toExternalForm() + '/' + rep.Id + '?pv0=' + EncodingUtil.urlEncode(usr.Name, 'UTF-8'),
                    Title = rep.Name, Body = String.format(system.label.ActivityHistoryBody, new String[] { day })));
            }
        }

        if (!itemList.isEmpty()) {
            insert itemList;
        }

    }

    /**
     * Chatter通知
     * @param itemList FeedItem登録用リスト
     * @param oppUpList 商談更新用リスト
     * @param opp 商談
     * @param userIdList 通知先ユーザリスト(ビズリーチ：CRS_担当営業|CRS_担当運用、キャリアトレック：CT_担当営業|CT_担当運用)
     * @return true:商談更新要 | false:商談更新否
     */
    private static boolean alertChatterProcess(List<FeedItem> itemList, List<Opportunity> oppUpList, Opportunity opp, List<Id> userIdList) {
        boolean upFlg = false;
        if (opp.UseStartDate__c != null && opp.UseStartProgressDate__c != null) {
            for (Integer i = 0; i < PROGRESS_DAYS.size(); i++) {
                //【定期連絡】契約開始n日経過状況連絡
                if (opp.UseStartDate__c.addDays(PROGRESS_DAYS[i]).isSameDay(opp.UseStartProgressDate__c)) {
                    createFeedItem(itemList, opp, userIdList, String.format(system.label.ContractProgressBody,
                        new String[] {String.valueOf(PROGRESS_DAYS[i])}), boolean.valueOf(representativeNotice[i]));
                    opp.UseStartProgressDate__c = null;
                    upFlg = true;
                    break;
                }
            }
        }
        //【再契約提案】契約終了30日前再提案連絡
        if (opp.UseEndDate30Ago__c != null) {
            createFeedItem(itemList, opp, userIdList, system.label.ContractUseEnd, boolean.valueOf(representativeNotice[4]));
            opp.UseEndDate30Ago__c = null;
            upFlg = true;
        }
        return upFlg;
    }

    /**
     * Feed登録
     * @param itemList FeedItem登録用リスト
     * @param opp 商談
     * @param userIdList 通知先ユーザリスト(ビズリーチ：CRS_担当営業|CRS_担当運用、キャリアトレック：CT_担当営業|CT_担当運用)
     * @param body Chatter本文
     * @param notice 担当運用登録有無(true:登録する|false:登録しない)
     */
    private static void createFeedItem(List<FeedItem> itemList, Opportunity opp, List<Id> userIdList, String body, boolean notice) {
        for (Integer i = 0; i < userIdList.size(); i++) {
            if (String.isNotBlank(userIdList.get(i)) && (i == 0 || notice)) {
                if (userMap.containsKey(userIdList.get(i))) {
                    itemList.add(new FeedItem(ParentId = userIdList.get(i), Type = 'LinkPost', LinkUrl =
                        URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id, Title = opp.Name, Body = body));
                }
            }
        }
    }

    /**
     * タスク通知
     * @param taskList タスク登録用リスト
     * @param oppUpList 商談更新用リスト
     * @param opp 商談
     * @param userIdList 通知先ユーザリスト(ビズリーチ：CRS_担当営業|CRS_担当運用、キャリアトレック：CT_担当営業|CT_担当運用)
     * @param recTypeId レコードタイプId
     * @return true:商談更新要 | false:商談更新否
     */
    private static boolean alertBizTaskProcess(List<BizTask__c> taskList, List<Opportunity> oppUpList, Opportunity opp,
        List<Id> userIdList, Id recTypeId) {
        boolean upFlg = false;
        //【初面談】初めての面談
        if (opp.FirstInterview__c) {
            createBizTask(taskList, opp, userIdList, system.label.FirstInterviewTitle,
                system.label.FirstInterviewDetail, boolean.valueOf(representativeNotice[5]), recTypeId);
            opp.FirstInterview__c = false;
            upFlg = true;
        }
        //【初内定】初めての内定
        if (opp.FirstUnofficially__c) {
            createBizTask(taskList, opp, userIdList, system.label.FirstUnofficiallyTitle,
                system.label.FirstUnofficiallyDetail, boolean.valueOf(representativeNotice[6]), recTypeId);
            opp.FirstUnofficially__c = false;
            upFlg = true;
        }
        //【初決定】初めての決定
        if (opp.FirstDecision__c) {
            createBizTask(taskList, opp, userIdList, system.label.FirstDecisionTitle, system.label.FirstDecisionDetail,
                boolean.valueOf(representativeNotice[7]), recTypeId);
            opp.FirstDecision__c = false;
            upFlg = true;
        }
        //【進捗アラート】求人未作成
        if (opp.JobNotCreated10__c) {
            createBizTask(taskList, opp, userIdList, system.label.JobNotCreatedTitle, system.label.JobNotCreatedDetail,
                boolean.valueOf(representativeNotice[8]), recTypeId);
            opp.JobNotCreated10__c = false;
            upFlg = true;
        }
        //【進捗アラート】リスト未評価
        if (opp.ListNonEaluation14__c) {
            createBizTask(taskList, opp, userIdList, system.label.ListNonEaluationTitle,
                system.label.ListNonEaluationDetail, boolean.valueOf(representativeNotice[9]), recTypeId);
            opp.ListNonEaluation14__c = false;
            upFlg = true;
        }
        //【進捗アラート】プラスカ未返信
        if (opp.PurasukaNonReply7__c) {
            createBizTask(taskList, opp, userIdList, system.label.PurasukaNonReplyTitle,
                system.label.PurasukaNonReplyDetail, boolean.valueOf(representativeNotice[10]), recTypeId);
            opp.PurasukaNonReply7__c = false;
            upFlg = true;
        }
        //【進捗アラート】面談日程未調整
        if (opp.InterviewUnadjusted7__c) {
            createBizTask(taskList, opp, userIdList, system.label.InterviewUnadjustedTitle,
                system.label.InterviewUnadjustedDetail, boolean.valueOf(representativeNotice[11]), recTypeId);
            opp.InterviewUnadjusted7__c = false;
            upFlg = true;
        }
        //【進捗アラート】未決定状況確認
        if (opp.Undecided33__c) {
            createBizTask(taskList, opp, userIdList, system.label.UndecidedTitle, system.label.UndecidedDetail,
                boolean.valueOf(representativeNotice[12]), recTypeId);
            opp.Undecided33__c = false;
            upFlg = true;
        }
        return upFlg;
    }

    /**
     * タスク登録
     * @param taskList タスク登録用リスト
     * @param opp 商談
     * @param userIdList 通知先ユーザリスト(ビズリーチ：CRS_担当営業|CRS_担当運用、キャリアトレック：CT_担当営業|CT_担当運用)
     * @param title タスク件名
     * @param detail タスク詳細
     * @param notice 担当運用登録有無(true:登録する|false:登録しない)
     * @param recTypeId レコードタイプId
     */
    private static void createBizTask(List<BizTask__c> taskList, Opportunity opp, List<Id> userIdList, String title,
        String detail, boolean notice, Id recTypeId) {
        for (Integer i = 0; i < userIdList.size(); i++) {
            if (String.isNotBlank(userIdList.get(i)) && (i == 0 || notice)) {
                if (userMap.containsKey(userIdList.get(i))) {
                    BizTask__c btk = new BizTask__c(Account__c = opp.AccountId, Opportunity__c = opp.Id,
                        Name = String.format(title, new String[] {opp.Account.Name}), Tantousya__c = userIdList.get(i),
                        Status__c = '未実施', Kigen__c = system.today(), Syousai__c = detail, OwnerId = userIdList.get(i));
                    if (recTypeId != null) btk.RecordTypeId = recTypeId;
                    taskList.add(btk);
                }
            }
        }
    }

}