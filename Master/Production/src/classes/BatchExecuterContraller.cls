public with sharing class BatchExecuterContraller {
    /**
     * 他社媒体掲載商品取り込みバッチ処理
     */
    public PageReference executeConvertCMJobToCustomObject3() {
		ConvertCMJobToCustomObject3 c = new ConvertCMJobToCustomObject3();
		c.query = 'SELECT DBID__c, Url__c, DataImportFlg__c, Other__c, Email__c, Qualifications__c, CompanyName__c, CompanyNameCl__c, CompanyNameKana__c, Salary__c, JobIndustry__c, Workplace__c, PublicationUrl__c, PublicationPeriod__c, PublicationUpdDate__c, PublicationCompanyName__c, Medium__c, AdvertisementSize__c, AdvertisementImage__c, kingaku__c, ContactName__c, ChargePost__c, JobDescription__c, Description__c, AcquisitionDate__c, City__c, Street__c, EmployeeNumber__c, JobCategory__c, JobCategorySub__c, EstablishmentYear__c, Phone__c, State__c, Sales__c, Department__c, WantedJobCategory__c, ZipCode__c, Charge__c FROM CompetingMediumJob__c WHERE BatchExecFlg__c = false and Medium__c != \'j-sen\' limit 50000';
		Database.executebatch(c);
        return null;
    }

	/**
	 * 活動履歴更新トリガー起動バッチ
     */
	public PageReference executeTaskAllUpdate() {
		TaskAllUpdate batch = new TaskAllUpdate();
   		batch.query = 'Select Id, DataUpdFlgForTrigger__c from task where DataUpdFlgForTrigger__c = false order by createddate asc limit 50000';
		ID batchprocessid = Database.executeBatch(batch);
		return null;
	}

	/**
	 * 取引先の商談訪問情報更新バッチ
     */
	public PageReference executeUpdateAccountOpportunityVisitData() {
		UpdateAccountOpportunityVisitData batch = new UpdateAccountOpportunityVisitData();
   		batch.query = 'select a.id, a.last_visit_date__c, (select c.id, c.VisitChargeUser__c, c.VisitDate__c from opportunities c where c.isdeleted = false and c.VisitCompletion__c = true and c.VisitDate__c != null order by c.VisitDate__c desc) from account a where a.isdeleted = false and a.id in (select b.accountid from opportunity b where b.isdeleted = false and b.VisitCompletion__c = true and b.VisitDate__c != null)';
		ID batchprocessid = Database.executeBatch(batch);
		return null;
	}

}