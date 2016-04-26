/**
 * OPP_OpportunityProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class OPP_OpportunityProcess {

	/**
	 * 共通処理
	 * @param oppNewList 商談リスト(トリガー無効データ除くtrriger.new)
	 * @param oppOldList 商談リスト(トリガー無効データ除くtrriger.old)
	 * @param oppNewMap  商談マップ(トリガー無効データ除くtrriger.newMap)
	 * @param oppOldMap  商談マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void commonProcess(List<Opportunity> oppNewList, List<Opportunity> oppOldList,
		Map<Id, Opportunity> oppNewMap, Map<Id, Opportunity> oppOldMap) {

		if (oppNewList.isEmpty()) return;

		Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
		Map<Id, User> userIdMap = (Map<Id, User>) umap.get(DAO_UserDao.MAP_KEY_ID);
		Map<Id, UserRole> roleMap = DAO_UserRoleDao.findUserRoleMap();

		for (Opportunity newOpp : oppNewList) {
			// 所有者、所有者ロール（テリトリー）、所有者ロール（部門）設定
			changeOwnerAndTerritory(newOpp, userIdMap, roleMap);
		}

	}

	/**
	 * 共通処理
	 * @param oppNewList 商談リスト(トリガー無効データ除くtrriger.new)
	 * @param oppOldList 商談リスト(トリガー無効データ除くtrriger.old)
	 * @param oppNewMap  商談マップ(トリガー無効データ除くtrriger.newMap)
	 * @param oppOldMap  商談マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void validatePriceBook2(List<Opportunity> oppNewList, List<Opportunity> oppOldList,
		Map<Id, Opportunity> oppNewMap, Map<Id, Opportunity> oppOldMap) {

		if (oppNewList.isEmpty()) return;
		List<Id> pb2IdList = new List<Id>();
		for (Opportunity opp : oppNewList) {
			if (opp.PriceBook2Id != null) {
				pb2IdList.add(opp.PriceBook2Id);
			}
		}
		if (!pb2IdList.isEmpty()) {
			Map<Id, Pricebook2> pb2Map = new Map<Id, Pricebook2>([SELECT Id, ProposedService__c FROM Pricebook2 WHERE Id IN : pb2IdList]);
			for (Opportunity opp : oppNewList) {
				if (opp.PriceBook2Id != null && pb2Map.containsKey(opp.PriceBook2Id)) {
					Pricebook2 pb2 = pb2Map.get(opp.PriceBook2Id);
					if (String.isNotBlank(opp.ProposedService__c) && String.isNotBlank(pb2.ProposedService__c)
						&& !opp.ProposedService__c.equals(pb2.ProposedService__c)) {
						opp.addError('ESS(CRS)商談にCRS(ESS)の価格表を選択することはできません。');
					}
				}
			}
		}
	}

	/**
	 * DRCアカウントマネージメントアラート非同期受付
	 * @param oppNewList 商談リスト(トリガー無効データ除くtrriger.new)
	 * @param oppOldList 商談リスト(トリガー無効データ除くtrriger.old)
	 * @param oppNewMap  商談マップ(トリガー無効データ除くtrriger.newMap)
	 * @param oppOldMap  商談マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void targetAccountManagement(List<Opportunity> oppNewList, List<Opportunity> oppOldList,
		Map<Id, Opportunity> oppNewMap, Map<Id, Opportunity> oppOldMap) {

		if (oppNewList.isEmpty()) return;

		Set<Id> accManageList = new Set<Id>();
		for (Opportunity newOpp : oppNewList) {
			if (newOpp.UseStartProgressDate__c != null || newOpp.UseEndDate30Ago__c != null || newOpp.FirstInterview__c
				|| newOpp.FirstUnofficially__c || newOpp.FirstDecision__c || newOpp.JobNotCreated10__c || newOpp.ListNonEaluation14__c
				|| newOpp.PurasukaNonReply7__c || newOpp.InterviewUnadjusted7__c || newOpp.Undecided33__c) {
				accManageList.add(newOpp.Id);
			}
		}

		if (!accManageList.isEmpty()) {
			// 非同期実行
			ACC_DrcAccountManagement.alertDrcAccountManagement(accManageList);
		}

	}

	/**
	 * 所有者・テリトリー設定処理
	 * @param newOpp 商談(new)
	 * @param userIdMap ユーザマップ（キー：ID）
	 * @param roleMap ロールマップ
	 */
	private void changeOwnerAndTerritory(Opportunity newOpp, Map<Id, User> userIdMap, Map<Id, UserRole> roleMap) {

		String oId = newOpp.OwnerId;
		String visitId = newOpp.VisitChargeUser__c;

		User user = userIdMap.get(visitId);
		UserRole ur = null;
		String vId = null;
		if (user != null) {
			ur = roleMap.get(user.UserRoleId);
			vId = user.Id;
		}
		system.debug('***** oId:'+oId+' vId:'+vId);
		// 所有者変更
		if (String.isNotBlank(vId) && !vId.equals(oId)) {
			newOpp.OwnerId = vId;
		} else {
			if (String.isNotBlank(visitId) && String.isBlank(vId)) {
				system.debug('***** visitId:' + visitId + ' vId:' + vId);
				newOpp.VisitChargeUser__c = null;
				newOpp.OwnerRoleTerritory__c = null;
				newOpp.OwnerRoleDepartment__c = null;
			}
			user = userIdMap.get(oId);
			if (user == null) {
				newOpp.OwnerId = UserInfo.getUserId();
				ur = roleMap.get(UserInfo.getUserRoleId());
			}
		}

		if (ur != null && !ur.RollupDescription.equals(newOpp.OwnerRoleTerritory__c)) {
			// 所有者ロール（テリトリー）変更
			newOpp.OwnerRoleTerritory__c = ur.RollupDescription;
			String parentUrid = ur.ParentRoleId;
			if (String.isNotBlank(parentUrid)) {
				ur = roleMap.get(parentUrid);
				if (ur != null && !ur.RollupDescription.equals(newOpp.OwnerRoleDepartment__c)) {
					// 所有者ロール（部門）変更
					newOpp.OwnerRoleDepartment__c = ur.RollupDescription;
				}
			}
		}

	}

}