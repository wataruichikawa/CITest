public with sharing class PrintApplicationPDF{

    @TestVisible private kpsr.ReportsConnectController rc;
    private Opportunity op;
    @TestVisible private String serviceName;
    public PrintDto dto {get; set;}

    /*  コンストラクタ */
    public PrintApplicationPDF(ApexPages.StandardController controller) {
        rc = new kpsr.ReportsConnectController();
        dto = new PrintDto();
    }

    /**
     * 申込書出力画面初期表示アクション
     */
    public Pagereference initPrintApplicationInput() {
        dto.opp.Id = System.currentPageReference().getParameters().get('id');
        serviceName = System.currentPageReference().getParameters().get('svc');
        dto.opp2.CloseDate = system.today();
        List<Opportunity> oppList =
            [Select Id, Account.Name, Account.BillingPostalCode, Account.BillingState, Account.BillingCity,
            	Account.BillingStreet, Account.Phone, Account.Field157__c
                From Opportunity Where Id = :dto.opp.Id];
        if (!oppList.isEmpty()) {
            Opportunity opp = oppList.get(0);
            Account acc = opp.Account;
            String address = convertNullToBlank(acc.BillingState) + convertNullToBlank(acc.BillingCity)
                + convertNullToBlank(acc.BillingStreet);
            dto.companyName = acc.Name;
            dto.companyNameKana = acc.Field157__c;
            dto.companyPostCode = acc.BillingPostalCode;
            dto.companyAddress = address;
            dto.companyPhone = acc.Phone;
           	if (String.isNotBlank(serviceName) && serviceName.contains('RS')) {
           		dto.usageEnd = true;
            }
        }
        return null;
    }

    /**
     * お見積書出力画面初期表示アクション
     */
    public Pagereference initPrintQuotationInput() {
        dto.opp.Id = System.currentPageReference().getParameters().get('id');
        List<Opportunity> oppList = [Select Id, QuotationExpireDate__c From Opportunity Where Id = :dto.opp.Id];
        if (!oppList.isEmpty()) {
            dto.opp.CloseDate = oppList.get(0).QuotationExpireDate__c;
        }
        return null;
    }

    /*  見積書出力用のエントリポイント */
    public Pagereference doPrintQuotation(){
        String ql = createQueryQuoAndApp();
        op = selectOpportunity(ql);
        OliDto oDto = exploreOpportunityLineItem(op.OpportunityLineItems);

        String fileName = createFileName('見積書', op.Account.Name, oDto.service, oDto.dispName);
        rc.setFilename(filename);
        rc.setReportId('見積書');

        //入力情報を設定
        if (dto.opp.CloseDate != null) {
            rc.getParms().put('p_quotationExpireDate', String.valueOf(dto.opp.CloseDate));
        } else {
            rc.getParms().put('p_quotationExpireDate', '');
        }

        return doPrint(ql,true);
    }

    /*  申込書出力用のエントリポイント */
    public Pagereference doPrintApplication(){
        String ql = createQueryQuoAndApp();
        op = selectOpportunity(ql);

        System.debug('serviceName :' + serviceName);
        System.debug('DebugLineItem :' + op.OpportunityLineItems);
        OliDto oDto = exploreOpportunityLineItem(op.OpportunityLineItems);

        String fileName = createFileName('お申込書', op.Account.Name, serviceName, oDto.dispName);
        rc.setFilename(filename);
        rc.setReportId(serviceName + '申込書'); //サービス名により参照する帳票ファイルが分岐する

        //入力情報を設定
        if (dto.opp2.CloseDate != null) {
            rc.getParms().put('p_proposalDateYYYY', String.valueOf(dto.opp2.CloseDate.year()));
            rc.getParms().put('p_proposalDateMM', String.valueOf(dto.opp2.CloseDate.month()));
            rc.getParms().put('p_proposalDateDD', String.valueOf(dto.opp2.CloseDate.day()));
        } else {
            rc.getParms().put('p_proposalDateYYYY', '');
            rc.getParms().put('p_proposalDateMM', '');
            rc.getParms().put('p_proposalDateDD', '');
        }
        if (dto.opp.CloseDate != null) {
            rc.getParms().put('p_usageStartDateYYYY', String.valueOf(dto.opp.CloseDate.year()));
            rc.getParms().put('p_usageStartDateMM', String.valueOf(dto.opp.CloseDate.month()));
            rc.getParms().put('p_usageStartDateDD', String.valueOf(dto.opp.CloseDate.day()));
        } else {
            rc.getParms().put('p_usageStartDateYYYY', '');
            rc.getParms().put('p_usageStartDateMM', '');
            rc.getParms().put('p_usageStartDateDD', '');
        }
        if (dto.usageEnd && dto.opp3.CloseDate != null) {
            rc.getParms().put('p_usageEndDateYYYY', String.valueOf(dto.opp3.CloseDate.year()));
            rc.getParms().put('p_usageEndDateMM', String.valueOf(dto.opp3.CloseDate.month()));
            rc.getParms().put('p_usageEndDateDD', String.valueOf(dto.opp3.CloseDate.day()));
        } else {
            rc.getParms().put('p_usageEndDateYYYY', '');
            rc.getParms().put('p_usageEndDateMM', '');
            rc.getParms().put('p_usageEndDateDD', '');
        }
        rc.getParms().put('p_companyName', dto.companyName);
        rc.getParms().put('p_companyNameKana', dto.companyNameKana);
        rc.getParms().put('p_companyPostCode', dto.companyPostCode);
        rc.getParms().put('p_companyAddress', dto.companyAddress);
        rc.getParms().put('p_companyPhone', dto.companyPhone);
        rc.getParms().put('p_department', dto.department);
        rc.getParms().put('p_name', dto.name);
        rc.getParms().put('p_nameKana', dto.nameKana);
        rc.getParms().put('p_email', dto.email);
        rc.getParms().put('p_billingPostCode', dto.billingPostCode);
        rc.getParms().put('p_billingAddress', dto.billingAddress);
        rc.getParms().put('p_billingPhone', dto.billingPhone);
        rc.getParms().put('p_billingDepartment', dto.billingDepartment);
        rc.getParms().put('p_billingName', dto.billingName);
        rc.getParms().put('p_billingNameKana', dto.billingNameKana);
        rc.getParms().put('p_continuation', oDto.continuation);
        rc.getParms().put('p_fixedFlg', oDto.fixedFlg);
        rc.getParms().put('p_successFlg', oDto.successFlg);
        rc.getParms().put('p_optionFlg', oDto.optionFlg);
        rc.getParms().put('p_remarks', oDto.remarks);
        return doPrint(ql,true);
    }

    /*  訪問前レポート出力用のエントリポイント */
    public Pagereference doPrintReportBeforeVisit(){
        String ql = createQueryReport();
        op = selectOpportunity(ql);
        String fileName = op.account.Name + '様_'+'訪問前準備レポート_'+ op.VisitChargeUser__r.Name;
        rc.setFilename(filename);
        rc.setReportId('訪問前レポート');

		String pname = '';
		for (OpportunityLineItem oli : op.OpportunityLineItems) {
			pname = pname + oli.Product2Name__c + ', ';
		}
		if (String.isNotBlank(pname)) {
			pname = pname.substring(0, pname.length() - 2);
		}
		rc.getParms().put('p_product2Name', pname);

        Pagereference pr =  doPrint(ql,false);

        if(String.isEmpty(op.HoumonmaeMgrCheck__c)){//doPrintより先に商談アップデートすると何故か落ちるため、この位置で更新
	        op.HoumonmaeMgrCheck__c = '未チェック';
	        try{
		        update op;
	        }catch(DmlException e){
				for (Integer i = 0; i < e.getNumDml(); i++) {
				    ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,e.getDmlMessage(i)));
				}
	        }
        }
		return pr;
    }

	private OliDto exploreOpportunityLineItem(List<OpportunityLineItem> oliList) {
		OliDto oDto = new OliDto();
		Map<String, String> serviceMap = new Map<String, String>();
        for (OpportunityLineItem oli : oliList) {
        	if (String.isNotBlank(oli.Service__c)) {
        		oDto.service = oli.Service__c;
        		serviceMap.put(oli.Service__c, oli.Service__c);
        	}
        	if (String.isNotBlank(oli.HirePlanCategory__c)) {
	        	if ('成功報酬'.equals(oli.HirePlanCategory__c)) {
	        		oDto.successFlg = '1';
	        		oDto.dispName = oli.DisplayNameForClient__c;
	        		oDto.remarks = oli.Product2.Remarks__c;
	        	} else if ('オプション'.equals(oli.HirePlanCategory__c) || 'プラスカ'.equals(oli.HirePlanCategory__c)) {
	        		oDto.optionFlg = '1';
	        	} else {
	        		oDto.fixedFlg = '1';
	        		oDto.dispName = oli.DisplayNameForClient__c;
	        		oDto.remarks = oli.Product2.Remarks__c;
	        		if (oli.HirePlanCategory__c.contains('継続')) {
	        			oDto.continuation = '1';
	        		}
	        	}
        	}
        	
        }
        if (serviceMap.size() != 1) {
        	oDto.service = '';
        	oDto.dispName = '';
        }
        return oDto;
	}

	/**
	 * 見積書・申込書用SOQLを生成するメソッド
	 */
	 private String createQueryQuoAndApp() {
	 	String soql = String.isNotBlank(serviceName) ? ' WHERE Service__c = \'' + String.escapeSingleQuotes(serviceName) + '\'' : '';
	 	return 'SELECT Id, Amount, Account.Name,'
	 		+ ' (SELECT Id, Name, Quantity, UnitPrice, TotalPrice, Service__c, SpecialInstruction__c, DisplayNameForClient__c, UpfrontFee__c, PlatinumScoutNumberOfFirstMonth__c, PlatinumScoutNumber__c, PlatinumScoutNumberInTotal__c, PlatinumScoutNumberContinuation__c, ContractPeriod__c, HirePlanCategory__c, UsePeriodText__c, UsePeriodFrom__c, UsePeriodTo__c, QuantityUnit__c, RemarksOption__c, BrTtMinimumFee__c, BrTtSuccessFeeRatio__c, BrTtSuccessFee__c, BrRgMinimumFee__c, BrRgSuccessFeeRatio__c, BrRgSuccessFee__c, CtMinimumFee__c, CtSuccessFeeRatio__c, CtSuccessFee__c, NrMinimumFee__c, NrSuccessFeeRatio__c, NrSuccessFee__c, Product2.Remarks__c FROM OpportunityLineItems'
	 		+ soql + ' ORDER BY PrintSort__c, SortOrder)'
	 		+ ' FROM Opportunity WHERE Id = \'' + System.currentPageReference().getParameters().get('id') + '\'';
	 }

	/**
	 * 訪問レポート用SOQLを生成するメソッド
	 */
	 private String createQueryReport() {
	 	return 'SELECT Account.Name, Account.Website, VisitDate__c, VisitChargeUser__r.Name, AppoH001__c, AppoH003__c, Amount, AppoH009__c, AppoH005__c,'
	 		+ ' AppoH007__c, AppoH008__c, CompanyProfile__c, ServiceOfCustomer__c, MarketTrend__c, Competing__c, PositionAndSearchCondition__c, BusinessTalk__c, HoumonmaeMgrCheck__c,'
	 		+ ' (SELECT Id, Product2Name__c FROM OpportunityLineItems ORDER BY SortOrder)'
	 		+ ' FROM Opportunity WHERE Id = \'' + System.currentPageReference().getParameters().get('id') + '\'';
	 }

    /*  商談を一件取得するメソッド  */
   private Opportunity selectOpportunity(String ql){
        try{
            op = Database.query(ql);
        }catch(QueryException e){
            ApexPages.addMessages(e);
        }
        return op;
   }

    /*  下記ルールでファイル名を作成するメソッド
    	{会社名}御中_{サービス名}{プラン名}_{今日の日付}
     */
	private String createFileName(String fileType, String accName, String serviceName, String dispName) {
		Datetime now = Datetime.now();
		return accName + '御中_' + serviceName + dispName + '_' + filetype + '_' + now.format('yyyyMMdd');
	}

    /*  PDF作成を行うメソッド
    	申込書、見積書は当該商談にPDFを添付し、訪問前レポートは添付しない
    */
    private Pagereference doPrint(String ql, boolean isAttachToId){ //
        rc.setSoql(ql);
        rc.setAttcheToId(isAttachToId);
        rc.setReturnUrl('/servlet/servlet.FileDownload');

        Pagereference pr = new Pagereference('');
        if(!Test.isRunningTest()){
	        rc.goPrint();
	        pr = new Pagereference(rc.goUrl);
        }

        return pr;
    }

    /**
     * nullの場合ブランクに変換
     */
    private String convertNullToBlank(String value) {
        return value == null ? '' : value;
    }

    /**
     * 申込書・見積書画面用DTO
     */
    @TestVisible private with sharing class PrintDto {
        public PrintDto() {
            opp = new Opportunity();
            opp2 = new Opportunity();
            opp3 = new Opportunity();
            companyName = '';
            companyNameKana = '';
            companyPostCode = '';
            companyAddress = '';
            companyPhone = '';
            department = '';
            name = '';
            nameKana = '';
            email = '';
            billingPostCode = '';
            billingAddress = '';
            billingPhone = '';
            billingDepartment = '';
            billingName = '';
            billingNameKana = '';
            usageEnd = false;
        }
        public Opportunity opp {get; set;}
        public Opportunity opp2 {get; set;}
        public Opportunity opp3 {get; set;}
        public String companyName {get; set;}
        public String companyNameKana {get; set;}
        public String companyPostCode {get; set;}
        public String companyAddress {get; set;}
        public String companyPhone {get; set;}
        public String department {get; set;}
        public String name {get; set;}
        public String nameKana {get; set;}
        public String email {get; set;}
        public String billingPostCode {get; set;}
        public String billingAddress {get; set;}
        public String billingPhone {get; set;}
        public String billingDepartment {get; set;}
        public String billingName {get; set;}
        public String billingNameKana {get; set;}
        public boolean usageEnd {get; set;}
    }

    @TestVisible private with sharing class OliDto {
    	public OliDto() {
    		continuation = '0';
    		fixedFlg = '0';
    		successFlg = '0';
    		optionFlg = '0';
    		service = '';
    		dispName = 'オプション';
    		remarks = '';
    	}
        public String continuation { get; set; }
        public String fixedFlg { get; set; }
        public String successFlg { get; set; }
        public String optionFlg { get; set; }
        public String service { get; set; }
        public String dispName { get; set; }
        public String remarks { get; set; }
    }
}