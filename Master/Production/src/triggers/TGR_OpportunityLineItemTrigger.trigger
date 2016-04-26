trigger TGR_OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, before insert) {

    System.debug('OpportunityLineItem Size : ' + trigger.new.size());

    // トリガー起動制御
    if (!UTL_TriggerUtil.canRunOpportunityLineItem) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunOpportunityLineItem = true;
        }
        return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
        trigger.isDelete, trigger.new, trigger.old);
    List<OpportunityLineItem> tmpOldList = (List<OpportunityLineItem>) dto.oldList;
    List<OpportunityLineItem> tmpNewList = (List<OpportunityLineItem>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, OpportunityLineItem> tempOldMap;
    Map<Id, OpportunityLineItem> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, OpportunityLineItem>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, OpportunityLineItem>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, OpportunityLineItem>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, OpportunityLineItem>();
    }

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
        new CLS_OLI_OpportunityLineItemProcess().commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
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
        UTL_TriggerUtil.canRunOpportunityLineItem = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }

}