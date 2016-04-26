@isTest
private class DateUtilTest {

	static testMethod void testIsSameDayDD() {
		Date d1 = System.today();
		Date d2 = d1.addDays(1);
		System.assert(!DateUtil.isSameDay((Date) null, d1));
		System.assert(!DateUtil.isSameDay(d1, (Date) null));
		System.assert(!DateUtil.isSameDay(d1, d2));
		System.assert(DateUtil.isSameDay(d1, d1));
	}

	static testMethod void testIsSameDayDtD() {
		Datetime dt = System.now();
		Date d1 = System.today();
		Date d2 = d1.addDays(1);
		System.assert(!DateUtil.isSameDay((Datetime) null, d1));
		System.assert(!DateUtil.isSameDay(dt, (Date) null));
		System.assert(!DateUtil.isSameDay(dt, d2));
		System.assert(DateUtil.isSameDay(dt, d1));
	}

}