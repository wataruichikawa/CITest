/**
 * TST_TGR_CampaignMemberTrigger
 *
 * テスト対象
 * 1.TGR_CampaignMemberTrigger
 * 2.CPM_CampaignMemberProcess
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_CampaignMemberTrigger {

	static testMethod void test() {
		List<RecordType> rts = [select SobjectType, NamespacePrefix, Name, LastModifiedDate, LastModifiedById, Id, DeveloperName, Description, BusinessProcessId from RecordType where name = '人材採用塾'];
		Campaign cp = new Campaign(name = 'Campaign', RecordType = rts[0], Type = '人材採用塾');
		Campaign cp2 = new Campaign(name = 'Campaign2', RecordType = rts[0], Type = '人材採用塾');
		insert cp;
		insert cp2;

		Lead led1 = new Lead(Company = '株式会社山本テスト', state = '東京都', city = '千代田区', lastName = '山本', firstName = '雄二', status = '新規', email = 'yamamoto1@sutead.com', LeadSource = '人材採用塾', Inbound_Trcd__c = '00001', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
		Lead led2 = new Lead(Company = '株式会社山本テスト', state = '東京都', city = '千代田区', lastName = '山本', firstName = '雄三', status = '新規', email = 'yamamoto2@sutead.com', LeadSource = '人材採用塾', Inbound_Trcd__c = '00001', mkto2__Lead_Score__c = 100);
		List<Lead> ledList = new Lead[] { led1, led2 };
		insert ledList;

		//CampaignMember cpm = new CampaignMember(CampaignId = cp2.Id, LeadId = led1.id, SQLFlag__c = true, EmailIndexKey__c = 'yamamoto1@sutead.com');
		CampaignMember cpm = new CampaignMember(CampaignId = cp2.Id, LeadId = led1.id, SQLFlag__c = true);
		insert cpm;

		Inbound_Trcd__c trcd = new Inbound_Trcd__c(Trcd__c = '00001', InfluxRoute__c = 'ビズリーチ', Campaign__c = cp.Id);
		insert trcd;

		CampaignMember cpm1 = new CampaignMember(CampaignId = cp.Id, LeadId = led1.id);
		CampaignMember cpm2 = new CampaignMember(CampaignId = cp.Id, LeadId = led2.id);
		List<CampaignMember> cpmList = new CampaignMember[] { cpm1, cpm2 };

		Test.startTest();
		insert cpmList;
		cpm1.TriggerInvalid__c = true;
		update cpmList;
		Test.stopTest();
		system.assert(![SELECT Id, TriggerInvalid__c FROM CampaignMember WHERE Id = :cpm1.Id].TriggerInvalid__c);
    }
}