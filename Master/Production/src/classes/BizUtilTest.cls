@isTest
private class BizUtilTest {

    static testMethod void testIsEmailTest() {
		System.assertEquals(BizUtil.isEmail('hodade@gmail.com'), true);
		System.assertEquals(BizUtil.isEmail('store-news@amazon.co.jp'), true);
		System.assertEquals(BizUtil.isEmail('ranking@emagazine.rakuten.co.jp'), true);
		System.assertEquals(BizUtil.isEmail('noreply@postmaster.twitter.com'), true);
		System.assertEquals(BizUtil.isEmail('News_Japan@insideapple.apple.com'), true);
		System.assertEquals(BizUtil.isEmail('microsoft@e-mail.microsoft.com'), true);
		System.assertEquals(BizUtil.isEmail('info@dle.jp'), true);

		System.assertEquals(BizUtil.isEmail('test@kiriu@ccccelection.co.jp'), false);
		System.assertEquals(BizUtil.isEmail('test@aaa'), false);
		System.assertEquals(BizUtil.isEmail('infodle.jp'), false);
    }
}