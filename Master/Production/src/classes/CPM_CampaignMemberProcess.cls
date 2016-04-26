/**
 * CPM_CampaignMemberProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class CPM_CampaignMemberProcess {

	/**
	 * 共通処理
	 * @param cpmNewList キャンペーンメンバーリスト(トリガー無効データ除くtrriger.new)
	 * @param cpmOldList キャンペーンメンバーリスト(トリガー無効データ除くtrriger.old)
	 * @param cpmNewMap  キャンペーンメンバーマップ(トリガー無効データ除くtrriger.newMap)
	 * @param cpmOldMap  キャンペーンメンバーマップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void commonProcess(List<CampaignMember> cpmNewList, List<CampaignMember> cpmOldList,
		Map<Id, CampaignMember> cpmNewMap, Map<Id, CampaignMember> cpmOldMap) {

		if (cpmNewList.isEmpty()) return;

		Map<String, Inbound_Trcd__c> trcdMap = new Map<String, Inbound_Trcd__c>();
		List<Inbound_Trcd__c> trcdList = [SELECT Trcd__c, InfluxRoute__c FROM Inbound_Trcd__c];
		for (Inbound_Trcd__c trcd : trcdList) {
			trcdMap.put(trcd.Trcd__c, trcd);
		}

		List<String> ledIdList = new List<String>();
		for (CampaignMember cpm : cpmNewList) {
			if (cpm.LeadId != null) {
				if (String.isNotBlank(cpm.LeadId)) {
					ledIdList.add(cpm.LeadId);
				}
			}
		}
		List<Lead> lds = null;
		Map<String, Lead> ledMap = new Map<String, Lead>();
		if (!ledIdList.isEmpty()) {
			ledMap = new Map<String, Lead>([SELECT Id, Inbound_Trcd__c, LeadSource FROM Lead WHERE Id IN :ledIdList]);
		}

		for (CampaignMember cpm : cpmNewList) {
			if (String.isNotBlank(cpm.LeadId)) {
				Lead led = ledMap.get(cpm.LeadId);
				if (led != null) {
					Inbound_Trcd__c trcd = trcdMap.get(led.Inbound_Trcd__c);
					if (trcd != null) {
						// 流入経路設定
						cpm.InfluxRoute__c = trcd.InfluxRoute__c;
					}
					cpm.LeadSource__c = led.LeadSource;
				}
			}
		}

	}

}