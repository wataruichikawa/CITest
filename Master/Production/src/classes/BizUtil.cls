public with sharing class BizUtil {

	public static boolean isEmail(String email) {
		if (String.isBlank(email)) {
			return false;
		}
		boolean rf = false;
		try {
			Pattern p = Pattern.compile('^[abcdefg.hijklmnopqrstuvwxyz!#$%&\'*/=?^_+-`{|}~0123456789]+@([a-zA-Z0-9_-]+\\.)+[a-zA-Z]{2,4}$');
			Matcher m = p.matcher(email);
			if (m.find()) {
				rf = true;
			} else {
				rf = false;
			}

			String[] ml = email.split('@', 3);
			if (ml.size() > 2) {
				return false;
			}
		} catch (Exception e) {
			rf = false;
		}
		return rf;
	}
}