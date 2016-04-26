/* test2 */
/**
 * ACC_AccountProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
public class ACC_AccountProcess {

	/**
	 * マージ依頼メールを非同期実行
	 * @param accIdSet 取引先IDのセット
	 */
	@future
	public static void aysncMergeMailSend(Set<Id> accIdSet) {
		List<Account> accList = [SELECT Id, Name, Website, WebsiteDomain__c, Phone, AccountType__c, Field224_Merge__c,
			Field224_MergeReason__c FROM Account WHERE Id IN : accIdSet AND Field224_Merge__c = true];

		// マージ依頼メール機能（専用のListを準備）
		// マージ依頼フラグONの取引先より、Phone_WebsiteDomain__cをListに格納
		Map<String, String> phoneWebMap = new Map<String, String>();
		List<Account> mergeAcList = new List<Account>();
		List<Account> updateAcList = new List<Account>();

		if (!accList.isEmpty()) {
			for (Account mTAM : accList) {
				if (String.isNotBlank(mTAM.Website)) {
					String domain = UTL_CommonUtil.extractWebsiteDomain(mTAM.Website);
					if (String.isNotBlank(domain) && !domain.equals(mTAM.WebsiteDomain__c)) {
						phoneWebMap.put(mTAM.Phone, domain);
					} else if (String.isNotBlank(mTAM.WebsiteDomain__c)){
						phoneWebMap.put(mTAM.Phone, mTAM.WebsiteDomain__c);
					} else {
						phoneWebMap.put(mTAM.Phone, 'blank_domain_xxxxxx');
					}
				} else if (String.isNotBlank(mTAM.WebsiteDomain__c)){
					phoneWebMap.put(mTAM.Phone, mTAM.WebsiteDomain__c);
				} else {
					phoneWebMap.put(mTAM.Phone, 'blank_domain_xxxxxx');
				}
			}

			// マージ依頼メール機能（対象になりうる最小限のAccountをListに格納）
			// Phoneの完全一致もしくはWebsiteDomain__cの完全一致を条件にSOQLクエリを発行、Listに格納
			mergeAcList = [
				Select Id, Name, Phone, WebsiteDomain__c, LastModifiedBy.Name, LastModifiedBy.Email, AccountType__c
				From Account
				Where Phone In :phoneWebMap.keySet() or WebsiteDomain__c In :phoneWebMap.values() limit 50000
			];
		}

		boolean isSandbox = CommonUtil.RunningIsSandbox();
		for (Account acc : accList) {
			// マージ依頼メール機能（メイン処理） //////////////////////////////////////////////////////
			String domain = acc.WebsiteDomain__c;
			if (String.isBlank(domain)) {
				domain = 'blank_domain_xxxxxx';
			}
			String mgUser = '';
			String mgEmail = '';
			String msgMain = '';
			String msgSub = '';
			String msgReason = '';
			String mgTgtCom = '';
			String accountType = acc.AccountType__c;

			for (Account mAL : mergeAcList) {
				if (acc.Id == mAL.Id) {
					// 対象企業の処理
					mgUser = mAL.LastModifiedBy.Name;
					mgEmail = mAL.LastModifiedBy.Email;
					mgTgtCom = mAL.Name;
					if(String.isNotBlank(acc.Field224_MergeReason__c)){
						msgReason = system.Label.mergeReasonMsg + '\n' + acc.Field224_MergeReason__c;
					}
					msgMain = mAL.LastModifiedBy.Name + 'さんより\n' +system.Label.mergeEmailMainMsg + '\n\n\n' + system.Label.mergeAccountType + ' ' + accountType + '\n\n' + system.Label.mergeEmailTargetCompany + '              ' + mAL.Name + '  ' + system.Label.domain + mAL.Id + '\n\n';
				} else if ((acc.Phone == mAL.Phone || domain == mAL.WebsiteDomain__c) && acc.AccountType__c == mAL.AccountType__c) {
					// マージ対象企業の処理
					msgSub += system.Label.mergeEmailmergeCompany + '    ' + mAL.Name + '  ' + system.Label.domain + mAL.Id + '\n';
				}
			}
			OutboundEmail mail = new OutboundEmail();
			String toaddr = system.Label.mergeEmailTo;
			String[] toaddrlist = toaddr.split(',', 0);
			mail.createSendMessage(mgEmail
				, mgEmail
				, toaddrlist
				, new String[]{mgEmail}
				, system.Label.mergeEmailTitle+mgUser+'／'+mgTgtCom
				, system.Label.mergeEmailTopMsg+'\n\n\n'+msgMain+msgSub+'\n'+msgReason);
			if (!isSandbox && !Test.isRunningTest()) {
				mail.send();
				system.debug('@future merge mail send account id : ' + acc.Id);
			}
			acc.Field224_Merge__c = false;
			updateAcList.add(acc);
		}

		if (!updateAcList.isEmpty()) {
			//マージ依頼フラグをOFFにするだけなのでトリガーは起動させない
			UTL_TriggerUtil.canRunAccount = false;
			try {
				update updateAcList;
			} catch (Exception e) {
				String body = 'Field224_Merge__c : ' + String.valueOf(updateAcList.get(0).Field224_Merge__c);
				UTL_EmailUtil.sendSystemErrorMail(e, 'Marge Mail Update', body);
			}
		}

	}

	/**
	 * 所有者をシステム管理者にする(isInsertのみを想定)
	 * @param accNewList 取引先リスト(トリガー無効データ除くtrriger.new)
	 * @param accNewMap  取引先マップ(トリガー無効データ除くtrriger.newMap)
	 */
	private void isNewSetOwner(List<Account> accNewList, List<Account> accOldList, Map<Id, Account> accNewMap,
		Map<Id, Account> accOldMap, Boolean isInsert){

		if (accNewList.isEmpty()) return;
		if (isInsert != true) return;

		Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
		Map<String, User> userNameMap = (Map<String, User>) umap.get(DAO_UserDao.MAP_KEY_NAME);

		String adminName = System.Label.adminName;
		String adminId = UTL_CommonUtil.searchUserId(adminName , userNameMap );

		for (Account newAcc : accNewList){
			Account oldAcc = accOldMap != null ? accOldMap.get(newAcc.Id) : null;

			// システム管理者設定
			//UTL_CommonUtil.convertUserNameToId("Owner", crsEigyoId, newAcc, oldAcc, userNameMap);

		}


	}

	/**
	 * 共通処理
	 * @param accNewList 取引先リスト(トリガー無効データ除くtrriger.new)
	 * @param accOldList 取引先リスト(トリガー無効データ除くtrriger.old)
	 * @param accNewMap  取引先マップ(トリガー無効データ除くtrriger.newMap)
	 * @param accOldMap  取引先マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void commonProcess(List<Account> accNewList, List<Account> accOldList, Map<Id, Account> accNewMap,
		Map<Id, Account> accOldMap, boolean isInsert) {

		if (accNewList.isEmpty()) return;

		Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
		Map<Id, User> userIdMap = (Map<Id, User>) umap.get(DAO_UserDao.MAP_KEY_ID);
		Map<String, User> userNameMap = (Map<String, User>) umap.get(DAO_UserDao.MAP_KEY_NAME);
		Map<Id, String> oldTeritoryMap = new Map<Id, String>();

		String crsEigyoName = Schema.SObjectType.Account.fields.Field107__c.Name;
		String crsEigyoId = Schema.SObjectType.Account.fields.CrsSales_RepresentativeMain__c.Name;
		String crsUnyoName = Schema.SObjectType.Account.fields.CrsSalesStaffForLink__c.Name;
		String crsUnyoId = Schema.SObjectType.Account.fields.CrsSale_Representative__c.Name;
		//項目削除によるコメントアウト
		//String ctsMaeTanName = Schema.SObjectType.Account.fields.CT_MaeTantousya__c.Name;
		String ctEigyoName = Schema.SObjectType.Account.fields.CrtSalesStaffForLink__c.Name;
		String ctEigyoId = Schema.SObjectType.Account.fields.careertreck_sales_representative__c.Name;
		String ctUnyoName = Schema.SObjectType.Account.fields.careertreck_representative__c.Name;
		String ctUnyoId = Schema.SObjectType.Account.fields.careertreck_representativeUser__c.Name;
		String bosPlanName = Schema.SObjectType.Account.fields.CRS_RPOTantousya_BOS__c.Name;
		String bosPlanId = Schema.SObjectType.Account.fields.CRS_BOSPlanner__c.Name;
		String bosTantoName = Schema.SObjectType.Account.fields.CTBOSTantousya__c.Name;
		String bosTantoId = Schema.SObjectType.Account.fields.CTBOSTantou__c.Name;
		String crsMaeTantoAddRequestName = Schema.SObjectType.Account.fields.req_add_list_username__c.Name;
		String crsMaeTantoId = Schema.SObjectType.Account.fields.CRS_MaeTantousya__c.Name;
		String crsMaeTantoAddRequestId = Schema.SObjectType.Account.fields.req_add_list_user__c.Name;


		for (Account newAcc : accNewList) {
			Account oldAcc = accOldMap != null ? accOldMap.get(newAcc.Id) : null;
			// CRS担当営業設定
			UTL_CommonUtil.convertUserNameToId(crsEigyoName, crsEigyoId, newAcc, oldAcc, userNameMap);
			// CRS担当運用設定
			UTL_CommonUtil.convertUserNameToId(crsUnyoName, crsUnyoId, newAcc, oldAcc, userNameMap);
			// キャリアトレック担当営業設定
			UTL_CommonUtil.convertUserNameToId(ctEigyoName, ctEigyoId, newAcc, oldAcc, userNameMap);
			// キャリアトレック担当運用設定
			UTL_CommonUtil.convertUserNameToId(ctUnyoName, ctUnyoId, newAcc, oldAcc, userNameMap);
			// CRS_BOSプランナー設定
			UTL_CommonUtil.convertUserNameToId(bosPlanName, bosPlanId, newAcc, oldAcc, userNameMap);
			// CT_BOS担当者設定
			UTL_CommonUtil.convertUserNameToId(bosTantoName, bosTantoId, newAcc, oldAcc, userNameMap);
			// リスト追加「する」の時、リスト追加依頼者の氏名より、CRS_前工程開拓担当者を設定  // 追加依頼者req_add_list_username__c
			if ('追加する'.equals(newAcc.add_list_request_picklist__c) && String.isNotBlank(newAcc.req_add_list_username__c)){
				UTL_CommonUtil.convertUserNameToId(crsMaeTantoAddRequestName, crsMaeTantoId, newAcc, oldAcc, userNameMap);
			}
			// リスト追加依頼者設定
			if (String.isNotBlank(newAcc.req_add_list_username__c)){
				UTL_CommonUtil.convertUserNameToId(crsMaeTantoAddRequestName, crsMaeTantoAddRequestId, newAcc, oldAcc, userNameMap);
			}

			// 所有者設定
			changeOwner(newAcc, oldAcc, userIdMap, userNameMap);
			// 取引先種別設定
			if (String.isBlank(newAcc.AccountType__c)) {
				newAcc.AccountType__c = 'CRS';
			}
			// Webサイトからドメイン名を抽出してWebサイトドメインに設定
			if (String.isNotBlank(newAcc.Website)) {
				String domain = UTL_CommonUtil.extractWebsiteDomain(newAcc.Website);
				if (String.isNotBlank(domain) && !domain.equals(newAcc.WebsiteDomain__c)) {
					newAcc.WebsiteDomain__c = domain;
				}
			} else {
				if (String.isNotBlank(newAcc.WebsiteDomain__c)) {
					newAcc.WebsiteDomain__c = null;
				}
			}
			// STEP設定
			String step = BizCrsSalesStepLogic.getCurrentSalesStep(newAcc);
			String oldStep = '';
			if (oldAcc != null) {
				oldStep = oldAcc.CrsCurrentStep__c;
			}
			if (!step.equals(oldStep)) {
				newAcc.CrsCurrentStep__c = step;
				newAcc.CrsStepLastUpdDate__c = Datetime.now();
			}
			// 住所クリーニング
			cleaningAddress(newAcc);
			// テリトリ比較用マップ設定
			if (oldAcc != null) {
				oldTeritoryMap.put(newAcc.Id, oldAcc.CompanyTeritory__c);
			}
		}
		// 会社所在テリトリー設定
		setCompanyTeritory(accNewList, oldTeritoryMap);

	}

	/**
	 * マージ依頼メールを非同期受付
	 * @param accList 取引先リスト
	 */
	public void mergeMailRequest(List<Account> accList) {
		if (accList.isEmpty()) return;
		Set<Id> asyncSet = new Set<Id>();
		for (Account acc : accList) {
			if (acc.Field224_Merge__c) {
				asyncSet.add(acc.Id);
			}
		}
		if (!asyncSet.isEmpty()) {
			aysncMergeMailSend(asyncSet);
		}
	}

	/**
	 * 所有者設定処理
	 * @param newAcc 取引先(new)
	 * @param oldAcc 取引先(old)
	 * @param userIdMap ユーザマップ(キー：ID)
	 * @param userNameMap ユーザマップ(キー：氏名)
	 */
	private void changeOwner(Account newAcc, Account oldAcc, Map<Id, User> userIdMap, Map<String, User> userNameMap) {

/*
		String adminName = System.Label.adminName;
		String adminId = UTL_CommonUtil.searchUserId(adminName , userNameMap );
		Date dt = Date.today();
		Date dtp90 = dt.addDays(90);
		Date dtm90 = dt.addDays(-90);
		String oId = newAcc.OwnerId;
		String vId = null;

		// 取引先所有者を変更：CRS_前工程開拓担当者
		// 	AND条件(1)：CRS_前工程開拓担当者が空白ではない
		// 	AND条件(2)：CRS_前工程開拓担当者がシステム管理者ではない
		// 	AND条件(3)：CRS_前工程開拓担当者が変更された
		//　	AND条件(4)：ビズの契約終了日が空白である　または　契約終了日から91日以上経過している
		//	AND条件(5)：キャリトレの契約終了日が空白である　または　契約終了日から91日以上経過している
		if (String.isNotBlank(newAcc.CRS_MaeTantousya__c) && newAcc.CRS_MaeTantousya__c != adminId && newAcc.CRS_MaeTantousya__c != oldAcc.CRS_MaeTantousya__c){
			if(newAcc.Field156__c == null || newAcc.Field156__c < dtm90 || newAcc.CT_CurrentContractTermEndDate__c == null || newAcc.CT_CurrentContractTermEndDate__c < dtm90 ){
				vId = newAcc.CRS_MaeTantousya__c;
			}
		}

		// 取引先所有者を変更：CT_前工程開拓担当者
		//	AND条件(1)：CRS_前工程開拓担当者が空白である　または　システム管理者である
		//	AND条件(2)：CT_前工程開拓担当者が空白ではない
		//	AND条件(3)：CT_前工程開拓担当者がシステム管理者ではない
		//	AND条件(4)：CT_前工程開拓担当者が変更された
		//	AND条件(5)：ビズの契約終了日が空白である、または契約終了日から91日以上経過している
		//	AND条件(6)：キャリトレの契約終了日が空白である、または契約終了日から91日以上経過している
		//
*/

		String oId = newAcc.OwnerId;
		String userName = newAcc.Field107__c;
		User user = userNameMap.get(userName);
		String vId = (user != null) ? user.id : null;
		// 取得できない場合CRS_担当営業から探す
		if (String.isBlank(vId)) {
			vId = UTL_CommonUtil.searchUserId(newAcc.CrsSale_Representative__c, userIdMap);
		}
		// さらに取得できない場合キャリアトレック_担当営業から探す
		if (String.isBlank(vId)) {
			vId = UTL_CommonUtil.searchUserId(newAcc.careertreck_sales_representative__c, userIdMap);
		}

		if (String.isNotBlank(vId) && !oId.equals(vId)) {
			newAcc.OwnerId = vId;
		} else {
			if (String.isNotBlank(userName) && String.isBlank(vId)) {
				newAcc.Field107__c = '';
			}
			user = userIdMap.get(oId);
			if (user == null) {
				newAcc.OwnerId = UserInfo.getUserId();
			}
		}

		User ou = userIdMap.get(newAcc.OwnerId);
		if (!newAcc.OwnerId.equals(oId)) {
			if (ou == null) {
				newAcc.OwnerId = UserInfo.getUserId();
			} else {
				if (String.isBlank(ou.UserRoleId)) {
					newAcc.OwnerId = UserInfo.getUserId();
				}
			}
		}

	}

	/**
	 * 住所クリーニング処理
	 * @param newAcc 取引先(new)
	 */
	private void cleaningAddress(Account newAcc) {
		String state = String.isNotEmpty(newAcc.BillingState) ? newAcc.BillingState : '';
		String city = String.isNotEmpty(newAcc.BillingCity) ? newAcc.BillingCity : '';
		String street = String.isNotEmpty(newAcc.BillingStreet) ? newAcc.BillingStreet : '';
		String addr = state.trim() + city.replace(state, '').trim() + street.replace(state, '').replace(city, '').trim();
		String[] newAddr = BizAddressLogic.convertAddress(addr);
		if (newAddr != null) {
			String newState = newAddr[0];
			String newCity = newAddr[1];
			String newStreet = newAddr[2];
			if (!newState.equals(state) || !newCity.equals(city) || !newStreet.equals(street)) {
				newAcc.BillingState = newState;
				newAcc.BillingCity = newCity;
				newAcc.BillingStreet = newStreet;
			}
		}
	}

	/**
	 * 会社所在テリトリー設定処理
	 * @param accNewList 取引先リスト
	 * @param oldTeritoryMap テリトリーマップ(oldの値を格納)
	 */
	private void setCompanyTeritory(List<Account> accNewList, Map<Id, String> oldTeritoryMap) {
		if (!accNewList.isEmpty()) {
			AddressAndTeritoryMatchLogic ad = new AddressAndTeritoryMatchLogic(accNewList);
			Integer teritoryLessEqualBatchSize = Integer.valueOf(system.label.TeritoryLessEqualBatchSize);
			for (Account newAcc : accNewList) {
			    // 会社所在テリトリー設定
				String baddrall = newAcc.BillingState + newAcc.BillingCity + newAcc.BillingStreet;
				if (String.isBlank(baddrall)) {
					baddrall = ' ';
				}
				String oldTeritory =  '';
				if (oldTeritoryMap.containsKey(newAcc.Id)) {
					oldTeritory = oldTeritoryMap.get(newAcc.Id);
				}
				if(trigger.New.size() <= teritoryLessEqualBatchSize){
					String newTeritory;
					newTeritory = ad.matchAddressAndTeritoryAccount(baddrall, newAcc.BillingState, newAcc.BillingCity, newAcc.Ootetantoukigyou__c);
					if (String.isNotBlank(newTeritory) && !newTeritory.equals(oldTeritory)) {
						newAcc.CompanyTeritory__c = newTeritory;
					}
					system.debug('String.isNotBlank(newTeritory) = '+String.isNotBlank(newTeritory));
					system.debug('newTeritory.equals(oldTeritory) = '+newTeritory.equals(oldTeritory));
					system.debug('teritoryAc.CompanyTeritory__c = '+ newAcc.CompanyTeritory__c);
				}
			}
		}
	}

}
