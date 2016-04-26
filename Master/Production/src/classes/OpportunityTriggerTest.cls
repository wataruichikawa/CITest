@isTest
private class OpportunityTriggerTest {
  @testSetup
  static void setUp() {
      User manager = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'test1@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
      insert manager;

      User user = new User(LastName = 'TEST2', FirstName = 'TEST2', Username = 'test2@sutead.com', Email = 'test2@sutead.com', Alias = 'test2', CommunityNickname = 'test2', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja',ManagerId=manager.Id);
      insert user;

      Account ac1 = new Account(name = 'Test Inc', Phone = '03-3333-3333', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='CRS');
      insert ac1;

      Account ac2 = new Account(name = 'Test2 Inc', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, AccountType__c='CRS');
      insert ac2;

      Account ac3 = new Account(name = 'Test Inc 5673', Phone = '03-5565-7879', website = 'http://www.bizreach.co.jp', Field221__c = 'Internet', Field107__c = user.LastName + ' ' + user.FirstName, ownerid = user.id, careertreck_sales_representative__c = user.id, CrtSalesStaffForLink__c = user.Name, BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx',AccountType__c='ESS');
      insert ac3;


      Opportunity op = new Opportunity();
      op.Name = 'TEST-ABCXYZ20150831';
      op.UseStartDate__c = Date.valueOf('2015-08-03');
      op.DounyuMtgDate__c = Datetime.valueOfGmt('2015-08-20 09:30:00');
      op.ProposedService__c = 'CRS';
      op.Type = '新規提案（過去未契約）';
      op.HirePlanMonths__c = 6;
      op.OwnerId = user.Id;
      op.ApplicationApprovalStatus__c = '';
      op.AccountId = ac1.Id;
      op.StageName = 'TEST';
      op.VisitChargeUser__c = user.Id;
      op.CloseDate = Date.today();
      op.ContactName__c = '新規_20150831';
      op.sample_case__c = '*';
      op.HiringPeriod__c = Date.today();
      op.Opportunity__c = '*';
      op.ContractCollectionDate__c = Date.today();
      op.useStartDate__c = Date.today().addDays(2);
      op.useEndDate__c = Date.today().addDays(120);
      op.ContractApplicationNo__c = '201601-000001';
      insert op;

      Contract_Application_Information__c info1 = new Contract_Application_Information__c();
      info1.Service_Name__c = 'ビズリーチ';
      info1.Opportunity__c = op.Id;
      info1.Version_No__c = 5;
      info1.Approval_Status__c = '未申請';
      info1.Fetch_Date_In_Service__c = null;
      insert info1;

  }

  static testMethod void updateSameDay() {
      Contract_Application_Information__c info = getInfo();
      Opportunity op = getOpportunity();
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);
  }

  static testMethod void updateOpportunityApproval() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      info.Approval_Status__c = '承認済';
      update info;

      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);
  }

  static testMethod void updateDifferenceDayApproval() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      info.Approval_Status__c = '承認済';
      update info;

      op.useStartDate__c = op.useStartDate__c.addDays(2);
      op.useEndDate__c = op.useEndDate__c.addDays(2);
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateDifferenceStartDayApproval() {
      Contract_Application_Information__c info = getInfo();
      Opportunity op = getOpportunity();

      info.Approval_Status__c = '承認済';
      update info;

      op.useStartDate__c = op.useStartDate__c.addDays(2);
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateDifferenceEndDayApproval() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      info.Approval_Status__c = '承認済';
      update info;

      op.useEndDate__c = op.useEndDate__c.addDays(2);
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateDifferenceDay() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      info.Approval_Status__c = '承認済';
      update info;

      op.useStartDate__c = op.useStartDate__c.addDays(2);
      op.useEndDate__c = op.useEndDate__c.addDays(2);
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateBrContractPdf() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      op.Br_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);

      info.Approval_Status__c = '承認済';
      update info;

			// 同じIDだったらステータスは変化しない。
      op.Br_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);

      op.Br_Contract_PDF_ID__c = '012345678901234568';
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateBrRsContractPdf() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      op.Br_Rs_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);

      info.Approval_Status__c = '承認済';
      update info;

			// 同じIDだったらステータスは変化しない。
      op.Br_Rs_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);

      op.Br_Rs_Contract_PDF_ID__c = '012345678901234568';
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateCtContractPdf() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      op.Ct_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);

      info.Approval_Status__c = '承認済';
      update info;

			// 同じIDだったらステータスは変化しない。
      op.Ct_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);

      op.Ct_Contract_PDF_ID__c = '012345678901234568';
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateCtRsContractPdf() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      op.Ct_Rs_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);

      info.Approval_Status__c = '承認済';
      update info;

			// 同じIDだったらステータスは変化しない。
      op.Ct_Rs_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);

      op.Ct_Rs_Contract_PDF_ID__c = '012345678901234568';
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateNrContractPdf() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      op.Nr_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);

      info.Approval_Status__c = '承認済';
      update info;

			// 同じIDだったらステータスは変化しない。
      op.Nr_Contract_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);

      op.Nr_Contract_PDF_ID__c = '012345678901234568';
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static testMethod void updateAttachPdf() {
      Contract_Application_Information__c info = getInfo();

      Opportunity op = getOpportunity();

      op.Br_Contract_PDF_ID__c = '012345678901234567';
      op.Attach_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('未申請', info.Approval_Status__c);

      info.Approval_Status__c = '承認済';
      update info;

			// 同じIDだったらステータスは変化しない。
      op.Attach_PDF_ID__c = '012345678901234567';
      update op;

      info = getInfo();
      System.assertEquals('承認済', info.Approval_Status__c);

      op.Attach_PDF_ID__c = '012345678901234568,012345678901234569';
      update op;

      info = getInfo();
      System.assertEquals('再申請待ち', info.Approval_Status__c);
  }

  static private Account getAccount() {
    return [SELECT ID,
                   Name,
                   BillingState,
                   BillingCity,
                   BillingStreet,
                   Phone
              FROM Account
             WHERE Name = 'Test Inc'];
  }

  static private Opportunity getOpportunity() {
    return [SELECT ID,
                   ContractApplicationNo__c,
                   useStartDate__c,
                   useEndDate__c,
                   Type,
                   ContactName__c
              FROM Opportunity
             WHERE ContactName__c ='新規_20150831'];
  }

  static private Contract_Application_Information__c getInfo() {
    return [SELECT ID,
                   Approval_Status__c
              FROM Contract_Application_Information__c
             WHERE Version_No__c = 5];
  }
}