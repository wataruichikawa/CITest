/**
 * BAT_JobExecutor
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
public class BAT_JobExecutor {

	/** 個人別KPI実績バッチ */
	@TestVisible private static final String JOB_KPI_SYUKEI = 'KpiSyukei';
	/** 取引先所有者変更_訪問予定日91日後 */
	@TestVisible private static final String JOB_ACC_91 = 'Acc91';
	/** PS送信日／TL追加日過去30日間フラグ */
	@TestVisible private static final String JOB_PS_30 = 'Ps30';
	/** DRCアカウントマネージメント 活動履歴アラート */
	@TestVisible private static final String JOB_AH_ALERT = 'AhAlert';
	/** ESS 商談自動作成 */
	@TestVisible private static final String JOB_AC_O = 'Aco';
	/** 包括契約対象解除 */
	@TestVisible private static final String JOB_INCLUSION = 'Inclusion';

	/**
	 * 次のJobを実行
	 * @param jobNo ジョブNo
	 */
	public static void executeNextJob(Integer jobNo) {
		jobNo++;
		if (jobNo < 1) return;
		BatchJobOrder__c bjo = BatchJobOrder__c.getOrgDefaults();
		Map<Integer, String> executeMap = new Map<Integer, String>();
		for (Integer i = bjo.StartJobNo__c.intValue(); i <= bjo.FinishJobNo__c.intValue(); i++) {
			executeMap.put(i, (String) bjo.get('Job' + String.valueOf(i) + '__c'));
		}
		if (executeMap.containsKey(jobNo)) {
			String jobName = executeMap.get(jobNo);
			if (String.isNotEmpty(jobName)) {
				executeNextBatch(jobNo, jobName);
			}
		}
	}

	/**
	 * バッチを実行
	 * @param jobNo ジョブNo
	 * @param jobName ジョブ名
	 */
	private static void executeNextBatch(Integer jobNo, String jobName) {
		Id jobId;
		if (JOB_KPI_SYUKEI.equals(jobName)) {
			jobId = Database.executeBatch(new BAT_PersonalKPIJissekiSyukeiBatch(jobNo));
		} else if (JOB_ACC_91.equals(jobName)) {
			jobId = Database.executeBatch(new BAT_AccountOwner91DaysBatch(jobNo));
		} else if (JOB_PS_30.equals(jobName)) {
			jobId = Database.executeBatch(new BAT_Ps30DaysShukeiBatch(jobNo), 1000);
		} else if (JOB_AH_ALERT.equals(jobName)) {
			jobId = Database.executeBatch(new BAT_DrcActivityHistoryAlertBatch(jobNo));
		} else if (JOB_AC_O.equals(jobName)) {
			jobId = Database.executeBatch(new BAT_AutoCreateOfOpportunityBatch(jobNo), 100);
		} else if (JOB_INCLUSION.equals(jobName)) {
			jobId = Database.executeBatch(new CLS_BAT_InclusionAccount(jobNo));
		}
		system.debug('***** jobId : ' + jobId);
	}

}