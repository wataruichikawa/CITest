/**
 * CHA_ChatterFollow
 * ユーザモードの場合、他人のフォローを登録できないのでシステムモードで実行
 * 取引先を自動フォローするユーザ参照項目
 * CRS_担当営業 | CRS_担当運用 | CRS_前工程開拓担当者 | CRS_BOSプランナー | CT_担当営業 | CT_担当運用 | CT_前工程開拓担当者 | CT_BOS担当
 * 商談を自動フォローするユーザ参照項目
 * ★訪問・対応予定者 | BCS担当（BCS入力）
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public without sharing class CHA_ChatterFollow {

	/**
	 * AccountTriggerでAfter Insert時にオブジェクトフォローを登録する
	 * @param accList Trigger.new
	 * @param accMap Trigger.newMap
	 */
	public void insertFollowAccount(List<Account> accList, Map<Id, Account> accMap) {

		if (accList.isEmpty()) return;

		Map<String, EntitySubscription> followMap = new Map<String, EntitySubscription>();

		for (Account acc : accList) {
			putEntitySubscription(followMap, acc.Id, acc.CrsSales_RepresentativeMain__c);
			putEntitySubscription(followMap, acc.Id, acc.CrsSale_Representative__c);
			putEntitySubscription(followMap, acc.Id, acc.CRS_MaeTantousya__c);
			putEntitySubscription(followMap, acc.Id, acc.CRS_BOSPlanner__c);
			putEntitySubscription(followMap, acc.Id, acc.careertreck_sales_representative__c);
			putEntitySubscription(followMap, acc.Id, acc.careertreck_representativeUser__c);
			//項目削除によるコメントアウト
			//putEntitySubscription(followMap, acc.Id, acc.CT_MaeTantousya__c);
			putEntitySubscription(followMap, acc.Id, acc.CTBOSTantou__c);
		}
		if (!followMap.isEmpty()) {
			confirmUserAndInsert(followMap);
		}

	}

	/**
	 * AccountTriggerでAfter Update時にオブジェクトフォローを登録する
	 * @param accNewList Trigger.new
	 * @param accNewMap Trigger.newMap
	 * @param accOldList Trigger.old
	 * @param accOldMap Trigger.oldMap
	 */
	public void updateFollowAccount(List<Account> accNewList, Map<Id, Account> accNewMap,
		List<Account> accOldList, Map<Id, Account> accOldMap) {

		if (accNewList.isEmpty()) return;

		Map<String, EntitySubscription> followMap = new Map<String, EntitySubscription>();
		List<String> unfollowKeyList = new List<String>();
		Map<String, EntitySubscription> remainMap = new Map<String, EntitySubscription>();
		List<Id> followList = new List<Id>();
		List<Id> unfollowList = new List<Id>();
		List<Id> remainList = new List<Id>();

		for (Account newAcc : accNewList) {
			Account oldAcc = accOldMap.get(newAcc.Id);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.CrsSales_RepresentativeMain__c, oldAcc.CrsSales_RepresentativeMain__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.CrsSale_Representative__c, oldAcc.CrsSale_Representative__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.CRS_MaeTantousya__c, oldAcc.CRS_MaeTantousya__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.CRS_BOSPlanner__c, oldAcc.CRS_BOSPlanner__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.careertreck_sales_representative__c, oldAcc.careertreck_sales_representative__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.careertreck_representativeUser__c, oldAcc.careertreck_representativeUser__c);
			//項目削除によるコメントアウト
			//followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				//newAcc.CT_MaeTantousya__c, oldAcc.CT_MaeTantousya__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newAcc.Id,
				newAcc.CTBOSTantou__c, oldAcc.CTBOSTantou__c);
		}

		unfollow(unfollowKeyList, unfollowList, followMap, remainMap);
		follow(followMap, followList, remainMap, remainList);

	}

	/**
	 * OpportunityTriggerでAfter Insert時にオブジェクトフォローを登録する
	 * @param oppList Trigger.new
	 * @param oppMap Trigger.newMap
	 */
	public void insertFollowOpportunity(List<Opportunity> oppList, Map<Id, Opportunity> oppMap) {

		if (oppList.isEmpty()) return;

		Map<String, EntitySubscription> followMap = new Map<String, EntitySubscription>();

		for (Opportunity opp : oppList) {
			putEntitySubscription(followMap, opp.Id, opp.VisitChargeUser__c);
			putEntitySubscription(followMap, opp.Id, opp.BCS__c);
		}
		if (!followMap.isEmpty()) {
			confirmUserAndInsert(followMap);
		}

	}

	/**
	 * OpportunityTriggerでAfter Update時にオブジェクトフォローを登録する
	 * @param oppNewList Trigger.new
	 * @param oppNewMap Trigger.newMap
	 * @param oppOldList Trigger.old
	 * @param oppOldMap Trigger.oldMap
	 */
	public void updateFollowOpportunity(List<Opportunity> oppNewList, Map<Id, Opportunity> oppNewMap,
		List<Opportunity> oppOldList, Map<Id, Opportunity> oppOldMap) {

		if (oppNewList.isEmpty()) return;

		Map<String, EntitySubscription> followMap = new Map<String, EntitySubscription>();
		List<String> unfollowKeyList = new List<String>();
		Map<String, EntitySubscription> remainMap = new Map<String, EntitySubscription>();
		List<Id> followList = new List<Id>();
		List<Id> unfollowList = new List<Id>();
		List<Id> remainList = new List<Id>();

		for (Opportunity newOpp : oppNewList) {
			Opportunity oldOpp = oppOldMap.get(newOpp.Id);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newOpp.Id,
				newOpp.VisitChargeUser__c, oldOpp.VisitChargeUser__c);
			followSetting(followMap, unfollowKeyList, followList, unfollowList, remainMap, remainList, newOpp.Id,
				newOpp.BCS__c, oldOpp.BCS__c);
		}

		unfollow(unfollowKeyList, unfollowList, followMap, remainMap);
		follow(followMap, followList, remainMap, remainList);

	}

	/**
	 * ユーザ参照項目がnullでない場合にMapに設定
	 * @param esMap EntitySubscriptionマップ
	 * @param pId オブジェクトID
	 * @param subId ユーザID
	 */
	private void putEntitySubscription(Map<String, EntitySubscription> esMap, Id pId, Id subId) {
		if (String.isNotEmpty(subId)) {
			esMap.put(String.valueOf(pId) + String.valueOf(subId),
			new EntitySubscription(ParentId = pId, SubscriberId = subId));
		}
	}

	/**
	 * Update時にフォローするか、フォロー解除するかを判別
	 * @param followMap フォロー登録用マップ
	 * @param unfollowKeyList フォロー解除用リスト(オブジェクトID+ユーザID)
	 * @param followList フォロー登録用リスト(オブジェクトID)
	 * @param unfollowList フォロー解除用リスト(オブジェクトID)
	 * @param remainMap フォロー変更なしマップ
	 * @param remainList フォロー変更なしリスト(オブジェクトID)
	 * @param pId オブジェクトID
	 * @param newId ユーザID変更後
	 * @param oldId ユーザID変更前
	 */
	private void followSetting(Map<String, EntitySubscription> followMap, List<String> unfollowKeyList,
		List<Id> followList, List<Id> unfollowList, Map<String, EntitySubscription> remainMap, List<Id> remainList,
		Id pId, Id newId, Id oldId) {
		if (String.isNotBlank(newId)) {
			if (String.isNotBlank(oldId)) {
				if (newId != oldId) {
					//new != null && old != null && new != old の場合、newをフォロー、oldをフォロー解除
					followMap.put(String.valueOf(pId) + String.valueOf(newId),
						new EntitySubscription(ParentId = pId, SubscriberId = newId));
					followList.add(pId);
					unfollowKeyList.add(String.valueOf(pId) + String.valueOf(oldId));
					unfollowList.add(pId);
				} else {
					//変更がない場合はフォロー解除しない
					remainMap.put(String.valueOf(pId) + String.valueOf(newId),
						new EntitySubscription(ParentId = pId, SubscriberId = newId));
					remainList.add(pId);
				}
			} else {
				//new != null && old == null の場合、newをフォロー
				followMap.put(String.valueOf(pId) + String.valueOf(newId),
					new EntitySubscription(ParentId = pId, SubscriberId = newId));
				followList.add(pId);
			}
		} else {
			if (String.isNotBlank(oldId)) {
				//new == null && old != null の場合、oldをフォロー解除
				unfollowKeyList.add(String.valueOf(pId) + String.valueOf(oldId));
				unfollowList.add(pId);
			}
		}
	}

	/**
	 * フォロー解除
	 * @param unfollowKeyList フォロー解除用リスト(オブジェクトID+ユーザID)
	 * @param unfollowList フォロー解除用リスト(オブジェクトID)
	 * @param followMap フォロー登録用マップ
	 * @param remainMap フォロー変更なしマップ
	 */
	private void unfollow(List<String> unfollowKeyList, List<Id> unfollowList,
		Map<String, EntitySubscription> followMap, Map<String, EntitySubscription> remainMap) {
		if (!unfollowKeyList.isEmpty()) {
			List<EntitySubscription> unEsList = [Select Id, ParentId, SubscriberId From EntitySubscription
				Where ParentId IN :unfollowList order by ParentId, SubscriberId limit 1000];
			if (!unEsList.isEmpty()) {
				Map<String, EntitySubscription> deleteMap = new Map<String, EntitySubscription>();
				for (EntitySubscription des : unEsList) {
					deleteMap.put(String.valueOf(des.ParentId) + String.valueOf(des.SubscriberId), des);
				}
				Map<String, EntitySubscription> deleteEsMap = new Map<String, EntitySubscription>();
				//フォロー解除ユーザのデータが存在し、変更なしユーザ・フォロー対象ユーザに存在しない場合にフォロー解除
				for (String dkey : unfollowKeyList) {
					if (deleteMap.containsKey(dkey) && !remainMap.containsKey(dkey) && !followMap.containsKey(dkey)) {
						deleteEsMap.put(dkey, deleteMap.get(dkey));
					}
				}
				if (!deleteEsMap.isEmpty()) {
					delete deleteEsMap.values();
				}
			}
		}
	}

	/**
	 * フォロー登録
	 * @param followMap フォロー登録用マップ
	 * @param followList フォロー登録用リスト(オブジェクトID)
	 * @param remainMap フォロー変更なしマップ
	 * @param remainList フォロー変更なしリスト(オブジェクトID)
	 */
	private void follow(Map<String, EntitySubscription> followMap, List<Id> followList,
		Map<String, EntitySubscription> remainMap, List<Id> remainList) {
		Map<String, EntitySubscription> insertMap = new Map<String, EntitySubscription>();
		if (!followMap.isEmpty()) {
			List<EntitySubscription> esList = [Select Id, ParentId, SubscriberId From EntitySubscription
			    Where ParentId IN :followList order by ParentId, SubscriberId limit 1000];
			if (!esList.isEmpty()) {
				Map<String, EntitySubscription> existMap = new Map<String, EntitySubscription>();
				for (EntitySubscription ies : esList) {
					existMap.put(String.valueOf(ies.ParentId) + String.valueOf(ies.SubscriberId), ies);
				}
				//フォロー対象でデータに存在しない場合にフォロー登録
				for (String ikey : followMap.keySet()) {
					if (!existMap.containsKey(ikey)) {
						insertMap.put(ikey, followMap.get(ikey));
					}
				}
			} else {
				//フォロー対象でデータに存在しない場合にフォロー登録
				for (String ikey : followMap.keySet()) {
					insertMap.put(ikey, followMap.get(ikey));
				}
			}
		}
		if (!remainMap.isEmpty()) {
			List<EntitySubscription> esList = [Select Id, ParentId, SubscriberId From EntitySubscription
			    Where ParentId IN :remainList order by ParentId, SubscriberId limit 1000];
			if (!esList.isEmpty()) {
				Map<String, EntitySubscription> existMap = new Map<String, EntitySubscription>();
				for (EntitySubscription ies : esList) {
					existMap.put(String.valueOf(ies.ParentId) + String.valueOf(ies.SubscriberId), ies);
				}
				//フォロー変更なしでデータに存在しない場合にフォロー登録(ユーザが自分でフォロー解除した時の対応)
				for (String ikey : remainMap.keySet()) {
					if (!existMap.containsKey(ikey)) {
						insertMap.put(ikey, remainMap.get(ikey));
					}
				}
			} else {
				//フォロー変更なしでデータに存在しない場合にフォロー登録(ユーザが自分でフォロー解除した時の対応)
				for (String ikey : remainMap.keySet()) {
					insertMap.put(ikey, remainMap.get(ikey));
				}
			}
		}
		if (!insertMap.isEmpty()) {
			confirmUserAndInsert(insertMap);
		}
	}

	/**
	 * ユーザが有効か確認し、有効のユーザのみフォローを登録
	 * @param esMap フォロー登録用マップ
	 * @param userList ユーザリスト(フォロー対象のユーザ)
	 */
	private void confirmUserAndInsert(Map<String, EntitySubscription> esMap) {
		List<Id> userIdList = new List<Id>();
		for (EntitySubscription es : esMap.values()) {
			userIdList.add(es.SubscriberId);
		}
		Map<Id, User> activeUserMap = new Map<Id, User>([SELECT Id FROM User WHERE isActive = true AND Id IN :userIdList]);
		if (!activeUserMap.isEmpty()) {
			List<EntitySubscription> insertList = new List<EntitySubscription>();
			for (EntitySubscription es : esMap.values()) {
				if (activeUserMap.containsKey(es.SubscriberId)) {
					insertList.add(es);
				}
			}
			if (!insertList.isEmpty()) {
				try {
					insert insertList;
				} catch (system.DMLException e) {
					String body = 'Error EntitySubscription Data\n\nParentId\tSubscriberId\n';
					for (EntitySubscription err : insertList) {
						body = body + err.ParentId + '\t' + err.SubscriberId + '\n';
					}
					UTL_EmailUtil.sendSystemErrorMail(e, 'Chatter Follow Error', body);
				}
			}
		}
	}

}