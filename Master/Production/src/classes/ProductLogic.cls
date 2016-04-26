/**
 * 契約申込商品に関連するロジック群です。
 */
public class ProductLogic {
	/**
	 * ProductDtoを初期化します。
	 * ProductDtoは商談商品分生成されます。
	 */
  public List<ProductDto> initializeProductDtoByOpportunityId(ID opportunityId, String serviceName, Boolean isNewContract) {
  	// 商談IDがない場合は何もしない。
  	if (String.isBlank(opportunityId)) {
  		return new List<ProductDto>();
  	}

		List<OpportunityLineItem> itemList = getOpportunityLineItemByOpportunityId(opportunityId);
		if (itemList.isEmpty()) {
			System.Debug('### Debug return value is empty!!');
  		return new List<ProductDto>();
		}

		List<ProductDto> dtoList = new List<ProductDto>();
		for (OpportunityLineItem item: itemList) {
			// 編集画面では登録されているサービスしか出さない。
			if (String.isNotBlank(serviceName) && !item.Service__c.contains(serviceName)) {
				continue;
			}
			
			// サービス名・採用プランカテゴリが商談商品に登録されていない場合はスキップ
			if (item.Service__c == null || item.HirePlanCategory__c == null) {
				continue;
			}

			ProductDto dto = new ProductDto();
			dto.opportunityLineItemId = item.Id;
			dto.opportunityLineItemName = item.Product2Name__c;
			dto.serviceName = item.Service__c;
			dto.serviceType = item.ProposedService__c;
			dto.displayName = item.DisplayNameForClient__c;
			dto.billName = item.BillName__c;
			dto.hirePlanCategory = item.HirePlanCategory__c;
			dto.isNewContract = isNewContract;
			dto.quantity = item.Quantity;
			dto.monthlyPrice1 = item.MonthlyPrice1__c;
			dto.monthlyPrice2 = item.MonthlyPrice2__c;
			dto.monthlyPrice3 = item.MonthlyPrice3__c;
			dto.monthlyPrice4 = item.MonthlyPrice4__c;
			dto.monthlyPrice5 = item.MonthlyPrice5__c;
			dto.monthlyPrice6 = item.MonthlyPrice6__c;
			dto.monthlyPrice7 = item.MonthlyPrice7__c;
			dto.monthlyPrice8 = item.MonthlyPrice8__c;
			dto.monthlyPrice9 = item.MonthlyPrice9__c;
			dto.monthlyPrice10 = item.MonthlyPrice10__c;
			dto.monthlyPrice11 = item.MonthlyPrice11__c;
			dto.monthlyPrice12 = item.MonthlyPrice12__c;
			dto.initialPrice = item.MonthlyPrice1__c == null ? item.UnitPrice : item.UpfrontFee__c;
			System.Debug('### Debug : ContractPeriod__c -> ' + item.ContractPeriod__c);
			dto.periodOfUse = item.ContractPeriod__c;
			System.Debug('### Debug : periodOfUse -> ' + dto.periodOfUse);
			dto.platinumScoutTypeName = item.PlatinumScoutType__c;
			if (String.isBlank(dto.platinumScoutTypeName) && !isOptionProduct(dto.hirePlanCategory)) {
				dto.platinumScoutTypeName = System.Label.PlatinumScoutTypeDefault;
			}
			dto.platinumScoutCount = item.PlatinumScoutNumber__c;
			dto.platinumScoutInitialCount = item.PlatinumScoutNumberOfFirstMonth__c;
			dto.platinumScoutContinuationCount = item.PlatinumScoutNumberContinuation__c;
			dto.useStartDate = item.UsePeriodFrom__c != null ? item.UsePeriodFrom__c : item.Opportunity.UseStartDate__c;
			dto.useEndDate = item.UsePeriodTo__c != null ? item.UsePeriodTo__c : item.Opportunity.UseEndDate__c;
			System.Debug('### Debug : item.UsePeriodFrom__c -> ' + item.UsePeriodFrom__c + ', useStartDate -> ' + dto.useStartDate);
			dto.productCode = item.ProductCode;
			if (dto.serviceName.contains(System.Label.ServiceBiz) && !isOptionProduct(item.hirePlanCategory__c) && 
			    (item.BrRgSuccessFee__c != null || item.BrRgSuccessFeeRatio__c != null || 
			     item.BrRgVolumeDiscount1__c != null || item.BrRgVolumeDiscount2__c != null || item.BrRgVolumeDiscount3__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				feeDto.labelName = System.Label.BrCandidateClassRG;
				// 入力規則対策。何もしないと不要な場所に0が登録されてしまうため。
				if (dto.hirePlanCategory.contains('固定')) {
					feeDto.replaceFee = item.BrRgSuccessFee__c;
				} else {
					// レートは0なら固定なので、0以外だったらデータを格納する。
					feeDto.replaceFeeRate = item.BrRgSuccessFeeRatio__c != 0 ? item.BrRgSuccessFeeRatio__c : null;
					feeDto.volumeDiscount1 = item.BrRgVolumeDiscount1__c != 0 ? item.BrRgVolumeDiscount1__c : null;
					feeDto.volumeDiscount2 = item.BrRgVolumeDiscount2__c != 0 ? item.BrRgVolumeDiscount2__c : null;
					feeDto.volumeDiscount3 = item.BrRgVolumeDiscount3__c != 0 ? item.BrRgVolumeDiscount3__c : null;
				}
				feeDto.minimumFee = item.BrRgMinimumFee__c;
				// 特別プランのみ入力させたいので、特別プラン以外の場合は文字に変換する。
				if (!dto.hirePlanCategory.contains('特別')) {
					feeDto.convertToStr();
				}
				dto.replaceFeeList.add(feeDto);
			}
			if (dto.serviceName.contains(System.Label.ServiceBiz) && !isOptionProduct(item.hirePlanCategory__c) && 
			    (item.BrTtSuccessFee__c != null || item.BrTtSuccessFeeRatio__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				feeDto.labelName = System.Label.BrCandidateClassTt;
				if (dto.hirePlanCategory.contains('固定')) {
					feeDto.replaceFee = item.BrTtSuccessFee__c;
				} else {
					feeDto.replaceFeeRate = item.BrTtSuccessFeeRatio__c != 0 ? item.BrTtSuccessFeeRatio__c : null;
				}
				feeDto.minimumFee = item.BrTtMinimumFee__c;
				// 特別プランのみ入力させたいので、特別プラン以外の場合は文字に変換する。
				if (!dto.hirePlanCategory.contains('特別')) {
					feeDto.convertToStr();
				}
				dto.replaceFeeList.add(feeDto);
			}
			if (dto.serviceName.contains(System.Label.ServiceCt) && !isOptionProduct(item.hirePlanCategory__c) && 
			    (item.CtSuccessFee__c != null || item.CtSuccessFeeRatio__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				if (dto.hirePlanCategory.contains('固定')) {
					feeDto.replaceFee = item.CtSuccessFee__c;
				} else {
					feeDto.replaceFeeRate = item.CtSuccessFeeRatio__c != 0 ? item.CtSuccessFeeRatio__c : null;
				}
				feeDto.minimumFee = item.CtMinimumFee__c;
				// 特別プランのみ入力させたいので、特別プラン以外の場合は文字に変換する。
				if (!dto.hirePlanCategory.contains('特別')) {
					feeDto.convertToStr();
				}
				dto.replaceFeeList.add(feeDto);
			}
			if (dto.serviceName.contains(System.Label.ServiceNk) && !isOptionProduct(item.hirePlanCategory__c) && 
			    (item.NrSuccessFee__c != null || item.NrSuccessFeeRatio__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				if (dto.hirePlanCategory.contains('固定')) {
					feeDto.replaceFee = item.NrSuccessFee__c;
				} else {
					feeDto.replaceFeeRate = item.NrSuccessFeeRatio__c != 0 ? item.NrSuccessFeeRatio__c : null;
				}
				feeDto.minimumFee = item.NrMinimumFee__c;
				// 特別プランのみ入力させたいので、特別プラン以外の場合は文字に変換する。
				if (!dto.hirePlanCategory.contains('特別')) {
					feeDto.convertToStr();
				}
				dto.replaceFeeList.add(feeDto);
			}
			dto.convertToStr();
			dtoList.add(dto);
		}
		System.Debug('### Debug return value(productDtoList) -> ' + dtoList);
		return dtoList;
  }
  
  private Boolean isOptionProduct(String hirePlanCategory) {
  	return hirePlanCategory == System.Label.HirePlanOption || hirePlanCategory == System.Label.HirePlanPlatinumScout;
  }

	/**
	 * 契約内容をキーに契約商品明細に紐づく商品を取得します。
	 * 契約商品明細は複数存在する可能性があるため、リストで返却します。
	 */
  public List<ProductDto> initializeProductDtoByInfoId(ID infoId, String serviceName, Boolean isNewContract) {
  	if (String.isBlank(infoId)) {
  		return new List<ProductDto>();
  	}

		List<Contract_Application_Product__c> productList = getContractApplicationProductByInfoId(infoId);
		if (productList.isEmpty()) {
  		return new List<ProductDto>();
		}

		List<ProductDto> dtoList = new List<ProductDto>();
		for (Contract_Application_Product__c product: productList) {
			// 契約内容オブジェクトにサービス名が指定されている場合は、そのサービスしか表示しない。
			if (String.isNotBlank(serviceName) && !product.Service__c.contains(serviceName)) {
				continue;
			}

			ProductDto dto = new ProductDto();
			dto.contractApplicationProductId = product.Id;
			dto.contractApplicationProductName = product.Name;
			dto.serviceName = product.Service__c;
			dto.serviceType = product.ProposedService__c;
			dto.displayName = product.DisplayNameForClient__c;
			dto.billName = product.BillName__c;
			dto.hirePlanCategory = product.HirePlanCategory__c;
			dto.isNewContract = isNewContract;
			dto.initialPrice = product.UpfrontFee__c;
			dto.monthlyPrice1 = product.MonthlyPrice1__c;
			dto.monthlyPrice2 = product.MonthlyPrice2__c;
			dto.monthlyPrice3 = product.MonthlyPrice3__c;
			dto.monthlyPrice4 = product.MonthlyPrice4__c;
			dto.monthlyPrice5 = product.MonthlyPrice5__c;
			dto.monthlyPrice6 = product.MonthlyPrice6__c;
			dto.monthlyPrice7 = product.MonthlyPrice7__c;
			dto.monthlyPrice8 = product.MonthlyPrice8__c;
			dto.monthlyPrice9 = product.MonthlyPrice9__c;
			dto.monthlyPrice10 = product.MonthlyPrice10__c;
			dto.monthlyPrice11 = product.MonthlyPrice11__c;
			dto.monthlyPrice12 = product.MonthlyPrice12__c;
			dto.periodOfUse = product.ContractPeriod__c;
			dto.platinumScoutTypeName = product.PlatinumScoutType__c;
			dto.platinumScoutCount = product.PlatinumScoutNumber__c;
			dto.platinumScoutInitialCount = product.PlatinumScoutNumberOfFirstMonth__c;
			dto.platinumScoutContinuationCount = product.PlatinumScoutNumberContinuation__c;
			dto.useStartDate = product.UsePeriodFrom__c;
			dto.useEndDate = product.UsePeriodTo__c;
			dto.productCode = product.ProductCode__c;
			if (dto.serviceName != null && dto.serviceName.contains(System.Label.ServiceBiz) && 
			    (product.BrRgSuccessFee__c != null || product.BrRgSuccessFeeRatio__c != null || 
			    product.BrRgVolumeDiscount1__c != null || product.BrRgVolumeDiscount2__c != null || product.BrRgVolumeDiscount3__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				feeDto.labelName = System.Label.BrCandidateClassRG;
				feeDto.replaceFee = product.BrRgSuccessFee__c;
				feeDto.replaceFeeRate = product.BrRgSuccessFeeRatio__c;
				feeDto.volumeDiscount1 = product.BrRgVolumeDiscount1__c;
				feeDto.volumeDiscount2 = product.BrRgVolumeDiscount2__c;
				feeDto.volumeDiscount3 = product.BrRgVolumeDiscount3__c;
				feeDto.minimumFee = product.BrRgMinimumFee__c;
				// 編集画面では0が含まれてしまうため、閲覧のみ文字に変換する。
				feeDto.convertToStr();
				dto.replaceFeeList.add(feeDto);
			}
			if (dto.serviceName != null && dto.serviceName.contains(System.Label.ServiceBiz) && 
			    (product.BrTtSuccessFee__c != null || product.BrTtSuccessFeeRatio__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				feeDto.labelName = System.Label.BrCandidateClassTt;
				feeDto.replaceFee = product.BrTtSuccessFee__c;
				feeDto.replaceFeeRate = product.BrTtSuccessFeeRatio__c;
				feeDto.minimumFee = product.BrTtMinimumFee__c;
				// 編集画面では0が含まれてしまうため、閲覧のみ文字に変換する。
				feeDto.convertToStr();
				dto.replaceFeeList.add(feeDto);
			}
			if (dto.serviceName != null && dto.serviceName.contains(System.Label.ServiceCt) && 
			    (product.CtSuccessFee__c != null || product.CtSuccessFeeRatio__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				feeDto.replaceFee = product.CtSuccessFee__c;
				feeDto.replaceFeeRate = product.CtSuccessFeeRatio__c;
				feeDto.minimumFee = product.CtMinimumFee__c;
				// 編集画面では0が含まれてしまうため、閲覧のみ文字に変換する。
				feeDto.convertToStr();
				dto.replaceFeeList.add(feeDto);
			}
			if (dto.serviceName != null && dto.serviceName.contains(System.Label.ServiceNk) && 
			    (product.NrSuccessFee__c != null || product.NrSuccessFeeRatio__c != null)) {
				ReplaceFeeDto feeDto = new ReplaceFeeDto();
				feeDto.replaceFee = product.NrSuccessFee__c;
				feeDto.replaceFeeRate = product.NrSuccessFeeRatio__c;
				feeDto.minimumFee = product.NrMinimumFee__c;
				// 編集画面では0が含まれてしまうため、閲覧のみ文字に変換する。
				feeDto.convertToStr();
				dto.replaceFeeList.add(feeDto);
			}
			dto.convertToStr();
			dtoList.add(dto);
		}
		System.Debug('### Debug return value(productDtoList) -> ' + dtoList);
		return dtoList;
  }
  
  /**
   * 商談商品を取得します。
   */ 
  public List<OpportunityLineItem> getOpportunityLineItemByOpportunityId(ID opportunityId) {
  	if (String.isBlank(opportunityId)) {
  		return new List<OpportunityLineItem>();
  	}

		// 商談商品にコピーして順番が変わったのか、選択リストが逆順になっている。
  	return [SELECT oli.ID,
  	               oli.ListPrice,
  	               oli.Discount,
  	               oli.TotalPrice,
  	               oli.ProductCode,
  	               oli.Subtotal,
  	               oli.Quantity,
  	               oli.ServiceDate,
  	               oli.UnitPrice,
  	               oli.Description,
  	               oli.BrTtMinimumFee__c,
  	               oli.BrTtSuccessFeeRatio__c,
  	               oli.BrTtSuccessFee__c,
  	               oli.BrRgMinimumFee__c,
  	               oli.BrRgSuccessFeeRatio__c,
  	               oli.BrRgSuccessFee__c,
  	               oli.CtMinimumFee__c,
  	               oli.CtSuccessFeeRatio__c,
  	               oli.CtSuccessFee__c,
  	               oli.IrregularPlan__c,
  	               oli.DisplayNameForClient__c,
  	               oli.BillName__c,
  	               oli.Service__c,
  	               oli.UpfrontFee__c,
  	               oli.TriggerInvalid__c,
  	               oli.NrMinimumFee__c,
  	               oli.NrSuccessFeeRatio__c,
  	               oli.NrSuccessFee__c,
  	               oli.PlatinumScoutNumberOfFirstMonth__c,
  	               oli.PlatinumScoutNumber__c,
  	               oli.PlatinumScoutNumberContinuation__c,
  	               oli.PlatinumScoutNumberInTotal__c,
  	               oli.PlatinumScoutType__c,
  	               oli.ContractPeriod__c,
  	               oli.MonthlyPrice1__c,
  	               oli.MonthlyPrice2__c,
  	               oli.MonthlyPrice3__c,
  	               oli.MonthlyPrice4__c,
  	               oli.MonthlyPrice5__c,
  	               oli.MonthlyPrice6__c,
  	               oli.MonthlyPrice7__c,
  	               oli.MonthlyPrice8__c,
  	               oli.MonthlyPrice9__c,
  	               oli.MonthlyPrice10__c,
  	               oli.MonthlyPrice11__c,
  	               oli.MonthlyPrice12__c,
  	               oli.HirePlanCategory__c,
  	               oli.Product2Name__c,
  	               oli.QuantityUnit__c,
  	               oli.BrRgVolumeDiscount1__c,
  	               oli.BrRgVolumeDiscount2__c,
  	               oli.BrRgVolumeDiscount3__c,
  	               oli.PrintSort__c,
  	               oli.ProposedService__c,
  	               oli.SpecialInstruction__c,
  	               oli.RemarksOption__c,
  	               oli.UsePeriodFrom__c,
  	               oli.UsePeriodTo__c,
  	               oli.UsePeriodText__c,
  	               o.UseStartDate__c,
  	               o.UseEndDate__c
  	          FROM OpportunityLineItem oli,
  	               OpportunityLineItem.Opportunity o
  	         WHERE oli.OpportunityId = :opportunityId
  	         ORDER BY Service__c, hirePlanCategory__c DESC];
  }
  
  public List<Contract_Application_Product__c> getContractApplicationProductByInfoId(ID infoId) {
  	if (String.isBlank(infoId)) {
  		return new List<Contract_Application_Product__c>();
  	}
  	
  	return [SELECT ID,
  	               Name,
  	               BrTtMinimumFee__c,
  	               BrTtSuccessFeeRatio__c,
  	               BrTtSuccessFee__c,
  	               BrRgMinimumFee__c,
  	               BrRgSuccessFeeRatio__c,
  	               BrRgVolumeDiscount1__c,
  	               BrRgVolumeDiscount2__c,
  	               BrRgVolumeDiscount3__c,
  	               BrRgSuccessFee__c,
  	               CtMinimumFee__c,
  	               CtSuccessFeeRatio__c,
  	               CtSuccessFee__c,
  	               IrregularPlan__c,
  	               DisplayNameForClient__c,
  	               BillName__c,
  	               Service__c,
  	               UpfrontFee__c,
  	               NrMinimumFee__c,
  	               NrSuccessFeeRatio__c,
  	               NrSuccessFee__c,
  	               PlatinumScoutNumberOfFirstMonth__c,
  	               PlatinumScoutNumber__c,
  	               PlatinumScoutNumberContinuation__c,
  	               PlatinumScoutNumberInTotal__c,
  	               PlatinumScoutType__c,
  	               ListPrice__c,
  	               Discount__c,
  	               ContractPeriod__c,
  	               MonthlyPrice1__c,
  	               MonthlyPrice2__c,
  	               MonthlyPrice3__c,
  	               MonthlyPrice4__c,
  	               MonthlyPrice5__c,
  	               MonthlyPrice6__c,
  	               MonthlyPrice7__c,
  	               MonthlyPrice8__c,
  	               MonthlyPrice9__c,
  	               MonthlyPrice10__c,
  	               MonthlyPrice11__c,
  	               MonthlyPrice12__c,
  	               TotalPrice__c,
  	               HirePlanCategory__c,
  	               ProductCode__c,
  	               Family__c,
  	               Description__c,
  	               Subtotal__c,
  	               Quantity__c,
  	               QuantityUnit__c,
  	               ProposedService__c,
  	               ServiceDate__c,
  	               SpecialInstruction__c,
  	               UnitPrice__c,
  	               Remarks__c,
  	               RemarksOption__c,
  	               UsePeriodFrom__c,
  	               UsePeriodTo__c,
  	               UsePeriodText__c
  	          FROM Contract_Application_Product__c
  	         WHERE IsActive__c = True
  	           AND Contract_Application_Information__c = :infoId
  	         ORDER BY Service__c, hirePlanCategory__c ASC];
  }

  public List<Contract_Application_Product__c> getContractApplicationProductWithInfoByInfoId(ID infoId) {
  	if (String.isBlank(infoId)) {
  		return new List<Contract_Application_Product__c>();
  	}
  	
  	return [SELECT p.ID,
  	               p.Name,
  	               p.BrTtMinimumFee__c,
  	               p.BrTtSuccessFeeRatio__c,
  	               p.BrTtSuccessFee__c,
  	               p.BrRgMinimumFee__c,
  	               p.BrRgSuccessFeeRatio__c,
  	               p.BrRgVolumeDiscount1__c,
  	               p.BrRgVolumeDiscount2__c,
  	               p.BrRgVolumeDiscount3__c,
  	               p.BrRgSuccessFee__c,
  	               p.CtMinimumFee__c,
  	               p.CtSuccessFeeRatio__c,
  	               p.CtSuccessFee__c,
  	               p.IrregularPlan__c,
  	               p.DisplayNameForClient__c,
  	               p.BillName__c,
  	               p.Service__c,
  	               p.UpfrontFee__c,
  	               p.NrMinimumFee__c,
  	               p.NrSuccessFeeRatio__c,
  	               p.NrSuccessFee__c,
  	               p.PlatinumScoutNumberOfFirstMonth__c,
  	               p.PlatinumScoutNumber__c,
  	               p.PlatinumScoutNumberContinuation__c,
  	               p.PlatinumScoutNumberInTotal__c,
  	               p.PlatinumScoutType__c,
  	               p.ListPrice__c,
  	               p.Discount__c,
  	               p.ContractPeriod__c,
  	               p.MonthlyPrice1__c,
  	               p.MonthlyPrice2__c,
  	               p.MonthlyPrice3__c,
  	               p.MonthlyPrice4__c,
  	               p.MonthlyPrice5__c,
  	               p.MonthlyPrice6__c,
  	               p.MonthlyPrice7__c,
  	               p.MonthlyPrice8__c,
  	               p.MonthlyPrice9__c,
  	               p.MonthlyPrice10__c,
  	               p.MonthlyPrice11__c,
  	               p.MonthlyPrice12__c,
  	               p.TotalPrice__c,
  	               p.HirePlanCategory__c,
  	               p.ProductCode__c,
  	               p.Family__c,
  	               p.Description__c,
  	               p.Subtotal__c,
  	               p.Quantity__c,
  	               p.QuantityUnit__c,
  	               p.ProposedService__c,
  	               p.ServiceDate__c,
  	               p.SpecialInstruction__c,
  	               p.UnitPrice__c,
  	               p.Remarks__c,
  	               p.RemarksOption__c,
  	               p.UsePeriodFrom__c,
  	               p.UsePeriodTo__c,
  	               p.UsePeriodText__c,
  	               i.Id,
  	               o.Id,
  	               a.Id,
  	               a.Name,
                   ow.Name,
                   ow.UserRole.Name
  	          FROM Contract_Application_Product__c p,
  	               Contract_Application_Product__c.Contract_Application_Information__r i,
  	               Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r o,
  	               Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.Owner ow,
  	               Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.Account a
  	         WHERE IsActive__c = True
  	           AND Contract_Application_Information__c = :infoId
  	         ORDER BY Service__c, hirePlanCategory__c ASC];
  }

	/**
	 * ProductDtoをContract_Application_Product__cに変換する。
	 * 変換したContract_Application_Product__cはサービスごとに格納する。
	 */
  public Map<String, List<Contract_Application_Product__c>> convertFromDtoToProductMap(List<ProductDto> dtoList) {
  	Map<String, List<Contract_Application_Product__c>> productMap = new Map<String, List<Contract_Application_Product__c>>();
  	
  	for (ProductDto dto: dtoList) {
  		Contract_Application_Product__c product = convertFromDtoToContractApplicationProduct(dto);
  		String serviceName = '';
  		if (product.Service__c.contains(System.Label.ServiceBiz)) {
  			serviceName = System.Label.ServiceBiz;
  		} else if (product.Service__c.contains(System.Label.ServiceCt)) {
  			serviceName = System.Label.ServiceCt;
  		} else if (product.Service__c.contains(System.Label.ServiceNk)) {
  			serviceName = System.Label.ServiceNk;
  		} else {
  			continue;
  		}
  		if (!productMap.containsKey(serviceName)) {
  			productMap.put(serviceName, new List<Contract_Application_Product__c>());
  		}
  		productMap.get(serviceName).add(product);
  	}
  	return productMap;
  }
  
  public Contract_Application_Product__c convertFromDtoToContractApplicationProduct(ProductDto dto) {
  	Contract_Application_Product__c product = new Contract_Application_Product__c();
  	product.Name = dto.opportunityLineItemName != '' ? dto.opportunityLineItemName : dto.contractApplicationProductName;
  	product.Service__c = dto.serviceName;
  	product.ProductCode__c = dto.ProductCode;
  	product.ProposedService__c = dto.serviceType;
  	product.DisplayNameForClient__c = dto.displayName;
  	product.BillName__c = dto.billName;
  	product.HirePlanCategory__c = dto.hirePlanCategory;
  	product.Quantity__c = dto.quantity;
  	product.UsePeriodFrom__c = dto.useStartDate;
  	product.UsePeriodTo__c = dto.useEndDate;
  	product.UpfrontFee__c = dto.InitialPrice;
  	product.MonthlyPrice1__c = dto.MonthlyPrice1;
  	product.MonthlyPrice2__c = dto.MonthlyPrice2;
  	product.MonthlyPrice3__c = dto.MonthlyPrice3;
  	product.MonthlyPrice4__c = dto.MonthlyPrice4;
  	product.MonthlyPrice5__c = dto.MonthlyPrice5;
  	product.MonthlyPrice6__c = dto.MonthlyPrice6;
  	product.MonthlyPrice7__c = dto.MonthlyPrice7;
  	product.MonthlyPrice8__c = dto.MonthlyPrice8;
  	product.MonthlyPrice9__c = dto.MonthlyPrice9;
  	product.MonthlyPrice10__c = dto.MonthlyPrice10;
  	product.MonthlyPrice11__c = dto.MonthlyPrice11;
  	product.MonthlyPrice12__c = dto.MonthlyPrice12;
  	product.ContractPeriod__c = dto.periodOfUse;
  	product.PlatinumScoutType__c = dto.PlatinumScoutTypeName;
  	product.PlatinumScoutNumber__c = dto.PlatinumScoutCount;
  	product.PlatinumScoutNumberOfFirstMonth__c = dto.PlatinumScoutInitialCount;
  	product.PlatinumScoutNumberContinuation__c = dto.PlatinumScoutContinuationCount;
  	// 成約報酬データの初期化
		product.BrRgSuccessFee__c = null;
		product.BrRgSuccessFeeRatio__c = null;
		product.BrRgVolumeDiscount1__c = null;
		product.BrRgVolumeDiscount2__c = null;
		product.BrRgVolumeDiscount3__c = null;
		product.BrRgMinimumFee__c = null;
		product.BrTtSuccessFee__c = null;
		product.BrTtSuccessFeeRatio__c = null;
		product.BrTtMinimumFee__c = null;
		product.CtSuccessFee__c = null;
		product.CtSuccessFeeRatio__c = null;
		product.CtMinimumFee__c = null;
		product.NrSuccessFee__c = null;
		product.NrSuccessFeeRatio__c = null;
		product.NrMinimumFee__c = null;

  	for (ReplaceFeeDto fee: dto.replaceFeeList) {
  		if (dto.serviceName.contains(System.Label.ServiceBiz) && fee.labelName == System.Label.BrCandidateClassRG) {
  			product.BrRgSuccessFee__c = fee.replaceFee;
  			product.BrRgSuccessFeeRatio__c = fee.replaceFeeRate;
  			product.BrRgVolumeDiscount1__c = fee.volumeDiscount1;
  			product.BrRgVolumeDiscount2__c = fee.volumeDiscount2;
  			product.BrRgVolumeDiscount3__c = fee.volumeDiscount3;
  			product.BrRgMinimumFee__c = fee.minimumFee;
  		}
  		if (dto.serviceName.contains(System.Label.ServiceBiz) && fee.labelName == System.Label.BrCandidateClassTt) {
  			product.BrTtSuccessFee__c = fee.replaceFee;
  			product.BrTtSuccessFeeRatio__c = fee.replaceFeeRate;
  			product.BrTtMinimumFee__c = fee.minimumFee;
  		}
  		if (dto.serviceName.contains(System.Label.ServiceCt)) {
  			product.CtSuccessFee__c = fee.replaceFee;
  			product.CtSuccessFeeRatio__c = fee.replaceFeeRate;
  			product.CtMinimumFee__c = fee.minimumFee;
  		}
  		if (dto.serviceName.contains(System.Label.ServiceNk)) {
  			product.NrSuccessFee__c = fee.replaceFee;
  			product.NrSuccessFeeRatio__c = fee.replaceFeeRate;
  			product.NrMinimumFee__c = fee.minimumFee;
  		}
  	}
  	product.isActive__c = True;

  	return product;
  }
  
  public void switchProductActiveStatusByInfoId(ID infoId) {
  	if (String.isBlank(infoId)) {
  		return;
  	}

  	List<Contract_Application_Product__c> productList = [SELECT Id
  	                                                       FROM Contract_Application_Product__c
  	                                                      WHERE Contract_Application_Information__c = :infoId];
  	                                                      
 		if (!productList.isEmpty()) {
 			for (Contract_Application_Product__c product: productList) {
 				product.IsActive__c = false;
 			}
 			update productList;
 		}
  }

}