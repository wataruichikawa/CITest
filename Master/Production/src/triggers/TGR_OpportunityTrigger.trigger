/**
 * TGR_OpportunityTrigger
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
trigger TGR_OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {

    UTL_TriggerUtil.scopeRunAccount = false;
    // トリガー起動制御
    if (!UTL_TriggerUtil.canRunOpportunity) {
        if (trigger.isAfter) {
            UTL_TriggerUtil.canRunOpportunity = true;
        }
        return;
    }

    // トリガー無効フラグ判別処理
    DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
        trigger.isDelete, trigger.new, trigger.old);
    List<Opportunity> tmpOldList = (List<Opportunity>) dto.oldList;
    List<Opportunity> tmpNewList = (List<Opportunity>) dto.newList;
    List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
    Map<Id, Opportunity> tempOldMap;
    Map<Id, Opportunity> tempNewMap;
    if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
        tempOldMap = new Map<Id, Opportunity>(tmpOldList);
    } else {
        tempOldMap = new Map<Id, Opportunity>();
    }
    if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
        tempNewMap = new Map<Id, Opportunity>(tmpNewList);
    } else {
        tempNewMap = new Map<Id, Opportunity>();
    }

    OPP_OpportunityProcess oppProcess = new OPP_OpportunityProcess();

    // before insert
    if (trigger.isBefore && trigger.isInsert) {
        // 商談共通処理
        oppProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
    }
    // before update
    if (trigger.isBefore && trigger.isUpdate) {
    	// 価格表整合性チェック
    	oppProcess.validatePriceBook2(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
        // 商談共通処理
        oppProcess.commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
    }
    // before delete
    if (trigger.isBefore && trigger.isDelete) {
    }
    // after insert
    if (trigger.isAfter && trigger.isInsert) {
        // 商談フォロー
        new CHA_ChatterFollow().insertFollowOpportunity(tmpNewList, tempNewMap);
        // DRCアカウントマネージメント
        oppProcess.targetAccountManagement(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
    }
    // after update
    if (trigger.isAfter && trigger.isUpdate) {
        // 商談フォロー
        new CHA_ChatterFollow().updateFollowOpportunity(tmpNewList, tempNewMap, tmpOldList, tempOldMap);
        // DRCアカウントマネージメント
        oppProcess.targetAccountManagement(tmpNewList, tmpOldList, tempNewMap, tempOldMap);

		// 契約内容のステータス変更有無の確認
		ContractLogic logic = new ContractLogic();
		logic.updateContractAppInfoApprovalStatus(tempOldMap, tempNewMap);
    }
    // after delete
    if (trigger.isAfter && trigger.isDelete) {
    }

    // トリガー無効フラグ(FALSE)更新処理
    if(trigger.isAfter && !invalidList.isEmpty()) {
        UTL_TriggerUtil.canRunOpportunity = false;
        UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
    }

}