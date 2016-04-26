public class ReplaceFeeDto {
	// 成功報酬はビズリーチの場合ハイクラス用・タレント用とあるので、ラベルの接頭辞にこの値を使用する。
	public String labelName { get; set; }

	public Decimal replaceFeeRate { get; set; }
	public String replaceFeeRateStr { get; set  { 
			replaceFeeRateStr = value; 
			if (String.isNotBlank(value) && isValidDecimalNumber(value)) { 
				replaceFeeRate = Decimal.valueOf(replaceFeeRateStr);
			} else {
				replaceFeeRate = null;
			}
		}
	}

	public Decimal replaceFee { get; set; }
	public String replaceFeeStr { get; set  { 
			replaceFeeStr = value; 
			if (String.isNotBlank(value) && value.isNumeric()) { 
				replaceFee = Decimal.valueOf(replaceFeeStr);
			} else {
				replaceFee = null;
			}
		}
	}

	public Decimal volumeDiscount1 { get; set; }
	public String volumeDiscount1Str { get; set  { 
			volumeDiscount1Str = value; 
			if (String.isNotBlank(value) && isValidDecimalNumber(value)) { 
				volumeDiscount1 = Decimal.valueOf(volumeDiscount1Str);
			} else {
				volumeDiscount1 = null;
			}
		}
	}

	public Decimal volumeDiscount2 { get; set; }
	public String volumeDiscount2Str { get; set  { 
			volumeDiscount2Str = value; 
			if (String.isNotBlank(value) && isValidDecimalNumber(value)) { 
				volumeDiscount2 = Decimal.valueOf(volumeDiscount2Str);
			} else {
				volumeDiscount2 = null;
			}
		}
	}

	public Decimal volumeDiscount3 { get; set; }
	public String volumeDiscount3Str { get; set  { 
			volumeDiscount3Str = value; 
			if (String.isNotBlank(value) && isValidDecimalNumber(value)) { 
				volumeDiscount3 = Decimal.valueOf(volumeDiscount3Str);
			} else {
				volumeDiscount3 = null;
			}
		}
	}

	public Decimal minimumFee { get; set; }
	public String minimumFeeStr { get; set  { 
			minimumFeeStr = value; 
			if (String.isNotBlank(value) && value.isNumeric()) { 
				minimumFee = Decimal.valueOf(minimumFeeStr);
			} else {
				minimumFee = null;
			}
		}
	}
	
	// 小数をチェックする正規表現のパターン
	private Pattern decimalPattern;
	
	public ReplaceFeeDto() {
		labelName = '';
		replaceFeeRate = null;
		replaceFeeRateStr = '';
		replaceFee = null;
		replaceFeeStr = '';
		volumeDiscount1 = null;
		volumeDiscount1Str = '';
		volumeDiscount2 = null;
		volumeDiscount2Str = '';
		volumeDiscount3 = null;
		volumeDiscount3Str = '';
		minimumFee = null;
		minimumFeeStr = '';
		
		decimalPattern = Pattern.compile('\\d+\\.\\d{1,2}$');
	}

  public void convertToStr() {
  	replaceFeeRateStr = replaceFeeRate != null ? replaceFeeRate.toPlainString() : '';
  	replaceFeeStr = replaceFee != null ? replaceFee.toPlainString() : '';
  	volumeDiscount1Str = volumeDiscount1 != null ? volumeDiscount1.toPlainString() : '';
  	volumeDiscount2Str = volumeDiscount2 != null ? volumeDiscount2.toPlainString() : '';
  	volumeDiscount3Str = volumeDiscount3 != null ? volumeDiscount3.toPlainString() : '';
  	minimumFeeStr = minimumFee != null ? minimumFee.toPlainString() : '';
  }
  
  /**
   * 与えられた文字列が有効な数値であるかを判定します。
   * @param value 検証する文字列
   * @return true : 数値, false : 数値でない
   */
  private boolean isValidDecimalNumber(String value) {
  	// 整数は有効
  	if (value.isNumeric()) {
  		return true;
  	}

		return decimalPattern.matcher(value).matches();
  }
}