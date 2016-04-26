/**
 * HWM_HuriwakeMasterProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class HWM_HuriwakeMasterProcess {

	/**
	 * ロールID、インバウンドロールID検証処理
	 * @param hwmNewList 振り分けマスタリスト(トリガー無効データ除くtrriger.new)
	 * @param hwmOldList 振り分けマスタリスト(トリガー無効データ除くtrriger.old)
	 * @param hwmNewMap  振り分けマスタマップ(トリガー無効データ除くtrriger.newMap)
	 * @param hwmOldMap  振り分けマスタマップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void validateRoleId(List<Huriwakemaster__c> hwmNewList, List<Huriwakemaster__c> hwmOldList,
		Map<Id, Huriwakemaster__c> hwmNewMap, Map<Id, Huriwakemaster__c> hwmOldMap) {

		if (hwmNewList.isEmpty()) return;

		// 振り分けマスタにあるロールIDを収集する
		Set<String> roleIdSet = new Set<String>();
		for(Huriwakemaster__c hwm : hwmNewList){
			roleIdSet.add(hwm.RoleID__c);
			roleIdSet.add(hwm.InboundRoleId__c);
		}

		// RoleID__cを元に、UserRoleを検索
		Map<Id, UserRole> roleMap = DAO_UserRoleDao.findUserRoleMap(roleIdSet);

		// IDに変換できない、該当するRoleIDが存在しない場合、エラー
		Id roleId;
		Id inboundRoleId;
		for(Huriwakemaster__c hwm : hwmNewList){
			try {
				roleId = Id.valueOf(hwm.RoleID__c);
				inboundRoleId = Id.valueOf(hwm.InboundRoleId__c);
				if (!roleMap.containsKey(roleId) || !roleMap.containsKey(inboundRoleId)) {
					hwm.adderror(system.label.HuriwakeMasterErrorMessage);
				}
			} catch (Exception e) {
				hwm.adderror(system.label.HuriwakeMasterErrorMessage);
			}
		}

	}

}