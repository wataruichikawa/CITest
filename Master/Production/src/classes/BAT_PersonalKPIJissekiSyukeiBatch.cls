/**
 * BAT_PersonalKPIJissekiSyukeiBatch
 * 商談から日別に個人別KPIを集計
 * 1商談複数化対応で一旦コメントアウトする.
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
global class BAT_PersonalKPIJissekiSyukeiBatch implements Database.Batchable<sObject> {

	public String query = 'SELECT Id, CreatedDate, LastmodifiedDate, Amount, IsDeleted, cancel_day__c, cancel_uriage__c, ContractCollectionDate__c, ContractCollectionInputDate__c, AppoAcquisitionDate__c, VisitDate__c, ContractRequestDate__c, VisitChargeUser__c, AppoAcquisitionUser__c FROM Opportunity WHERE AppoAcquisitionDate__c = THIS_MONTH OR AppoAcquisitionDate__c = LAST_MONTH OR VisitDate__c = THIS_MONTH OR VisitDate__c = LAST_MONTH OR ContractCollectionInputDate__c = LAST_MONTH OR ContractCollectionInputDate__c = THIS_MONTH ORDER BY VisitChargeUser__c DESC ALL ROWS';
	global Integer jobNo = -1;
	private final String JISSEKI = '実績';
	private Date targetDate = system.today() - Integer.valueOf(System.label.KPIDateChange);
	private Date jissekiDate = Date.valueOf(targetDate - 1);
	private DateTime startTime = system.now().addDays(-Integer.valueOf(System.label.KPIDateChange));

	//検索用ユーザ,ロール,プロファイル,スケジュール済みジョブ,採用プランマスタ,個人別KPI,商談
	private Map<id, User> userMap;
	private Map<id, UserRole> userRoleMap;
	private Map<id, Profile> profileMap;
	private CronTrigger cronTrigger;
	private Map<id, MstHirePlan__c> mstHirePlanMap;
	private Map<String, PersonalKPI__c> upsertKpiMap;
	private Map<id, Opportunity> opportunityMap;

	global BAT_PersonalKPIJissekiSyukeiBatch(Integer jobNo) {
		this.jobNo = jobNo;
	}

	/**
	 * 個人別KPI集計開始処理
	 * @param BC BatchableContextインターフェース
	 */
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	/**
	 * 個人別KPI集計処理
	 * @param BC BatchableContextインターフェース
	 * @param scope 商談リスト
	 */
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
/*
		List<Opportunity> opportunityList = (List<Opportunity>) scope;
		preparationData(opportunityList);
		Map<String, PersonalKPI__c> findKpiMap = new Map<String, PersonalKPI__c>();
		List<String> findKpiList = new List<String>();

		for (Opportunity opp : opportunityList) {

			if (opp.VisitChargeUser__c != null && userMap.containsKey(opp.VisitChargeUser__c)) {

				User usr = userMap.get(opp.VisitChargeUser__c);
				String kpiKey = JISSEKI + usr.name + String.valueOf(targetDate);
				PersonalKPI__c kpi;
				PersonalKPI__c transferKpi = null;

				if (upsertKpiMap.containsKey(kpiKey)) {
					kpi = upsertKpiMap.get(kpiKey);
				} else {
					kpi = createDefaultPersonalKPI(usr, kpiKey, targetDate);
				}

				MstHirePlan__c plan = mstHirePlanMap.get(opp.HirePlanRelatingToMasterData__c);

				if (plan != null) {
					Integer[] tmpInt;
					if (DateUtil.isSameDay(opp.AppoAcquisitionDate__c, jissekiDate)
						&& opp.AppoAcquisitionUser__c != null) {
						//★アポ取得者==★訪問・対応予定者
						if (opp.AppoAcquisitionUser__c == kpi.Syozokutantou__c) {
							//アポ数算出
							tmpInt = countApoJiApoHoumon(plan, opp);
							if (kpi.BIZAposuu__c != null) {
								kpi.BIZAposuu__c = kpi.BIZAposuu__c + tmpInt[0];
							} else {
								kpi.BIZAposuu__c = tmpInt[0];
							}
							if (kpi.CTAposuu__c != null) {
								kpi.CTAposuu__c = kpi.CTAposuu__c + tmpInt[1];
							} else {
								kpi.CTAposuu__c = tmpInt[1];
							}
							//自アポ数算出
							if (opp.AppoAcquisitionUser__c == opp.VisitChargeUser__c) {
								tmpInt = countApoJiApoHoumon(plan, opp);
								if (kpi.BIZJiappo__c != null) {
									kpi.BIZJiappo__c = kpi.BIZJiappo__c + tmpInt[0];
								} else {
									kpi.BIZJiappo__c = tmpInt[0];
								}
								if (kpi.CTJiappo__c != null) {
									kpi.CTJiappo__c = kpi.CTJiappo__c + tmpInt[1];
								} else {
									kpi.CTJiappo__c = tmpInt[1];
								}
							}
						//★アポ取得者!=★訪問・対応予定者
						} else {
							User apoUser = userMap.get(opp.AppoAcquisitionUser__c);
							if (apoUser != null) {
								String apoKpiKey = JISSEKI + apoUser.name + String.valueOf(targetDate);
								PersonalKPI__c apoKpi;
								if (upsertKpiMap.containsKey(apoKpiKey)) {
									apoKpi = upsertKpiMap.get(apoKpiKey);
								} else {
									apoKpi = createDefaultPersonalKPI(apoUser, apoKpiKey, targetDate);
								}
								//アポ数算出
								tmpInt = countApoJiApoHoumon(plan, opp);
								if (apoKpi.BIZAposuu__c != null) {
									apoKpi.BIZAposuu__c = apoKpi.BIZAposuu__c + tmpInt[0];
								} else {
									apoKpi.BIZAposuu__c = tmpInt[0];
								}
								if (apoKpi.CTAposuu__c != null) {
									apoKpi.CTAposuu__c = apoKpi.CTAposuu__c + tmpInt[1];
								} else {
									apoKpi.CTAposuu__c = tmpInt[1];
								}
								upsertKpiMap.put(apoKpi.Key__c, apoKpi);
							}
						}
					}
					//訪問数算出
					if (DateUtil.isSameDay(opp.VisitDate__c, jissekiDate)
						&& opp.VisitChargeUser__c == kpi.Syozokutantou__c) {
						tmpInt = countApoJiApoHoumon(plan, opp);
						if (kpi.BIZHoumonsuu__c != null) {
							kpi.BIZHoumonsuu__c = kpi.BIZHoumonsuu__c + tmpInt[0];
						} else {
							kpi.BIZHoumonsuu__c = tmpInt[0];
						}
						if (kpi.CTHoumonsuu__c != null) {
							kpi.CTHoumonsuu__c = kpi.CTHoumonsuu__c + tmpInt[1];
						} else {
							kpi.CTHoumonsuu__c = tmpInt[1];
						}
					}
					//固定受注件数,成功報酬受注件数,前工程受注金額,BOS前工程金額,BOS契約社数,契約社数(固定),契約社数(成果)算出
					if (DateUtil.isSameDay(opp.ContractCollectionInputDate__c, jissekiDate)
						&& opp.ContractCollectionDate__c != null) {
						transferKpi = calculationContractCollection(plan, opp, kpi.SyozokuTantouText__c, kpi.SyozokuTantou__c);
					}
					//マイナス計上
					if (DateUtil.isSameDay(opp.cancel_day__c, jissekiDate) && opp.cancel_uriage__c != null) {
						appropriateMinus(plan, opp, kpi);
					}

				}

				upsertKpiMap.put(kpi.Key__c, kpi);
				if (transferKpi != null) {
					//申込書回収日に一致する個人別KPIデータが存在する場合は、受注関連項目を更新する
					if (upsertKpiMap.containsKey(transferKpi.Key__c)) {
						PersonalKPI__c originalKpi = upsertKpiMap.get(transferKpi.Key__c);
						transferContractCollectionKpi(originalKpi, transferKpi);
						upsertKpiMap.put(originalKpi.Key__c, originalKpi);
					} else {
						//存在しない場合はMap、Listに保持
						if (findKpiMap.containsKey(transferKpi.Key__c)) {
							PersonalKPI__c originalKpi = findKpiMap.get(transferKpi.Key__c);
							transferContractCollectionKpi(originalKpi, transferKpi);
							findKpiMap.put(originalKpi.Key__c, originalKpi);
						} else {
							findKpiMap.put(transferKpi.Key__c, transferKpi);
							findKpiList.add(transferKpi.Key__c);
						}
					}
				}

			}

		}

		//申込書回収日に一致する個人別KPIデータが存在しなかった場合は検索後、受注関連項目を更新する
		if (!findKpiMap.isEmpty()) {
			List<PersonalKPI__c> kpiList = [SELECT Id, Key__c, BIZKoteijyutsuukensuu__c, BIZSeikouhousyuukensuu__c,
				BIZMaejyutyuukingaku__c, BIZBOSMaekouteiKingaku__c, BIZBOSKeiyakusya__c, BIZKeiyakusyasuuKotei__c,
				BIZKeiyakusyasuuSeika__c, CTKoteijyutsuukensuu__c, CTSeikouhousyuukensuu__c, CTMaejyutyuukingaku__c,
				CTBOSMaekouteiKingaku__c, CTBOSKeiyakusyasuu__c, CTKeiyakusyasuuKotei__c, CTKeiyakusyasuuSeika__c
				FROM PersonalKPI__c WHERE Key__c IN : findKpiList];
			Map<String, PersonalKPI__c> pkpiMap = new Map<String, PersonalKPI__c>();
			for (PersonalKPI__c pkpi : kpiList) {
				pkpiMap.put(pkpi.Key__c, pkpi);
			}
			for (PersonalKPI__c pkpi : findKpiMap.values()) {
				if (pkpiMap.containsKey(pkpi.Key__c)) {
					PersonalKPI__c originalKpi = pkpiMap.get(pkpi.Key__c);
					transferContractCollectionKpi(originalKpi, pkpi);
					upsertKpiMap.put(originalKpi.Key__c, originalKpi);
				} else {
					//検索結果に存在しない場合は新規に個人別KPIを作成
					PersonalKPI__c newKpi = createDefaultPersonalKPI(userMap.get(pkpi.SyozokuTantou__c), pkpi.Key__c,
						pkpi.Syukeibi__c);
					transferContractCollectionKpi(newKpi, pkpi);
					upsertKpiMap.put(newKpi.Key__c, newKpi);
				}
			}
		}

		if (!upsertKpiMap.isEmpty()) {
			upsert upsertKpiMap.values() Key__c;
		}
*/
	}

	/**
	 * 個人別KPI集計終了処理
	 * @param BC BatchableContextインターフェース
	 */
	global void finish(Database.BatchableContext BC) {
		BAT_JobExecutor.executeNextJob(jobNo);
	}

	/**
	 * データの準備
	 * メイン処理で使用するユーザ・ロール・プロファイル・スケジュール済みジョブ・採用プランマスタ・個人別KPI、
	 * 商談を取得しマップを生成
	 * @param opportunityList 商談リスト
	 */
/*
	private void preparationData(List<Opportunity> opportunityList) {

		userMap = new Map<id, user>(
			[SELECT Id, Name, userRoleId, profileId FROM User WHERE isActive = true AND UserType = 'Standard']);
		userRoleMap = new Map<id, UserRole>([SELECT Id, Name, RollupDescription FROM UserRole]);
		profileMap = new Map<id, Profile>([SELECT Id, Name FROM Profile]);
		List<CronTrigger> triggerList = [SELECT Id, PreviousFireTime, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = '個人別KPI実績バッチ'];
		if (!triggerList.isEmpty()) {
			cronTrigger = triggerList.get(0);
		}
		mstHirePlanMap = new Map<id, MstHirePlan__c>(
			[SELECT Id, Name, Service__c, DisplayNameForClient__c From MstHirePlan__c]);
		List<PersonalKPI__c> pkpiList = [SELECT Id, Name, BIZBOSKeiyakusya__c,ID__c, BIZBOSMaekouteiKingaku__c,CTBOSKeiyakusyasuu__c,CTBOSMaekouteiKingaku__c, BIZAposuu__c, CTAposuu__c, Profile__c, LastModifieddate,Createddate,OwnerID,BIZPSAnkensuu__c,BIZPSsoushinsuu__c,BIZOubosuu__c,BIZKadouAnkensuu__c,BIZFollow__c,BIZKyujinannaisoushinsuu__c,BIZKyujinkakutokusuu__c,BIZKetteisuu__c,BIZKoteijyutsuukensuu__c,BIZAtokouteiUriage__c,BIZJiappo__c,BIZSyoruiOK__c,BIZSeikouhousyuukensuu__c,BIZMaejyutyuukingaku__c,BIZHoumonsuu__c,CTPSOubosuu__c,CTPSSoushinsuu__c,CTOubosuu__c,CTKyujinkakutokusuu__c,CTKetteisuu__c,CTFollow__c,CTKoteijyutsuukensuu__c,CTAtokouteiUriage__c,CTJiappo__c,CTJidouSukautosuu__c,CTSyoruiOK__c,CTSeikouhousyuukensuu__c,CTMaejyutyuukingaku__c,CTHoumonsuu__c,Key__c,Syukeibi__c,Syozokutantou__c,SyozokuTantouTeam__c,SyozokuTantouText__c,Yojitsukubun__c,BIZKeiyakusyasuuKotei__c,BIZKeiyakusyasuuSeika__c,CTKeiyakusyasuuKotei__c,CTKeiyakusyasuuSeika__c FROM PersonalKPI__c WHERE Syukeibi__c = :targetDate];

		opportunityMap = new Map<id, Opportunity>();
		upsertKpiMap = new Map<string, PersonalKPI__c>();

		//商談を検索するためのマップを作成
		for(Opportunity opp : opportunityList){
			opportunityMap.put(opp.id, opp);
		}

		//既にある個人別KPI検索用MAP作成
		for(PersonalKPI__c kpi : pkpiList){
			upsertKpiMap.put(kpi.Key__c, kpi);
		}

	}
*/
	/**
	 * 新規登録用の個人別KPIオブジェクトを生成
	 * @param usr ユーザ
	 * @param kpiKey 個人別KPIのキー項目(予実区分+所属担当（テキスト）+集計日)
	 * @param syukeiDate 集計日
	 * @return 個人別KPI
	 */
/*
	private PersonalKPI__c createDefaultPersonalKPI(User usr, String kpiKey, Date syukeiDate) {

		PersonalKPI__c kpi = new PersonalKPI__c();

		//情報[ プロファイル名 ]
		kpi.Profile__c = '';
		if (profileMap.containsKey(usr.profileId)) {
			kpi.Profile__c = profileMap.get(usr.profileId).Name;
		}

		//共通情報[ 所属担当チーム,所属担当,所属担当（テキスト）,予実区分,集計日 ]
		kpi.SyozokuTantouTeam__c = '';
		if (userRoleMap.containsKey(usr.userRoleId)) {
			kpi.SyozokuTantouTeam__c = userRoleMap.get(usr.userRoleId).RollupDescription;
		}

		kpi.Syozokutantou__c = usr.id;
		kpi.SyozokuTantouText__c = usr.Name;
		kpi.Yojitsukubun__c = JISSEKI;
		kpi.Syukeibi__c = syukeiDate;

		//BIZ前工程[ BIZアポ数,BIZ自アポ,BIZ訪問数,BIZ固定受注件数,BIZ成功報酬受注件数,BIZ前工程受注金額 ]
		kpi.BIZAposuu__c = 0;
		kpi.BIZJiappo__c = 0;
		kpi.BIZHoumonsuu__c = 0;
		kpi.BIZKoteijyutsuukensuu__c = 0;
		kpi.BIZSeikouhousyuukensuu__c = 0;
		kpi.BIZMaejyutyuukingaku__c = 0;

		//CT前工程[ CTアポ数,CT自アポ,CT訪問数,CT固定受注件数,CT成功報酬受注件数,CT前工程受注金額 ]
		kpi.CTAposuu__c = 0;
		kpi.CTJiappo__c = 0;
		kpi.CTHoumonsuu__c = 0;
		kpi.CTKoteijyutsuukensuu__c = 0;
		kpi.CTSeikouhousyuukensuu__c = 0;
		kpi.CTMaejyutyuukingaku__c = 0;

		//BOS前工程特別項目[ BIZBOS前工程金額,CTBOS前工程金額,CTBOS契約社数,BIZBOS契約社数 ]
		kpi.BIZBOSMaekouteiKingaku__c = 0;
		kpi.CTBOSMaekouteiKingaku__c = 0;
		kpi.CTBOSKeiyakusyasuu__c = 0;
		kpi.BIZBOSKeiyakusya__c = 0;

		//BIZ後工程[ BIZ契約社数(固定),BIZ契約社数(成果),BIZ求人獲得数,BIZ PS送信数,BIZ応募数,BIZ稼働案件数,
		//           BIZフォロー率,BIZ求人案内送信数,BIZ PS20案件数,BIZ書類OK数,BIZ決定数,BIZ後工程売上 ]
		kpi.BIZKeiyakusyasuuKotei__c = 0;
		kpi.BIZKeiyakusyasuuSeika__c = 0;
		kpi.BIZKyujinkakutokusuu__c = 0;
		kpi.BIZPSsoushinsuu__c = 0;
		kpi.BIZOubosuu__c = 0;
		kpi.BIZKadouAnkensuu__c = 0;
		kpi.BIZFollow__c = 0;
		kpi.BIZKyujinannaisoushinsuu__c = 0;
		kpi.BIZPSAnkensuu__c = 0;
		kpi.BIZSyoruiOK__c = 0;
		kpi.BIZKetteisuu__c = 0;
		kpi.BIZAtokouteiUriage__c = 0;

		//CT後工程[ CT契約社数(固定),CT契約社数(成果),CT求人獲得数,CT　PS送信数,CT応募数,CT決定数,
		//          CTフォロー率,CT自動スカウト数,CT　PS応募数,CT書類OK数,CT後工程売上 ]
		kpi.CTKeiyakusyasuuKotei__c = 0;
		kpi.CTKeiyakusyasuuSeika__c = 0;
		kpi.CTKyujinkakutokusuu__c = 0;
		kpi.CTPSSoushinsuu__c = 0;
		kpi.CTOubosuu__c = 0;
		kpi.CTKetteisuu__c = 0;
		kpi.CTFollow__c = 0;//
		kpi.CTJidouSukautosuu__c = 0;
		kpi.CTPSOubosuu__c = 0;
		kpi.CTSyoruiOK__c = 0;
		kpi.CTAtokouteiUriage__c = 0;

		//システム情報[ 個人別KPIキー項目,所有者 ]
		kpi.Key__c = kpiKey;
		kpi.OwnerId = usr.id;
		return kpi;

	}
*/
	/**
	 * アポ数・自アポ数・訪問数を算出
	 * 商談が削除されて場合はマイナスする
	 * @param plan 採用プランマスタ
	 * @param opp 商談
	 * @return 要素0:BIZカウント|要素1:CTカウント
	 */
/*
	private Integer[] countApoJiApoHoumon(MstHirePlan__c plan, Opportunity opp) {

		Integer bizCount = 0;
		Integer ctCount = 0;
		Integer cnt = opportunityDeleted(opp);

		if (cnt == 0) {
			return new Integer[] { 0, 0 };
		}

		if (plan != null) {
			//CT
			if (plan.Service__c == 'キャリアトレック') {
				ctCount = cnt;
			//BIZ
			} else if (plan.Service__c == 'ビズリーチ') {
				bizCount = cnt;
			//BOS
			} else if (plan.Service__c == 'BOS') {
				bizCount = cnt;
			//キャリトレBOS
			} else if (plan.Service__c == 'キャリアトレックBOS') {
				ctCount = cnt;
			}
		}

		return new Integer[] { bizCount, ctCount };

	}
*/
	/**
	 * 固定受注件数,成功報酬受注件数,前工程受注金額,BOS前工程金額,BOS契約社数,契約社数(固定),契約社数(成果)を算出
	 * @param plan 採用プランマスタ
	 * @param opp 商談
	 * @param userName 担当者名
	 */
/*
	private PersonalKPI__c calculationContractCollection(MstHirePlan__c plan, Opportunity opp, String userName,
		String userId) {

		Integer cnt = opportunityDeleted(opp);
		if (cnt == 0) {
			return null;
		}
		//申込書回収日+1日をキーにして集計用の個人別KPIオブジェクトを作成
		Date keyDate = opp.ContractCollectionDate__c.addDays(1);
		PersonalKPI__c kpi = new PersonalKPI__c(BIZKoteijyutsuukensuu__c = 0, BIZSeikouhousyuukensuu__c = 0,
			BIZMaejyutyuukingaku__c = 0, BIZBOSMaekouteiKingaku__c = 0, BIZBOSKeiyakusya__c = 0,
			BIZKeiyakusyasuuKotei__c = 0, BIZKeiyakusyasuuSeika__c = 0, CTKoteijyutsuukensuu__c = 0,
			CTSeikouhousyuukensuu__c = 0, CTMaejyutyuukingaku__c = 0, CTBOSMaekouteiKingaku__c = 0,
			CTBOSKeiyakusyasuu__c = 0, CTKeiyakusyasuuKotei__c = 0, CTKeiyakusyasuuSeika__c = 0,
			SyozokuTantou__c = userId, Syukeibi__c = keyDate, Key__c = JISSEKI + userName + String.valueOf(keyDate));

		if (plan != null) {

			String dispName = plan.DisplayNameForClient__c;
			if (plan.Service__c == 'キャリアトレック') {

				if (dispName == 'スタンダードプラン' || dispName == 'トライアルプラン'
					|| dispName == 'プレミアムプラン' || dispName == '貴社特別プラン') {
					kpi.CTKoteijyutsuukensuu__c = cnt;
					kpi.CTKeiyakusyasuuKotei__c = cnt;
					if (opp.Amount != null) {
						kpi.CTMaejyutyuukingaku__c = opp.Amount * cnt;
					}
				} else if (dispName == '成功報酬プラン' || dispName == 'エグゼクティブサーチサポート') {
					kpi.CTSeikouhousyuukensuu__c = cnt;
					kpi.CTKeiyakusyasuuSeika__c = cnt;
					if (opp.Amount != null) {
						kpi.CTMaejyutyuukingaku__c = opp.Amount * cnt;
					}
				} else if (dispName == 'キャリアトレックBOS') {
					kpi.CTBOSKeiyakusyasuu__c = cnt;
					if (opp.Amount != null) {
						kpi.CTBOSMaekouteiKingaku__c = opp.Amount * cnt;
					}
				}

			} else if (plan.Service__c == 'ビズリーチ') {

				if (dispName == 'スタンダードプラン' || dispName == 'トライアルプラン'
					|| dispName == 'プレミアムプラン' || dispName == '貴社特別プラン') {
					kpi.BIZKoteijyutsuukensuu__c = cnt;
					kpi.BIZKeiyakusyasuuKotei__c = cnt;
					if (opp.Amount != null) {
						kpi.BIZMaejyutyuukingaku__c = opp.Amount * cnt;
					}
				} else if (dispName == '成功報酬プラン' || dispName == 'エグゼクティブサーチサポート') {
					kpi.BIZSeikouhousyuukensuu__c = cnt;
					kpi.BIZKeiyakusyasuuSeika__c = cnt;
					if (opp.Amount != null) {
						kpi.BIZMaejyutyuukingaku__c = opp.Amount * cnt;
					}
				} else if (dispName == '公募プラン' || dispName == 'プラチナスカウト' || dispName == 'その他') {
					if (opp.Amount != null) {
						kpi.BIZMaejyutyuukingaku__c = opp.Amount * cnt;
					}
					if (opp.Amount != null) {
						kpi.CTMaejyutyuukingaku__c = opp.Amount * cnt;
					}
				} else if(dispName == 'BOS') {
					kpi.BIZBOSKeiyakusya__c = cnt;
					if (opp.Amount != null) {
						kpi.BIZBOSMaekouteiKingaku__c = opp.Amount * cnt;
					}
				}

			}

		} else {
			if(opp.Amount != null){
				kpi.BIZMaejyutyuukingaku__c = opp.Amount * cnt;
			}
		}

		return kpi;
	}
*/
	/**
	 * マイナス計上
	 * @param plan 採用プランマスタ
	 * @param opp 商談
	 * @param kpi 個人別KPI
	 */
/*
	private void appropriateMinus(MstHirePlan__c plan, Opportunity opp, PersonalKPI__c kpi) {

		Integer cnt = opportunityDeleted(opp);
		if (cnt == 0) {
			return;
		}

		//マイナス計上のため商談通常時をマイナス、商談削除時をプラスにする
		cnt = cnt * -1;

		if (plan != null) {
			if (plan.Service__c == 'キャリアトレック') {
				if (kpi.CTMaejyutyuukingaku__c != null) {
					kpi.CTMaejyutyuukingaku__c = kpi.CTMaejyutyuukingaku__c + (opp.cancel_uriage__c * cnt);
				} else {
					kpi.CTMaejyutyuukingaku__c = (opp.cancel_uriage__c * cnt);
				}
			} else if (plan.Service__c == 'ビズリーチ') {
				if (kpi.BIZMaejyutyuukingaku__c != null) {
					kpi.BIZMaejyutyuukingaku__c = kpi.BIZMaejyutyuukingaku__c + (opp.cancel_uriage__c * cnt);
				} else {
					kpi.BIZMaejyutyuukingaku__c = (opp.cancel_uriage__c * cnt);
				}
			} else if (plan.Service__c == 'BOS') {
				if (kpi.BIZBOSMaekouteiKingaku__c != null) {
					kpi.BIZBOSMaekouteiKingaku__c = kpi.BIZBOSMaekouteiKingaku__c + (opp.cancel_uriage__c * cnt);
				} else {
					kpi.BIZBOSMaekouteiKingaku__c = (opp.cancel_uriage__c * cnt);
				}
			} else if (plan.Service__c == 'キャリアトレックBOS') {
				if (kpi.CTBOSMaekouteiKingaku__c != null) {
					kpi.CTBOSMaekouteiKingaku__c = kpi.CTBOSMaekouteiKingaku__c + (opp.cancel_uriage__c * cnt);
				} else {
					kpi.CTBOSMaekouteiKingaku__c = (opp.cancel_uriage__c * cnt);
				}
			}
		} else {
			if (kpi.BIZMaejyutyuukingaku__c != null) {
				kpi.BIZMaejyutyuukingaku__c = kpi.BIZMaejyutyuukingaku__c + (opp.cancel_uriage__c * cnt);
			} else {
				kpi.BIZMaejyutyuukingaku__c = (opp.cancel_uriage__c * cnt);
			}
		}

	}
*/
	/**
	 * 固定受注件数,成功報酬受注件数,前工程受注金額,BOS前工程金額,BOS契約社数,契約社数(固定),契約社数(成果)を移す
	 * @param originalKpi 移動先個人別KPI
	 * @param transferKpi 移動元個人別KPI
	 */
/*
	private void transferContractCollectionKpi(PersonalKPI__c originalKpi, PersonalKPI__c transferKpi) {

		if (originalKpi.BIZKoteijyutsuukensuu__c != null) {
			originalKpi.BIZKoteijyutsuukensuu__c = originalKpi.BIZKoteijyutsuukensuu__c + transferKpi.BIZKoteijyutsuukensuu__c;
		} else {
			originalKpi.BIZKoteijyutsuukensuu__c = transferKpi.BIZKoteijyutsuukensuu__c;
		}
		if (originalKpi.BIZSeikouhousyuukensuu__c != null) {
			originalKpi.BIZSeikouhousyuukensuu__c = originalKpi.BIZSeikouhousyuukensuu__c + transferKpi.BIZSeikouhousyuukensuu__c;
		} else {
			originalKpi.BIZSeikouhousyuukensuu__c = transferKpi.BIZSeikouhousyuukensuu__c;
		}
		if (originalKpi.BIZMaejyutyuukingaku__c != null) {
			originalKpi.BIZMaejyutyuukingaku__c = originalKpi.BIZMaejyutyuukingaku__c + transferKpi.BIZMaejyutyuukingaku__c;
		} else {
			originalKpi.BIZMaejyutyuukingaku__c = transferKpi.BIZMaejyutyuukingaku__c;
		}
		if (originalKpi.BIZBOSMaekouteiKingaku__c != null) {
			originalKpi.BIZBOSMaekouteiKingaku__c = originalKpi.BIZBOSMaekouteiKingaku__c + transferKpi.BIZBOSMaekouteiKingaku__c;
		} else {
			originalKpi.BIZBOSMaekouteiKingaku__c = transferKpi.BIZBOSMaekouteiKingaku__c;
		}
		if (originalKpi.BIZBOSKeiyakusya__c != null) {
			originalKpi.BIZBOSKeiyakusya__c = originalKpi.BIZBOSKeiyakusya__c + transferKpi.BIZBOSKeiyakusya__c;
		} else {
			originalKpi.BIZBOSKeiyakusya__c = transferKpi.BIZBOSKeiyakusya__c;
		}
		if (originalKpi.BIZKeiyakusyasuuKotei__c != null) {
			originalKpi.BIZKeiyakusyasuuKotei__c = originalKpi.BIZKeiyakusyasuuKotei__c + transferKpi.BIZKeiyakusyasuuKotei__c;
		} else {
			originalKpi.BIZKeiyakusyasuuKotei__c = transferKpi.BIZKeiyakusyasuuKotei__c;
		}
		if (originalKpi.BIZKeiyakusyasuuSeika__c != null) {
			originalKpi.BIZKeiyakusyasuuSeika__c = originalKpi.BIZKeiyakusyasuuSeika__c + transferKpi.BIZKeiyakusyasuuSeika__c;
		} else {
			originalKpi.BIZKeiyakusyasuuSeika__c = transferKpi.BIZKeiyakusyasuuSeika__c;
		}
		if (originalKpi.CTKoteijyutsuukensuu__c != null) {
			originalKpi.CTKoteijyutsuukensuu__c = originalKpi.CTKoteijyutsuukensuu__c + transferKpi.CTKoteijyutsuukensuu__c;
		} else {
			originalKpi.CTKoteijyutsuukensuu__c = transferKpi.CTKoteijyutsuukensuu__c;
		}
		if (originalKpi.CTSeikouhousyuukensuu__c != null) {
			originalKpi.CTSeikouhousyuukensuu__c = originalKpi.CTSeikouhousyuukensuu__c + transferKpi.CTSeikouhousyuukensuu__c;
		} else {
			originalKpi.CTSeikouhousyuukensuu__c = transferKpi.CTSeikouhousyuukensuu__c;
		}
		if (originalKpi.CTMaejyutyuukingaku__c != null) {
			originalKpi.CTMaejyutyuukingaku__c = originalKpi.CTMaejyutyuukingaku__c + transferKpi.CTMaejyutyuukingaku__c;
		} else {
			originalKpi.CTMaejyutyuukingaku__c = transferKpi.CTMaejyutyuukingaku__c;
		}
		if (originalKpi.CTBOSMaekouteiKingaku__c != null) {
			originalKpi.CTBOSMaekouteiKingaku__c = originalKpi.CTBOSMaekouteiKingaku__c + transferKpi.CTBOSMaekouteiKingaku__c;
		} else {
			originalKpi.CTBOSMaekouteiKingaku__c = transferKpi.CTBOSMaekouteiKingaku__c;
		}
		if (originalKpi.CTBOSKeiyakusyasuu__c != null) {
			originalKpi.CTBOSKeiyakusyasuu__c = originalKpi.CTBOSKeiyakusyasuu__c + transferKpi.CTBOSKeiyakusyasuu__c;
		} else {
			originalKpi.CTBOSKeiyakusyasuu__c = transferKpi.CTBOSKeiyakusyasuu__c;
		}
		if (originalKpi.CTKeiyakusyasuuKotei__c != null) {
			originalKpi.CTKeiyakusyasuuKotei__c = originalKpi.CTKeiyakusyasuuKotei__c + transferKpi.CTKeiyakusyasuuKotei__c;
		} else {
			originalKpi.CTKeiyakusyasuuKotei__c = transferKpi.CTKeiyakusyasuuKotei__c;
		}
		if (originalKpi.CTKeiyakusyasuuSeika__c != null) {
			originalKpi.CTKeiyakusyasuuSeika__c = originalKpi.CTKeiyakusyasuuSeika__c + transferKpi.CTKeiyakusyasuuSeika__c;
		} else {
			originalKpi.CTKeiyakusyasuuSeika__c = transferKpi.CTKeiyakusyasuuSeika__c;
		}

	}
*/
	/**
	 * 商談の状態を判別
	 * @param opp 商談
	 * @return 0:削除済(マイナス処理不要)|1:通常|-1:削除済(マイナス処理必要)
	 */
/*
	private Integer opportunityDeleted(Opportunity opp) {
		Integer cnt = 0;
		if (!opp.IsDeleted) {
			cnt = 1;
		//商談削除時はマイナスカウント判定
		} else {
			if (cronTrigger != null &&  cronTrigger.PreviousFireTime != null) {
				//前回バッチ開始時間以降に登録され、今回バッチ開始時間前に削除された場合はマイナスしない
				if (!(cronTrigger.PreviousFireTime < opp.createdDate && opp.createdDate < startTime)
					&& (cronTrigger.PreviousFireTime < opp.LastModifiedDate && opp.LastModifiedDate < startTime)) {
					cnt = -1;
				}
			} else {
				//前回バッチ開始時間が取得できない場合、今回バッチ開始時間-1日して判定
				DateTime previousFireTime = startTime.addDays(-1);
				if (!(previousFireTime < opp.createdDate && opp.createdDate < startTime)
					&& (previousFireTime < opp.LastModifiedDate && opp.LastModifiedDate < startTime)) {
					cnt = -1;
				}
			}
		}
		return cnt;
	}
*/
}