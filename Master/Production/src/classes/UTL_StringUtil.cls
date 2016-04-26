/**
 * UTL_StringUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public with sharing class UTL_StringUtil {

	/**
	 * 拡張子取得
	 * @param fileName ファイル名
	 */
	public static String getExtension(String fileName) {
		if (String.isBlank(fileName)) return '';
		Integer index = fileName.lastIndexOf('.');
		if (index >= 0) {
			return fileName.substring(index + 1);
		}
		return '';
	}

}