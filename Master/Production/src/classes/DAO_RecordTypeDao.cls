/**
 * DAO_RecordTypeDao
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class DAO_RecordTypeDao {

    /**
     * オブジェクト、API参照名で有効なレコードタイプを検索
     * @param sobjType オブジェクトAPI参照名
     * @param devName API参照名
     * @return レコードタイプId
     */
    public static Id findRecordTypeId(String sobjType, String devName) {
        List<RecordType> recList = [SELECT Id FROM RecordType WHERE IsActive = true AND SobjectType = :sobjType AND DeveloperName = :devName];
        if (recList.isEmpty()) return null;
        return recList.get(0).Id;
    }

}