/**
 * TGR_CaseTrigger
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
 trigger TGR_CaseTrigger on Case (before insert, before update, before delete, after insert, after update) {

    if (!UTL_TriggerUtil.canRunCase) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunCase = true;
        }
        return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    List<Case> tmpOldList = (List<Case>) dto.oldList;
    List<Case> tmpNewList = (List<Case>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, Case> tempOldMap;
    Map<Id, Case> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, Case>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, Case>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, Case>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, Case>();
    }

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
    }
    // before update
    if (trigger.isBefore && trigger.isUpdate) {
        CLS_CAS_SendMail mail = new CLS_CAS_SendMail();
        mail.sendUpdated(tmpOldList, tmpNewList, tempOldMap, tempNewMap);
    }
    // before delete
    if (trigger.isBefore && trigger.isDelete) {
    }
    // after insert
    if (trigger.isAfter && trigger.isInsert) {
        CLS_CAS_SendMail mail = new CLS_CAS_SendMail();
        mail.sendRegistered(tmpOldList, tmpNewList, tempOldMap, tempNewMap);
    }
    // after update
    if (trigger.isAfter && trigger.isUpdate) {
    }
    // after delete
    if (trigger.isAfter && trigger.isDelete) {
    }

    // トリガー無効フラグ(FALSE)更新処理
    if(trigger.isAfter && !invalidList.isEmpty()) {
        UTL_TriggerUtil.canRunCase = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }
}