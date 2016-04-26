/**
 * TGR_FeedItemTrigger
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_FeedItemTrigger on FeedItem (after insert) {

	//FeedItemには項目追加できないのでトリガー無効フラグの処理は実行しない
	List<FeedItem> tmpOldList = Trigger.old;
	List<FeedItem> tmpNewList = Trigger.new;
	Map<Id, FeedItem> tempOldMap = Trigger.oldMap;
	Map<Id, FeedItem> tempNewMap = Trigger.newMap;

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
	}
	// before delete
	if (trigger.isBefore && trigger.isDelete) {
	}
	// after insert
	if (trigger.isAfter && trigger.isInsert) {
		new FEI_FeedItemProcess().updateAccountOrganizationChart(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// after update
	if (trigger.isAfter && trigger.isUpdate) {
	}
	// after delete
	if (trigger.isAfter && trigger.isDelete) {
	}

}