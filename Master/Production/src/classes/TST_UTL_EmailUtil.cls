/**
 * TST_UTL_EmailUtil
 *
 * テスト対象
 * 1.UTL_EmailUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_UTL_EmailUtil {

	/**
	 * ドメイン取得テスト
	 */
	static testMethod void testSplitEmailDomain() {
		Test.startTest();
		system.assertEquals('biz.co.jp', UTL_EmailUtil.splitEmailDomain('test_addr@biz.co.jp'));
		system.assertEquals('', UTL_EmailUtil.splitEmailDomain('test_addr#biz.co.jp'));
		system.assertEquals('', UTL_EmailUtil.splitEmailDomain(''));
		Test.stopTest();
	}

	/**
	 * プライベートアドレス判別テスト
	 */
	static testMethod void testIsPrivateEmailAddress() {
		Test.startTest();
		system.assert(!UTL_EmailUtil.isPrivateEmailAddress('ヤフー株式会社', 'test_addr@yahoo.co.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('ヤフ株式会社', 'test_addr@yahoo.co.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@gmail.com'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@mail.goo.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@hotmail.com'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@infoseek.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@outlook.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@aol.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@plala.or.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@nifty.com'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@wakwak.com'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@so-net.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@ocn.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@dream.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@biglobe.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@docomo.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@i.softbank.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@me.com'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@jcom.home.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@ezweb.ne.jp'));
		system.assert(UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@vodafone.ne.jp'));
		system.assert(!UTL_EmailUtil.isPrivateEmailAddress('テスト株式会社', 'test_addr@biz.co.jp'));
		Test.stopTest();
	}

	/**
	 * メール送信テスト
	 */
	static testMethod void testSendSystemErrorMail() {
		UTL_EmailUtil.sendSystemErrorMail(new TestException(), 'subject', 'body');
	}

	private class TestException extends Exception {}
}