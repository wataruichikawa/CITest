public with sharing class ChatterUtil {
	/**
	 * 1人にメンションしてフィードを吐き出すメソッド
	 */
	public void postFeedWithLinkAndOneMention(Id userId, Id mentionId,String text, String url, String urlName){
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = mentionId;
		messageBodyInput.messageSegments.add(mentionSegmentInput);

		setFeedContent(feedItemInput,messageBodyInput,userId,text, url, urlName);
		if (!Test.isRunningTest()) {
			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput, null);
		}
	}

	/**
	 * 複数の人にメンションしてフィードを吐き出すメソッド
	 */
	public void postFeedWithLinkAndPluralMentions(Id userId, Set<Id> mentionIdSet,String text, String url, String urlName){
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		for (Id mentionId : mentionIdSet){
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			mentionSegmentInput.id = mentionId;
			messageBodyInput.messageSegments.add(mentionSegmentInput);
		}
		setFeedContent(feedItemInput,messageBodyInput,userId,text, url, urlName);
		if (!Test.isRunningTest()) {
			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput, null);
		}
	}

	/**
	 * フィードに発言者、リンク、タイトル、内容をセットするメソッド
	 */
	private void setFeedContent(ConnectApi.FeedItemInput feedItemInput,ConnectApi.MessageBodyInput messageBodyInput,ID userId,String text, String url, String urlName){
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = text;
		messageBodyInput.messageSegments.add(textSegmentInput);

		ConnectApi.LinkAttachmentInput linkAttachmentInput = new ConnectApi.LinkAttachmentInput();
		linkAttachmentInput.url = url;
		linkAttachmentInput.urlName = urlName;

		feedItemInput.body = messageBodyInput;
		feedItemInput.attachment = linkAttachmentInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = userId;
	}
}