/**
 * TGR_ContactTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_ContactTrigger on Contact (before insert, before update, after insert, after update) {

    // トリガー起動制御
    if (!UTL_TriggerUtil.canRunContact) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunContact = true;
        }
        return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
        trigger.isDelete, trigger.new, trigger.old);
    List<Contact> tmpOldList = (List<Contact>) dto.oldList;
    List<Contact> tmpNewList = (List<Contact>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, Contact> tempOldMap;
    Map<Id, Contact> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, Contact>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, Contact>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, Contact>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, Contact>();
    }

    CON_ContactProcess conProcess = new CON_ContactProcess();

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
        // Emailドメイン抽出
        conProcess.extractEmailDomain(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
    }
    // before update
    if (trigger.isBefore && trigger.isUpdate) {
        // Emailドメイン抽出
        conProcess.extractEmailDomain(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
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
        UTL_TriggerUtil.canRunContact = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }

}