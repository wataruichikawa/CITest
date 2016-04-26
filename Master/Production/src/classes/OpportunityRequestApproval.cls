public with sharing class OpportunityRequestApproval {

    public Opportunity op{get;set;}
    public boolean canRequest{get;set;}
    public boolean isNewContract{get;set;}
    public String comments{get;set;}

    public Attachment applicationForm{get;set;}
    public Attachment appBizForm{get;set;}
    public Attachment appCtForm{get;set;}
    public Attachment appBizRsForm{get;set;}
    public Attachment appCtRsForm{get;set;}
    public Attachment appNkForm{get;set;}
    public Attachment appBizWForm{get;set;}
    public Attachment appBosForm{get;set;}
    public Attachment evidence{get;set;}
    public Attachment certification{get;set;}
    public Attachment agreement{get;set;}

	public Boolean isApp{get;set;}
	public Boolean isAppBiz{get;set;}
	public Boolean isAppCt{get;set;}
	public Boolean isAppBizRS{get;set;}
	public Boolean isAppCtRs{get;set;}
	public Boolean isAppNk{get;set;}
	public Boolean isAppBizW{get;set;}
	public Boolean isAppBos{get;set;}
	private Boolean isEssBiz{get;set;}

    public Transient Blob applicationFormBlob{get;set;}
    public Transient Blob appBizFormBlob{get;set;}
    public Transient Blob appCtFormBlob{get;set;}
    public Transient Blob appBizRsFormBlob{get;set;}
    public Transient Blob appCtRsFormBlob{get;set;}
    public Transient Blob appNkFormBlob{get;set;}
    public Transient Blob appBizWFormBlob{get;set;}
    public Transient Blob appBosFormBlob{get;set;}
    public Transient Blob evidenceBlob{get;set;}
    public Transient Blob certificationBlob{get;set;}
    public Transient Blob agreementBlob{get;set;}

    private String oppId;
    private static String CRS_FIRST_REQUEST_PROCESS_NAME = 'CRSApprovalProcessFirstSubmission';
    private static String ESS_FIRST_REQUEST_PROCESS_NAME = 'ESSApprovalProcessFirstSubmission';
    private static String CRS_RE_REQUEST_PROCESS_NAME = 'CRSApprovalProcessResubmit';
    private static String ESS_RE_REQUEST_PROCESS_NAME = 'ESSApprovalProcessResubmit';
    private static String UNDER_REQUEST = '申請中';
    private static String REJECTED_FROM_SCREENING_DEPARTMENT = '却下';
    private static String REPEAT_CONTRACT = '既存提案（リピート・継続）';
    private static Integer VF_MAX_FILE_SIZE = 1024 * 1024 * 10;//10MB

    /*
        コンストラクタ
    */
    public OpportunityRequestApproval(ApexPages.StandardController controller) {
        op = new Opportunity();
        applicationForm = new Attachment();
        appBizForm = new Attachment();
        appCtForm = new Attachment();
        appBizRsForm = new Attachment();
        appCtRsForm = new Attachment();
        appNkForm = new Attachment();
        appBizWForm = new Attachment();
        appBosForm = new Attachment();
        evidence = new Attachment();
        certification = new Attachment();
        agreement = new Attachment();

        canRequest = true;
        isNewContract = true;
        comments = '';

		isApp = false;
		isAppBiz = false;
		isAppCt = false;
		isAppBizRs = false;
		isAppCtRs = false;
		isAppNk = false;
		isAppBizW = false;
		isAppBos = false;
		isEssBiz = false;
    }

    /*
        承認申請画面の表示するエントリポイント
    */
    public Pagereference requestApproval(){
        oppId = System.currentPageReference().getParameters().get('id');
        op = [SELECT Name,UseStartDate__c,UseEndDate__c,DounyuMtgDate__c,ProposedService__c,Type,OwnerId
                ,HirePlanMonths__c,ApplicationApprovalStatus__c, Amount
                ,Introduction__c, AccountInfo__c, AppPositionRecruitTarget__c
                ,IntroductionMTGDateIsBlank__c,CreditManagerApproval__c
                ,(SELECT Id, Product2Name__c, Service__c, IrregularPlan__c FROM OpportunityLineItems ORDER BY SortOrder)
                FROM Opportunity WHERE Id =:oppId];

		String devName = '';
        if (op.ProposedService__c =='ESS'){
        	devName = 'ESSSalesAssistant';
        	isApp = true;
        	for (OpportunityLineItem oli : op.OpportunityLineItems) {
        		if (System.Label.ServiceBiz.equals(oli.Service__c)) {
        			isEssBiz = true;
        		}
        	}
        }else{
        	devName = 'SalesAssistant';
        	for (OpportunityLineItem oli : op.OpportunityLineItems) {
        		if (System.Label.ServiceBiz.equals(oli.Service__c)) {
        			isAppBiz = true;
        		} else if (System.Label.ServiceCt.equals(oli.Service__c)) {
        			isAppCt = true;
        		} else if (System.Label.ServiceBizRs.equals(oli.Service__c)) {
        			isAppBizRs = true;
        		} else if (System.Label.ServiceCtRs.equals(oli.Service__c)) {
        			isAppCtRs = true;
        		} else if (System.Label.ServiceNk.equals(oli.Service__c)) {
        			// TODO ニクリーチの申込書を対応することになった場合はコメント外す
        			//isAppNk = true;
        		} else if (System.Label.ServiceBizW.equals(oli.Service__c)) {
        			// TODO ビズリーチウーマンの申込書を対応することになった場合はコメント外す
        			//isAppBizW = true;
        		} else if (System.Label.ServiceBos.equals(oli.Service__c)) {
        			isAppBos = true;
        		}
        	}
        }
        List<GroupMember> groupMemberList = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Regular' AND Group.DeveloperName = :devName];
        Set<Id> salesAssistantIDSet = new Set<Id>();
        for (GroupMember gm : groupMemberList){
            salesAssistantIDSet.add(gm.UserOrGroupId);
        }

        //商談所有者でない場合、なおかつSAでない場合は申請画面を表示させない
        if(UserInfo.getUserId() != op.OwnerId && !salesAssistantIDSet.contains(UserInfo.getUserId())){
            canRequest = false;
            return null;
        }

        //今までに申請した承認プロセスがあるか
        List<ProcessInstance> processInstanceList=
        [SELECT Id,Status FROM ProcessInstance where TargetObjectId=:oppId];

        if(!processInstanceList.isEmpty()){
            for(ProcessInstance pi : processInstanceList){
                if (pi.status == 'Pending'){ //現在申請中があるか、過去に承認されているか
                    canRequest = false;
                }
            }
        }

        if(op.Type == REPEAT_CONTRACT){
            isNewContract = false;
        }

        return null;
    }

    /*
        承認を申請するエントリポイント
    */
    public Pagereference doRequest(){
    	//ファイルサイズが10MBを超えた場合、エラーメッセージが格納されているので格納されている場合はreturnして
    	//メッセージを表示する
    	if (ApexPages.hasMessages()) {
    		return null;
    	}
        //審査で不承認になったことがあるかどうか判定
        String processName = '';
        if(op.ProposedService__c == 'CRS'){//CRSの場合
            //CRSの場合、入力チェックを行う
            if (!validateCrsRequest()) return null;
            //過去に却下があるか、イレギュラープランの場合か、事前審査部長承認フラグがONの場合はCRS用の申込書審査（再提出）フローに入る
            Boolean irregular = false;
            for (OpportunityLineItem oli : op.OpportunityLineItems) {
            	if (oli.IrregularPlan__c) {
            		irregular = true;
            		break;
            	}
            }
            if(op.ApplicationApprovalStatus__c == REJECTED_FROM_SCREENING_DEPARTMENT
                || irregular || op.CreditManagerApproval__c) {
                processName = CRS_RE_REQUEST_PROCESS_NAME;
            }else{
                processName = CRS_FIRST_REQUEST_PROCESS_NAME;
            }
        }else{//ESSの場合
            //過去に却下があるか、事前審査部長承認フラグがONの場合はESS用の申込書審査（再提出）フローに入る
            if(op.ApplicationApprovalStatus__c == REJECTED_FROM_SCREENING_DEPARTMENT
                || op.CreditManagerApproval__c){
                processName = ESS_RE_REQUEST_PROCESS_NAME;
            }else{
                processName = ESS_FIRST_REQUEST_PROCESS_NAME;
            }
        }

        //申込書回収日を今日の日付にして、商談を更新
        //※承認申請後だと商談レコードがロックされるので、この位置
        Date endDate = calcUseEndDate();
        op.UseEndDate__c = endDate;
        op.ApplicationApprovalStatus__c = UNDER_REQUEST;

        // 入力規則に合わないものが出たらtry catchして、画面にメッセージを出す
        update op;

        //承認申請をスタート
        oppId = System.currentPageReference().getParameters().get('id');
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();

        psr.setObjectId(oppId); //商談と承認申請を紐付け
        psr.setComments(comments);//コメントを設定
        psr.setProcessDefinitionNameOrId(processName);//承認プロセスを指定


        List<User> opOwnerList = [select Id,ManagerId from User where id = :op.OwnerId];
        List<User> loginUserList = [select Id,ManagerId from User where id = :UserInfo.getUserId()];
        User opOwner = opOwnerList.isEmpty() ? loginUserList.get(0) : opOwnerList.get(0);
        List<Id> nextApproverIds = new List<Id>();
        if(opOwner.ManagerId !=null){ //マネージャがいる場合はマネージャを次の承認者に（9割9分こちらのケース）
            nextApproverIds.add(opOwner.ManagerId);
        }else{ //部長自身が販売したときは自分を次の承認者に（レアケース）
            nextApproverIds.add(opOwner.Id);
        }
        psr.setNextApproverIds(nextApproverIds);

        Approval.ProcessResult submitResult = Approval.process(psr);// プロセス実行

        // 成功 or 失敗の確認
        System.assert(submitResult.isSuccess());

        // 状態の確認
        System.assertEquals('Pending', submitResult.getInstanceStatus());

        // 承認申請により作成された　ProcessInstanceIDを取得
        Id processInstanceId = submitResult.getInstanceId();

        //添付ファイルをアップロード
        insertAttachment(applicationForm, applicationFormBlob, oppId, processInstanceId, isEssBiz ? '_BIZ' : '_CT');
        insertAttachment(appBizForm, appBizFormBlob, oppId, processInstanceId, '_BIZ');
        insertAttachment(appCtForm, appCtFormBlob, oppId, processInstanceId, '_CT');
        insertAttachment(appBizRsForm, appBizRsFormBlob, oppId, processInstanceId, '_BIZRS');
        insertAttachment(appCtRsForm, appCtRsFormBlob, oppId, processInstanceId, '_CTRS');
        insertAttachment(appNkForm, appNkFormBlob, oppId, processInstanceId, '');
        insertAttachment(appBizWForm, appBizWFormBlob, oppId, processInstanceId, '');
        insertAttachment(appBosForm, appBosFormBlob, oppId, processInstanceId, '');
        insertAttachment(evidence, evidenceBlob, oppId, processInstanceId, '');
        insertAttachment(certification, certificationBlob, oppId, processInstanceId, '');
        insertAttachment(agreement, agreementBlob, oppId, processInstanceId, '');

        // ビューステートに重いデータを残さないようにするため、bodyをnullにする
        applicationForm.body = null;
        appBizForm.body = null;
        appCtForm.body = null;
        appBizRsForm.body = null;
        appCtRsForm.body = null;
        appNkForm.body = null;
        appBizWForm.body = null;
        evidence.body = null;
        certification.body = null;
        agreement.body = null;

        //Chatterに承認依頼を促すポストを行う
        ChatterUtil cu = new ChatterUtil();
        String domain = URL.getSalesforceBaseUrl().toExternalForm();
        String completePageUrl =  domain + '/apex/OpportunityApproval?id=' + oppId;
        String postComment = 'さん\r\n\r\n下記商談の申込書承認をお願いいたします。';
        String urlTitle = op.Name + 'の申込書承認画面';
        if(!Test.isRunningTest()){ //このクラスのテストメソッドではConnectApiに触れないので、一旦回避
            cu.postFeedWithLinkAndOneMention(UserInfo.getUserId(),nextApproverIds.get(0),postComment, completePageUrl,urlTitle);
        }

        // 承認画面に遷移させる
        PageReference completePage = new PageReference(completePageUrl);
        return completePage;
    }

	/**
	 * 添付ファイル登録
	 * @param att 添付ファイル
	 * @param body Blob
	 * @param pid 商談ID
	 * @param piid プロセスインスタンスID
	 * @param suffix プロセスインスタンスIDに付与する文字列
	 */
	private void insertAttachment(Attachment att, Blob body, Id pid, Id piid, String suffix) {
		if(String.isNotEmpty(att.Name)){
			att.body = body;
			att.parentId = pid;
			att.description = String.isNotBlank(suffix) ? String.valueOf(piid) + suffix : String.valueOf(piid);
			insert att;
		}
	}

    /**
     * CRS申請の場合に入力チェックを行う
     * @return true:エラーなし、false:エラーあり
     */
    private boolean validateCrsRequest() {
    	boolean errFlg = true;
    	//継続の場合
    	if (!isNewContract) {
    		if ((op.DounyuMtgDate__c == null && !op.IntroductionMTGDateIsBlank__c) || (op.DounyuMtgDate__c != null && op.IntroductionMTGDateIsBlank__c)) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,
    				'導入MTG日時、' + Schema.SObjectType.Opportunity.fields.IntroductionMTGDateIsBlank__c.Label
    				+ 'のどちらかを入力してください。'));
    			errFlg =  false;
    		}
        }
        List<String> errItemList = new List<String>();
        if (String.isEmpty(op.Introduction__c)) {
            errItemList.add(Schema.SObjectType.Opportunity.fields.Introduction__c.Label);
        }
        if (String.isEmpty(op.AccountInfo__c)) {
            errItemList.add(Schema.SObjectType.Opportunity.fields.AccountInfo__c.Label);
        }
        if (String.isEmpty(op.AppPositionRecruitTarget__c)) {
            errItemList.add(Schema.SObjectType.Opportunity.fields.AppPositionRecruitTarget__c.Label);
        }
        if (!errItemList.isEmpty()) {
            for (String err : errItemList) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err + 'を入力してください。'));
            }
            errFlg =  false;
        }
        return errFlg;
    }

	/**
	 * 利用終了日計算
	 * @return 計算後の利用終了日
	 */
	@TestVisible private Date calcUseEndDate() {
        Date endDate = op.UseEndDate__c;
        if(endDate == null){ //CRSの申込書は手動で終了日入れさせない。ミスが多いから
        	Decimal d = op.HirePlanMonths__c;
        	Decimal dmonth = d.round(System.RoundingMode.DOWN);
        	Decimal dday = ((d - dmonth) * 30).round(System.RoundingMode.HALF_UP);
            endDate = op.UseStartDate__c;
            endDate = endDate.addMonths(Integer.valueOf(dmonth)); //整数部分を月単位で追加
            //利用開始日と月を足した後の日付の日(day)を比較
            if (op.UseStartDate__c.day() <= endDate.day()) {
            	endDate = endDate.addDays(-1); //終了日自動計算 マイナス1日
            }
            endDate = endDate.addDays(Integer.valueOf(dday)); //小数点部分を日単位で追加
        }
        return endDate;
	}

	public Integer getMaxFileSize() {
		return VF_MAX_FILE_SIZE;
	}
}