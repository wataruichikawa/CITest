/**
 * TGR_HuriwakeMasterTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_HuriwakeMasterTrigger on HuriwakeMaster__c (before insert, before update, after insert, after update) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunHuriwakeMaster) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunHuriwakeMaster = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<HuriwakeMaster__c> tmpOldList = (List<HuriwakeMaster__c>) dto.oldList;
	List<HuriwakeMaster__c> tmpNewList = (List<HuriwakeMaster__c>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, HuriwakeMaster__c> tempOldMap;
	Map<Id, HuriwakeMaster__c> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, HuriwakeMaster__c>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, HuriwakeMaster__c>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, HuriwakeMaster__c>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, HuriwakeMaster__c>();
	}

	HWM_HuriwakeMasterProcess hwmProcess = new HWM_HuriwakeMasterProcess();

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		// ロールID検証処理
		hwmProcess.validateRoleId(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
		// ロールID検証処理
		hwmProcess.validateRoleId(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
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
		UTL_TriggerUtil.canRunHuriwakeMaster = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}