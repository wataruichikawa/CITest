global class UpdateAccountClearActivityDataSch implements Schedulable {
    global void execute(SchedulableContext sc) {
		UpdateAccountClearActivityData batch = new UpdateAccountClearActivityData();
    	batch.query = 'Select id from Account where REC_COMPANY_ID__c != null or (createddate = TODAY or createddate = YESTERDAY) or (LastReferencedDate = TODAY or LastReferencedDate = YESTERDAY) or (LastModifiedDate = TODAY or LastModifiedDate = YESTERDAY) or (lastActivityDate = TODAY or lastActivityDate = YESTERDAY)';
		ID batchprocessid = Database.executeBatch(batch);
    }
}