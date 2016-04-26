public with sharing class BizTaskListController {

    private List<BIZTask__c> BizTaskList;
    public Boolean bos {get; set;}


    public BizTaskListController(ApexPages.StandardController stdController) {
        BizTaskList = [select id, CreatedDate, Account__c, Account__r.Name, CandidateCd__c, Name, AccountName__c,CRSCandidateName__c, CRSCandidate__c, Status__c, Kigen__c,Syousai__c, Tantousya__c, TantousyaMemo__c from BizTask__c where Status__c IN ('未実施','実施中', '差し戻し') and Tantousya__c = :UserInfo.getUserId() order by Kigen__c asc limit 20];
        system.debug('***BizTaskList size*** : ' + BizTaskList.size());
        system.debug('***BizTaskList*** : ' + BizTaskList);
        List<Profile> plist = [Select Id, Name From Profile Where id = :UserInfo.getProfileId()];
        if (!plist.IsEmpty()) {
            bos = plist.get(0).Name.contains('BOS');
        } else {
            bos = false;
        }
        system.debug('***bos*** : ' + bos);
    }

    public List<BizTask__c> getBizTaskList() {
        system.debug('***BizTaskList*** : ' + BizTaskList);
        return BizTaskList;
    }

    public String getNameLabel(){
        return Schema.SObjectType.BizTask__c.fields.Name.getLabel();
    }
}