/**
 * CPM_LeadToCampaignMemberCopy
 * ----------------------------------------
 * @createdName      : Y.Yokoo
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
public class CPM_LeadToCampaignMemberCopy {

	/**
	 * リードに登録されている情報をキャンペーンメンバーにコピーする。
	 * 本来、キャンペーンメンバーに設定する項目を、現在はリードに持たせているため、
	 * データ精査が完了するまで、両方のオブジェクトに同項目を保持する。
	 *
	 * @param cpmNewList キャンペーンメンバーリスト(トリガー無効データ除くtrriger.new)
	 * @param cpmOldList キャンペーンメンバーリスト(トリガー無効データ除くtrriger.old)
	 * @param cpmNewMap  キャンペーンメンバーマップ(トリガー無効データ除くtrriger.newMap)
	 * @param cpmOldMap  キャンペーンメンバーマップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void copyLeadToCPM(List<CampaignMember> cpmNewList, List<CampaignMember> cpmOldList,
		Map<Id, CampaignMember> cpmNewMap, Map<Id, CampaignMember> cpmOldMap) {

		if (cpmNewList.isEmpty()) return;

		// 同一メールアドレスのキャンペーンメンバーを取得する
		Set<String> emailSet = new Set<String>();
		for(CampaignMember cpm : cpmNewList){
			emailSet.add(cpm.LeadOrContactEmail__c);
		}

		//List<CampaignMember> cpmList = [SELECT Id, EmailIndexKey__c, SQLFlag__c FROM CampaignMember WHERE EmailIndexKey__c IN :emailSet];

		List<Id> leadIdList = new List<Id>();
		//キャンペーンメンバーの件数だけ処理を行う
		for (CampaignMember cpm : cpmNewList) {
			//リードとキャンペーンメンバーが紐付けられていれば
			if (cpm.LeadId != null && String.isNotBlank(cpm.LeadId)) {
				//検索するリードをリストに格納
				leadIdList.add(cpm.LeadId);
			}
		}
		//リードが１件以上あれば、後続の作業を実施する
		if (!leadIdList.isEmpty()) {
			//リードからコピーする項目を抽出する
			Map<Id, Lead> leadMap = new Map<Id, Lead>(getSqlLead(leadIdList));

			//キャンペーンメンバーの件数だけ処理を行う。
			for (CampaignMember cpm : cpmNewList) {
				if (String.isNotBlank(cpm.LeadId) && leadMap.containsKey(cpm.LeadId)) {
					//各リードの項目をキャンペーンメンバーにコピーする。
					Lead targetLead = leadMap.get(cpm.LeadId);
					//ここにコピー項目を列挙する
					cpm.trcd__c = targetLead.Inbound_Trcd__c;								//トラッキングコード
					cpm.Inquiry__c = targetLead.Inquiry__c;									//ご相談内容
					cpm.AdoptionTarget__c = targetLead.AdoptionTarget__c;					//採用対象
					cpm.OpportunityProducts__c = targetLead.OpportunityProducts__c;			////商品
					cpm.AdoptionStatus__c = targetLead.AdoptionStatus__c;					//採用のご状況
					cpm.AdoptionSupportService__c = targetLead.AdoptionSupportService__c;	//採用支援サービス
					cpm.InquiryText__c = targetLead.InquiryText__c;							//ご質問
					cpm.Path__c = targetLead.Path__c;										//きっかけ
					cpm.SingleSeminarDay__c = targetLead.SingleSeminarDay__c;				//その他のセミナー日付
					cpm.InfluxRoute__c = targetLead.InPath__c;								//流入経路
					cpm.ApplyForSeminar__c = targetLead.ApplyForSeminar__c;					//申込経路
					cpm.LeadSource__c = targetLead.LeadSource;								//リードソース
					cpm.kobetu_sodankai__c = targetLead.kobetu_sodankai__c;					//個別商談会

					/*
					// SQLフラグを判定
					// マルケトLeadScore判定を除いたフォロー優先度確認
					LED_LeadProcess leadProcess = new LED_LeadProcess();
					Lead resultLead = leadProcess.checkFollowPriority(targetLead, 'CampaignMember');

					if ( resultLead.follow_priority__c != null){
						if ( resultLead.follow_priority__c.equals('高') ){
							cpm.SQLFlag__c = true;
						}
					}

					// MQLユニークを判定、SQLユニークを判定
					Boolean dupeEmailFlag = false;
					Boolean dupeFollowPriorityHighFlag = false;
					if ( !cpmList.isEmpty() ){
						for(CampaignMember exitstingCpm : cpmList){
							if(cpm.LeadOrContactEmail__c.equals(exitstingCpm.EmailIndexKey__c)){
								dupeEmailFlag = true;
								if(exitstingCpm.SQLFlag__c == true){
									dupeFollowPriorityHighFlag = true;

								}
							}
						}
					}

					if(dupeEmailFlag == false){
						cpm.MQLUnique__c = true;
					}
					if(cpm.SQLFlag__c == true && dupeFollowPriorityHighFlag == false){
						cpm.SQLUnique__c = true;
					}
					*/

				}
			}
		}
	}

	/**
	 * リードの検索
	 * キャンペーンメンバーに設定されているリードのIdを元に、リード情報を取得する。
	 *
	 * @param targetIdList  リードのId詰め合わせ(トリガー無効データ除くtrriger.oldMap)
	 * @return mLead Map<Id,Lead> SalesforceIdをキーとし、リード情報を取得するMap
	 */
	private Map<Id,Lead> getSqlLead(List<String> targetIdList){
		Map<Id,Lead> mLead = new Map<Id,Lead>([
			SELECT Id,							//Id
				   Inbound_Trcd__c, 			//リードトラッキングコード
				   Inquiry__c,					//ご相談内容
				   AdoptionTarget__c,			//採用対象
				   OpportunityProducts__c,		//商品
				   AdoptionStatus__c,			//採用のご状況
				   AdoptionSupportService__c,	//採用支援サービス
				   InquiryText__c,				//ご質問
				   Path__c,						//きっかけ
				   SingleSeminarDay__c,			//その他のセミナー日付
				   InPath__c,					//流入経路
				   ApplyForSeminar__c,			//申込経路
			 	   LeadSource, 					//リードソース
			 	   kobetu_sodankai__c,			//個別商談会
				   follow_priority__c			//フォロー優先度
			FROM Lead
			WHERE Id IN :targetIdList]);
		return mLead;
	}

}