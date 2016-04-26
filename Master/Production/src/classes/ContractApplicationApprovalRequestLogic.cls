/**
 * 契約内容オブジェクトを発生売上承認者に承認申請するためのロジックです。
 */
public class ContractApplicationApprovalRequestLogic {
    private static final String REQUEST_PROCESS_NAME = 'Approval_Contract_Hassei_Sales';
    private static final String REQUEST_PROCESS_LABEL_NAME = '発生売上承認';
    private static final String RE_REQUEST_PROCESS_NAME = 'ReApproval_Contract_Hassei_Sales';
    
    /*
        承認を申請するエントリポイント
    */
    public Boolean approvalRequest(ID infoId, Boolean isRegister) {
      System.Debug(' ### 承認申請対象のIDは ' + infoId + ' です。');
      if (String.isBlank(infoId)) {
      	return false;
      }

      ProductLogic productLogic = new ProductLogic();
      List<Contract_Application_Product__c> productList = productLogic.getContractApplicationProductWithInfoByInfoId(infoId);

      //承認申請をスタート
      Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

      psr.setObjectId(infoId); //契約内容と承認申請を紐付け
      psr.setComments('');//コメントを設定
      String processName = isRegister ? REQUEST_PROCESS_NAME : RE_REQUEST_PROCESS_NAME;
      psr.setProcessDefinitionNameOrId(processName);//承認プロセスを指定

			// 承認者とサービス名を検索
			Contract_Application_Information__c[] infoList = [SELECT sau.Id,
			                                                         i.Service_Name__c,
			                                                         i.Del_Flg__c,
			                                                         ow.Id,
			                                                         ow.Name,
			                                                         a.Name
			                                                    FROM Contract_Application_Information__c i,
			                                                         Contract_Application_Information__c.Opportunity__r o,
			                                                         Contract_Application_Information__c.Opportunity__r.Account a,
			                                                         Contract_Application_Information__c.Opportunity__r.Owner ow,
			                                                         Contract_Application_Information__c.Opportunity__r.Owner.SalesApprovalUser__r sau
			                                                   WHERE i.Id = :infoId];
      System.Debug('### Debug : approvalUsers -> ' + infoList);
      if (infoList == null || infoList.isEmpty() || infoList.size() > 1) {
        return false;
      }

      String serviceName = infoList[0].Service_Name__c;
      Boolean isDelete = infoList[0].Del_Flg__c;
			Opportunity opportunity = infoList[0].Opportunity__r;
			Account account = opportunity.Account;

      psr.setSubmitterId(UserInfo.getUserId());

      List<Id> nextApproverIds = new List<Id>();
      nextApproverIds.add(infoList[0].Opportunity__r.Owner.SalesApprovalUser__r.Id);
      if (nextApproverIds.isEmpty()) {
      	System.Debug('### Debug : 承認者が設定されていません。');
      	return false;
      }
      
      psr.setNextApproverIds(nextApproverIds);

			try {
				Approval.ProcessResult submitResult = Approval.process(psr);// プロセス実行
				// 成功 or 失敗の確認
				if (!submitResult.isSuccess()) {
					return false;
				}

				// 状態の確認
				if (submitResult.getInstanceStatus() != 'Pending') {
					return false;
				}

				// 承認申請により作成された　ProcessInstanceIDを取得
				Id processInstanceId = submitResult.getInstanceId();

				// 売上総額を計算する。
				Decimal totalCost = 0.0;
				String planName = '';
				for (Contract_Application_Product__c product: productList) {
					if (product.UpFrontFee__c != null) {
						totalCost += product.UpfrontFee__c;
						// プラン名は最初の明細についている商品種別名
						if (String.isBlank(planName)) {
							planName = product.DisplayNameForClient__c;
						}
					}
				}

				//Chatterに承認依頼を促すポストを行う
				ChatterUtil cu = new ChatterUtil();
				String domain = URL.getSalesforceBaseUrl().toExternalForm();
				String completePageUrl =  domain + '/apex/contractApplicationApproval?Id=' + infoId;
				String postComment = isDelete ? 'さん\r\n\r\n下記契約の発生売上キャンセル承認をお願いいたします。' : 'さん\r\n\r\n下記契約の発生売上承認をお願いいたします。';
				String ccComment = isDelete ? 'さん\r\n\r\n下記契約の発生売上キャンセル承認申請を行いました。' : 'さん\r\n\r\n下記契約の発生売上承認申請を行いました。';
        String commonPostComment = '\r\n\r\n' +
                                   'サービス名      :' + serviceName + '\r\n' +
                                   '発生売上       :' + totalCost.format() + '円\r\n' +
                                   '企業名         :' + account.Name + '\r\n' +
                                   '契約プラン     :' + planName + '\r\n' +
                                   '営業担当       :' + opportunity.owner.Name;
				String urlTitle = '契約内容承認画面';
				if(!Test.isRunningTest()){ //このクラスのテストメソッドではConnectApiに触れないので、一旦回避
					cu.postFeedWithLinkAndOneMention(UserInfo.getUserId(),nextApproverIds.get(0),postComment + commonPostComment, completePageUrl,urlTitle);
					cu.postFeedWithLinkAndOneMention(UserInfo.getUserId(),opportunity.owner.Id,ccComment + commonPostComment, completePageUrl,urlTitle);
				}
			} catch (Exception e) {
				return false;
			}
			
			return true;
    }

    public String tryCancelRequest(ID infoId) {
			List<ProcessInstanceStep> stepList=
					[SELECT ProcessInstance.ProcessDefinition.Name, Id, StepStatus, Comments,CreatedDate,OriginalActor.Name,StepNodeId
							FROM ProcessInstanceStep where ProcessInstance.TargetObjectId = :infoId order by CreatedDate Desc];

			//承認項目が何もない場合はそのままリターン
			if(stepList.isEmpty()){
					return '';
			}

			//ProcessNodeからステップ名を抽出するために、stepNodeIdを抽出
			Set<String> stepNodeIds = new Set<String>();
			for(ProcessInstanceStep pis : stepList){
					stepNodeIds.add(pis.StepNodeId);
					system.Debug('StepNodeId is ' + pis.StepNodeId);
			}

			// ProcessNodeを抽出
			Map<ID,ProcessNode> nodeMap = new Map<ID,ProcessNode>([SELECT id,name from ProcessNode where id in :stepNodeIds]);

			//ProcessInstanceWorkItemから未実施の承認ステップを抽出
			List<ProcessInstanceWorkitem> workItemList=
			[SELECT ProcessInstance.ProcessDefinition.Name, Id, OriginalActor.Name,OriginalActor.Id,CreatedDate
					FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :infoId
					ORDER BY ID DESC];
			
			if (workItemList.isEmpty()) {
				return '';
			}
			
			String processName = workItemList.get(0).ProcessInstance.ProcessDefinition.Name;
			System.Debug('### Debug : processName is ' + processName);
			
			// プロセスの作成
			Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();

			// 承認するProcessInstanceWorkitemオブジェクトのIDの設定
			pwr.setWorkitemId(workItemList.get(0).Id);

			// アクションの設定
			pwr.setAction('Removed');
			pwr.setComments('再申請のため申請を取り下げます。');
			
			try {
				Approval.ProcessResult result =	Approval.process(pwr);
				if (!result.isSuccess()) {
					processName = '';
				}
			} catch (Exception e) {
				processName = '';
			}
        
			return processName;
    }
    
    public Boolean isNewApprovalProcessName(String processName) {
    	return processName == REQUEST_PROCESS_LABEL_NAME;
    }
}