@isTest
private class TST_CPM_SeminarManagement {

	@testSetup static void setup(){
		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(thisUser) {
			// リードの追加
			Lead led1 = new Lead(FirstName = '太郎', LastName = '山田', Email = 'taro.yamada@biztest.co.jp', Company = 'テストカンパニー', Status = '新規', LeadSource = '日本の人事部');
			insert led1;

			// 取引先担当者の追加
			Contact con1 = new Contact(FirstName = '一郎', LastName = '鈴木', Email = 'ichiro.suzuki@biztest.co.jp');
			insert con1;

			// キャンペーンの追加
			Date dt = system.Today();
			Campaign cp1 = new Campaign(Name = '採用決定向上編ABCDE', StartDate = dt, EndDate = dt, IsActive = true);
			Campaign cp2 = new Campaign(Name = '成功事例セミナーFFFFFF', StartDate = dt, EndDate = dt, IsActive = true);
			insert cp1;
			insert cp2;


			// キャンペーンメンバーの追加
			Lead led1Id = [SELECT Id FROM Lead WHERE Email = 'taro.yamada@biztest.co.jp' LIMIT 1];
			Contact con1Id = [SELECT Id FROM Contact WHERE Email = 'ichiro.suzuki@biztest.co.jp' LIMIT 1];
			Campaign cp1Id = [SELECT Id FROM Campaign WHERE Name = '採用決定向上編ABCDE' LIMIT 1];
			Campaign cp2Id = [SELECT Id FROM Campaign WHERE Name = '成功事例セミナーFFFFFF' LIMIT 1];
			CampaignMember cpm1 = new CampaignMember(LeadId = led1Id.Id, CampaignId = cp1Id.Id);
			CampaignMember cpm2 = new CampaignMember(LeadId = led1Id.Id, CampaignId = cp2Id.Id);
			CampaignMember cpm3 = new CampaignMember(ContactId = con1Id.Id, CampaignId = cp2Id.Id);
			insert cpm1;
			insert cpm2;
			insert cpm3;


			// 作成済みアンケートの追加
			CampaignMember cpm2Id = [SELECT Id FROM CampaignMember WHERE LeadId = :led1Id.Id AND CampaignId = :cp2Id.Id];
			Seminar_Survey_Result__c ssr2 = new Seminar_Survey_Result__c(
				CampaignMemberId__c = cpm2Id.Id, LeadId__c = led1Id.Id, CampaignId__c = cp2Id.Id,
				Company__c = 'テストカンパニー', Department__c = '人事部', Name__c = '山田 太郎'
			);
			insert ssr2;

		}
	}


	@isTest static void test_method_Seminar_Survey() {
		Test.startTest();
		// VFPのインスタンス化
		PageReference pageRef = Page.VFP_CPM_SeminarManagement;
		Test.setCurrentPage(pageRef);
		// コントローラのインスタンス化
		CLS_CPM_SeminarManagement ctrl = new CLS_CPM_SeminarManagement();

		Campaign cp2Id = [SELECT Id FROM Campaign WHERE Name = '成功事例セミナーFFFFFF' LIMIT 1];
		ctrl.selectedTargetMenu = cp2Id.Id;
		ctrl.selectedActionMenu = 'アンケート入力';

		String cp2IdStr = (String)cp2Id.Id;
		List<Seminar_Survey_Result__c> ssrList = CLS_CPM_SeminarManagement.getSeminarSurveyResult(cp2IdStr);
		List<CampaignMember> cpmList = CLS_CPM_SeminarManagement.getCampaignMember(cp2IdStr);
		if(!ssrList.isEmpty()){
			for(Seminar_Survey_Result__c ssr : ssrList){
				ssr.know_was_triggered__c = 'CMを見て';
			}
			CLS_CPM_SeminarManagement.saveSsrRecords(ssrList);
		}
		List<Seminar_Survey_Result__c> ssrL = [SELECT know_was_triggered__c FROM Seminar_Survey_Result__c];
		System.assertEquals(ssrL[0].know_was_triggered__c, 'CMを見て');
	    Test.stopTest();
	}

	@isTest static void test_method_DRA_Attendance() {
		Test.startTest();
		// VFPのインスタンス化
		PageReference pageRef = Page.VFP_CPM_SeminarManagement;
		Test.setCurrentPage(pageRef);
		// コントローラのインスタンス化
		CLS_CPM_SeminarManagement ctrl = new CLS_CPM_SeminarManagement();

		Campaign cp1Id = [SELECT Id FROM Campaign WHERE Name = '採用決定向上編ABCDE' LIMIT 1];
		ctrl.selectedTargetMenu = cp1Id.Id;
		ctrl.selectedActionMenu = '出席管理';

		String cp1IdStr = (String)cp1Id.Id;
		List<CampaignMember> cpmList = CLS_CPM_SeminarManagement.getCampaignMember(cp1IdStr);
		if(!cpmList.isEmpty()){
			for(CampaignMember cpm : cpmList){
				cpm.Path__c = 'CMを見て';
			}
			CLS_CPM_SeminarManagement.saveCpmRecords(cpmList);
		}
		String cpName = CLS_CPM_SeminarManagement.getCampaignName(cp1IdStr);
		System.assertEquals(cpName, '採用決定向上編ABCDE');
		List<CampaignMember> cpmL = [SELECT Path__c FROM CampaignMember];
		System.assertEquals(cpmL[0].Path__c, 'CMを見て');

		String topPage = ctrl.topPageUrl;
		String dUrl = ctrl.domainUrl;

		Test.stopTest();
	}


}