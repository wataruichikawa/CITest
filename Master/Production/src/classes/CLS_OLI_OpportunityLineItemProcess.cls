/**
 * ACC_AccountProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public with sharing class CLS_OLI_OpportunityLineItemProcess {

	/**
	 * 共通処理
	 * @param oliNewList 商談商品リスト(トリガー無効データ除くtrriger.new)
	 * @param oliOldList 商談商品リスト(トリガー無効データ除くtrriger.old)
	 * @param oliNewMap  商談商品マップ(トリガー無効データ除くtrriger.newMap)
	 * @param oliOldMap  商談商品マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void commonProcess(List<OpportunityLineItem> oliNewList, List<OpportunityLineItem> oliOldList,
		Map<Id, OpportunityLineItem> oliNewMap, Map<Id, OpportunityLineItem> oliOldMap) {

		if (oliNewList.isEmpty()) return;

		Set<Id> oppIdList = new Set<Id>();
		Map<Id, List<OpportunityLineItem>> oliMap = new Map<Id, List<OpportunityLineItem>>();
		//トリガー分のレコードをマップに追加
		for (OpportunityLineItem oli : oliNewList) {
			if (!'オプション'.equals(oli.HirePlanCategory__c) && !'プラスカ'.equals(oli.HirePlanCategory__c)) {
				oppIdList.add(oli.OpportunityId);
				if (oliMap.containsKey(oli.OpportunityId)) {
					oliMap.get(oli.OpportunityId).add(oli);
				} else {
					oliMap.put(oli.OpportunityId, new OpportunityLineItem[] { oli });
				}
			}
		}

		//登録済みのレコードをマップに追加
		List<OpportunityLineItem> oliList = [SELECT Id, OpportunityId, Service__c, HirePlanCategory__c FROM OpportunityLineItem WHERE OpportunityId IN : oppIdList AND HirePlanCategory__c != 'オプション' AND HirePlanCategory__c != 'プラスカ'];
		for (OpportunityLineItem oli : oliList) {
			if (oliMap.containsKey(oli.OpportunityId)) {
				oliMap.get(oli.OpportunityId).add(oli);
			}
		}

		for (OpportunityLineItem oli : oliNewList) {
			if (!'オプション'.equals(oli.HirePlanCategory__c) && !'プラスカ'.equals(oli.HirePlanCategory__c)
				&& oliMap.containsKey(oli.OpportunityId)) {
				Map<String, OpportunityLineItem> serviceMap = new Map<String, OpportunityLineItem>();
				for (OpportunityLineItem checkOli : oliMap.get(oli.OpportunityId)) {
					System.debug(' checkOli : ' + checkOli.Service__c);
					if (serviceMap.containsKey(checkOli.Service__c)) {
						oli.addError('同一サービスで固定・成果報酬・特別プランの重複、及び同時に選択する事はできません。');
					} else {
						serviceMap.put(checkOli.Service__c, checkOli);
					}
				}
			}
			if (String.isNotBlank(oli.Service__c) && oli.Service__c.contains('RS')) {
				oli.RsFlag__c = true;
			}
		}

	}

}