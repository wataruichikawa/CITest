/**
 * DAO_UserDao
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class DAO_UserDao {

	/** IDマップを取得するためのキー */
	public static final String MAP_KEY_ID = 'ID';
	/** 氏名マップを取得するためのキー */
	public static final String MAP_KEY_NAME = 'NAME';

	/**
	 * 標準有効ユーザ全件を検索
	 * @return ユーザリスト
	 */
	public static List<User> findStdActiveUser() {
		return [SELECT Id, Name, UserRoleId, UserRole.RollupDescription, profile.Name FROM User WHERE isActive = true AND UserType = 'Standard'];
	}

	/**
	 * 標準有効ユーザ全件のマップを返す
	 * @return マップ(キーがIDのマップとキーが氏名のマップを格納)
	 */
	public static Map<String, Object> findStdActiveUserMap() {
		return findStdActiveUserMap(findStdActiveUser());
	}

	/**
	 * ユーザリストをIDマップ、氏名マップを格納したマップにして返す
	 * @param ユーザリスト
	 * @return マップ(キーがIDのマップとキーが氏名のマップを格納)
	 */
	public static Map<String, Object> findStdActiveUserMap(List<User> userList) {
		Map<Id, User> idMap = new Map<Id, User>();
		Map<String, User> nameMap = new Map<String, User>();
		for (User u : userList) {
			idMap.put(u.Id, u);
			nameMap.put(u.Name, u);
		}
		Map<String, Object> retMap = new Map<String, Object>();
		retMap.put(MAP_KEY_ID, idMap);
		retMap.put(MAP_KEY_NAME, nameMap);
		return retMap;
	}

}