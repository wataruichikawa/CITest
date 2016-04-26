/**
 * CLS_CPN_AcademyAttendance
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
 public class CLS_CPN_AcademyAttendance {

	public List<SelectOption> options { get; private set; }
	public List<SelectOption> statusOoptions { get; private set; }
	public List<SelectOption> categoryOoptions { get; private set; }
	public List<SelectOption> pluscouOoptions { get; private set; }
	public List<CampaignMember> campaignMemberList { get; private set; }
	public Id campaignId { get; set; }
	private Map<ID, String> statusMap { private get; private set; }
	private List<CampaignMember> updateList {private get; private set;}


	public void init() {
		Date weekBefore = system.today() - 7;
		List<Campaign> campaignList = [SELECT Id, Name FROM Campaign WHERE SeminarStartDatetime__c >= :weekBefore order by Name];
		options = new List<SelectOption>();
		for (Campaign c : campaignList) {
			options.add(new SelectOption(c.Id, c.Name));
		}
	}

	public void search() {
		// campaignMemberList = [SELECT CompanyName__c, Lead.Name, Lead.Company, academy_status__c, Lead.Email, CategoryOfEmail__c, PluscouNecessity__c FROM CampaignMember WHERE Campaign.Id = :campaignId];
        campaignMemberList = [SELECT CompanyName__c, LeadOrContactName__c, academy_status__c, LeadOrContactEmail__c, CategoryOfEmail__c, PluscouNecessity__c FROM CampaignMember WHERE Campaign.Id = :campaignId];
		statusMap = new Map<ID, String>();
		for(CampaignMember cm : campaignMemberList) {
			statusMap.put(cm.Id, cm.academy_status__c);
		}

		DescribeFieldResult f = SObjectType.CampaignMember.fields.academy_status__c;
		List<PicklistEntry> entries = f.getPicklistValues();

		statusOoptions = new List<SelectOption>();
		statusOoptions.add(new SelectOption('', '--なし--'));
	    for (PicklistEntry e : entries) {
	        if (e.isActive()) {
	            statusOoptions.add(new SelectOption(e.getValue(), e.getLabel()));
	        }
	    }

	    f = SObjectType.CampaignMember.fields.CategoryOfEmail__c;
	    entries = f.getPicklistValues();

		categoryOoptions = new List<SelectOption>();
		categoryOoptions.add(new SelectOption('', '--なし--'));
	    for (PicklistEntry e : entries) {
	        if (e.isActive()) {
	            categoryOoptions.add(new SelectOption(e.getValue(), e.getLabel()));
	        }
	    }

	    f = SObjectType.CampaignMember.fields.PluscouNecessity__c;
	    entries = f.getPicklistValues();

		pluscouOoptions = new List<SelectOption>();
		pluscouOoptions.add(new SelectOption('', '--なし--'));
	    for (PicklistEntry e : entries) {
	        if (e.isActive()) {
	            pluscouOoptions.add(new SelectOption(e.getValue(), e.getLabel()));
	        }
	    }
	}

	public void save() {
		updateList = new List<CampaignMember>();
		for(CampaignMember cm : campaignMemberList) {
			updateList.add(cm);
		}
		if (updateList.size() > 0) {
			update updateList;
		}

		// アップデート後に、最新の状態を取得
		search();
	}
}