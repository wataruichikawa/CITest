global class HttpAsyncCallout {
  @future (callout=true)
  public static void uploadS3(ID id, String path) {
  	if (String.isBlank(id) || String.isBlank(path)) {
  		return;
  	}

		// 契約に添付されるファイルを取得する。
		List<Attachment> attachments = [SELECT Body FROM Attachment WHERE ID = :id];
		if (attachments.isEmpty()) {
			return;
		}

		String awsUrl = '';
		String apiKey = '';
		if (CommonUtil.RunningIsSandbox()) {
			awsUrl = System.Label.Demoreach_AWS_API_URL;
			apiKey = System.Label.Demoreach_AWS_API_Key;
		} else {
			awsUrl = System.Label.Bizreach_AWS_API_URL;
			apiKey = System.Label.Bizreach_AWS_API_Key;
		}
		Http httpClient = new Http();
		
		AWSRequestJson requestJson = new AWSRequestJson();
		requestJson.path = path;
		requestJson.body = attachments.get(0).body;

		HttpRequest request = new HttpRequest();
		request.setEndPoint(awsUrl + '/prod/contracts');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('x-api-key', apiKey);
		request.setBody(JSON.serializePretty(requestJson));
		
		System.Debug('### Debug : File Path -> ' + requestJson.path);
		HttpResponse response = httpClient.send(request);
		System.Debug('### Debug : Http Response -> ' + response);
		System.Debug('### Debug : Http Response Body -> ' + response.getBody());
  } 

	/*
	 * AWS-APIへのリクエスト用JSON
	 */
	@Testvisible
	private with sharing class AWSRequestJson {
			public String path { get; set; }
			public Blob body { get; set; }
	}
}