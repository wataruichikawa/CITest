@isTest
private class ChatterUtilTest {

	static testMethod void testPostFeedWithLinkAndOneMention() {
		ChatterUtil cu = new ChatterUtil();
		cu.postFeedWithLinkAndOneMention(UserInfo.getUserId(), UserInfo.getUserId(),
			'text', 'http://chatter.test.com', 'urlName');
	}

	static testMethod void testPostFeedWithLinkAndPluralMentions() {
		ChatterUtil cu = new ChatterUtil();
		Set<Id> ids = new Set<Id>();
		ids.add(UserInfo.getUserId());
		cu.postFeedWithLinkAndPluralMentions(UserInfo.getUserId(), ids,
			'text', 'http://chatter.test.com', 'urlName');
	}

}