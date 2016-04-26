/**
 * LED_UpdateFromTaskToLead
 * ----------------------------------------
 * @createdName      : Y.Yokoo
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
public without sharing class LED_UpdateFromTaskToLead {
	/**
	 * リード最新活動時間更新処理
	 * 完了済みToDoが新規作成されたタイミングで、紐付くリードの活動時間項目に対して、活動履歴の活動時間の値を設定する。
	 * 同様に、任命先とメモ欄もコピーする
	 * leadUpdate
	 * @param tmpTaskList List<Task>
	 */
	public void leadUpdate(List<Task> tmpTaskList) {
		Map<Id,Task> taskToLeadMap = new Map<Id,Task>();
		//管理者ユーザId
		Id adminUserId = selectAdminUserId();
		//タスク分ループ
		for(Task target:tmpTaskList){
			//　完了済みToDo（IsClosedがtrue）の場合、
			// システム管理者以外のユーザが作成した場合、
			//　リードが設定されている（WhoIdが'00Q'）場合、
			// コール結果が「（GKブロック）断られた」で、種別が「電話」以外
			if(target.IsClosed && target.CreatedById != adminUserId && target.WhoId != null
			 && String.valueOf(target.WhoId).startsWith(Lead.sObjectType.getDescribe().getKeyPrefix())
			 && !(System.label.TaskCallGKBlock.equals(target.call__c) && '電話'.equals(target.Type))){

			 	//taskToLeadMap生成処理
				if(taskToLeadMap.containsKey(target.WhoId)){
					//日付が最新のものに上書きする
					if((taskToLeadMap.get(target.WhoId)).action_time__c < target.action_time__c){
						//リードとタスクのIDmapを作成
						taskToLeadMap.put(target.WhoId,target);
					}
				}else{
					//リードとタスクのIDmapを作成
					taskToLeadMap.put(target.WhoId,target);
				}
			}
		}
		
		//1件以上Mapがある場合
		if(!taskToLeadMap.isEmpty()){
			//リードの検索
			Map<Id,Lead> leadMap = selectLeadList(taskToLeadMap.keySet());
			List<Lead> updLeadList = new List<Lead>();
			
			//ネオタスク分ループ
			for(Task target:taskToLeadMap.values()){
				Lead targetLead = leadMap.get(target.WhoId);
				//リードの活動時間に変更がある場合、対応するリードにタスクの活動日を設定
				if(targetLead.action_time__c == null || targetLead.action_time__c < target.action_time__c){
					//変更して
					targetLead.action_time__c = target.action_time__c;
					targetLead.lastActivitiesOwner__c = target.OwnerId;
					targetLead.lastActivities__c = target.Field3__c;
					//リストに格納
					updLeadList.add(targetLead);
				}
			}
			if(!updLeadList.isEmpty()){
				//リードの更新
				update updLeadList;
			}
		}
		
	}

    /**
     * システム管理者Id検索
     * @return Id システム管理者のId　なければnullを返却
     */
    private Id selectAdminUserId(){
    	try{
	    	User target = [select Id from User where Name = :System.Label.adminName];
    		return target != null ? target.Id:null;
    	}catch(Exception e){
    		return null;
    	}
    }
    
    /**
     * リード検索（Id検索）
     * @param leadSet ToDoの名前項目から抽出したId Set<Id>
     * @return Map<Id,Lead> リードリスト
     */
    private Map<Id,Lead> selectLeadList(Set<Id> leadSet){
    	return new Map<Id,Lead>(
    		[SELECT Id, action_time__c FROM Lead WHERE Id IN :leadSet]);
    }
    
}