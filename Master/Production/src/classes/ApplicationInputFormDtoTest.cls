@isTest
private class ApplicationInputFormDtoTest {
  static testMethod void dtoGetterSetter() {
  	ApplicationInputFormDto dto = new ApplicationInputFormDto();
  	
  	System.assertEquals('', dto.contractApplicationNo);
  	System.assertNotEquals('', dto.errorCollectionDate);
  	System.assertNotEquals('', dto.errorZipCode);
  	System.assertNotEquals('', dto.errorPrefecture);
  	System.assertNotEquals('', dto.errorAddress1);
  	System.assertNotEquals('', dto.errorPhoneNumber);
  	System.assertNotEquals('', dto.errorContactName);
  	System.assertEquals(true, dto.hasError);
  	
  	String testStr = 'aaa';
  	Date testDate = Date.today();

		dto.contractApplicationNo = testStr;
		System.assertEquals(testStr, dto.contractApplicationNo);

		dto.serviceType = testStr;
		System.assertEquals(testStr, dto.serviceType);

		dto.collectionDate = testDate;
		System.assertEquals(testDate, dto.collectionDate);

		dto.startDate = testDate;
		System.assertEquals(testDate, dto.startDate);

		dto.endDate = testDate;
		System.assertEquals(testDate, dto.endDate);

		dto.companyName = testStr;
		System.assertEquals(testStr, dto.companyName);

		dto.companyNameKana = testStr;
		System.assertEquals(testStr, dto.companyNameKana);

		dto.zipCode = testStr;
		System.assertEquals(testStr, dto.zipCode);

		dto.prefecture = testStr;
		System.assertEquals(testStr, dto.prefecture);

		dto.address1 = testStr;
		System.assertEquals(testStr, dto.address1);

		dto.address2 = testStr;
		System.assertEquals(testStr, dto.address2);

		dto.phoneNumber = testStr;
		System.assertEquals(testStr, dto.phoneNumber);

		dto.contactDepartment = testStr;
		System.assertEquals(testStr, dto.contactDepartment);

		dto.contactPosition = testStr;
		System.assertEquals(testStr, dto.contactPosition);

		dto.contactName = testStr;
		System.assertEquals(testStr, dto.contactName);

		dto.emailAddress = testStr;
		System.assertEquals(testStr, dto.emailAddress);

		dto.opportunityId = testStr;
		System.assertEquals(testStr, dto.opportunityId);

		dto.accountId = testStr;
		System.assertEquals(testStr, dto.accountId);

		// データを入れた後にエラーチェックをし、必須項目が正しく入力されていることを確認する。
  	System.assertEquals('', dto.errorCollectionDate);
  	System.assertEquals('', dto.errorZipCode);
  	System.assertEquals('', dto.errorPrefecture);
  	System.assertEquals('', dto.errorAddress1);
  	System.assertEquals('', dto.errorPhoneNumber);
  	System.assertEquals('', dto.errorContactName);
  	System.assertEquals(false, dto.hasError);
  }   
  
  static testMethod void convert() {
  	ApplicationInputFormDto dto = new ApplicationInputFormDto();
  	
  	// テストデータの作成
		User user = new User(LastName = 'TEST', FirstName = 'TEST', Username = 'test@sutead.com', Email = 'test@sutead.com', 
		                     Alias = 'test', CommunityNickname = 'test', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', 
		                     EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user;

		Account account = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', 
		                              Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, 
		                              ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, 
		                              BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx', AccountType__c='CRS');
		insert account;
  	
  	Opportunity opportunity = new Opportunity(name = 'TEST-ABCXYZ20150831', UseStartDate__c = Date.today(), DounyuMtgDate__c = Datetime.now(),
  	                                          ProposedService__c = 'CRS', Type = '新規提案（過去未契約）', HirePlanMonths__c = 6, OwnerId = user.Id,
  	                                          ApplicationApprovalStatus__c = '', AccountId= account.Id, StageName = 'TEST',
  	                                          VisitChargeUser__c = user.Id, CloseDate = Date.today(), ContactName__c = '新規テスト',
  	                                          sample_case__c = '*', HiringPeriod__c = Date.today(), Opportunity__c = '*',
  	                                          ContractCollectionDate__c = Date.today(), useEndDate__c = Date.today().addDays(180),
  	                                          ContractApplicationNo__c = '201602-250001');
		insert opportunity;
		
		// 使われ方として必ず取引先とセットで取得されている。
		String opportunityId = opportunity.Id;
		opportunity = [SELECT o.Id, 
		                      o.ContractApplicationNo__c,
		                      o.ProposedService__c,
		                      o.ContractCollectionDate__c,
		                      o.UseStartDate__c,
		                      o.UseEndDate__c,
		                      o.ContactDepartment__c,
		                      o.ContactTitle__c,
		                      o.ContactName__c,
		                      o.ContactEmail__c,
		                      a.Id,
		                      a.Name,
		                      a.billingPostalCode,
		                      a.billingState,
		                      a.billingCity,
		                      a.billingStreet,
		                      a.Phone
		                 FROM Opportunity o, 
		                      Opportunity.Account a 
		                WHERE o.Id = :opportunityId];
		
		dto.convertFromOpportunity(opportunity);
		System.assertEquals(opportunity.Id, dto.opportunityId);
		System.assertEquals(account.Id, dto.accountId);
  }
 
  static testMethod void convertNull() {
		ApplicationInputFormDto dto = new ApplicationInputFormDto();

		dto.convertFromOpportunity(null);
		System.assertEquals('', dto.opportunityId);
		System.assertEquals('', dto.accountId);
  }
}