public class CLS_CPM_SeminarManagement {

	// ユーザーロールによって表示モード
	// 以下カスタム表示ラベルの文字列を含むロールに所属しているユーザーのみVFPで「保存」ボタンを表示する
	public Boolean semiMgAllowedFlag {get; private set;}

	// Topページ
	public String topPageUrl{
		get{
			String str = '';
			if (CommonUtil.RunningIsSandbox()){
				str = system.Label.Domain_Sandbox;
			}else{
				str = system.Label.Domain;
			}
			return str + Lead.sObjectType.getDescribe().getKeyPrefix();
		}
	}


	// TargetMenuセクションのキャンペーン一覧用フィールド変数
	public Id selectedTargetMenu {get; set;}
	public List<SelectOption> cpListOptions { get; private set; }

	// ActionMenuセクションのアクション一覧用フィールド変数
	public String selectedActionMenu {get; set;}
	public List<SelectOption> actionListOptions { get; private set; }

    // 各選択リスト項目の値一覧格納用フィールド変数　事前に用意しておくこと
	// public List<SelectOption> cpmAcademyStatusOptions { get; private set; }
	// public List<SelectOption> ssrAdoptionSupportServiceOptions { get; private set; }

    // キャンペーン一覧 List
	private List<Campaign> cpList = new List<Campaign>();

    // キャンペーン一覧 IdNameMap
	public Map<Id, String> cpIdNameMap = new Map<Id, String>();

	// ドメインのURL取得
	public String domainUrl{
    	get{
			String str = '';
			if (CommonUtil.RunningIsSandbox()){
				str = system.Label.Domain_Sandbox;
			}else{
				str = system.Label.Domain;
			}
			return str;
        	//return getDomainUrl();
    	}
	}
  // コンストラクタ
  public CLS_CPM_SeminarManagement(){

	    // ログインユーザーのロール判断
		// 許可されたロール、もしくはシステム管理者プロファイルの場合、フラグをTrueにする
		Id roleId = UserInfo.getUserRoleId();
		Id proId = UserInfo.getProfileId();
		UserRole ur = [SELECT RollupDescription FROM UserRole WHERE Id = :roleId LIMIT 1];

		semiMgAllowedFlag = false;
		if(ur != Null){
			String roles = system.Label.SeminarManagementRole;
			List<String> roleList = roles.split('\\,');
			if(!roleList.isEmpty()){
				for(String role : roleList){
					if(ur.RollupDescription.contains(role)){
						semiMgAllowedFlag = true;
						break;
					}else if(proId == system.Label.adminProfileId){
						semiMgAllowedFlag = true;
						break;
					}
				}
			}
		}

		// キャンペーン一覧を取得
		Date weekBefore = system.today() - 7;
		String searchText1 = '%自社セミナー%';
		String searchText2 = '%外部セミナー%';
		cpList = [Select Id, Name FROM Campaign WHERE ( StartDate >= :weekBefore OR SeminarStartDatetime__c >= :weekBefore ) AND ( Type LIKE :searchText1 OR Type LIKE :searchText2 ) order by Name];
		//cpList = [Select Id, Name FROM Campaign];
		system.debug('cpList.size='+ cpList.size());
		if(!cpList.isEmpty()){
			for(Campaign cp : cpList){
				cpIdNameMap.put(cp.Id, cp.Name);
			}
		}

		// TargetMenuセクションのキャンペーン一覧選択リスト値を設定
		cpListOptions = new List<SelectOption>();
		if(!cpIdNameMap.isEmpty()){
			for (Id id : cpIdNameMap.keySet()){
				String cpName = cpIdNameMap.get(id);
				cpListOptions.add(new SelectOption(id, cpName));
				system.debug('cpListOptions.size='+ cpListOptions.size());
			}
		}else{
			cpListOptions.add(new SelectOption('XXXXXXXXXXXXXXX', '※該当キャンペーンなし'));
		}

		// ActionMenuセクションのアクション一覧選択リスト値設定
		actionListOptions = new List<SelectOption>();
		actionListOptions.add(new SelectOption('出席管理', '出席管理'));
		actionListOptions.add(new SelectOption('アンケート入力', 'アンケート入力'));
		system.debug('actionListOptions.size='+ actionListOptions.size());

  }

	@RemoteAction
	public static List<CampaignMember> getCampaignMember(String t){
		String tMenuId = t;
		List<CampaignMember> cpmList = [
			SELECT Id, LeadOrContactId__c, leadOwnerOrQueue__c, CompanyName__c, Name, academy_status__c, CategoryOfEmail__c, PluscouNecessity__c, LeadOrContactEmail__c, IS__c,
				LeadOrContactPhone__c, LeadOrContactDepartment__c, LeadOrContactTitle__c, LeadOrContactIndustry__c, LeadOrContactEmployees__c, AdoptionSupportService__c, Path__c, Inquiry__c
			FROM CampaignMember
			WHERE Campaign.Id = :tMenuId];

		return cpmList;
	}

	@RemoteAction
	public static List<Seminar_Survey_Result__c> getSeminarSurveyResult(String t){
		String tMenuId = t;
		List<Seminar_Survey_Result__c> seminarSurveyList = new List<Seminar_Survey_Result__c>();
		List<CampaignMember> campaignMemberList = [SELECT Id, CompanyName__c, Name, LeadOrContactEmail__c, LeadOrContactId__c, Campaign.Id FROM CampaignMember WHERE Campaign.Id = :tMenuId];

		if(!campaignMemberList.isEmpty()){
			Set<Id> campaignMemberIdSet = new Set<Id>();
			for(CampaignMember cm : campaignMemberList) {
				campaignMemberIdSet.add(cm.Id);
				system.debug('campaignMemberIdSet.size='+ campaignMemberIdSet.size());
				// キャンペーンメンバー一覧からメンバーに対応するアンケート一覧を事前準備
				Seminar_Survey_Result__c ssr;
				if(String.valueOf(cm.LeadOrContactId__c).startsWith(Lead.sObjectType.getDescribe().getKeyPrefix())){
					ssr = new Seminar_Survey_Result__c(CampaignMemberId__c = cm.Id, Company__c = cm.CompanyName__c, Name__c = cm.Name, Email__c = cm.LeadOrContactEmail__c, CampaignId__c = cm.Campaign.Id, LeadId__c = cm.LeadOrContactId__c, ContactId__c = null);
				}else if(String.valueOf(cm.LeadOrContactId__c).startsWith(Contact.sObjectType.getDescribe().getKeyPrefix())){
					ssr = new Seminar_Survey_Result__c(CampaignMemberId__c = cm.Id, Company__c = cm.CompanyName__c, Name__c = cm.Name, Email__c = cm.LeadOrContactEmail__c, CampaignId__c = cm.Campaign.Id, LeadId__c = null, ContactId__c = cm.LeadOrContactId__c);
				}
				if(ssr != null){
					seminarSurveyList.add(ssr);
				}
			}
			// 既存の入力済みアンケートを取得する
			List<Seminar_Survey_Result__c> ssrList = [
				//SELECT Id, CampaignMemberId__c,CampaignId__c, LeadId__c, ContactId__c, Company__c, Name__c, Email__c, Department__c, Phone__c, Position__c, Industry__c, EmployeeNumber__c, AdoptionSupportService__c, know_was_triggered__c, Inquiry__c
				SELECT Id, CampaignMemberId__c, CampaignId__c, LeadId__c, ContactId__c, Company__c, Name__c, Email__c, AdoptionSupportService__c, Inquiry__c, Q1__c, A1__c, Q2__c, A2__c, Q3__c, A3__c
				FROM Seminar_Survey_Result__c
				WHERE CampaignMemberId__c
				IN :campaignMemberIdSet
			];
			// 事前準備したアンケート一覧に対して、入力済みアンケートが突合された場合、入力済みアンケートの値で上書きする
			if(!seminarSurveyList.isEmpty()){
				system.debug('part1_seminarSurveyList.size='+ seminarSurveyList.size());
				for(Seminar_Survey_Result__c survey : seminarSurveyList){
					if(!ssrList.isEmpty()){
						for(Seminar_Survey_Result__c submittedSurvey : ssrList){
							if(survey.CampaignMemberId__c == submittedSurvey.CampaignMemberId__c){
								survey.Id = submittedSurvey.Id;
								survey.CampaignId__c = submittedSurvey.CampaignId__c;
								survey.LeadId__c = submittedSurvey.LeadId__c;
								survey.ContactId__c = submittedSurvey.ContactId__c;
								survey.Company__c = submittedSurvey.Company__c;
								survey.Name__c = submittedSurvey.Name__c;
								survey.Email__c = submittedSurvey.Email__c;
								//survey.Department__c = submittedSurvey.Department__c;
								//survey.Phone__c = submittedSurvey.Phone__c;
								//survey.Position__c = submittedSurvey.Position__c;
								//survey.Industry__c = submittedSurvey.Industry__c;
								//survey.EmployeeNumber__c = submittedSurvey.EmployeeNumber__c;
								survey.AdoptionSupportService__c = submittedSurvey.AdoptionSupportService__c;
								//survey.know_was_triggered__c = submittedSurvey.know_was_triggered__c;
								survey.Inquiry__c = submittedSurvey.Inquiry__c;
								survey.Q1__c = submittedSurvey.Q1__c;
								survey.A1__c = submittedSurvey.A1__c;
								survey.Q2__c = submittedSurvey.Q2__c;
								survey.A2__c = submittedSurvey.A2__c;
								survey.Q3__c = submittedSurvey.Q3__c;
								survey.A3__c = submittedSurvey.A3__c;
							}
						}
					}
				}
			}
		}

		return seminarSurveyList;
	}

	@RemoteAction
	public static void saveCpmRecords(CampaignMember[] DataList){
		system.debug('DataList.size====='+DataList.size());
		update DataList;
	}

	@RemoteAction
	public static void saveSsrRecords(Seminar_Survey_Result__c[] DataList){
		system.debug('DataList.size====='+DataList.size());
		upsert DataList;
		// アンケート項目と共通する項目のみ、同一人物のキャンペーンメンバー、リードの同項目値を更新する
		List<CampaignMember> cpmUpdateList = new List<CampaignMember>();
		List<Lead> leadUpdateList = new List<Lead>();
		for(Seminar_Survey_Result__c ssr : DataList){
			/*
			CampaignMember cpm = new CampaignMember(
				Id = ssr.CampaignMemberId__c, AdoptionSupportService__c = ssr.AdoptionSupportService__c,
				Path__c = ssr.know_was_triggered__c, InquiryText__c = ssr.Inquiry__c
			);
			*/
			CampaignMember cpm = new CampaignMember(
				Id = ssr.CampaignMemberId__c, AdoptionSupportService__c = ssr.AdoptionSupportService__c,InquiryText__c = ssr.Inquiry__c
			);
			cpmUpdateList.add(cpm);
			if(ssr.LeadId__c != null){
				/*
				Lead led = new Lead(
					Id = ssr.LeadId__c, Title = ssr.Position__c, Field6__c = ssr.Department__c, SizeOfEmployees__c = ssr.EmployeeNumber__c, Industry = ssr.Industry__c,
					AdoptionSupportService__c = ssr.AdoptionSupportService__c, Path__c = ssr.know_was_triggered__c, InquiryText__c = ssr.Inquiry__c
				);
				*/
				Lead led = new Lead(
					Id = ssr.LeadId__c,	AdoptionSupportService__c = ssr.AdoptionSupportService__c, InquiryText__c = ssr.Inquiry__c
				);
				leadUpdateList.add(led);
			}
		}
		if(!cpmUpdateList.isEmpty()){
			update cpmUpdateList;
		}
		if(!leadUpdateList.isEmpty()){
			update leadUpdateList;
		}

	}

	@RemoteAction
	public static String getCampaignName(String tMenuId){
		  Id tId = (String)tMenuId;
		  Campaign cp = [SELECT Name FROM Campaign WHERE Id = :tId limit 1];
		  String resultCpName = cp.Name;
		  return resultCpName;
	}
	/*
	private String getDomainUrl(){
	    String str = '';
		if (CommonUtil.RunningIsSandbox()){
			str = system.Label.Domain_Sandbox;
		}else{
			str = system.Label.Domain;
		}
	    return str;
	}
	*/
    /**
	 * Helperメソッド　選択リストの値を設定する
	 * @param DescribeFieldResult, List<SelectOption>
	 */
	 /*
	private List<SelectOption> setSelectOptions (DescribeFieldResult f){
		List<SelectOption> options = new List<SelectOption>();
		List<PicklistEntry> entries = f.getPicklistValues();
		options.add(new SelectOption('', '--なし--'));
		for (PicklistEntry e : entries) {
			if (e.isActive()) {
				options.add(new SelectOption(e.getValue(), e.getLabel()));
			}
		}
		return options;
	}
	*/
}