/**
 * UTL_EmailUtil
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class UTL_EmailUtil {

	/** プライベートメールアドレスドメイン一覧 */
	private static final List<String> PRIVATE_EMAIL_DOMAIN = new String[] {'@gmail.com', '@mail.goo.ne.jp', '@hotmail.com',
		'@infoseek.jp', '@outlook.jp', '@aol.jp', '@plala.or.jp', '@nifty.com', '@wakwak.com', '@so-net.ne.jp',
		'@ocn.ne.jp', '@dream.jp', '@biglobe.ne.jp', '@docomo.ne.jp', '@i.softbank.jp', '@me.com', '@jcom.home.ne.jp',
		'@ezweb.ne.jp', '@vodafone.ne.jp'};

	/**
	 * メールアドレスのドメインを取得
	 * @param email メールアドレス
	 * @return メールアドレスのドメイン
	 */
	public static String splitEmailDomain(String email) {
		if (String.isNotBlank(email)) {
			String[] splitEmail = email.split('@');
			if (splitEmail.size() > 1) {
				return splitEmail[1];
			}
		}
		return '';
	}

	/**
	 * プライベートメールアドレスか判別
	 * @param companyName 会社名
	 * @param email メールアドレス
	 * @return プライベートメールアドレスの場合：true、プライベートメールアドレスでない場合：false
	 */
	public static boolean isPrivateEmailAddress(String companyName, String email) {
		String com = companyName != null ? companyName : '';
		if (com.indexOf('ヤフー') < 0 && email.endsWith('@yahoo.co.jp')) {
			return true;
		}
		for (String pemail : PRIVATE_EMAIL_DOMAIN) {
			if (email.endsWith(pemail)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * エラー時に指定アドレスにエラー内容を通知
	 * @param e Exception
	 * @param subject 件名
	 * @param body 本文
	 */
	public static void sendSystemErrorMail(Exception e, String subject, String body) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(system.label.ExceptionToAddresses.split(',', 0));
		mail.setSubject('System Error : ' + subject);
		String addBody = 'Exception Type: ' + e.getTypeName() + '\n';
		body += 'Message: ' + e.getMessage() + '\n';
		body += 'Stack trace: ' + e.getStackTraceString();
		mail.setPlainTextBody(body + '\n\n' + addBody);
		if (!CommonUtil.RunningIsSandbox()) {
			try {
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
			} catch (EmailException ee) {
				system.debug('***** not send mail : ' + ee.getMessage());
			}
		}
	}
}