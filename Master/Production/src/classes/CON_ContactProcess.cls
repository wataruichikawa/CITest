/**
 * CON_ContactProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class CON_ContactProcess {

	/**
	 * Emailドメイン抽出処理
	 * @param conNewList 商談リスト(トリガー無効データ除くtrriger.new)
	 * @param conOldList 商談リスト(トリガー無効データ除くtrriger.old)
	 * @param conNewMap  商談マップ(トリガー無効データ除くtrriger.newMap)
	 * @param conOldMap  商談マップ(トリガー無効データ除くtrriger.oldMap)
	 */
	public void extractEmailDomain(List<Contact> conNewList, List<Contact> conOldList, Map<Id, Contact> conNewMap,
		Map<Id, Contact> conOldMap) {

		if (conNewList.isEmpty()) return;

		for (Contact con : conNewList) {
			if (String.isNotBlank(con.Email)) {
				String domain = UTL_EmailUtil.splitEmailDomain(con.Email);
				if (String.isNotBlank(domain)) {
					con.EMaildomain__c = domain;
				}
			} else {
				if (String.isNotBlank(con.EMaildomain__c)) {
					con.EMaildomain__c = null;
				}
			}
		}

	}

}