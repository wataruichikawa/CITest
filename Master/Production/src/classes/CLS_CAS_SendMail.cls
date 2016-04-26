/**
 * CLS_CAS_SendMail
 * ----------------------------------------
 * @createdName      : tanaka.second
 * @lastModifiedName : tanaka.second
 * ----------------------------------------
 */
public class CLS_CAS_SendMail {

    Map<ID, Account> accountMap = new Map<ID, Account>();
    Map<ID, Contact> contactMap = new Map<ID, Contact>();
	Map<String, List<String>> roleUserMap = new Map<String, List<String>>();

	OutboundEmail mail = new OutboundEmail();

	public void sendRegistered (List<Case> tmpOldList, List<Case> tmpNewList,
		Map<Id, Case> tempOldMap, Map<Id, Case> tempNewMap) {
    	// 取引先情報のマップを作成
    	createAccountMap(tmpNewList);

    	// 取引先担当者情報のマップを作成
    	createContactMap(tmpNewList);

		// 取引先の営業担当、運用担当、運用担当チームの情報マップを作成
		createUserMap(tmpNewList);

		// メールを送信するための情報を作成
		for (Case newObj : tmpNewList) {
			if (newObj.accountId != null) {
				List<String> toAddressList = new List<String>();
				if(String.isNotBlank(newObj.OwnerEmail__c)) {
					toAddressList.add(newObj.OwnerEmail__c);
				}
				if (String.isNotBlank(newObj.LastModifiedByEmail__c)) {
					toAddressList.add(newObj.LastModifiedByEmail__c);
				}
				if (String.isNotBlank(newObj.RepresentativeEmail__c)) {
					toAddressList.add(newObj.RepresentativeEmail__c);
				}
				if (String.isNotBlank(newObj.RepresentativeMainEmail__c)) {
					toAddressList.add(newObj.RepresentativeMainEmail__c);
				}
				if (String.isNotBlank(newObj.RepresentativeTeamName__c)) {
					toAddressList.addAll(roleUserMap.get(newObj.RepresentativeTeamName__c));
				}
				if (newObj.Status == '担当営業/営業へ') {
					if (toAddressList.size() > 0) {
						String subject = createSubjectToRepresentative(newObj, false, newObj.ClaimFlg__c);
						String body = createMailBodyToRepresentative(newObj, false);
						mail.createSendMessage(newObj.OwnerEmail__c, newObj.OwnerName__c, toAddressList, null, subject, body);
					}
				} else {
					// 通常時のメール
					if (toAddressList.size() > 0) {
						boolean colseFlg = (newObj.Status == 'クローズ');
						String subject = createSubject(newObj, colseFlg, newObj.ClaimFlg__c);
						String body = createMailBody(newObj, colseFlg);
						mail.createSendMessage(newObj.OwnerEmail__c, newObj.OwnerName__c, toAddressList, null, subject, body);
					}
				}
			}
		}
		mail.send();
	}

	public void sendUpdated(List<Case> tmpOldList, List<Case> tmpNewList,
		Map<Id, Case> tempOldMap, Map<Id, Case> tempNewMap){
    	// 取引先情報のマップを作成
    	createAccountMap(tmpNewList);

    	// 取引先担当者情報のマップを作成
    	createContactMap(tmpNewList);

		// 取引先の営業担当、運用担当、運用担当チームの情報マップを作成
		createUserMap(tmpNewList);

		// メールを送信するための情報を作成
		for (Case newObj : tmpNewList) {
			if (newObj.accountId != null) {
				List<String> toAddressList = new List<String>();
				if(String.isNotBlank(newObj.OwnerEmail__c)) {
					toAddressList.add(newObj.OwnerEmail__c);
				}
				if (String.isNotBlank(newObj.LastModifiedByEmail__c)) {
					toAddressList.add(newObj.LastModifiedByEmail__c);
				}
				if (String.isNotBlank(newObj.RepresentativeEmail__c)) {
					toAddressList.add(newObj.RepresentativeEmail__c);
				}
				if (String.isNotBlank(newObj.RepresentativeMainEmail__c)) {
					toAddressList.add(newObj.RepresentativeMainEmail__c);
				}
				if (String.isNotBlank(newObj.RepresentativeTeamName__c)) {
					toAddressList.addAll(roleUserMap.get(newObj.RepresentativeTeamName__c));
				}

				if (toAddressList.size() > 0) {
					if (newObj.Status == '担当営業/営業へ' && tempOldMap.get(newObj.Id) != null && newObj.Status != tempOldMap.get(newObj.Id).Status) {
						String subject = createSubjectToRepresentative(newObj, false, newObj.ClaimFlg__c);
						String body = createMailBodyToRepresentative(newObj, false);
						mail.createSendMessage(newObj.OwnerEmail__c, newObj.OwnerName__c, toAddressList, null, subject, body);
					} else if (tempOldMap.get(newObj.Id) != null && newObj.Status == 'クローズ' && tempOldMap.get(newObj.Id).Status == '担当営業/営業へ'){
						String subject = createSubjectToRepresentative(newObj, true, newObj.ClaimFlg__c);
						String body = createMailBodyToRepresentative(newObj, true);
						mail.createSendMessage(newObj.OwnerEmail__c, newObj.OwnerName__c, toAddressList, null, subject, body);
					} else if (tempOldMap.get(newObj.Id) != null && newObj.Status == 'クローズ'){
						String subject = createSubject(newObj, true, newObj.ClaimFlg__c);
						String body = createMailBody(newObj, true);
						mail.createSendMessage(newObj.OwnerEmail__c, newObj.OwnerName__c, toAddressList, null, subject, body);
					}
				}
			}
		}
		mail.send();
	}

	private void createAccountMap(List<Case> tmpNewList) {
		// 取引先のIDを取得
		List<ID> accountIdList = new List<ID>();
		for (Case newObj : tmpNewList) {
			accountIdList.add(newObj.AccountId);
		}

		List<Account> accountList = [SELECT ID, Name FROM Account where ID in :accountIdList];

		// 取引先をID毎にマッピング
		for (Account account : accountList) {
			accountMap.put(account.ID, account);
		}
	}

	private void createContactMap(List<Case> tmpNewList) {
		// 取引先責任者のIDを取得
		List<ID> contactIdList = new List<ID>();
		for (Case newObj : tmpNewList) {
			contactIdList.add(newObj.ContactId);
		}

		List<Contact> contactList = [SELECT ID, Name FROM Contact where ID in :contactIdList];

		// 取引先をID毎にマッピング
		for (Contact contact : contactList) {
			contactMap.put(contact.ID, contact);
		}
	}

	private void createUserMap(List<Case> tmpNewList) {
		// 運用担当チームの情報を取得
		List<String> teamNameList = new List<String>();
		for (Case newObj : tmpNewList) {
			if (String.isNotBlank(newObj.RepresentativeTeamName__c)) {
				teamNameList.add(newObj.RepresentativeTeamName__c);
			}
		}

		List<ID> salesRepRoleIdList = new List<ID>();
		if (teamNameList.size() > 0) {
			List<User> roleUserList = [SELECT ID, Email, UserRole.RollupDescription FROM User where UserRole.RollupDescription in :teamNameList and User.UserType = 'Standard'];
			// チームユーザのメールアドレスをチームごとにマッピング
			for (User user : roleUserList) {
				List<String> mailAddressList;
				if (roleUserMap.containsKey(user.UserRole.RollupDescription)) {
					mailAddressList = roleUserMap.get(user.UserRole.RollupDescription);
				} else {
					mailAddressList = new List<String>();
					roleUserMap.put(user.UserRole.RollupDescription, mailAddressList);
				}
				mailAddressList.add(user.Email);
			}
		}
	}

	private String createSubjectToRepresentative(Case caseObj, boolean colseFlg, boolean claimFlg) {
		String closeStr = '【要対応】';
		if (colseFlg) {
			closeStr = '【解決済み】';
		}
		String claimStr = '';
		if (claimFlg) {
			claimStr = '【至急】';
		}
		String representativeName = '';
		if (String.isNotBlank(caseObj.RepresentativeName__c)) {
			representativeName += caseObj.RepresentativeName__c;
			representativeName += 'さん';
		}
		if (String.isNotBlank(caseObj.RepresentativeMainEmail__c)) {
			if (!String.isEmpty(representativeName)) {
				representativeName += ' ';
			}
			representativeName += caseObj.RepresentativeMainEmail__c;
			representativeName += 'さん';
		}
		return claimStr + closeStr + representativeName + ' ' + accountMap.get(caseObj.accountId).Name + 'よりお問い合わせがありました';
	}

	private String createSubject(Case caseObj, boolean colseFlg, boolean claimFlg) {
		String closeStr = '【要対応】';
		if (colseFlg) {
			closeStr = '【解決済み】';
		}
		String claimStr = '';
		if (claimFlg) {
			claimStr = '【至急】';
		}
		return claimStr + closeStr + ' ' + accountMap.get(caseObj.accountId).Name + 'よりお問い合わせがありました';
	}

	private String createMailBodyToRepresentative(Case caseObj, Boolean colseFlg) {
		String body = '';
		if (String.isNotBlank(caseObj.RepresentativeName__c)) {
			body += caseObj.RepresentativeName__c + 'さん\r\n';
		}
		if (String.isNotBlank(caseObj.RepresentativeMainName__c)) {
			body += caseObj.RepresentativeMainName__c + 'さん\r\n';
		}
		body += '\r\n';
		body += 'お疲れ様です。\r\n';
		body += '表題の件、電話問い合わせがありましたのでご確認下さい。\r\n';
		body += '\r\n';
		body += '取引先：' + accountMap.get(caseObj.accountId).Name + '\r\n';
		if (contactMap.containsKey(caseObj.ContactId)) {
			body += '先方担当者名：' + contactMap.get(caseObj.ContactId).Name + '様\r\n';
		}
		body += '\r\n';
		body += '問合せ番号\r\n';
		body += caseObj.CaseNumber;
		body += '\r\n\r\n';
		body += '問合せ内容詳細\r\n';
		body += caseObj.Description;
		body += '\r\n\r\n';
		body += '問合せへのリンク\r\n\r\n';
		body += URL.getSalesforceBaseUrl().toExternalForm();
		body += '/';
		body += caseObj.Id;
		body += '\r\n';
		if (colseFlg) {
			body += '\r\n';
			body += '回答内容\r\n';
			body += caseObj.Kaiketsusaku__c;
			body += '\r\n';
		}
		return body;
	}

	private String createMailBody(Case caseObj, Boolean colseFlg) {
		String body = '';
		body += '\r\n';
		body += 'お疲れ様です。\r\n';
		body += '表題の件、電話問い合わせがありましたのでご確認下さい。\r\n';
		body += '\r\n';
		body += '取引先：' + accountMap.get(caseObj.accountId).Name + '\r\n';
		if (contactMap.containsKey(caseObj.ContactId)) {
			body += '先方担当者名：' + contactMap.get(caseObj.ContactId).Name + '様\r\n';
		}
		body += '\r\n';
		body += '問合せ番号\r\n';
		body += caseObj.CaseNumber;
		body += '\r\n\r\n';
		body += '問合せ内容詳細\r\n';
		body += caseObj.Description;
		body += '\r\n\r\n';
		body += '問合せへのリンク\r\n\r\n';
		body += URL.getSalesforceBaseUrl().toExternalForm();
		body += '/';
		body += caseObj.Id;
		body += '\r\n';
		if (colseFlg) {
			body += '\r\n';
			body += '回答内容\r\n';
			body += caseObj.Kaiketsusaku__c;
			body += '\r\n';
		}
		return body;
	}
}