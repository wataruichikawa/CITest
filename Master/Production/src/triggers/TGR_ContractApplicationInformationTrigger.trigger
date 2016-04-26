/**
 * 商談に対して1サービスにつき有効な契約が1つになるようチェックする。
 */
trigger TGR_ContractApplicationInformationTrigger on Contract_Application_Information__c (before insert) {
    // トリガー起動制御
    if (!UTL_TriggerUtil.canRunContractApplicationInformation) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunContractApplicationInformation = true;
        }
        return;
    }
    
    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
            trigger.isDelete, trigger.new, trigger.old);
  List<Contract_Application_Information__c> tmpOldList = (List<Contract_Application_Information__c>) dto.oldList;
  List<Contract_Application_Information__c> tmpNewList = (List<Contract_Application_Information__c>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, Contract_Application_Information__c> tempOldMap;
    Map<Id, Contract_Application_Information__c> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, Contract_Application_Information__c>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, Contract_Application_Information__c>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, Contract_Application_Information__c>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, Contract_Application_Information__c>();
    }
    
    // before insert
    if (trigger.isBefore && trigger.isInsert) {
        ContractLogic logic = new ContractLogic();
        logic.duplicateCheckContractAppInfo(tmpNewList);
    }

  // トリガー無効フラグ(FALSE)更新処理
    if(trigger.isAfter && !invalidList.isEmpty()) {
        UTL_TriggerUtil.canRunContractApplicationInformation = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }
}