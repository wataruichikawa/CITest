/**
 * TGR_JyukouKanriTrigger
 * ----------------------------------------
 * @createdName      : S.Sogawa
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_JyukouKanriTrigger on JyukouKanri__c (before insert, before update, after insert, after update) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunJyukouKanri) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunJyukouKanri = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<JyukouKanri__c> tmpOldList = (List<JyukouKanri__c>) dto.oldList;
	List<JyukouKanri__c> tmpNewList = (List<JyukouKanri__c>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, JyukouKanri__c> tempOldMap;
	Map<Id, JyukouKanri__c> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, JyukouKanri__c>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, JyukouKanri__c>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, JyukouKanri__c>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, JyukouKanri__c>();
	}

	JKK_JyukouKanriProcess jkkProcess = new JKK_JyukouKanriProcess();

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		// 受講管理共通処理
		jkkProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
		// 受講管理共通処理
		jkkProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
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
		UTL_TriggerUtil.canRunJyukouKanri = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}