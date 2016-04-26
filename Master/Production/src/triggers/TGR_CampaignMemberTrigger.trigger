/**
 * TGR_CampaignMemberTrigger
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
trigger TGR_CampaignMemberTrigger on CampaignMember (before insert, after insert, after update) {

	// トリガー起動制御
	if (!UTL_TriggerUtil.canRunCampaignMember) {
		if (trigger.isAfter) {
			UTL_TriggerUtil.canRunCampaignMember = true;
		}
		return;
	}

    // トリガー無効フラグ判別処理
	DTO_TriggerDto dto = UTL_TriggerUtil.createTriggerList(trigger.isInsert, trigger.isUpdate,
		trigger.isDelete, trigger.new, trigger.old);
	List<CampaignMember> tmpOldList = (List<CampaignMember>) dto.oldList;
	List<CampaignMember> tmpNewList = (List<CampaignMember>) dto.newList;
	List<id> invalidList = trigger.isAfter ? (List<id>) dto.invalidList : new List<Id>();
	Map<Id, CampaignMember> tempOldMap;
	Map<Id, CampaignMember> tempNewMap;
	if (!tmpOldList.isEmpty() && (trigger.isUpdate || trigger.isDelete)) {
		tempOldMap = new Map<Id, CampaignMember>(tmpOldList);
	} else {
		tempOldMap = new Map<Id, CampaignMember>();
	}
	if (!tmpNewList.isEmpty() && (trigger.isUpdate || (trigger.isAfter && trigger.isInsert))) {
		tempNewMap = new Map<Id, CampaignMember>(tmpNewList);
	} else {
		tempNewMap = new Map<Id, CampaignMember>();
	}

	CPM_AcademyEntryCheck cpmProcess = new CPM_AcademyEntryCheck();

	// before insert
	if (trigger.isBefore && trigger.isInsert) {
		new CPM_CampaignMemberProcess().commonProcess(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
		//紐付くリードの特定項目をキャンペーンメンバーにコピーする
		new CPM_LeadToCampaignMemberCopy().copyLeadToCPM(tmpNewList, tmpOldList, tempNewMap, tempOldMap);
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
		//アカデミー参加状況チェック
		//ここにメソッドを記述
	}
	// after delete
	if (trigger.isAfter && trigger.isDelete) {
	}

    // トリガー無効フラグ(FALSE)更新処理
	if(trigger.isAfter && !invalidList.isEmpty()) {
		UTL_TriggerUtil.canRunCampaignMember = false;
		UTL_TriggerUtil.updateTriggerInvalid(invalidList, trigger.new.getsObjectType().getDescribe().getName());
	}

}