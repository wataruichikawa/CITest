public with sharing class BizAddressLogic {

	/**
	 * 住所テキストを都道府県、市区郡、町名・番地に区切る
	 * @param String 住所テキスト
     * @return
     */
	public static String[] convertAddress(String adStr) {

		// [0]:都道府県、[1]:市区郡、[2]:町名・番地
		String[] adr = new String[]{'','',''};

		// 改行を排除
		adStr = adStr.replace('\r\n', '');

		//Pattern p = Pattern.compile('^(北海道|京都府|東京都|大阪府|.+?県)(.+?郡.+?町町|.+?郡.+?町|.+?市.+?町|.+?郡.+?村|.+?区|.+?市市|.+?市|.+?町|.+?村)(.*)$');
		Pattern p = Pattern.compile('^(北海道|京都府|東京都|大阪府|.+?県)(.+?郡.+?町町|.+?郡.+?町|.+?郡.+?村|.+?区|.+?市市|.+?市|.+?町|.+?村)(.*)$');
		Matcher m = p.matcher(adStr);
		String state = '';
		String city = '';
		String street = '';
		if (m.find()) {
			System.debug('*********** group:' + m.groupCount());
			for (Integer i = 0; i < m.groupCount()+1; i++){
				System.debug('*********** group' + i + ':' + m.group(i));
				if (i == 1) {
					System.debug('*********** group1:' + m.group(1));
					state = m.group(i) != null ? m.group(i) : '';
				} else if (i == 2) {
					System.debug('*********** group2:' + m.group(2));
					city = m.group(i) != null ? m.group(i) : '';
				} else if (i == 3) {
					System.debug('*********** group3:' + m.group(3));
					street = m.group(i) != null ? m.group(i) : '';
				}
			}
		} else {
			System.debug('*********** not match');
			return null;
		}

		if (city.length() > 40) {
			street = city + street;
			city = '';
		}
		adr[0] = state;
		adr[1] = city;
		adr[2] = street;

		System.debug('*********** adr:' + adr);
		return adr;
	}
}