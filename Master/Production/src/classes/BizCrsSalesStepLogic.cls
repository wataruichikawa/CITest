public with sharing class BizCrsSalesStepLogic {
	// 現在時刻
	public static String getCurrentSalesStep(Account ac){
		System.debug('*************** ac:' + ac);
		System.debug('*************** ac.CrsSecondInterviewCountLastThisM__c:' + ac.CrsSecondInterviewCountLastThisM__c);
		System.debug('*************** ac.CrsLastInterviewCountLastThisM__c:' + ac.CrsLastInterviewCountLastThisM__c);
		Date currentDate = Date.today();
		Decimal crsSecondInterviewCount = ac.CrsSecondInterviewCountLastThisM__c + ac.CrsLastInterviewCountLastThisM__c;

			// STEP21~11
		if (ac.Field156__c != null && ('承認済'.equals(ac.Field1__c) || '承認'.equals(ac.Field1__c)) && ac.Field156__c.daysBetween(currentDate) <= 0) {
			if (ac.CrsJoinedCountThisContract__c >= 1) {
				return 'STEP21:内定承諾';
			} else if (ac.CrsOfferCountThisContract__c >= 1) {
				return 'STEP20:内定通知済1以上';
			} else if (crsSecondInterviewCount >= 1) {
				return 'STEP19:終面1以上';
			} else if (ac.CrsFirstInterviewCountLastThisM__c >= 5) {
				return 'STEP18:1面設定済5以上';
			} else if (ac.CrsDocumentScreeningOkCLastThisM__c >= 8) {
				return 'STEP17:書類OK8 以上';
			} else if (ac.CrsPlatinumScoutSendCLastThisM__c >= 1) {
				return 'STEP16:プラスカ送信済';
			} else if (ac.Field208__c > 0) {
				return 'STEP15:求人案内設定済';
			} else if (ac.Field226__c > 0) {
				return 'STEP14:求人登録（承認済）';
			} else{
				return 'STEP11:アカウント開設済';
			}
			//STEP10~4
		} else if ('STEP04：訪問前準備'.equals(ac.CrsLatestOpportunityStage__c)) {
			return 'STEP04:訪問前準備';
	    } else if ('STEP03：アポ獲得'.equals(ac.CrsLatestOpportunityStage__c)) {
			return 'STEP03:アポ獲得';
		}else if (ac.CrsLastTodoDatetime__c != null && ac.CrsLastTodoDatetime__c.date().daysBetween(currentDate) < 180){
			return 'STEP02:コネクト';
		}else{
			return 'STEP00:担当割り当て';
		}
	}
}