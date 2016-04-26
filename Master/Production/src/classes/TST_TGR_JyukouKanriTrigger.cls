/**
 * TST_TGR_CampaignMemberTrigger
 *
 * テスト対象
 * 1.TGR_JyukouKanriTrigger
 * 2.JKK_JyukouKanriProcess
 * ----------------------------------------
 * @createdName      : S.Sogawa
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_JyukouKanriTrigger {

	static testMethod void test() {
		//社員マスタ作成
		SyainMaster__c SM = new SyainMaster__c(ShinnyuSyainmei_del__c = UserInfo.getUserId());
		insert SM;

		//研修マスタ作成
		KensyuMaster__c KM = new KensyuMaster__c();
		insert KM;

		//受講管理作成
		JyukouKanri__c JK = new JyukouKanri__c(ShinnyuSyainMaster__c = SM.id, Kensyumei__c = KM.id);

		Test.startTest();
		insert JK;
		update JK;

		JK.TriggerInvalid__c = true;
		update JK;
		Test.stopTest();

		system.assert(![SELECT Id, TriggerInvalid__c FROM JyukouKanri__c WHERE Id = :JK.Id].TriggerInvalid__c);
	}

}