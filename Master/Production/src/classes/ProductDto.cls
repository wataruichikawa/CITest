public class ProductDto {
  public enum MstProductType { STD, BOS, AGY, PSC, OPT, NON }

	public String name { get; set; }
  public String serviceName { get; set; }
  public String serviceType { get; set; }
  public String displayName { get; set; }
  public String billName { get; set; }
  public String hirePlanCategory { get; set; }
  public Boolean isNewContract { get; set; }
  public Decimal quantity { get; set; }
  public Decimal initialPrice { get; set; }
  public String initialPriceStr { get; set { 
			initialPriceStr = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        initialPrice = Decimal.valueOf(initialPriceStr);
      } else {
      	initialPrice = null;
      }
    } 
  }
  public Decimal monthlyPrice1 { get; set; }
  public String monthlyPrice1Str { get; set { 
			monthlyPrice1Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice1 = Decimal.valueOf(monthlyPrice1Str);
      } else {
      	monthlyPrice1 = null;
      }
    } 
  }
  public Decimal monthlyPrice2 { get; set; }
  public String monthlyPrice2Str { get; set { 
			monthlyPrice2Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice2 = Decimal.valueOf(monthlyPrice2Str);
      } else {
      	monthlyPrice2 = null;
      }
    } 
  }
  public Decimal monthlyPrice3 { get; set; }
  public String monthlyPrice3Str { get; set { 
			monthlyPrice3Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice3 = Decimal.valueOf(monthlyPrice3Str);
      } else {
      	monthlyPrice3 = null;
      }
    } 
  }
  public Decimal monthlyPrice4 { get; set; }
  public String monthlyPrice4Str { get; set { 
			monthlyPrice4Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice4 = Decimal.valueOf(monthlyPrice4Str);
      } else {
      	monthlyPrice4 = null;
      }
    } 
  }
  public Decimal monthlyPrice5 { get; set; }
  public String monthlyPrice5Str { get; set { 
			monthlyPrice5Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice5 = Decimal.valueOf(monthlyPrice5Str);
      } else {
      	monthlyPrice5 = null;
      }
    } 
  }
  public Decimal monthlyPrice6 { get; set; }
  public String monthlyPrice6Str { get; set { 
			monthlyPrice6Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice6 = Decimal.valueOf(monthlyPrice6Str);
      } else {
      	monthlyPrice6 = null;
      }
    } 
  }
  public Decimal monthlyPrice7 { get; set; }
  public String monthlyPrice7Str { get; set { 
			monthlyPrice7Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice7 = Decimal.valueOf(monthlyPrice7Str);
      } else {
      	monthlyPrice7 = null;
      }
    } 
  }
  public Decimal monthlyPrice8 { get; set; }
  public String monthlyPrice8Str { get; set { 
			monthlyPrice8Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice8 = Decimal.valueOf(monthlyPrice8Str);
      } else {
      	monthlyPrice8 = null;
      }
    } 
  }
  public Decimal monthlyPrice9 { get; set; }
  public String monthlyPrice9Str { get; set { 
			monthlyPrice9Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice9 = Decimal.valueOf(monthlyPrice9Str);
      } else {
      	monthlyPrice9 = null;
      }
    } 
  }
  public Decimal monthlyPrice10 { get; set; }
  public String monthlyPrice10Str { get; set { 
			monthlyPrice10Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice10 = Decimal.valueOf(monthlyPrice10Str);
      } else {
      	monthlyPrice10 = null;
      }
    } 
  }
  public Decimal monthlyPrice11 { get; set; }
  public String monthlyPrice11Str { get; set { 
			monthlyPrice11Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice11 = Decimal.valueOf(monthlyPrice11Str);
      } else {
      	monthlyPrice11 = null;
      }
    } 
  }
  public Decimal monthlyPrice12 { get; set; }
  public String monthlyPrice12Str { get; set { 
			monthlyPrice12Str = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        monthlyPrice12 = Decimal.valueOf(monthlyPrice12Str);
      } else {
      	monthlyPrice12 = null;
      }
    } 
  }
  public Decimal platinumScoutCount { get; set; }
  public String platinumScoutCountStr { get; set { 
			platinumScoutCountStr = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        platinumScoutCount = Decimal.valueOf(platinumScoutCountStr);
      } else {
      	platinumScoutCount = null;
      }
    } 
  }
  public Decimal platinumScoutInitialCount { get; set; }
  public String platinumScoutInitialCountStr { get; set { 
			platinumScoutInitialCountStr = value; 
      if (String.isNotBlank(value) && value.isNumeric()) { 
        platinumScoutInitialCount = Decimal.valueOf(platinumScoutInitialCountStr);
      } else {
      	platinumScoutInitialCount = null;
      }
    }
  }
  public Decimal platinumScoutContinuationCount { get; set; }
  public String platinumScoutContinuationCountStr { get; set {
  		platinumScoutContinuationCountStr = value;
  		if (String.isNotBlank(value) && value.isNumeric()) {
  			platinumScoutContinuationCount = Decimal.valueOf(platinumScoutContinuationCountStr);
  		} else {
  			platinumScoutContinuationCount = null;
  		}
		}
  }
  public String platinumScoutTypeName { get; set; }
  public String replaceFeeTypeName { get; set; }

  public Date useStartDate { get; set; }
  public Date useEndDate { get; set; }
  public Decimal PeriodOfUse { get; set; }
  
  public String opportunityLineItemId {get; set;}
  public String opportunityLineItemName {get; set;}
  public String contractApplicationProductId {get; set;}
  public String contractApplicationProductName {get; set;}
  public List<ReplaceFeeDto> replaceFeeList { get; set; }
  public String productCode { get; set; }
  
  public ProductDto() {
  	name = '';
    serviceName = '';
    serviceType = '';
    initialPrice = null;
    initialPriceStr = '';
    periodOfUse = null;
    monthlyPrice1 = null;
    monthlyPrice1Str = '';
    monthlyPrice2 = null;
    monthlyPrice2Str = '';
    monthlyPrice3 = null;
    monthlyPrice3Str = '';
    monthlyPrice4 = null;
    monthlyPrice4Str = '';
    monthlyPrice5 = null;
    monthlyPrice5Str = '';
    monthlyPrice6 = null;
    monthlyPrice6Str = '';
    monthlyPrice7 = null;
    monthlyPrice7Str = '';
    monthlyPrice8 = null;
    monthlyPrice8Str = '';
    monthlyPrice9 = null;
    monthlyPrice9Str = '';
    monthlyPrice10 = null;
    monthlyPrice10Str = '';
    monthlyPrice11 = null;
    monthlyPrice11Str = '';
    monthlyPrice12 = null;
    monthlyPrice12Str = '';
    platinumScoutCount = null;
    platinumScoutCountStr = '';
    platinumScoutInitialCount = null;
    platinumScoutInitialCountStr = '';
    platinumScoutContinuationCount = null;
    platinumScoutContinuationCountStr = '';
    platinumScoutTypeName = '';
    replaceFeeTypeName = '';
    opportunityLineItemId = null;
    opportunityLineItemName = '';
    productCode = '';
    replaceFeeList = new List<ReplaceFeeDto>();
  }

  // 数値から文字列に変換する。
  public void convertToStr() {
    initialPriceStr = initialPrice != null ? initialPrice.toPlainString() : '';
    monthlyPrice1Str = monthlyPrice1 != null ? monthlyPrice1.toPlainString() : '';
    monthlyPrice2Str = monthlyPrice2 != null ? monthlyPrice2.toPlainString() : '';
    monthlyPrice3Str = monthlyPrice3 != null ? monthlyPrice3.toPlainString() : '';
    monthlyPrice4Str = monthlyPrice4 != null ? monthlyPrice4.toPlainString() : '';
    monthlyPrice5Str = monthlyPrice5 != null ? monthlyPrice5.toPlainString() : '';
    monthlyPrice6Str = monthlyPrice6 != null ? monthlyPrice6.toPlainString() : '';
    monthlyPrice7Str = monthlyPrice7 != null ? monthlyPrice7.toPlainString() : '';
    monthlyPrice8Str = monthlyPrice8 != null ? monthlyPrice8.toPlainString() : '';
    monthlyPrice9Str = monthlyPrice9 != null ? monthlyPrice9.toPlainString() : '';
    monthlyPrice10Str = monthlyPrice10 != null ? monthlyPrice10.toPlainString() : '';
    monthlyPrice11Str = monthlyPrice11 != null ? monthlyPrice11.toPlainString() : '';
    monthlyPrice12Str = monthlyPrice12 != null ? monthlyPrice12.toPlainString() : '';
    platinumScoutCountStr = platinumScoutCount != null ? platinumScoutCount.toPlainString() : '';
    platinumScoutInitialCountStr = platinumScoutInitialCount != null ? platinumScoutInitialCount.toPlainString() : '';
    platinumScoutContinuationCountStr = platinumScoutContinuationCount != null ? platinumScoutContinuationCount.toPlainString() : '';
  }

  public String productTypeName { get {
  		if (ProductType == ProductDto.MstProductType.OPT) {
  			return 'オプション';
  		} else if (ProductType == ProductDto.MstProductType.PSC) {
  			return 'プラスカ';
  		} else if (ProductType == ProductDto.MstProductType.BOS) {
  			return 'RS';
  		} else {
  			return '基本商品';
  		}
  	}
  }

  public MstProductType ProductType {
    get {
    	if (hirePlanCategory == 'オプション') {
        return ProductDto.MstProductType.OPT;
    	} else if (hirePlanCategory == 'プラスカ') {
        return ProductDto.MstProductType.PSC;
    	} else if (serviceName == 'ビズリーチRS' || serviceName == 'キャリアトレックRS') {
        return ProductDto.MstProductType.BOS;
    	} else {
        return ProductDto.MstProductType.STD;
    	}
    }
  }
}