@isTest
private class BillingDtoTest {
	static testMethod void constructor() {
  	BillingDto dto = new BillingDto();
		
		System.assertEquals('', dto.companyName);
		System.assertEquals('', dto.zipCode);
		System.assertEquals('', dto.address);
		System.assertEquals('', dto.buildingName);
		System.assertEquals('', dto.phoneNumber);
		System.assertEquals('', dto.contactDepartment);
		System.assertEquals('', dto.contactPosition);
		System.assertEquals('', dto.contactName);

		System.assertNotEquals('', dto.errorCompanyName());
		System.assertNotEquals('', dto.errorZipCode());
		System.assertNotEquals('', dto.errorAddress());
		System.assertNotEquals('', dto.errorPhoneNumber());
		System.assertNotEquals('', dto.errorContactName());
		System.assertEquals(true, dto.hasError());
	}

  static testMethod void dtoGetterSetter() {
  	BillingDto dto = new BillingDto();
  	String str1 = 'aaa';
  	String telStr = '090-0000-0000';
		
		dto.companyName = str1;
		System.assertEquals(str1, dto.companyName);
		dto.zipCode = str1;
		System.assertEquals(str1, dto.zipCode);
		dto.prefectureName = str1;
		System.assertEquals(str1, dto.prefectureName);
		dto.address = str1;
		System.assertEquals(str1, dto.address);
		dto.buildingName = str1;
		System.assertEquals(str1, dto.buildingName);
		dto.phoneNumber = telStr;
		System.assertEquals(telStr, dto.phoneNumber);
		dto.contactDepartment = str1;
		System.assertEquals(str1, dto.contactDepartment);
		dto.contactPosition = str1;
		System.assertEquals(str1, dto.contactPosition);
		dto.contactName = str1;
		System.assertEquals(str1, dto.contactName);

		// すべてのプロパティを入力しているので、必須チェックにはひかからない。
		System.assertEquals('', dto.errorCompanyName());
		System.assertEquals('', dto.errorZipCode());
		System.assertEquals('', dto.errorAddress());
		System.assertEquals('', dto.errorPhoneNumber());
		System.assertEquals('', dto.errorContactName());
		System.assertEquals(false, dto.hasError());
  }
  
  static testMethod void convertFromOpportunity() {
  	ID accountId = getAccountId();

		User user = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user;

		Opportunity op = new Opportunity();
		op.Name = 'TEST-ABCXYZ20150831';
		op.UseStartDate__c = Date.valueOf('2016-03-03');
		op.DounyuMtgDate__c = Datetime.valueOfGmt('2016-03-20 09:30:00');
		op.ProposedService__c = 'CRS';
		op.Type = '新規提案（過去未契約）';
		op.HirePlanMonths__c = 6;
		op.OwnerId = user.Id;
		op.ApplicationApprovalStatus__c = '';
		op.AccountId = accountId;
		op.StageName = 'TEST';
		op.VisitChargeUser__c = user.Id;
		op.CloseDate = Date.today();
		op.ContactName__c = '新規_20160303';
		op.sample_case__c = '*';
		op.HiringPeriod__c = Date.today();
		op.Opportunity__c = '*';
		op.ContractCollectionDate__c = Date.today();
		op.useStartDate__c = Date.today().addDays(2);
		op.useEndDate__c = Date.today().addDays(120);
		insert op;

		Opportunity target = [SELECT o.Id,
							 			             a.Id,
										             a.Name,
										             a.billingPostalCode,
										             a.billingState,
										             a.billingCity,
										             a.billingStreet,
										             a.Phone,
										             a.Fax,
										             o.ContactDepartment__c,
										             o.ContactTitle__c,
										             o.ContactName__c,
										             o.ContactNameKana__c,
										             o.UseStartDate__c
							              FROM Opportunity o,
										             Opportunity.Account a
							             WHERE a.Id = :accountId
								             AND o.Id = :op.Id
							             ORDER BY o.Id desc];
		
		BillingDto dto = new BillingDto();
		dto.convertFromOpportunity(target);
		System.assertEquals(target.ContactName__c, dto.contactName);
  }
  
  static testMethod void convertFromInfo() {
  	ID accountId = getAccountId();

		User user = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user;

		Opportunity op = new Opportunity();
		op.Name = 'TEST-ABCXYZ20150831';
		op.UseStartDate__c = Date.valueOf('2016-03-03');
		op.DounyuMtgDate__c = Datetime.valueOfGmt('2016-03-20 09:30:00');
		op.ProposedService__c = 'CRS';
		op.Type = '新規提案（過去未契約）';
		op.HirePlanMonths__c = 6;
		op.OwnerId = user.Id;
		op.ApplicationApprovalStatus__c = '';
		op.AccountId = accountId;
		op.StageName = 'TEST';
		op.VisitChargeUser__c = user.Id;
		op.CloseDate = Date.today();
		op.ContactName__c = '新規_20160303';
		op.sample_case__c = '*';
		op.HiringPeriod__c = Date.today();
		op.Opportunity__c = '*';
		op.ContractCollectionDate__c = Date.today();
		op.useStartDate__c = Date.today().addDays(2);
		op.useEndDate__c = Date.today().addDays(120);
		insert op;
		
  	String testStr = 'aaa';
		Contract_Application_Information__c info = new Contract_Application_Information__c();
		info.Opportunity__c = op.Id;
		info.Billing_Company_Name__c = testStr;
		info.Billing_Zip_Code__c = testStr;
		info.Billing_Prefecture_Name__c = testStr;
		info.Billing_Address__c = testStr;
		info.Billing_Building_Name__c = testStr;
		info.Billing_Phone_Number__c = testStr;
		info.Billing_Contact_Department__c = testStr;
		info.Billing_Contact_Position__c = testStr;
		info.Billing_Contact_Name__c = testStr;
		
		insert info;

		BillingDto dto = new BillingDto();
		dto.convertFromInfo(info);
		System.assertEquals(info.Billing_Company_Name__c, dto.companyName);
  }

  static ID getAccountId() {
		User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user;

		Account ac = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
		insert ac;

		return ac.Id;
  }

  static ID getAnotherAccountId() {
		User user = new User(LastName = 'TEST3', FirstName = 'TEST3', Username = 'test3@sutead.com', Email = 'test3@sutead.com', Alias = 'test3', CommunityNickname = 'test3', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
		insert user;

		Account ac = new Account(name = 'Test Inc 2', Phone = '03-3333-3334', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
		insert ac;

		return ac.Id;
  }
}