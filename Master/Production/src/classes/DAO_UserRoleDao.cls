/**
 * DAO_UserRoleDao
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class DAO_UserRoleDao {

	/**
	 * ロール全件のマップを検索
	 * @return ロールマップ(キー：Id)
	 */
	public static Map<Id, UserRole> findUserRoleMap() {
		return new Map<Id, UserRole>([SELECT Id, Name, RollupDescription, ParentRoleId FROM UserRole]);
	}

	/**
	 * 指定されたロールIDのロールマップを検索
	 * @param roleIdSet ロールIDリスト
	 * @return ロールマップ(キー：Id)
	 */
	public static Map<Id, UserRole> findUserRoleMap(Set<String> roleIdSet) {
		return new Map<Id, UserRole>([SELECT Id, Name, RollupDescription, ParentRoleId FROM UserRole WHERE Id IN :roleIdSet]);
	}

}