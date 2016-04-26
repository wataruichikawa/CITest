/**
 * FEI_FeedItemProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public without sharing class FEI_FeedItemProcess {

	/**
	 * 取引先組織図登録日更新
	 * @param feiNewList FeedItemリスト(trriger.new)
	 * @param feiOldList FeedItemリスト(trriger.old)
	 * @param feiNewMap  FeedItemマップ(trriger.newMap)
	 * @param feiOldMap  FeedItemマップ(trriger.oldMap)
	 */
	public void updateAccountOrganizationChart(List<FeedItem> feiNewList,
		List<FeedItem> feiOldList, Map<Id, FeedItem> feiNewMap, Map<Id, FeedItem> feiOldMap) {

		List<Account> accList = new List<Account>();
		String keyPrefix = Account.SObjectType.getDescribe().getKeyPrefix();
		List<String> extList = Test.isRunningTest() ? new String[] { 'jpg', 'png' } : System.Label.FEI_ImageExtensions.split(',', 0);
		Map<String, String> extMap = new Map<String, String>();
		for (String ext : extList) {
			extMap.put(ext.toLowerCase(), ext);
		}
		Date sysDate = System.today();

		for (FeedItem fei : feiNewList) {
			if ('ContentPost'.equals(fei.Type) && String.valueOf(fei.ParentId).startsWith(keyPrefix)
				&& extMap.containsKey(UTL_StringUtil.getExtension(fei.ContentFileName).toLowerCase())) {
				accList.add(new Account(Id = fei.ParentId, TriggerInvalid__c = true));
			}
		}

		if (!accList.isEmpty()) {
			update accList;
		}

	}
}