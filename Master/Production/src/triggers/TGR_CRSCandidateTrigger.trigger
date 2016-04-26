/**
 * TGR_CRSCandidateTrigger
 * ----------------------------------------
 * @createdName      : W.Ichikawa
 * @lastModifiedName : W.Ichikawa
 * ----------------------------------------
 */
trigger TGR_CRSCandidateTrigger on CrsCandidate__c (before insert, before update, after insert, after update) {

    // トリガー起動制御
    if (!UTL_TriggerUtil.canRunCRSCandidate) {
      if (trigger.isAfter) {
        UTL_TriggerUtil.canRunCRSCandidate = true;
      }
      return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
        trigger.isDelete, trigger.new, trigger.old);
    List<CRSCandidate__c> tmpOldList = (List<CRSCandidate__c>) dto.oldList;
    List<CRSCandidate__c> tmpNewList = (List<CRSCandidate__c>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, CRSCandidate__c> tempOldMap;
    Map<Id, CRSCandidate__c> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, CRSCandidate__c>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, CRSCandidate__c>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, CRSCandidate__c>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, CRSCandidate__c>();
    }

    CLS_CRSCandidateProcess CrsProcess = new CLS_CRSCandidateProcess();

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
      CrsProcess.setUserNameProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
    }
    // before update
    if (trigger.isBefore && trigger.isUpdate) {
      CrsProcess.setUserNameProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
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
        UTL_TriggerUtil.canRunCRSCandidate = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }
}