/**
 * TGR_LeadTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_LeadTrigger on Lead (before insert, before update, after insert, after update) {

    // トリガー起動制御
    if (!UTL_TriggerUtil.canRunLead) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunLead = true;
        }
        return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
        trigger.isDelete, trigger.new, trigger.old);
    List<Lead> tmpOldList = (List<Lead>) dto.oldList;
    List<Lead> tmpNewList = (List<Lead>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, Lead> tempOldMap;
    Map<Id, Lead> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, Lead>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, Lead>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, Lead>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, Lead>();
    }

    LED_LeadProcess ledProcess = new LED_LeadProcess();

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
        // リード分類・所有者振り分け処理
        ledProcess.divideCategoryAndOwner(tmpNewList, tmpOldList, tempNewMap, tempOldMap, trigger.isInsert, trigger.isUpdate);
        ledProcess.setFollowPriority(tmpNewList);
    }
    // before update
    if (trigger.isBefore && trigger.isUpdate) {
        // リード分類・所有者振り分け処理
        ledProcess.divideCategoryAndOwner(tmpNewList, tmpOldList, tempNewMap, tempOldMap, trigger.isInsert, trigger.isUpdate);
        ledProcess.setFollowPriority(tmpNewList);
    }
    // before delete
    if (trigger.isBefore && trigger.isDelete) {
    }
    // after insert
    if (trigger.isAfter && trigger.isInsert) {
        // 定例セミナーキャンペーンメンバー追加処理
        ledProcess.addCampaignMemberOfRegularSeminar(tmpNewList, tempNewMap);
    }
    // after update
    if (trigger.isAfter && trigger.isUpdate) {
        // 取引開始処理
        new LED_ConvertFromLeadToAccount().startConvertFromLeadToAccount(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
    }
    // after delete
    if (trigger.isAfter && trigger.isDelete) {
    }

    // トリガー無効フラグ(FALSE)更新処理
    if(trigger.isAfter && !invalidList.isEmpty()) {
        UTL_TriggerUtil.canRunLead = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }

}