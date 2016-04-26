/**
 * 発生売上の承認申請を実施します。
 */
public without sharing class ContractApplicationApprovalLogic {

    public List<ApprovalHistoryDto> dtoList {get; set;}
    public ApprovalDetailDto detailDto{get;set;}
    public Contract_Application_Information__c cai { get; set; }
    public Decimal totalCost { get; set; }

    public List<Attachment> attachmentList{get;set;}
    public List<Attachment> attachmentListForTab{get;set;}

    public boolean isButtonVisible{get;set;}
    //public boolean isGyousui{get;set;}

    private String infoId;
    private String stepNodeIdList;
    private static final String APPROVED = 'Approved';
    private static final String STARTED = 'Started';
    private static final String REJECTED = 'Rejected';
    private static final String PENDING = 'Pending';
		private ContractLogic contractLogic;
    private ProductLogic productLogic;
		
    /*
        コンストラクタ
    */
    public ContractApplicationApprovalLogic(ApexPages.StandardController controller) {
        dtoList = new List<ApprovalHistoryDto>();
        detailDto = new ApprovalDetailDto();
        cai = (Contract_Application_Information__c)controller.getRecord();
        contractLogic = new ContractLogic();
        productLogic = new ProductLogic();

        infoId = System.currentPageReference().getParameters().get('Id');
        if (String.isBlank(infoId)) {
        		infoId = cai.Id;
        }
				
				List<Contract_Application_Product__c> productList = [SELECT o.Br_Contract_PDF_ID__c,
				                                                            o.Br_Rs_Contract_PDF_ID__c,
				                                                            o.Ct_Contract_PDF_ID__c,
				                                                            o.Ct_Rs_Contract_PDF_ID__c,
				                                                            o.Nr_Contract_PDF_ID__c,
				                                                            o.Attach_PDF_ID__c,
				                                                            o.Name,
				                                                            o.ContractApplicationNo__c,
				                                                            p.Service__c,
				                                                            i.Id,
				                                                            i.Name,
				                                                            i.Fetch_Date_In_Service__c,
				                                                            i.Service_Name__c,
				                                                            i.Version_No__c,
				                                                            i.Approval_Status__c,
				                                                            i.Contract_Transfer_Memo__c,
				                                                            i.Contract_Application_Memo__c,
				                                                            i.Last_Edit_User__c,
				                                                            i.Del_Flg__c,
				                                                            i.Parent_Contract_Application_No__c,
				                                                            i.Billing_Company_Name__c,
				                                                            i.Billing_Building_Name__c,
				                                                            i.Billing_Address__c,
				                                                            i.Billing_Contact_Name__c,
				                                                            i.Billing_Phone_Number__c,
				                                                            i.Billing_contact_Department__c,
				                                                            i.Billing_Contact_Position__c,
				                                                            i.Billing_Zip_Code__c
				                                                       FROM Contract_Application_Product__c p,
				                                                            Contract_Application_Product__c.Contract_Application_Information__r i,
				                                                            Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r o
				                                                      WHERE i.Id = :infoId];

				cai = productList.get(0).Contract_Application_Information__r;
				Opportunity opp = cai.Opportunity__r;
				attachmentList = contractLogic.getAttachmentList(opp, cai.Service_Name__c);
			}

    /*
        承認履歴リストを表示するエントリポイント
    */
    public Pagereference selectApprovalHistoryList(){
        //承認画面から呼び出された場合は、画面遷移のボタンを表示しない
        String urlStr =ApexPages.currentPage().getUrl();
        isButtonVisible = !urlStr.contains('contractApplicationApproval');

        List<ProcessInstanceStep> stepList=
            [SELECT ProcessInstance.ProcessDefinition.Name, Id, StepStatus, Comments,CreatedDate,OriginalActor.Name,StepNodeId
                FROM ProcessInstanceStep where ProcessInstance.TargetObjectId = :infoId order by CreatedDate Desc];

        //承認項目が何もない場合はそのままリターン
        if(stepList.isEmpty()){
            return null;
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
        List<ProcessInstanceWorkitem> wortItemList=
        [SELECT ProcessInstance.ProcessDefinition.Name, Id, OriginalActor.Name,OriginalActor.Id,CreatedDate
            FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :infoId];


        //ProcessInstanceWorkItemのレコードをDtoに詰める
        if(!wortItemList.isEmpty()){
            ApprovalHistoryDto dto = new ApprovalHistoryDto();
            ProcessInstanceWorkitem piwi = wortItemList.get(0);
            dto.approvalDate = piwi.CreatedDate.format('yyyy/MM/dd HH:mm','Asia/Tokyo');
            dto.actorName = piwi.OriginalActor.Name;
            dto.stepName = '-';
            dto.approvalStatus = '現在承認待ち';

            //承認ページへの導線を出すか出さないかの判定
            //TODO 承認者にしか導線出さないパターンで大丈夫？承認者が休んだケースなど
            // dto.canApprove = isLoginUserAnApprover(piwi.OriginalActor.Id);
            dtoList.add(dto);
        }

        //ProcessInstanceStepのレコードをDtoに詰める
        for(ProcessInstanceStep pis : stepList){
            ApprovalHistoryDto dto = new ApprovalHistoryDto();
            dto.approvalDate = pis.CreatedDate.format('yyyy/MM/dd HH:mm','Asia/Tokyo');
            dto.approvalStatus = translateApprovalStatusToJapanese(pis.StepStatus);
            dto.actorName = pis.OriginalActor.Name;
            dto.comments = pis.Comments;
            dto.canApprove = false;

            if(pis.stepNodeId != null){
                ProcessNode node= nodeMap.get(pis.stepNodeId);
                dto.stepName = node.name;
            }else{
                dto.stepName = '00. 契約内容の承認申請';
            }

            dtoList.add(dto);
        }


        return null;
    }

    /*
        承認画面を表示するエントリポイント
    */
    public Pagereference showProcessWorkItem(){
        System.Debug('対象の契約内容');
        System.Debug(cai);

				List<Contract_Application_Product__c> productList = [SELECT UpfrontFee__c
				                                                       FROM Contract_Application_Product__c
				                                                      WHERE Contract_Application_Information__c = :infoId];

        totalCost = 0;
        for (Contract_Application_Product__c p: productList) {
          totalCost += p.UpfrontFee__c;
        }

        List<ProcessInstanceWorkitem> wortItemList=
        [SELECT ProcessInstance.ProcessDefinition.Name, Id, OriginalActor.Name,OriginalActor.Id,CreatedDate,ProcessInstanceId
            FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :infoId];

        String status = '';
        if (!wortItemList.isEmpty()){
            ProcessInstanceWorkitem piwi = wortItemList.get(0);
            ProcessInstanceStep stepLatest = selectFirstStep(piwi.ProcessInstanceId);
            //DetailDtoに値を詰める
            detailDto.workItemId = piwi.Id;
            detailDto.approver = piwi.OriginalActor.Name;
            detailDto.canApprove = isLoginUserAnApprover(piwi.OriginalActor.Id);
            detailDto.requester = stepLatest.OriginalActor.Name;

            //直近のステータスを取得
            status = stepLatest.ProcessInstance.Status;

        }else{
      Datetime cmpDate = null;
            List<ProcessInstance> piList =
                [SELECT Status, CompletedDate FROM ProcessInstance where TargetObjectId =:infoId order by CreatedDate Desc];
            if(!piList.isEmpty()){
                ProcessInstance pi = piList.get(0);
                status = pi.Status;
                cmpDate = pi.CompletedDate;
            }
        }

        detailDto.titleString =createTitleString(status, detailDto);

        return null;
    }

    /*
        承認実行メソッド
    */
    public Pagereference doApprove(){
        // ここでファイルをS3にアップロードする。
        // TODO BizReach以外のサービス
				Savepoint sp = Database.setSavePoint();
				PageReference pageRef = null;
				try {
						if (cai.Service_Name__c == System.Label.ServiceBiz) {
								Integer attachedFileNo = 1;
								String path = '';
								for (Attachment a: attachmentList) {
										if (a.Id == cai.Opportunity__r.Br_Contract_PDF_ID__c) {
												// RS以外の契約申込書
												path = 'contract/contract_' + cai.Opportunity__r.ContractApplicationNo__c + '_' + cai.Version_No__c + '_' + Datetime.now().getTime() + '.pdf';
												cai.Contract_PDF_S3_Path__c = path;
										} else if (a.Id == cai.Opportunity__r.Br_Rs_Contract_PDF_ID__c) {
												// RSの契約申込書
												path = 'contract/contract_' + cai.Opportunity__r.ContractApplicationNo__c + '_' + cai.Version_No__c + '_' + Datetime.now().getTime() + '.pdf';
												cai.Contract_Rs_PDF_S3_Path__c = path;
										} else {
												// 契約申込書以外の添付ファイル
												path = 'contractattachfile/contractattached_' + cai.Opportunity__r.ContractApplicationNo__c + '_' + cai.Version_No__c + '_' + 
															 attachedFileNo + '_' + Datetime.now().getTime() + '.pdf';
												if (attachedFileNo == 1) {
														cai.Attached_PDF1_S3_Path__c = path;
												} else if (attachedFileNo == 2){
														cai.Attached_PDF2_S3_Path__c = path;
												} else {
														cai.Attached_PDF3_S3_Path__c = path;
												}
												attachedFileNo++;
										}
							
										HttpAsyncCallout.uploadS3(a.Id, path);
								}
						
						}
						// ここで取り込み日時をnullにし、再取り込みできるようにする。
						cai.Hassei_Sales_Approval_User__c = UserInfo.getUserId();
						cai.Fetch_Date_In_Service__c = null;
						update cai;

						List<User> users = [select Id,Name,ManagerId from User where id = :UserInfo.getUserId()];
						User loginUser = users.get(0);

						Approval.ProcessResult workitemResult = pushForwardApprovalProcess(detailDto,'Approve',loginUser);
						System.assert(workitemResult.isSuccess());
						List<Id> newWorkitemIds= workitemResult.getNewWorkitemIds();

						ChatterUtil cu = new ChatterUtil();
						String domain = URL.getSalesforceBaseUrl().toExternalForm();
						String currentPageUrl =  domain + '/apex/contractApplicationApproval?Id=' + cai.Id;

						String urlTitle = cai.Opportunity__r.Name + 'の契約内容承認画面';
						String postComment = '';

						//承認が完了した場合
						Id instanceId = workitemResult.getInstanceId();

						//申請当初のデータを取得
						ProcessInstanceStep stepLatest = selectFirstStep(instanceId);

						postComment = 'さん\r\n\r\n承認者が契約内容の承認を完了しました。';
						if(!Test.isRunningTest()){
								cu.postFeedWithLinkAndOneMention(loginUser.Id,stepLatest.OriginalActor.Id ,postComment, currentPageUrl,urlTitle);
						}

						pageRef = new PageReference(currentPageUrl);
						pageRef.setRedirect(true);

				} catch (DmlException e) {
						// 連打対策
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '既に契約が承認されている可能性があります。このページを再度開き直して確認下さい。(再読み込みの場合反映されていない可能性があります。) : ' + e.getMessage(), ''));
						System.Debug('### Debug : レコードの登録に失敗しました。 -> ' + e.getMessage());
						Database.rollback(sp);
				}
        
        return pageRef;
    }
    
    /*
        却下実行メソッド
    */
    public Pagereference doReject(){
				Savepoint sp = Database.setSavePoint();
				PageReference pageRef = null;

				try {
						List<User> users = [select Id,ManagerId from User where id = :UserInfo.getUserId()];
						User loginUser = users.get(0);

						Approval.ProcessResult workitemResult = pushForwardApprovalProcess(detailDto,'Reject',loginUser);
						System.assert(workitemResult.isSuccess());

						String rejectComment = 'さん\r\n\r\n契約内容に不備がありました。下記を修正の上、再申請をお願いします。\r\n■理由:' + detailDto.comments;
						String resubmitUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + cai.Id;
						String urlTitle = cai.Opportunity__r.Name + 'の契約内容再申請画面';

						//申請当初のデータを取得
						Id instanceId = workitemResult.getInstanceId();
						ProcessInstanceStep stepLatest = selectFirstStep(instanceId);
						Set<Id> mentionIdSet= new Set<Id>();
						mentionIdSet.add(stepLatest.OriginalActor.Id);

						ChatterUtil cu = new ChatterUtil();
						if(!Test.isRunningTest()){
								cu.postFeedWithLinkAndPluralMentions(loginUser.Id,mentionIdSet,rejectComment, resubmitUrl,urlTitle);
						}
						
						// 削除の場合は復活させる。
						if (cai.Del_Flg__c) {
								cai.Del_Flg__c = false;
								update cai;
						}

						pageRef = new PageReference(ApexPages.currentPage().getUrl());
						pageRef.setRedirect(true);
				} catch (DMLException e) {
						// 連打対策
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '既に契約が却下されている可能性があります。このページを再度開き直して確認下さい。(再読み込みの場合反映されていない可能性があります。) : ' + e.getMessage(), ''));
						System.Debug('### Debug : レコードの登録に失敗しました。 -> ' + e.getMessage());
						Database.rollback(sp);
				}
        return pageRef;
    }

    /*
        承認ステータスの和訳メソッド
        （Salesforceのロケールとかで何とかならんか探したが、見つけられなかったのでしぶしぶ作成）
    */
    private String translateApprovalStatusToJapanese(String English){
        String Japanese = '';
        if(English.equals(APPROVED)){
            Japanese = '承認済み';
        }else if(English.equals(STARTED)){
            Japanese = '申請済み';
        }else if(English.equals(REJECTED)){
            Japanese = '却下';
        }
        return Japanese;
    }

    /*
        現在のログインユーザーが承認か判定するメソッド
    */
    private boolean isLoginUserAnApprover(Id actorId){
        //ログインユーザが承認者か否か判定
        // TODO 代理承認者を設定するか否か
        return UserInfo.getUserId() == actorId;
    }

    /*
        承認画面でユーザーに見せるタイトル文を作成するメソッド
    */
    private String createTitleString(String status, ApprovalDetailDto dto){
        if(status.equals(APPROVED)){
            return 'この契約内容は承認されました';
        }else if(status.equals(REJECTED)){
            return '不承認状態です、再申請してください';
        }else if(status.equals(PENDING)){
            String title = dto.approver +'さんの承認待ち状態です';
            return title;
        }

        return 'まだ契約内容が申請されていません。';
    }

    /*
        承認実行メソッド
     */
    private Approval.ProcessResult pushForwardApprovalProcess(ApprovalDetailDto dto, String actionType, User loginUser){
        // プロセスの作成
        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();

        // 承認するProcessInstanceWorkitemオブジェクトのIDの設定
        pwr.setWorkitemId(Id.valueOf(dto.workItemId));

        // アクションの設定
        // Approval:承認、Reject:却下、 Removed:削除＜システム管理者のみ＞
        pwr.setAction(actionType);

        //承認者の設定
        if(pwr.getNextApproverIds() == null){ //次の承認者がデフォルト設定されていない場合 CRSの部長承認を想定
            List<ID> nextApproverIDList = new List<ID>();

            if(loginUser.ManagerId != null){ //現ログインユーザにマネージャがいる場合
                nextApproverIDList.add(loginUser.ManagerId);
            }else{ //マネージャ欄が空白なら、現ログインユーザーを次の承認者にする
                nextApproverIDList.add(loginUser.Id);
            }

            pwr.setNextApproverIds(nextApproverIDList);
        }

        String comments = dto.comments;
        // コメントの設定
        pwr.setComments(comments);

        // プロセス実行
        return Approval.process(pwr);
    }

    /*
        申請当初のProcessInstanceStep情報を返すメソッド
     */
    private ProcessInstanceStep selectFirstStep(Id instanceId){
        //承認履歴のデータを取得
        List<ProcessInstanceStep> stepList=
            [SELECT ProcessInstance.ProcessDefinition.Name, CreatedDate,OriginalActor.Name,ProcessInstance.Status,OriginalActor.Id
                FROM ProcessInstanceStep where ProcessInstance.Id = :instanceId
                AND StepStatus='Started' order by CreatedDate Desc];

        //承認を申請した時点のデータを取得
        return stepList.get(0);
    }

    /*
        承認履歴リスト表示Dto
    */
    @Testvisible private with sharing class ApprovalHistoryDto{
        public ApprovalHistoryDto(){
            stepName = '';
            approvalDate = '';
            approvalStatus = '';
            actorName = '';
            comments = '';
            boolean canApprove = false;
        }
        public String stepName {get;set;}
        public String approvalDate {get;set;}
        public String approvalStatus {get;set;}
        public String actorName {get;set;}
        public String comments {get;set;}
        public boolean canApprove{get;set;}
    }

    /*
        承認画面詳細Dto
    */
    @Testvisible private with sharing class ApprovalDetailDto{
        public ApprovalDetailDto(){
            workItemId = '';
            titleString ='';
            approver = '';
            requester = '';
            comments = '';
            dounyuMtgDateTimeInLocalTimeZone = '';
            canApprove = false;
        }
        public String workItemId{get;set;}
        public String titleString {get;set;}
        public String approver {get;set;}
        public String requester {get;set;}
        public String comments {get;set;}
        public String dounyuMtgDateTimeInLocalTimeZone{get;set;}
        public boolean canApprove{get;set;}
    }
    
}