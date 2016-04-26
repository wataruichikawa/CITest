@isTest
private class ReplaceFeeDtoTest {
  static testMethod void constructor() {
 		ReplaceFeeDto dto = new ReplaceFeeDto();
 		 	
		System.assertEquals('', dto.labelName);
		System.assertEquals(null, dto.replaceFeeRate);
		System.assertEquals('', dto.replaceFeeRateStr);
		System.assertEquals(null, dto.replaceFee);
		System.assertEquals('', dto.replaceFeeStr);
		System.assertEquals(null, dto.volumeDiscount1);
		System.assertEquals('', dto.volumeDiscount1Str);
		System.assertEquals(null, dto.volumeDiscount2);
		System.assertEquals('', dto.volumeDiscount2Str);
		System.assertEquals(null, dto.volumeDiscount3);
		System.assertEquals('', dto.volumeDiscount3Str);
		System.assertEquals(null, dto.minimumFee);
		System.assertEquals('', dto.minimumFeeStr);
  }

  static testMethod void dtoGetterSetter() {
  	String correctValueStr = '50';
  	String uncorrectValueStr = 'aaa';
  	Decimal correctDecimal = 40;

 		ReplaceFeeDto dto = new ReplaceFeeDto();

		dto.labelName = correctValueStr;
		System.assertEquals(correctValueStr, dto.labelName);

		dto.replaceFeeRate = correctDecimal;
		System.assertEquals(correctDecimal, dto.replaceFeeRate);

		dto.replaceFeeRateStr = correctValueStr;
		System.assertEquals(correctValueStr, dto.replaceFeeRateStr);
		dto.replaceFeeRateStr = uncorrectValueStr;
		System.assertEquals(null, dto.replaceFeeRate);

		dto.replaceFee = correctDecimal;
		System.assertEquals(correctDecimal, dto.replaceFee);

		dto.replaceFeeStr = correctValueStr;
		System.assertEquals(correctValueStr, dto.replaceFeeStr);
		dto.replaceFeeStr = uncorrectValueStr;
		System.assertEquals(null, dto.replaceFee);

		dto.volumeDiscount1 = correctDecimal;
		System.assertEquals(correctDecimal, dto.volumeDiscount1);

		dto.volumeDiscount1Str = correctValueStr;
		System.assertEquals(correctValueStr, dto.volumeDiscount1Str);
		dto.volumeDiscount1Str = uncorrectValueStr;
		System.assertEquals(null, dto.volumeDiscount1);

		dto.volumeDiscount2 = correctDecimal;
		System.assertEquals(correctDecimal, dto.volumeDiscount2);

		dto.volumeDiscount2Str = correctValueStr;
		System.assertEquals(correctValueStr, dto.volumeDiscount2Str);
		dto.volumeDiscount2Str = uncorrectValueStr;
		System.assertEquals(null, dto.volumeDiscount2);

		dto.volumeDiscount3 = correctDecimal;
		System.assertEquals(correctDecimal, dto.volumeDiscount3);

		dto.volumeDiscount3Str = correctValueStr;
		System.assertEquals(correctValueStr, dto.volumeDiscount3Str);
		dto.volumeDiscount3Str = uncorrectValueStr;
		System.assertEquals(null, dto.volumeDiscount3);

		dto.minimumFee = correctDecimal;
		System.assertEquals(correctDecimal, dto.minimumFee);

		dto.minimumFeeStr = correctValueStr;
		System.assertEquals(correctValueStr, dto.minimumFeeStr);
		dto.minimumFeeStr = uncorrectValueStr;
		System.assertEquals(null, dto.minimumFee);
  } 
  
  static testMethod void convertToStr() {
 		ReplaceFeeDto dto = new ReplaceFeeDto();
 		
 		Decimal value = 50;
 		String valueStr = '50';
 		
 		dto.replaceFee = value;
 		System.assertEquals('', dto.replaceFeeStr);

 		dto.convertToStr();

 		System.assertEquals(value, dto.replaceFee);
 		System.assertEquals(valueStr, dto.replaceFeeStr);
  }

  static testMethod void convertToDecimalStr() {
 		ReplaceFeeDto dto = new ReplaceFeeDto();
 		
 		Decimal value = 25.50;
 		String valueStr = '25.50';
 		
 		dto.replaceFeeRate = value;
 		System.assertEquals('', dto.replaceFeeRateStr);

 		dto.convertToStr();

 		System.assertEquals(value, dto.replaceFeeRate);
 		System.assertEquals(valueStr, dto.replaceFeeRateStr);
  }

  static testMethod void convertStrToDecimal() {
 		ReplaceFeeDto dto = new ReplaceFeeDto();
 		
 		Decimal value = 25.52;
 		String valueStr = '25.52';
 		
 		dto.replaceFeeRateStr = valueStr;

 		System.assertEquals(value, dto.replaceFeeRate);
 		System.assertEquals(valueStr, dto.replaceFeeRateStr);
  }

  static testMethod void convertStrToDecimal2() {
 		ReplaceFeeDto dto = new ReplaceFeeDto();
 		
 		String valueStr = '25.526';
 		
 		dto.replaceFeeRateStr = valueStr;

 		System.assertEquals(null, dto.replaceFeeRate);
 		System.assertEquals(valueStr, dto.replaceFeeRateStr);
  }
}