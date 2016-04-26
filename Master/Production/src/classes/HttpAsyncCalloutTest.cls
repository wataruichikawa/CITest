@isTest
public with sharing class HttpAsyncCalloutTest {
	static testMethod void callIdIsNull() {
		test.startTest();

		// accountをinsertするとCalloutExceptionにになるため。
		HttpAsyncCallout.uploadS3(null, 'hoge/hoge');
		Test.setMock(HttpCalloutMock.class, new AWSAccessHttpMock());

		test.stopTest();
	}   

	static testMethod void callInvalidId() {
		test.startTest();

		// accountをinsertするとCalloutExceptionにになるため。
		HttpAsyncCallout.uploadS3('000000000000000000', 'hoge/hoge');
		Test.setMock(HttpCalloutMock.class, new AWSAccessHttpMock());

		test.stopTest();
	}   
	
}