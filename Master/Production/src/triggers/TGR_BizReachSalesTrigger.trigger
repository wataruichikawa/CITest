/**
 * TGR_BizReachSalesTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_BizReachSalesTrigger on BizReachSales__c (before insert, before update, after insert, after update) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunBizReachSales) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunBizReachSales = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<BizReachSales__c> tmpOldList = (List<BizReachSales__c>) dto.oldList;
	List<BizReachSales__c> tmpNewList = (List<BizReachSales__c>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, BizReachSales__c> tempOldMap;
	Map<Id, BizReachSales__c> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, BizReachSales__c>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, BizReachSales__c>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, BizReachSales__c>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, BizReachSales__c>();
	}

	BRS_BizReachSalesProcess brsProcess = new BRS_BizReachSalesProcess();

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		// BizReach売上共通処理
		brsProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
		// BizReach売上共通処理
		brsProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before delete
	if (trigger.isBefore && trigger.isDelete) {
	}
	// after insert
	if (trigger.isAfter && trigger.isInsert) {
	}
	// after update
	if (trigger.isAfter && trigger.isUpdate) {
	}
	// after delete
	if (trigger.isAfter && trigger.isDelete) {
	}

    // トリガー無効フラグ(FALSE)更新処理
	if(trigger.isAfter && !invalidList.isEmpty()) {
		UTL_TriggerUtil.canRunBizReachSales = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}