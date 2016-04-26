global class UpdateAccountOpportunityVisitDataSch implements Schedulable {
    global void execute(SchedulableContext sc) {
		UpdateAccountOpportunityVisitData batch = new UpdateAccountOpportunityVisitData();
    	batch.query = 'select a.id, a.last_visit_date__c, (select c.id, c.VisitChargeUser__c, c.VisitDate__c from opportunities c where c.isdeleted = false and c.VisitCompletion__c = true and c.VisitDate__c != null order by c.VisitDate__c desc) from account a where a.isdeleted = false and a.id in (select b.accountid from opportunity b where b.isdeleted = false and b.VisitCompletion__c = true and b.VisitDate__c != null)';
		ID batchprocessid = Database.executeBatch(batch);
    }
}