@isTest
private class AccountingHasseiPendingDtoTest {
  static testMethod void dtoGetterSetter() {
  	AccountingHasseiPendingDto dto = new AccountingHasseiPendingDto();
  	Date testDate = Date.today();
  	String str1 = 'aaa';

  	dto.accountName = str1;
  	System.assertEquals(str1, dto.accountName);
  	dto.opportunityName = str1;
  	System.assertEquals(str1, dto.opportunityName);
  	dto.serviceName = str1;
  	System.assertEquals(str1, dto.serviceName);
  	dto.status = str1;
  	System.assertEquals(str1, dto.status);
  	dto.salesPersonName = str1;
  	System.assertEquals(str1, dto.salesPersonName);
  	dto.hasseiDate = testDate;
  	System.assertEquals(testDate, dto.hasseiDate);
  	dto.infoId = str1;
  	System.assertEquals(str1, dto.infoId);
  }
}