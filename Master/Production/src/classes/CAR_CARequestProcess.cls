/**
 * CAR_CARequestProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class CAR_CARequestProcess {

	/**
	 * 元担当設定処理
	 * @param carNewList CA依頼リスト(トリガー無効データ除くtrriger.new)
	 * @param carOldList CA依頼リスト(トリガー無効データ除くtrriger.old)
	 * @param carNewMap  CA依頼マップ(トリガー無効データ除くtrriger.newMap)
	 * @param carOldMap  CA依頼マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void setMotoTantou(List<CARequest__c> carNewList, List<CARequest__c> carOldList,
		Map<Id, CARequest__c> carNewMap, Map<Id, CARequest__c> carOldMap) {

		if (carNewList.isEmpty()) return;

		boolean insFlg = carOldMap.isEmpty() ? true : false;

		if (insFlg) {
			for (CARequest__c car : carNewList) {
				car.MotoTantouCA__c = car.User__c;
			}
		} else {
			for (CARequest__c car : carNewList) {
				if (carOldMap.containsKey(car.Id)) {
					car.MotoTantouCA__c = carOldMap.get(car.Id).User__c;
				}
			}
		}

	}

}