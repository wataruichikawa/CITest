@isTest
private class BizAddressLogicTest {

    static testMethod void testconvertAddress() {
		Test.startTest();
		String adStr = '京都府京都市中京区御池通間之町東入高宮町206御池ビル9F';
    	String[] address = BizAddressLogic.convertAddress(adStr);

		adStr = 'シンガポール10 Anson Road #13-13A International Plaza Singapore 079903';
    	address = BizAddressLogic.convertAddress(adStr);

		adStr = '千葉県八千代市緑が丘1-2-1パークタワー八千代緑が丘408';
    	address = BizAddressLogic.convertAddress(adStr);

		adStr = '東京都渋谷区本町3-12-1 住友不動産西新宿ビル6号館';
    	address = BizAddressLogic.convertAddress(adStr);

		adStr = '東京都中央区銀座1-15-6　KN銀座ビル7階東京都中央区銀座1-15-6 KN銀座ビル7階';
    	address = BizAddressLogic.convertAddress(adStr);

		adStr = '東京都東京都東京都';
		System.debug('******** adStr.length:' + adStr.length());
    	address = BizAddressLogic.convertAddress(adStr);
		Test.stopTest();
    }
}