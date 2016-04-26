/**
 * BAT_AutomationCreateOfOpportunityBatch
 * 契約終了日より、自動で商談を作成する。
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
 global class BAT_AutoCreateOfOpportunityBatch implements Database.Batchable<sObject> {

    public String query = 'SELECT Id, Name, OwnerId, Owner.Name, Field107__c, OPEID__c, careertreck_sales_representative__c, Field156__c, CT_CurrentContractTermEndDate__c FROM Account WHERE AccountType__c = \'ESS\' ';
    global Integer jobNo = -1;

    global BAT_AutoCreateOfOpportunityBatch(Integer jobNo) {
        this.jobNo = jobNo;
    }

    /**
     * 商談自動作成開始処理
     * @param BC BatchableContextインターフェース
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Datetime today = system.today();
        Date beforeDate = (today + Integer.valueOf(system.Label.AutomationCreateOfOpportuniyBeforeDay)).date();

        String endDateStr = ((Datetime)beforeDate).format('yyyy-MM-dd');
        query += 'AND (';
        query += 'Field156__c = ';
        query += endDateStr;
        query += ' OR ';
        query += 'CT_CurrentContractTermEndDate__c = ';
        query += endDateStr;
        query += ')';
        system.debug(query);

        return Database.getQueryLocator(query);
    }
    
    /**
     * 商談自動作成処理
     * @param BC BatchableContextインターフェース
     * @param scope 商談リスト
     */
     global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Datetime today = system.today();
        Date beforeDate = (today + Integer.valueOf(system.Label.AutomationCreateOfOpportuniyBeforeDay)).date();

        String endDateStr = ((Datetime)beforeDate).format('yyyy-MM-dd');

        List<Opportunity> inserList = new List<Opportunity>();
        List<Id> selectAccountIdList = new List<Id>();
        List<Opportunity> notCreateList = new List<Opportunity>();
        Map<ID, Opportunity> notCreateMap = new Map<ID, Opportunity>();
        Id recordTypeId = null;

        List<Schema.RecordTypeInfo> rt = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();
        for (RecordTypeInfo ri : rt) {
            if ('ESS' == ri.getName()) {
                recordTypeId = ri.getRecordTypeId();
                break;
            }
        }

        Date closeDate = beforeDate - 7;

        for (sObject obj : scope) {
            Account a = (Account)obj;

            selectAccountIdList.add(a.Id);
        }
        notCreateList = [SELECT AccountId FROM Opportunity WHERE AccountId in :selectAccountIdList AND CloseDate = :closeDate];

        for (Opportunity op : notCreateList) {
            notCreateMap.put(op.AccountId, op);
        }

        for (sObject obj : scope) {
            Account a = (Account)obj;
            createAddOpportunityBiz(notCreateMap, a, inserList, beforeDate, endDateStr, recordTypeId);
            createAddOpportunityCree(notCreateMap, a, inserList, beforeDate, endDateStr, recordTypeId);
        }

        system.debug('debug : executed insert');
        system.debug(inserList);
        insert inserList;
    }
    
    /**
     * 商談自動作成終了処理
     * @param BC BatchableContextインターフェース
     */
    global void finish(Database.BatchableContext BC) {
        BAT_JobExecutor.executeNextJob(jobNo);
    }

    private void createAddOpportunityBiz(Map<ID, Opportunity> notCreateMap, Account a, List<Opportunity> inserList
            ,Date beforeDate, String endDateStr, Id recordTypeId) {
        if (!notCreateMap.containsKey(a.Id) && beforeDate == a.Field156__c) {
            Opportunity newOp = new Opportunity();
            newOp.Name = '新規商談';
            newOp.AccountId = a.Id;
            newOp.Amount = 0;
            newOp.CloseDate = beforeDate - 7;
            newOp.StageName = 'STEP07：Cヨミ';
            newOp.NextActionDueDate__c = beforeDate - 30;
            newOp.NextAction__c = '訪問';
            newOp.Type = '既存提案（リピート・継続）';
            newOp.AppoChannel__c = '継続提案(アポ獲得経路なし)';
            newOp.AppoAcquisitionDate__c = beforeDate - 45;
            newOp.VisitDate__c = beforeDate - 30;
            newOp.RecordTypeId = recordTypeId;
            newOp.VisitChargeUser__c = a.OwnerId;
            newOp.bikou__c = 'ビズリーチ契約更新(自動商談)_' + endDateStr;
            newOp.TriggerInvalid__c = true;
            newOp.ProposedService__c = 'ESS';

            inserList.add(newOp);
        }
    }

    private void createAddOpportunityCree(Map<ID, Opportunity> notCreateMap, Account a, List<Opportunity> inserList
        ,Date beforeDate, String endDateStr, Id recordTypeId) {
        if (!notCreateMap.containsKey(a.Id) && beforeDate == a.CT_CurrentContractTermEndDate__c) {
            Opportunity newOp = new Opportunity();
            newOp.Name = '新規商談';
            newOp.AccountId = a.Id;
            newOp.Amount = 0;
            newOp.CloseDate = beforeDate - 7;
            newOp.StageName = 'STEP07：Cヨミ';
            newOp.NextActionDueDate__c = beforeDate - 30;
            //newOp.NextAction__c = '訪問';
            newOp.Type = '既存提案（リピート・継続）';
            newOp.AppoChannel__c = '継続提案(アポ獲得経路なし)';
            newOp.AppoAcquisitionDate__c = beforeDate - 45;
            newOp.VisitDate__c = beforeDate - 30;
            newOp.RecordTypeId = recordTypeId;
            newOp.VisitChargeUser__c = a.OwnerId;
            newOp.bikou__c = 'キャリアトレック契約更新(自動商談)_' + endDateStr;
            newOp.TriggerInvalid__c = true;
            newOp.ProposedService__c = 'ESS';

            inserList.add(newOp);
        }
    }
}