@isTest
global class AWSAccessHttpMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		String expectUrl = '';
		if (CommonUtil.RunningIsSandbox()) {
			expectUrl = System.Label.Demoreach_AWS_API_URL;
		} else {
			expectUrl = System.Label.Bizreach_AWS_API_URL;
		}
		System.assertEquals(expectUrl + '/prod/contracts', req.getEndpoint());
		System.assertEquals('POST', req.getMethod());
        
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"ETag":"0000000000"}');
		res.setStatusCode(200);
		return res;
	} 
}