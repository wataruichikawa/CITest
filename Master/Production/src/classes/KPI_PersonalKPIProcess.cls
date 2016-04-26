/**
 * KPI_PersonalKPIProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class KPI_PersonalKPIProcess {

	/**
	 * 共通処理
	 * @param kpiNewList 個人別KPIリスト(トリガー無効データ除くtrriger.new)
	 * @param kpiOldList 個人別KPIリスト(トリガー無効データ除くtrriger.old)
	 * @param kpiNewMap  個人別KPIマップ(トリガー無効データ除くtrriger.newMap)
	 * @param kpiOldMap  個人別KPIマップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void commonProcess(List<PersonalKPI__c> kpiNewList, List<PersonalKPI__c> kpiOldList,
		Map<Id, PersonalKPI__c> kpiNewMap, Map<Id, PersonalKPI__c> kpiOldMap) {

		if (kpiNewList.isEmpty()) return;

		Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
		Map<Id, User> userIdMap = (Map<Id, User>) umap.get(DAO_UserDao.MAP_KEY_ID);
		Map<String, User> userNameMap = (Map<String, User>) umap.get(DAO_UserDao.MAP_KEY_NAME);

		for (PersonalKPI__c kpi : kpiNewList) {
			if (String.isBlank(kpi.Yojitsukubun__c)) {
				kpi.Yojitsukubun__c = '実績';
			}
			User tmepUser =  userNameMap.get(kpi.SyozokuTantouText__c);
			if (tmepUser != null) {
				if (String.isBlank(kpi.Syozokutantou__c)) {
					kpi.Syozokutantou__c = tmepUser.Id;
				}
				if (String.isBlank(kpi.SyozokuTantouTeam__c)) {
					kpi.SyozokuTantouTeam__c = tmepUser.userRole.RollupDescription;
				}
				if (String.isBlank(kpi.Profile__c)) {
					kpi.Profile__c = tmepUser.profile.Name;
				}
				if (kpi.OwnerId != tmepUser.Id) {
					kpi.OwnerId = tmepUser.Id;
				}
			}
		}

	}

}