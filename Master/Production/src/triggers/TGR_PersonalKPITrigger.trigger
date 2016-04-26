/**
 * TGR_PersonalKPITrigger
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_PersonalKPITrigger on PersonalKPI__c (before insert, after insert) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunPersonalKPI) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunPersonalKPI = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<PersonalKPI__c> tmpOldList = (List<PersonalKPI__c>) dto.oldList;
	List<PersonalKPI__c> tmpNewList = (List<PersonalKPI__c>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, PersonalKPI__c> tempOldMap;
	Map<Id, PersonalKPI__c> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, PersonalKPI__c>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, PersonalKPI__c>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, PersonalKPI__c>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, PersonalKPI__c>();
	}

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		// 個人別KPI共通処理
		new KPI_PersonalKPIProcess().commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
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
		UTL_TriggerUtil.canRunPersonalKPI = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}