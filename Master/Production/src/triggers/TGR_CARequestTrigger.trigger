/**
 * TGR_CARequestTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_CARequestTrigger on CARequest__c (before insert, before update, after insert, after update) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunCARequest) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunCARequest = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<CARequest__c> tmpOldList = (List<CARequest__c>) dto.oldList;
	List<CARequest__c> tmpNewList = (List<CARequest__c>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, CARequest__c> tempOldMap;
	Map<Id, CARequest__c> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, CARequest__c>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, CARequest__c>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, CARequest__c>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, CARequest__c>();
	}

	CAR_CARequestProcess carProcess = new CAR_CARequestProcess();

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		// 元担当設定
		carProcess.setMotoTantou(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
		// 元担当設定
		carProcess.setMotoTantou(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before delete
	if (trigger.isBefore && trigger.isDelete) {
	}
	// after insert
	if (trigger.isAfter && trigger.isInsert) {
		new ACC_UpdateTegamiFromCA().updateTegamiDate(tmpNewList);
	}
	// after update
	if (trigger.isAfter && trigger.isUpdate) {
		new ACC_UpdateTegamiFromCA().updateTegamiDate(tmpNewList);
	}
	// after delete
	if (trigger.isAfter && trigger.isDelete) {
	}

    // トリガー無効フラグ(FALSE)更新処理
	if(trigger.isAfter && !invalidList.isEmpty()) {
		UTL_TriggerUtil.canRunCARequest = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}