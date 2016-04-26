/**
 * TGR_TaskTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
trigger TGR_TaskTrigger on Task (before insert, before update, after insert, after update) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunTask) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunTask = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<Task> tmpOldList = (List<Task>) dto.oldList;
	List<Task> tmpNewList = (List<Task>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, Task> tempOldMap;
	Map<Id, Task> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, Task>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, Task>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, Task>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, Task>();
	}

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		new CLS_TaskUpdateLogic().setResponsibleFlg(tmpNewList);
	}
	// before update
	if (trigger.isBefore && trigger.isUpdate) {
		new CLS_TaskUpdateLogic().setResponsibleFlg(tmpNewList);
	}
	// before delete
	if (trigger.isBefore && trigger.isDelete) {
	}
	// after insert
	if (trigger.isAfter && trigger.isInsert) {
		new ACC_AccountTaskUpdate().updateTaskInfo(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
		new ACC_AccountTaskUpdate().insertContactFromFinishedTask(tmpNewList, tempNewMap);
		//リード最新活動時間更新処理
		new LED_UpdateFromTaskToLead().leadUpdate(tmpNewList);

	}
	// after update
	if (trigger.isAfter && trigger.isUpdate) {
		new ACC_AccountTaskUpdate().updateTaskInfo(tmpNewList, tmpOldList, tempNewMap, tempOldMap);

	}
	// after delete
	if (trigger.isAfter && trigger.isDelete) {
	}

    // トリガー無効フラグ(FALSE)更新処理
	if(trigger.isAfter && !invalidList.isEmpty()) {
		UTL_TriggerUtil.canRunTask = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}