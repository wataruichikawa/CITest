/**
 * UTL_CommonUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class UTL_CommonUtil {

	/**
	 * オブジェクトのBoolean変換
	 * @param value：Boolean変換対象Object
	 * @return オブジェクトがNULL、またはBooleanに変換出来ない値の場合はfalseを返却
	 *         それ以外の場合はBoolean型にして返却
	 */
	public static Boolean toBoolean(object obj){
		return (obj!=null && obj instanceof Boolean) ? Boolean.valueOf(obj) : false;
	}

	/**
	 * ユーザ名からユーザのオブジェクトIDを取得して、オブジェクトのID項目に設定
	 * @param nameApi ユーザ名の項目のAPI参照名
	 * @param idApi ユーザのオブジェクトIDの項目のAPI参照名
	 * @param newObj new sObject
	 * @param oldObj old sObject
	 * @param userMap ユーザ名がキーのユーザのマップ
	 */
	public static void convertUserNameToId(String nameApi, String idApi, sObject newObj, sObject oldObj, Map<String, User> userMap) {
		Id newId = (Id) newObj.get(idApi);
		Id oldId = null;
		if (oldObj != null) {
			oldId = (Id) oldObj.get(idApi);
		}
		String nameLink = (String) newObj.get(nameApi);
		newId = searchUserId(nameLink, userMap);
		if (String.isNotBlank(newId) && !newId.equals(oldId)) {
			newObj.put(idApi, newId);
		}
	}

	/**
	 * URLからドメインを取得
	 * @param website WebサイトURL
	 * @return URLのドメイン 取得できない場合はnull
	 */
	public static String extractWebsiteDomain(String website) {
		String domain = null;
		if (String.isNotBlank(webSite)) {
			Pattern p = Pattern.compile('^(.+://)(www[0-9]*[.]+)*([^/]+)(.*)');
			Matcher m = p.matcher(website);
			if (m.find()) {
				if (m.groupCount() > 3) {
					domain = m.group(3);
				}
			}
		}
		return domain;
	}

	/**
	 * ユーザのマップクラスからユーザが存在するか確認
	 * @param userId ユーザID
	 * @param ユーザマップ
	 * @return 存在する場合はユーザID、存在しない場合はnull
	 */
	public static Id searchUserId(Id userId, Map<Id, User> userIdMap) {
		if (userId != null && userIdMap.containsKey(userId)) {
			return userId;
		}
		return null;
	}

	/**
	 * ユーザのマップクラスからユーザが存在するか確認
	 * @param userId ユーザID
	 * @param ユーザマップ
	 * @return 存在する場合はユーザID、存在しない場合はnull
	 */
	public static Id searchUserId(String userName, Map<String, User> userNameMap) {
		if (String.isNotBlank(userName) && userNameMap.containsKey(userName)) {
			return userNameMap.get(userName).Id;
		}
		return null;
	}

	/**
	 * 会社名から株式会社等を除去
	 * @param orgCompanyName 会社名
	 * @return 会社名(株式会社等除去)
	 */
	public static String replaceCompanyName(String orgCompanyName) {
		String comNm = orgCompanyName;
		if (String.isNotEmpty(orgCompanyName)) {
			comNm = comNm.replace('株式会社', '');
			comNm = comNm.replace('有限会社', '');
			comNm = comNm.replace('(株)', '');
			comNm = comNm.replace('（株）', '');
			comNm = comNm.trim();
		}
		return comNm;
	}
}