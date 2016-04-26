@isTest
private class NotExistsContractDtoTest {
  static testMethod void dtoGetterSetter() {
  	NotExistsContractDto dto = new NotExistsContractDto();
  	Date testDate = Date.today();
  	String str1 = 'aaa';

  	dto.opportunityId = str1;
  	System.assertEquals(str1, dto.opportunityId);
  	dto.opportunityName = str1;
  	System.assertEquals(str1, dto.opportunityName);
  	dto.accountName = str1;
  	System.assertEquals(str1, dto.accountName);
  	dto.status = str1;
  	System.assertEquals(str1, dto.status);
  	dto.salesPersonName = str1;
  	System.assertEquals(str1, dto.salesPersonName);
  	dto.useStartDate = testDate;
  	System.assertEquals(testDate, dto.useStartDate);
  	dto.useEndDate = testDate;
  	System.assertEquals(testDate, dto.useEndDate);
  }
}