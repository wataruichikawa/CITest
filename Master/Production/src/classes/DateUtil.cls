/**
 * DateUtil Class
 * 日付ユーティリティクラス
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public with sharing class DateUtil {

    public static Boolean isSameDay(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        return date1.isSameDay(date2);
    }

    public static Boolean isSameDay(DateTime dateTime1, Date date2) {
        if (dateTime1 == null || date2 == null) {
            return false;
        }
        return dateTime1.isSameDay(date2);
    }

}