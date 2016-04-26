public without sharing class OpportunityApprovalLogic {

    public List<ApprovalHistoryDto> dtoList {get; set;}
    public ApprovalDetailDto detailDto{get;set;}
    public Opportunity op{get;set;}

    public List<Attachment> attachmentList{get;set;}
    public List<Attachment> attachmentListForTab{get;set;}

    public boolean isButtonVisible{get;set;}
    //public boolean isGyousui{get;set;}

    private String oppId;
    private String stepNodeIdList;
    private static final String APPROVED = 'Approved';
    private static final String STARTED = 'Started';
    private static final String REJECTED = 'Rejected';
    private static final String PENDING = 'Pending';

    private static final String GYOUSUI_ID = '00510000003Je8OAAS';
    private static final String CAREERTREK_DRC_ROLLUPDESCRIPTION = 'キャリトレ';

    private static final String GYOUSUI_EMAIL_ADDRESS = 'div-sales_promotion@bizreach.co.jp';
    private static final String KEIRI_EMAIL_ADDRESS = 'ap@bizreach.co.jp';
    
    private static final String BR_PDF_SUFFIX = 'BIZ';
    private static final String BR_RS_PDF_SUFFIX = 'BIZRS';
    private static final String CT_PDF_SUFFIX = 'CT';
    private static final String CT_RS_PDF_SUFFIX = 'CTRS';

	/** プロセス実行時に失敗した時のメッセージ表示フラグ(pageMessagesタグだと画面がスクロールして見えないからalertで表示) */
	public Boolean isError { get; set; }

	public Boolean exsitLineItem { get; set; }

    /**
     *コンストラクタ
     */
    public OpportunityApprovalLogic(ApexPages.StandardController controller) {
        dtoList = new List<ApprovalHistoryDto>();
        detailDto = new ApprovalDetailDto();
        op = new Opportunity();
        isError = false;
    }

    /**
     * 承認履歴リストを表示するエントリポイント
     */
    public Pagereference selectApprovalHistoryList(){
        //ProcessInstanceStepから承認履歴を抽出
        oppId = System.currentPageReference().getParameters().get('id');
        op.Id = oppId;

		exsitLineItem = false;
		List<Opportunity> oppList = [SELECT Id, LineItemNum__c FROM Opportunity WHERE Id = :oppId];
		if (!oppList.isEmpty()) {
			exsitLineItem = oppList.get(0).LineItemNum__c > 0;
		}

        //承認画面から呼び出された場合は、画面遷移のボタンを表示しない
        String urlStr =ApexPages.currentPage().getUrl();
        isButtonVisible = !urlStr.contains('OpportunityApproval');

        List<ProcessInstanceStep> stepList=
            [SELECT ProcessInstance.ProcessDefinition.Name, Id, StepStatus, Comments,CreatedDate,OriginalActor.Name,StepNodeId
                FROM ProcessInstanceStep where ProcessInstance.TargetObjectId = :oppId order by CreatedDate Desc];

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
            FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :oppId];


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
            dto.canApprove = isLoginUserAnApprover(piwi.OriginalActor.Id);
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
                dto.stepName = '00. 申込書の承認申請';
            }

            dtoList.add(dto);
        }


        return null;
    }

    /**
     * 承認画面を表示するエントリポイント
     */
    public Pagereference showProcessWorkItem(){
        oppId = System.currentPageReference().getParameters().get('id');
        //商談を抽出
        List<Opportunity> oppList =
        [SELECT Name,Id,ProposedService__c,ContractCollectionDate__c,UseStartDate__c,UseEndDate__c,DounyuMtgDate__c
            ,Amount,Type,HirePlanMonths__c,Account.Name
            ,AppoAcquisitionUser__r.UserRoleId,VisitChargeUser__r.UserRoleId,CreditManagerApproval__c,CreditComment__c
            ,(SELECT Id, Product2Name__c FROM OpportunityLineItems ORDER BY SortOrder)
            FROM Opportunity where Id = :oppId];

        //商談データがNullの場合、何もせずにreturn
        if (oppList.isEmpty()){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '対象の商談が取得できませんでした。'));
            return null;
        }
        op = oppList.get(0);
        //outputTextにそのまま値を渡すと、グリニッジ標準時で表示されるので、ここで時差コントロール
        if (op.DounyuMtgDate__c != null){
            detailDto.dounyuMtgDateTimeInLocalTimeZone = op.DounyuMtgDate__c.format('yyyy/MM/dd HH:mm');
        }

        List<ProcessInstanceWorkitem> wortItemList=
        [SELECT ProcessInstance.ProcessDefinition.Name, Id, OriginalActor.Name,OriginalActor.Id,CreatedDate,ProcessInstanceId
            FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :oppId];
        //申込書の添付ファイルを抽出
        List<Attachment> attList = new List<Attachment> ();

        String status = '';
        if (!wortItemList.isEmpty()){
            ProcessInstanceWorkitem piwi = wortItemList.get(0);
            ProcessInstanceStep stepLatest = selectFirstStep(piwi.ProcessInstanceId);
            //DetailDtoに値を詰める
            detailDto.workItemId = piwi.Id;
            detailDto.approver = piwi.OriginalActor.Name;
            detailDto.canApprove = isLoginUserAnApprover(piwi.OriginalActor.Id);
            detailDto.isDelegatedApprover = isLoginUserDelegatedApprover(piwi.OriginalActor.Id);
            detailDto.requester = stepLatest.OriginalActor.Name;

            //現在のログインユーザが業推で、なおかつ承認者も業推
            //isGyousui = UserInfo.getUserId() == GYOUSUI_ID && piwi.OriginalActor.Id == GYOUSUI_ID;

            //直近のステータスを取得
            status = stepLatest.ProcessInstance.Status;

            //承認プロセスがPending中は、そのプロセスに紐付いたファイルだけ抽出
            attList = [SELECT Id,name FROM Attachment where ParentId =:oppId and description LIKE :piwi.ProcessInstanceId + '%'];
        }else{
			Datetime cmpDate = null;
            List<ProcessInstance> piList =
                [SELECT Status, CompletedDate FROM ProcessInstance where TargetObjectId =:oppId order by CreatedDate Desc];
            if(!piList.isEmpty()){
                ProcessInstance pi = piList.get(0);
                status = pi.Status;
                cmpDate = pi.CompletedDate;
            }
            //承認プロセスが完了したら、申請に使った全部のファイルを抽出
            attList = cmpDate == null ? [SELECT Id,name FROM Attachment where ParentId =:oppId and description !=null ORDER BY LastModifiedDate DESC]
            	: [SELECT Id,name FROM Attachment where ParentId =:oppId and description !=null AND LastModifiedDate <= :cmpDate ORDER BY LastModifiedDate DESC];
        }

        detailDto.titleString =createTitleString(status, detailDto);

        attachmentList = new List<Attachment>();
        attachmentListForTab = new List<Attachment>();
        for (Attachment att : attList){
            attachmentList.add(att);
            attachmentListForTab.add(att);
        }

        return null;
    }

    /**
     * 承認実行メソッド
     */
    public Pagereference doApprove(){
        List<User> users = [select Id,Name,ManagerId from User where id = :UserInfo.getUserId()];
        User loginUser = users.get(0);

        Approval.ProcessResult workitemResult;
        try {
        	workitemResult = pushForwardApprovalProcess(detailDto,'Approve',loginUser);
        } catch(System.DmlException sde) {
        	isError = true;
        	return null;
        }
        System.assert(workitemResult.isSuccess());
        List<Id> newWorkitemIds= workitemResult.getNewWorkitemIds();

        // 現在のユーザーが業務推進部かつ申込書回収日が空白の場合、今日の日付で更新
        if(UserInfo.getUserId() == GYOUSUI_ID){
        		// 業推承認タイミングでどのPDFを使用しているか知りたいのでこのタイミングでPDFを保存する。
            Id instanceId = workitemResult.getInstanceId();
            List<Attachment> attList = [SELECT Id,name,body,description FROM Attachment where ParentId =:oppId and description LIKE :instanceId + '%' ORDER BY Id Asc];
            
            // 一旦PDFファイルをリセット
						op.Br_Contract_PDF_ID__c = null;
						op.Br_Rs_Contract_PDF_ID__c = null;
						op.Ct_Contract_PDF_ID__c = null;
						op.Attach_PDF_ID__c = null;
						op.Ct_Rs_Contract_PDF_ID__c = null;
            for (Attachment att: attList) {
            		List<String> instanceIds = att.description.split('_');
            		if (instanceIds.size() == 1) {
            				// _で分割できないものは添付ファイル
            				if (String.isBlank(op.Attach_PDF_ID__c)) {
            						op.Attach_PDF_ID__c = att.Id;
            				} else {
            						op.Attach_PDF_ID__c += ',' + att.Id;
            				}
            		} else if (instanceIds.get(1) == BR_PDF_SUFFIX) {
            				op.Br_Contract_PDF_ID__c = att.Id;
            		} else if (instanceIds.get(1) == BR_RS_PDF_SUFFIX) {
            				op.Br_Rs_Contract_PDF_ID__c = att.Id;
            		} else if (instanceIds.get(1) == CT_PDF_SUFFIX) {
            				op.Ct_Contract_PDF_ID__c = att.Id;
            		} else if (instanceIds.get(1) == CT_RS_PDF_SUFFIX) {
            				op.Ct_Rs_Contract_PDF_ID__c = att.Id;
            		}
            }
            if (op.ContractCollectionDate__c == null) {
            	// 申込書回収日が未入力の時のみここは更新。
							op.ContractCollectionDate__c = date.today();
							op.YomiProbability__c = '受注';
							op.StageName = 'STEP10：契約';
							op.sales_all__c = op.Amount;
            }
            update op;
        }
				//審査部、審査部長の場合のみUpdateのため上記Updateとは同一トランザクションでは実行されない
				updateCreditComment(detailDto.comments, '承認');

        ChatterUtil cu = new ChatterUtil();
        String domain = URL.getSalesforceBaseUrl().toExternalForm();
        String currentPageUrl =  domain + '/apex/OpportunityApproval?id=' + op.Id;

        String urlTitle = op.Name + 'の申込書承認画面';
        String postComment = '';

        if(!newWorkitemIds.isEmpty()){//次の承認者がいる場合
            Id workItemId = newWorkitemIds.get(0);
            List<ProcessInstanceWorkitem> wortItemList=
                [SELECT ProcessInstance.ProcessDefinition.Name,OriginalActor.Id
                FROM ProcessInstanceWorkitem where Id= :workItemId];
            ProcessInstanceWorkitem workItem = wortItemList.get(0);

            //Chatterに承認依頼を促すポストを行う
            postComment = 'さん\r\n\r\n下記商談の承認をお願いいたします。';
            if(!Test.isRunningTest()){
                cu.postFeedWithLinkAndOneMention(loginUser.Id,workItem.OriginalActor.Id ,postComment, currentPageUrl,urlTitle);
            }
        }else{//承認が完了した場合
            Id instanceId = workitemResult.getInstanceId();

            //申請当初のデータを取得
            ProcessInstanceStep stepLatest = selectFirstStep(instanceId);

            postComment = 'さん\r\n\r\n承認者全員が申込書の承認を完了しました。';
            if(!Test.isRunningTest()){
                cu.postFeedWithLinkAndOneMention(loginUser.Id,stepLatest.OriginalActor.Id ,postComment, currentPageUrl,urlTitle);
            }

						// 契約サービスを特定するためメールの作成前に添付ファイルリストを取得。
            List<Attachment> attList = [SELECT Id,name,body,description FROM Attachment where ParentId =:oppId and description LIKE :instanceId + '%' ORDER BY Id Asc];
            Boolean isBizReachContract = false;
            Boolean isCareertrekContract = false;
            for (Attachment att: attList) {
            		System.Debug('### Debug attList -> ' + att.Id + ': ' + att.Name + ', description -> ' + att.description);
            		List<String> instanceIds = att.description.split('_');
            		if (instanceIds.size() > 1 && instanceIds.get(1).contains(BR_PDF_SUFFIX)) {
            				isBizReachContract = true;
            		} else if (instanceIds.size() > 1 && instanceIds.get(1).contains(CT_PDF_SUFFIX)) {
            				isCareertrekContract = true;
            		}
            }

            String serviceName = '';
            if (isBizReachContract && isCareertrekContract) {
								serviceName = System.Label.ServiceBiz + ', ' + System.Label.ServiceCt;
            } else if (isBizReachContract) {
								serviceName = System.Label.ServiceBiz;
            } else if (isCareertrekContract) {
            		serviceName = System.Label.ServiceCt;
            }

            //業推と財務経理室に承認フローが完了した旨、メールを送信
            Datetime today = Datetime.now();
            String todayString = today.format('yyyyMMdd');

            String replyTo = 'bdp@bizreach.co.jp';
            String senderDisplayName = loginUser.Name;
            List<String> toAddresses = new List<String>();
            toAddresses.add(GYOUSUI_EMAIL_ADDRESS);
            toAddresses.add(KEIRI_EMAIL_ADDRESS);
            String subject = '【' + todayString + ' 申込書承認完了】' + serviceName + ' - ' + op.ProposedService__c + ' / ' + op.Account.Name;
            System.Debug('### Debug : subject -> ' + subject);
            String plainText = '財務経理室各位、業務推進室各位\r\n\r\n';
            plainText = plainText + op.Account.Name + '様の申込書承認が完了いたしました。\r\n' ;
            plainText = plainText +  'お申込み内容詳細は添付ファイルをご確認ください。\r\n' ;
            plainText = plainText +  '下記はSalesforceの商談URLです。\r\n ' ;
            plainText = plainText +  URL.getSalesforceBaseUrl().toExternalForm() + '/' + op.Id;
            plainText = plainText +  '\r\n\r\n※このメールはSalesforceから自動で送信されています' ;

            OutboundEmail mail = new OutboundEmail();
            mail.createSendMessage(replyTo, senderDisplayName, toAddresses, null, subject, plainText);

						// 契約申込書を特定するため、ID昇順で明示的にソート。契約申込書は承認申請時に一番最初にinsertされている。
            mail.attachFilesToOneMessage(attList);

						// 承認の確認が面倒なのでSandboxの場合はメール送信しない.
						if (!CommonUtil.RunningIsSandbox()) {
							mail.send();
						}
        }

        PageReference pageRef = new PageReference(currentPageUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }

    /**
     * 却下実行メソッド
     */
    public Pagereference doReject(){
        List<User> users = [select Id,ManagerId from User where id = :UserInfo.getUserId()];
        User loginUser = users.get(0);

		updateCreditComment(detailDto.comments, '却下');

        Approval.ProcessResult workitemResult;
        try {
        	workitemResult = pushForwardApprovalProcess(detailDto,'Reject',loginUser);
        } catch(System.DmlException sde) {
        	isError = true;
        	return null;
        }
        System.assert(workitemResult.isSuccess());


        String rejectComment = 'さん\r\n\r\n申込書に不備がありました。下記を修正の上、再申請をお願いします。\r\n■理由:' + detailDto.comments;
        String resubmitUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/OpportunityRequestApproval?id=' + op.Id;
        String urlTitle = op.Name + 'の申込書再申請画面';

        //申請当初のデータを取得
        Id instanceId = workitemResult.getInstanceId();
        ProcessInstanceStep stepLatest = selectFirstStep(instanceId);
        Set<Id> mentionIdSet= new Set<Id>();
        //申請者・★訪問・対応予定者・業務推進部・セールスアシスタントにメンション
        mentionIdSet.add(stepLatest.OriginalActor.Id);
        mentionIdSet.add(op.VisitChargeUser__c);
        mentionIdSet.add(GYOUSUI_ID);
        String devName = '';
        if (op.ProposedService__c =='ESS'){
        	devName = 'ESSSalesAssistant';
        }else{
        	devName = 'SalesAssistant';
        }
    	//セールスアシスタントの公開グループ取得
    	List<GroupMember> gmrList = [SELECT Id, UserOrGroupId FROM GroupMember WHERE Group.Type = 'Regular' AND Group.DeveloperName = :devName];
    	String userPrefix = User.sObjectType.getDescribe().getKeyPrefix();
    	String gmrId;
    	for (GroupMember gmr : gmrList) {
    		gmrId = gmr.UserOrGroupId;
    		if (gmrId.startsWith(userPrefix)) {
    			mentionIdSet.add(gmr.UserOrGroupId);
    		}
    	}
        ChatterUtil cu = new ChatterUtil();
        if(!Test.isRunningTest()){
            cu.postFeedWithLinkAndPluralMentions(loginUser.Id,mentionIdSet,rejectComment, resubmitUrl,urlTitle);
        }

        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }


    /**
     * 承認ステータスの和訳メソッド
     * （Salesforceのロケールとかで何とかならんか探したが、見つけられなかったのでしぶしぶ作成）
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

    /**
     * 現在のログインユーザーが承認か判定するメソッド
     */
    private boolean isLoginUserAnApprover(Id actorId){
        //ログインユーザが承認者か否か判定
        if(UserInfo.getUserId()==actorId){
            return true;
        }

        //ログインユーザが代理承認者か見分ける
        return isLoginUserDelegatedApprover(actorId);
    }

    /**
     * 現在のログインユーザーが代理の承認者か判定するメソッド
     */
    private boolean isLoginUserDelegatedApprover(Id actorId){
        List<User> actorList = [SELECT DelegatedApproverId FROM User where id =:actorId];
        User actor = actorList.get(0);
        if(UserInfo.getUserId()==actor.DelegatedApproverId){
            return true;
        }

        return false;
    }

    /**
     * 承認画面でユーザーに見せるタイトル文を作成するメソッド
     */
    private String createTitleString(String status, ApprovalDetailDto dto){
        if(status.equals(APPROVED)){
            return 'この申込書は承認されました';
        }else if(status.equals(REJECTED)){
            return '不承認状態です、再申請してください';
        }else if(status.equals(PENDING)){
            String title = dto.approver +'さんの承認待ち状態です';
            if(dto.isDelegatedApprover){
                title = title + '（'   + UserInfo.getName() + 'さんも代理承認可能）';
            }
            return title;
        }

        return 'まだ申込書が申請されていません。';
    }

    /**
     * 承認実行メソッド
     */
    private Approval.ProcessResult pushForwardApprovalProcess(ApprovalDetailDto dto, String actionType, User loginUser){
    	isError = false;
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
        if(dto.isDelegatedApprover){ //代理承認の場合、代理承認したことがどこのデータにも残らないため、せめてコメントには絶対記録が残るようにする
            comments = comments + '【' + UserInfo.getName() + ' 代理承認】';
        }
        // コメントの設定
        pwr.setComments(comments);

        // プロセス実行
        return Approval.process(pwr);
    }

    /**
     * 申請当初のProcessInstanceStep情報を返すメソッド
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

	/**
	 * 審査部・審査部長が承認・却下した場合に商談の審査時コメントを更新
	 */
	private void updateCreditComment(String comment, String status) {
		List<GroupMember> gmrList = [SELECT Id, UserOrGroupId FROM GroupMember WHERE Group.Type = 'Regular' AND Group.DeveloperName = 'CreditDivision'];
		Map<Id, GroupMember> gmrMap = new Map<Id, GroupMember>();
		for (GroupMember gmr : gmrList) {
			gmrMap.put(gmr.UserOrGroupId, gmr);
		}

		if (!gmrMap.containsKey(UserInfo.getUserId())) {
			return;
		}

		String cmt = System.now().format('yyyy/MM/dd HH:mm','Asia/Tokyo');
		cmt += ' ' + UserInfo.getName() + ' ' + status + '\r\n' + comment;
		op.CreditComment__c = String.isBlank(op.CreditComment__c) ? cmt : op.CreditComment__c + '\r\n' + cmt;
		update op;
	}

    /**
     * 承認履歴リスト表示Dto
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

    /**
     * 承認画面詳細Dto
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
            isDelegatedApprover = false;
        }
        public String workItemId{get;set;}
        public String titleString {get;set;}
        public String approver {get;set;}
        public String requester {get;set;}
        public String comments {get;set;}
        public String dounyuMtgDateTimeInLocalTimeZone{get;set;}
        public boolean canApprove{get;set;}
        public boolean isDelegatedApprover{get;set;}
    }
}