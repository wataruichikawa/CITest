@isTest
private class ProductDtoTest {
  static testMethod void getProductType() {
    ProductDto dto = new ProductDto();
    dto.hirePlanCategory = 'オプション';
    System.assertEquals('オプション', dto.ProductTypeName);
    System.assertEquals(ProductDto.MstProductType.OPT, dto.ProductType);

    dto.hirePlanCategory = 'プラスカ';
    System.assertEquals('プラスカ', dto.ProductTypeName);
		System.assertEquals(ProductDto.MstProductType.PSC, dto.ProductType);

    dto.hirePlanCategory = '固定';
    dto.serviceName = 'ビズリーチRS';
    System.assertEquals('RS', dto.ProductTypeName);
		System.assertEquals(ProductDto.MstProductType.BOS, dto.ProductType);

    dto.hirePlanCategory = '固定';
    dto.serviceName = 'ビズリーチ';
    System.assertEquals('基本商品', dto.ProductTypeName);
		System.assertEquals(ProductDto.MstProductType.STD, dto.ProductType);
  }

  static testMethod void accessProperty() {
    ProductDto dto = new ProductDto();
    String testStr = 'A';
    Decimal testDecimal = 1;
    String testDecimalStr = '1';
    Date testDate = Date.today();

		dto.displayName = testStr;
		System.assertEquals(testStr, dto.displayName);
		
		dto.hirePlanCategory = testStr;
		System.assertEquals(testStr, dto.hirePlanCategory);
		
		dto.isNewContract = true;
		System.assertEquals(true, dto.isNewContract);
		
		dto.quantity = testDecimal;
		System.assertEquals(testDecimal, dto.quantity);
		
    dto.serviceName = testStr;
    System.assertEquals(testStr, dto.serviceName);

    dto.serviceType = testStr;
    System.assertEquals(testStr, dto.serviceType);

    dto.initialPriceStr = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.initialPriceStr);
    System.assertEquals(testDecimal, dto.initialPrice);

    dto.initialPrice = testDecimal;
    System.assertEquals(testDecimal, dto.initialPrice);

    dto.monthlyPrice1Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice1Str);
    System.assertEquals(testDecimal, dto.monthlyPrice1);

    dto.monthlyPrice1 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice1);

    dto.monthlyPrice2Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice2Str);
    System.assertEquals(testDecimal, dto.monthlyPrice2);

    dto.monthlyPrice2 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice2);

    dto.monthlyPrice3Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice3Str);
    System.assertEquals(testDecimal, dto.monthlyPrice3);

    dto.monthlyPrice3 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice3);

    dto.monthlyPrice4Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice4Str);
    System.assertEquals(testDecimal, dto.monthlyPrice4);

    dto.monthlyPrice4 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice4);

    dto.monthlyPrice5Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice5Str);
    System.assertEquals(testDecimal, dto.monthlyPrice5);

    dto.monthlyPrice5 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice5);

    dto.monthlyPrice6Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice6Str);
    System.assertEquals(testDecimal, dto.monthlyPrice6);

    dto.monthlyPrice6 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice6);

    dto.monthlyPrice7Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice7Str);
    System.assertEquals(testDecimal, dto.monthlyPrice7);

    dto.monthlyPrice7 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice7);

    dto.monthlyPrice8Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice8Str);
    System.assertEquals(testDecimal, dto.monthlyPrice8);

    dto.monthlyPrice8 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice8);

    dto.monthlyPrice9Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice9Str);
    System.assertEquals(testDecimal, dto.monthlyPrice9);

    dto.monthlyPrice9 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice9);

    dto.monthlyPrice10Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice10Str);
    System.assertEquals(testDecimal, dto.monthlyPrice10);

    dto.monthlyPrice10 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice10);

    dto.monthlyPrice11Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice11Str);
    System.assertEquals(testDecimal, dto.monthlyPrice11);

    dto.monthlyPrice11 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice11);

    dto.monthlyPrice12Str = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.monthlyPrice12Str);
    System.assertEquals(testDecimal, dto.monthlyPrice12);

    dto.monthlyPrice12 = testDecimal;
    System.assertEquals(testDecimal, dto.monthlyPrice12);

    dto.platinumScoutCountStr = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.platinumScoutCountStr);
    System.assertEquals(testDecimal, dto.platinumScoutCount);

    dto.platinumScoutCount = testDecimal;
    System.assertEquals(testDecimalStr, dto.platinumScoutCountStr);

    dto.platinumScoutInitialCountStr = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.platinumScoutInitialCountStr);
    System.assertEquals(testDecimal, dto.platinumScoutInitialCount);

    dto.platinumScoutInitialCount = testDecimal;
    System.assertEquals(testDecimal, dto.platinumScoutInitialCount);

    dto.platinumScoutContinuationCountStr = testDecimalStr;
    System.assertEquals(testDecimalStr, dto.platinumScoutContinuationCountStr);
    System.assertEquals(testDecimal, dto.platinumScoutContinuationCount);

    dto.platinumScoutContinuationCount = testDecimal;
    System.assertEquals(testDecimal, dto.platinumScoutContinuationCount);

    dto.platinumScoutTypeName = testStr;
    System.assertEquals(testStr, dto.platinumScoutTypeName);
    
    dto.useStartDate = testDate;
    System.assertEquals(testDate, dto.useStartDate);

    dto.useEndDate = testDate;
    System.assertEquals(testDate, dto.useEndDate);

    dto.replaceFeeTypeName = testStr;
    System.assertEquals(testStr, dto.replaceFeeTypeName);
    
    dto.opportunityLineItemId = testStr;
    System.assertEquals(testStr, dto.opportunityLineItemId);
    
    dto.opportunityLineItemName = testStr;
    System.assertEquals(testStr, dto.opportunityLineItemName);
    
    dto.contractApplicationProductId = testStr;
    System.assertEquals(testStr, dto.contractApplicationProductId);
    
    dto.contractApplicationProductName = testStr;
    System.assertEquals(testStr, dto.contractApplicationProductName);
  }

  static testMethod void convert() {
    ProductDto dto = new ProductDto();
    Decimal testDecimal = 1000;
    String testDecimalStr = '1000';

    dto.initialPrice = testDecimal;
    System.assertEquals(testDecimal, dto.initialPrice);
    System.assertEquals('', dto.initialPriceStr);
    dto.convertToStr();
    System.assertEquals(testDecimalStr, dto.initialPriceStr);
  }

}