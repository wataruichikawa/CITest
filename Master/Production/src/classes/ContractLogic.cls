/**
 * 契約内容に関連するロジック群です。
 */
public with sharing class ContractLogic {
	// 定数
	private static final String APPROVAL_STATUS_APL = '承認済';
	
  /**
   * 指定日時より後に更新された契約内容と契約内容明細とそれに関連する商品マスタ、商談、取引先を取得する。
   * @Return JSONデータ
   */
  // TODO 検索条件用のJSONを渡せるようにする。
  public String searchContract(String serviceType) {
		String serviceName = '';
		if (serviceType == System.Label.ServiceBizEN) {
			serviceName = System.Label.ServiceBiz;
		} else if (serviceType == System.Label.ServiceCtEN) {
			serviceName = System.Label.ServiceCt;
		} else if (serviceType == System.Label.ServiceNkEN) {
			serviceName = System.Label.ServiceNk;
		} else {
			return '';
		}

    List<Contract_Application_Product__c> productList = [SELECT i.Id,
                                                                o.Id,
                                                                a.Id,
                                                                o.ContractApplicationNo__c,
                                                                i.Version_No__c,
                                                                o.ProposedService__c,
                                                                o.Type,
                                                                o.ContractCollectionDate__c,
                                                                o.UseStartDate__c,
                                                                o.UseEndDate__c,
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
                                                                o.ContactEmail__c,
                                                                o.AdminContractApplicationMemo__c,
                                                                o.AgencyFlg__c,
                                                                o.AppoChannel__c,
                                                                o.AppoAcquisitionDate__c,
                                                                o.AppoAcquisitionUserName__c,
                                                                o.apo_team__c,
                                                                o.apo_chanel__c,
                                                                o.inbound__c,
                                                                o.VisitDate__c,
                                                                a.Field221__c,
                                                                a.CompanySize__c,
                                                                o.CompanyProfile__c,
                                                                a.Website,
                                                                a.Field38__c,
                                                                a.Field7__c,
                                                                a.Field195__c,
                                                                ow.Name,
                                                                ow.Email,
                                                                o.OwnerRoleDepartment__c,
                                                                o.OwnerRoleTerritory__c,
                                                                o.Br_Contract_PDF_ID__c,
                                                                o.Br_Rs_Contract_PDF_ID__c,
                                                                o.Ct_Contract_PDF_ID__c,
                                                                o.Ct_Rs_Contract_PDF_ID__c,
                                                                o.Nr_Contract_PDF_ID__c,
                                                                o.Attach_PDF_ID__c,
                                                                i.Name,
                                                                i.Service_Name__c,
                                                                i.Contract_Transfer_Memo__c,
                                                                i.Del_Flg__c,
                                                                i.Parent_Contract_Application_No__c,
                                                                i.Fetch_Date_In_Service__c,
                                                                i.Billing_Company_Name__c,
                                                                i.Billing_Building_Name__c,
                                                                i.Billing_Prefecture_Name__c,
                                                                i.Billing_Address__c,
                                                                i.Billing_Contact_Name__c,
                                                                i.Billing_Phone_Number__c,
                                                                i.Billing_Contact_Department__c,
                                                                i.Billing_Contact_Position__c,
                                                                i.Billing_Zip_Code__c,
                                                                i.Contract_PDF_S3_Path__c,
                                                                i.Contract_Rs_PDF_S3_Path__c,
                                                                i.Attached_PDF1_S3_Path__c,
                                                                i.Attached_PDF2_S3_Path__c,
                                                                i.Attached_PDF3_S3_Path__c,
                                                                hsau.Name,
                                                                hsau.Email,
                                                                iow.Name,
                                                                iow.Email,
                                                                aau.Email,
                                                                i.LastModifiedDate,
                                                                o.LastModifiedDate,
                                                                a.LastModifiedDate,
                                                                ow.LastModifiedDate,
                                                                p.Name,
                                                                p.Service__c,
                                                                p.ProposedService__c,
                                                                p.DisplayNameForClient__c,
                                                                p.BillName__c,
                                                                p.Quantity__c,
                                                                p.UpfrontFee__c,
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
                                                                p.hirePlanCategory__c,
                                                                p.PlatinumScoutNumberOfFirstMonth__c,
                                                                p.PlatinumScoutNumber__c,
                                                                p.PlatinumScoutNumberInTotal__c,
                                                                p.PlatinumScoutNumberContinuation__c,
                                                                p.PlatinumScoutType__c,
                                                                p.BrRgSuccessFee__c,
                                                                p.BrRgSuccessFeeRatio__c,
                                                                p.BrRgVolumeDiscount1__c,
                                                                p.BrRgVolumeDiscount2__c,
                                                                p.BrRgVolumeDiscount3__c,
                                                                p.BrRgMinimumFee__c,
                                                                p.BrTtSuccessFee__c,
                                                                p.BrTtSuccessFeeRatio__c,
                                                                p.BrTtMinimumFee__c,
                                                                p.CtSuccessFee__c,
                                                                p.CtSuccessFeeRatio__c,
                                                                p.CtMinimumFee__c,
                                                                p.NrSuccessFee__c,
                                                                p.NrSuccessFeeRatio__c,
                                                                p.NrMinimumFee__c,
                                                                p.UsePeriodFrom__c,
                                                                p.UsePeriodTo__c,
                                                                p.ProductCode__c
                                                           FROM Contract_Application_Product__c p,
                                                                Contract_Application_Product__c.Contract_Application_Information__r i,
                                                                Contract_Application_Product__c.Contract_Application_Information__r.Hassei_Sales_Approval_User__r hsau,
                                                                Contract_Application_Product__c.Contract_Application_Information__r.Last_Edit_User__r iow,
                                                                Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r o,
                                                                Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.Account a,
                                                                Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.Owner ow,
                                                                Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.AppoAcquisitionUser__r aau
                                                          WHERE i.Approval_Status__c = :APPROVAL_STATUS_APL
                                                            AND p.IsActive__c = true
                                                            AND i.Service_Name__c = :serviceName
                                                            AND i.Fetch_Date_In_Service__c = null
                                                          ORDER BY i.Parent_Contract_Application_No__c ASC NULLS FIRST,
                                                                   o.ContractApplicationNo__c];

    // 取得データの整理
    Map<ID, List<Contract_Application_Product__c>> infoMap = new Map<ID, List<Contract_Application_Product__c>>();
    Set<ID> productIdSet = new Set<ID>();
    for (Contract_Application_Product__c product: productList) {
      if (!infoMap.containsKey(product.Contract_Application_Information__r.Id)) {
        infoMap.put(product.Contract_Application_Information__r.Id, new List<Contract_Application_Product__c>());
      }
      infoMap.get(product.Contract_Application_Information__r.Id).add(product);
    }

    return createJson(infoMap);
  }

  public Opportunity searchOpportunityById(String id) {
		// ID空文字対策
		if (String.isBlank(id)) {
			return null;
		}

		List<Opportunity> opportunityList = [SELECT o.Id,
		                                            a.Id,
		                                            o.ContractApplicationNo__c,
		                                            o.ProposedService__c,
		                                            o.Type,
		                                            o.ContractCollectionDate__c,
		                                            o.UseStartDate__c,
		                                            o.UseEndDate__c,
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
		                                            o.ContactEmail__c,
		                                            o.AdminContractApplicationMemo__c,
		                                            o.AgencyFlg__c,
		                                            o.AppoChannel__c,
		                                            o.AppoAcquisitionDate__c,
		                                            o.AppoAcquisitionUserName__c,
		                                            o.apo_team__c,
		                                            o.apo_chanel__c,
		                                            o.inbound__c,
		                                            o.VisitDate__c,
		                                            a.Field221__c,
		                                            a.CompanySize__c,
		                                            o.CompanyProfile__c,
		                                            a.Website,
		                                            a.Field38__c,
		                                            a.Field7__c,
		                                            a.Field195__c,
		                                            ow.Name,
		                                            ow.Email,
		                                            o.OwnerRoleDepartment__c,
		                                            o.OwnerRoleTerritory__c,
		                                            o.Br_Contract_PDF_Id__c,
		                                            o.Br_Rs_Contract_PDF_Id__c,
		                                            o.Ct_Contract_PDF_Id__c,
		                                            o.Ct_Rs_Contract_PDF_Id__c,
		                                            o.Nr_Contract_PDF_Id__c,
		                                            o.Attach_PDF_Id__c,
		                                            o.ApplicationApprovalStatus__c,
		                                            o.shinkisyoudanflag__c,
		                                            aau.Email,
		                                            o.LastModifiedDate,
		                                            a.LastModifiedDate,
		                                            ow.LastModifiedDate,
		                                            o.BOSTeianService__c
		                                       FROM Opportunity o,
                                                Opportunity.Account a,
                                                Opportunity.Owner ow,
                                                Opportunity.AppoAcquisitionUser__r aau
                                          WHERE o.ID = :id];

    // IDが不正対策
		return opportunityList.isEmpty() ? null : opportunityList.get(0);
  }
  
  /**
   * 請求先の元となる情報を取引先、商談から取得します。
   * 取引先IDは必須です。商談IDが入力されていない場合は、一番新しい商談から関連する情報を取得します。
   */
  public Opportunity getBillingSource(ID accountId, ID opportunityId) {
  	if (String.isBlank(accountId)) {
  		return null;
  	}

		if (String.isBlank(opportunityId)) {
			return getBillingSource(accountId);
		} else {
			return [SELECT o.Id,
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
								 AND o.Id = :opportunityId
							 ORDER BY o.Id desc];
		}
  }

  public Opportunity getBillingSource(ID accountId) {
		List<Opportunity> opportunityList = [SELECT o.Id,
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
		                                      WHERE a.Id = :accountId];
  	if (opportunityList.isEmpty()) {
  		return null;
  	}
		return opportunityList.get(0);
  }
  
  /**
   * 契約が代理店契約かどうかを返却します。
   */
  public Boolean isAgencyContract(ID opportunityId) {
  	if (opportunityId == null) {
  		return false;
  	}
  	
  	return [SELECT AgencyFlg__c FROM Opportunity WHERE ID = :opportunityId].AgencyFlg__c;
  }

  public void updateFetchedContract(String serviceType, List<String> applicationNoList) {
		String serviceName = '';
		if (serviceType == System.Label.ServiceBizEN) {
			serviceName = System.Label.ServiceBiz;
		} else if (serviceType == System.Label.ServiceCtEN) {
			serviceName = System.Label.ServiceCt;
		} else if (serviceType == System.Label.ServiceNkEN) {
			serviceName = System.Label.ServiceNk;
		} else {
			return ;
		}

    Contract_Application_Information__c[] infoList = searchContractInfoByContractApplicationNo(serviceName, applicationNoList);
    if (infoList != null) {
      for(Contract_Application_Information__c info: infoList) {
        info.Fetch_Date_In_Service__c = datetime.now();
        info.Version_No__c = info.Version_No__c + 1;
      }
      update infoList;
    }
  }

  public Contract_Application_Information__c[] searchContractInfoByContractApplicationNo(String serviceName, List<String> applicationNoList) {
    if (String.isBlank(serviceName) || applicationNoList == null || applicationNoList.size() == 0) {
      return null;
    }

    return [SELECT i.Id,
                   i.Version_No__c
              FROM Contract_Application_Information__c i,
                   Contract_Application_Information__c.Opportunity__r o
             WHERE i.Service_Name__c = :serviceName
               AND o.ContractApplicationNo__c in :applicationNoList];
  }
  
  public Contract_Application_Information__c searchContractInfoById(String infoId) {
    if (String.isBlank(infoId)) {
      return null;
    }

		List<Contract_Application_Information__c> infoList = [SELECT Opportunity__c,
		                                                             Contract_Application_Memo__c,
		                                                             Contract_Transfer_Memo__c,
		                                                             Parent_Contract_Application_No__c,
		                                                             Del_Flg__c,
		                                                             Service_Name__c,
		                                                             Billing_Company_Name__c,
		                                                             Billing_Building_Name__c,
		                                                             Billing_Prefecture_Name__c,
		                                                             Billing_Address__c,
		                                                             Billing_Contact_Name__c,
		                                                             Billing_Phone_Number__c,
		                                                             Billing_Contact_Department__c,
		                                                             Billing_Contact_Position__c,
		                                                             Billing_Zip_Code__c
		                                                        FROM Contract_Application_Information__c
		                                                       WHERE Id = :infoId];

		// 不正ID対策
		return infoList.isEmpty() ? null : infoList.get(0);
  }
  
  public List<Attachment> getAttachmentList(Opportunity opp, String serviceName) {
		List<String> attachIdList = new List<String>();
		if (String.isBlank(serviceName)) {
			attachIdList.add(opp.Br_Contract_PDF_ID__c);
			attachIdList.add(opp.Br_Rs_Contract_PDF_ID__c);
			attachIdList.add(opp.Ct_Contract_PDF_ID__c);
			attachIdList.add(opp.Ct_Rs_Contract_PDF_ID__c);
			attachIdList.add(opp.Nr_Contract_PDF_ID__c);
		} else if (serviceName == System.Label.ServiceBiz) {
			attachIdList.add(opp.Br_Contract_PDF_ID__c);
			attachIdList.add(opp.Br_Rs_Contract_PDF_ID__c);
		} else if (serviceName == System.Label.ServiceCt) {
			attachIdList.add(opp.Ct_Contract_PDF_ID__c);
			attachIdList.add(opp.Ct_Rs_Contract_PDF_ID__c);
		} else if (serviceName == System.Label.ServiceNk) {
			attachIdList.add(opp.Nr_Contract_PDF_ID__c);
		}

		if (String.isNotBlank(opp.Attach_PDF_ID__c)) {
			attachIdList.addAll(opp.Attach_PDF_ID__c.split(','));
		}
		
		if (attachIdList.isEmpty()) {
			return new List<Attachment>();
		}
		
		return [SELECT Id,
									 Name,
									 Body
						 FROM Attachment
						WHERE Id in :attachIdList];
  }

	/**
	 * 1商談の契約が1サービスに複数設定されないか確認する。
	 */
	public void duplicateCheckContractAppInfo(List<Contract_Application_Information__c> triggerData) {
		System.Debug('### Debug triggerData -> ' + triggerData + ', size = ' + triggerData.size());
		Set<ID> opportunityIdSet = new Set<ID>();
		for (Contract_Application_Information__c info: triggerData) {
			opportunityIdSet.add(info.Opportunity__c);
		}
		if (opportunityIdSet.isEmpty()) {
			return;
		}
		System.Debug('### Debug opportunityIdSet -> ' + opportunityIdSet);

		Contract_Application_Information__c[] infoList = [SELECT o.ID,
																														 i.ID,
																														 i.Service_Name__c
																												FROM Contract_Application_Information__c i,
																														 Contract_Application_Information__c.Opportunity__r o
																											 WHERE o.ID in :opportunityIdSet
																												 AND i.Del_Flg__c = false];
		
		if (infoList.isEmpty()) {
			return;
		}

		Map<ID, Set<String>> infoMap = new Map<ID, Set<String>>();
		for (Contract_Application_Information__c info: infoList) {
			if (!infoMap.containsKey(info.Opportunity__r.Id)) {
				infoMap.put(info.Opportunity__r.Id, new Set<String>());
			}
			infoMap.get(info.Opportunity__r.Id).add(info.Service_Name__c);
		}

		for (Contract_Application_Information__c info: triggerData) {
			if (infoMap.containsKey(info.Opportunity__c) && infoMap.get(info.Opportunity__c).contains(info.Service_Name__c)) {
				System.Debug('### Debug infoMap -> ' + infoMap.get(info.Opportunity__c));
				info.addError('この商談には' + info.Service_Name__c + 'の契約が既に登録されています。');
			}
		}
	}
	
	/**
	 * 商談のデータ更新に伴い、契約内容の更新を行う。
	 */
	public void updateContractAppInfoApprovalStatus(Map<ID, Opportunity> oldMap, Map<ID, Opportunity> newMap) {
		Map<ID, DiffDay> diffDayMap = new Map<ID, DiffDay>();
		Set<ID> updatedPdfIdSet = new Set<ID>();

		for (ID opportunityId: newMap.keySet()) {
			Opportunity oldOpportunity = oldMap.get(opportunityId);
			Opportunity newOpportunity = newMap.get(opportunityId);
			
			//開始日、もしくは終了日が変更された場合
			if (oldOpportunity.useStartDate__c != null && newOpportunity.useStartDate__c != null && 
					oldOpportunity.useEndDate__c != null && newOpportunity.useEndDate__c != null &&
					((!oldOpportunity.useStartDate__c.isSameDay(newOpportunity.useStartDate__c)) || 
					(!oldOpportunity.useEndDate__c.isSameDay(newOpportunity.useEndDate__c)))) {
				DiffDay dd = new DiffDay();
				dd.startDiff = oldOpportunity.useStartDate__c.daysBetween(newOpportunity.useStartDate__c);
				dd.startDate = newOpportunity.useStartDate__c;
				dd.endDiff = oldOpportunity.useEndDate__c.daysBetween(newOpportunity.useEndDate__c);
				dd.endDate = newOpportunity.useEndDate__c;
				diffDayMap.put(opportunityId, dd);
			}
			
			// 契約申込PDF、または添付PDFが変更された場合　
			Boolean isBrContractPdfUpdate = oldOpportunity.Br_Contract_PDF_ID__c != null && newOpportunity.Br_Contract_PDF_ID__c != null &&
																			oldOpportunity.Br_Contract_PDF_ID__c != newOpportunity.Br_Contract_PDF_ID__c;

			Boolean isBrRsContractPdfUpdate = oldOpportunity.Br_Rs_Contract_PDF_ID__c != null && newOpportunity.Br_Rs_Contract_PDF_ID__c != null &&
																				oldOpportunity.Br_Rs_Contract_PDF_ID__c != newOpportunity.Br_Rs_Contract_PDF_ID__c;
																				
			Boolean isCtContractPdfUpdate = oldOpportunity.Ct_Contract_PDF_ID__c != null && newOpportunity.Ct_Contract_PDF_ID__c != null &&
																				oldOpportunity.Ct_Contract_PDF_ID__c != newOpportunity.Ct_Contract_PDF_ID__c;
																				
			Boolean isCtRsContractPdfUpdate = oldOpportunity.Ct_Rs_Contract_PDF_ID__c != null && newOpportunity.Ct_Rs_Contract_PDF_ID__c != null &&
																				oldOpportunity.Ct_Rs_Contract_PDF_ID__c != newOpportunity.Ct_Rs_Contract_PDF_ID__c;
																				
			Boolean isNrContractPdfUpdate = oldOpportunity.Nr_Contract_PDF_ID__c != null && newOpportunity.Nr_Contract_PDF_ID__c != null &&
																			oldOpportunity.Nr_Contract_PDF_ID__c != newOpportunity.Nr_Contract_PDF_ID__c;
																			
			Boolean isAttachPdfUpdate = oldOpportunity.Attach_PDF_ID__c != null && newOpportunity.Attach_PDF_ID__c != null &&
																	oldOpportunity.Attach_PDF_ID__c != newOpportunity.Attach_PDF_ID__c;

			if (isBrContractPdfUpdate || isBrRsContractPdfUpdate || isCtContractPdfUpdate || isCtRsContractPdfUpdate ||
					isNrContractPdfUpdate || isAttachPdfUpdate) {
					updatedPdfIdSet.add(opportunityId);
			}
		}

		if (diffDayMap.isEmpty() && updatedPdfIdSet.isEmpty()) {
			return;
		}
		
		Set<ID> targetIdSet = new Set<ID>();
		targetIdSet.addAll(diffDayMap.keySet());
		targetIdSet.addAll(updatedPdfIdSet);

		// 契約内容の確認。
		Contract_Application_Information__c[] infoList = [SELECT i.ID,
																														 i.Approval_Status__c,
																														 o.Id
																												FROM Contract_Application_Information__c i,
																														 Contract_Application_Information__c.Opportunity__r o
																											 WHERE o.Id in :targetIdSet];
		
		Map<ID, Contract_Application_Information__c> newInfoMap = new Map<ID, Contract_Application_Information__c>();
		
		if (infoList != null && !infoList.isEmpty()) {
			for (Contract_Application_Information__c i: infoList) {
				if (i.Approval_Status__c == '承認済' || i.Approval_Status__c == '不承認') {
					i.Approval_Status__c = '再申請待ち';
					if (!newInfoMap.containsKey(i.Id)) {
						newInfoMap.put(i.Id, i);
					}
				}
			}
		}

		if (!newInfoMap.isEmpty()) {
			update newInfoMap.values();
		}
			
	}

  private String createJson(Map<ID, List<Contract_Application_Product__c>> contractMap) {
    ContractInfoJsonObject outputJson = new ContractInfoJsonObject();

    for (ID contractId: contractMap.keySet()) {
      ContractInformation info = new ContractInformation();
      Contract_Application_Information__c contractInfo = contractMap.get(contractId)[0].Contract_Application_Information__r;
      Opportunity opportunity = contractInfo.Opportunity__r;
      Account account = opportunity.Account;
      info.sfId = String.valueOf(account.Id);
      info.contractApplicationNo = opportunity.ContractApplicationNo__c;
      info.contractApplicationVersionNo = contractInfo.Version_No__c;
      info.parentContractApplicationNo = contractInfo.Parent_Contract_Application_No__c;
      info.proposedService = opportunity.ProposedService__c;
      info.contractApplicationType = opportunity.Type;
      info.collectionDate = opportunity.ContractCollectionDate__c;
      info.startDate = opportunity.UseStartDate__c;
      info.endDate = opportunity.UseEndDate__c;
      info.memo = opportunity.AdminContractApplicationMemo__c;
      info.agencyFlg = opportunity.AgencyFlg__c;
      info.appoChannel = opportunity.AppoChannel__c;
      info.appoAcquisitionDate = opportunity.AppoAcquisitionDate__c;
      info.appoAcquisitionUser = opportunity.AppoAcquisitionUserName__c;
      info.appoAcquisitionEmail = opportunity.AppoAcquisitionUser__r.Email;
      info.appoTeam = opportunity.apo_team__c;
      info.appoType = opportunity.apo_chanel__c;
      info.inboundFlg = opportunity.inbound__c;
      if (opportunity.VisitDate__c != null) {
        info.visitDate = opportunity.VisitDate__c.Date();
      }
      info.industryCd = account.Field221__c;
      info.companySize = account.CompanySize__c != null ? account.CompanySize__c : System.Label.UNOPEN_COMPANY_SIZE;
      info.companyProfile = opportunity.CompanyProfile__c;
      info.webUrl = account.Website;
      info.establishmentDate = account.Field38__c;
      info.capital = account.Field7__c;
      info.representative = account.Field195__c;
      info.ownerName = opportunity.owner.Name;
      info.ownerEmail = opportunity.owner.Email;
      info.ownerRoleDepartment = opportunity.OwnerRoleDepartment__c;
      info.ownerRoleTerritory = opportunity.OwnerRoleTerritory__c;
      info.lastUpdateOperatorName= contractInfo.Last_Edit_User__r.Name;
      info.lastUpdateOperatorEmail= contractInfo.Last_Edit_User__r.Email;
      info.approvalOperatorName= contractInfo.Hassei_Sales_Approval_User__r.Name;
      info.approvalOperatorEmail= contractInfo.Hassei_Sales_Approval_User__r.Email;
      info.contractTransferMemo = contractInfo.Contract_Transfer_Memo__c;

			info.contractPdfPath = contractInfo.Contract_PDF_S3_Path__c;
			info.contractBosPdfPath = contractInfo.Contract_Rs_PDF_S3_Path__c;
			info.attachedPdfPathList = new List<String>();
			if (contractInfo.Attached_PDF1_S3_Path__c != null) {
				info.attachedPdfPathList.add(contractInfo.Attached_PDF1_S3_Path__c);
			}
			if (contractInfo.Attached_PDF2_S3_Path__c != null) {
				info.attachedPdfPathList.add(contractInfo.Attached_PDF2_S3_Path__c);
			}
			if (contractInfo.Attached_PDF3_S3_Path__c != null) {
				info.attachedPdfPathList.add(contractInfo.Attached_PDF3_S3_Path__c);
			}
      info.delFlg = contractInfo.Del_Flg__c;
      info.contractName = contractInfo.Name;
      info.lastModifiedDate = contractInfo.LastModifiedDate;
      
      Company company = new Company();
      company.companyName = account.Name;
      company.zipCode = account.billingPostalCode;
      company.prefectureCd = account.billingState;
      company.address1 = account.billingCity;
      company.address2 = account.billingStreet;
      company.phoneNumber = account.Phone;
      company.faxNumber = account.Fax;
      company.contactDepartment = opportunity.ContactDepartment__c;
      company.contactPosition = opportunity.ContactTitle__c;
      company.contactName = opportunity.ContactName__c;
      company.contactNameKana = opportunity.ContactNameKana__c;
      company.contactEmail = opportunity.ContactEmail__c;
      info.company = company;
      
      info.detailList = new List<ContractDetail>();
      Boolean existsStandardContract = false;
      Boolean existsRsContract = false;

      for (Contract_Application_Product__c p: contractMap.get(contractId)) {
        ContractDetail detail = new ContractDetail();
				BillingDetail billingDetail = new BillingDetail();
				billingDetail.companyName = contractInfo.Billing_Company_Name__c;
				billingDetail.zipCode = contractInfo.Billing_Zip_Code__c;
				billingDetail.prefectureCd = contractInfo.Billing_Prefecture_Name__c;
				billingDetail.address1 = contractInfo.Billing_Address__c;
				billingDetail.address2 = contractInfo.Billing_Building_Name__c;
				billingDetail.phoneNumber = contractInfo.Billing_Phone_Number__c;
				billingDetail.contactDepartment = contractInfo.Billing_Contact_Department__c;
				billingDetail.contactPosition = contractInfo.Billing_Contact_Position__c;
				billingDetail.contactName = contractInfo.Billing_Contact_Name__c;
				info.companyBilling = billingDetail;

        detail.name = p.Name;
        detail.quantity = p.Quantity__c;
        detail.startDate = p.UsePeriodFrom__c != null ? p.UsePeriodFrom__c : opportunity.UseStartDate__c;
        detail.endDate = p.UsePeriodTo__c != null ? p.UsePeriodTo__c : opportunity.UseEndDate__c;
        ProductMaster product = new ProductMaster();
        product.name = p.Name;
        product.price = p.UpfrontFee__c;
        product.monthlyPrice = new List<Decimal>();
        if (p.MonthlyPrice1__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice1__c);
        }
        if (p.MonthlyPrice2__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice2__c);
        }
        if (p.MonthlyPrice3__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice3__c);
        }
        if (p.MonthlyPrice4__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice4__c);
        }
        if (p.MonthlyPrice5__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice5__c);
        }
        if (p.MonthlyPrice6__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice6__c);
        }
        if (p.MonthlyPrice7__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice7__c);
        }
        if (p.MonthlyPrice8__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice8__c);
        }
        if (p.MonthlyPrice9__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice9__c);
        }
        if (p.MonthlyPrice10__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice10__c);
        }
        if (p.MonthlyPrice11__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice11__c);
        }
        if (p.MonthlyPrice12__c != null) {
        	product.monthlyPrice.add(p.MonthlyPrice12__c);
        }
        product.serviceName = p.Service__c;
        product.serviceType = p.ProposedService__c;
        if (p.Service__c.contains(System.Label.RS)) {
        	product.ProductType = System.Label.ContractAPIProductNameRS;
        } else if (p.hirePlanCategory__c == System.Label.HirePlanOption) {
        	product.ProductType = System.Label.ContractAPIProductNameOP;
        } else if (p.hirePlanCategory__c == System.Label.HirePlanPlatinumScout) {
        	product.ProductType = System.Label.ContractApiProductNamePS;
        } else {
        	product.ProductType = System.Label.ContractAPIProductNameST;
        }
        product.ProductCode = p.ProductCode__c;
        product.DisplayName = p.DisplayNameForClient__c;
        product.BillName = p.BillName__c;
        product.platinumScoutHolderFirstMonth = p.PlatinumScoutNumberOfFirstMonth__c != null ? p.PlatinumScoutNumberOfFirstMonth__c : p.PlatinumScoutNumberContinuation__c;
        product.platinumScoutHolder = p.PlatinumScoutNumberInTotal__c;
        product.platinumScoutType = p.PlatinumScoutType__c != null ? p.PlatinumScoutType__c : System.Label.PlatinumScoutTypeDefault;
				product.feeMaster = new List<ReplaceFeeMaster>();
        if (p.Service__c.contains(System.Label.ServiceBiz)) {
        	ReplaceFeeMaster fee = new ReplaceFeeMaster();
        	fee.name = p.name;
        	fee.candidateClassType = System.Label.BrCandidateClassRG;
        	fee.minimumGuarantee = p.BrRgMinimumFee__c;
        	if (p.hirePlanCategory__c.contains(System.Label.HirePlanFix) && p.BrRgSuccessFee__c != null) {
        		fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
						fee.amount = p.BrRgSuccessFee__c;
						product.feeMaster.add(fee);
						if (p.Service__c == System.Label.ServiceBiz) {
							existsStandardContract = true;
						}
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSuccess)) {
							if (p.ProposedService__c == System.Label.ServiceTypeESS && p.BrRgVolumeDiscount1__c != null && p.BrRgVolumeDiscount1__c > 0 && 
							    p.BrRgVolumeDiscount2__c != null && p.BrRgVolumeDiscount3__c != null) {
								fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeVD;
								fee.volumeRates = new List<Decimal>();
								fee.volumeRates.add(p.BrRgVolumeDiscount1__c);
								fee.volumeRates.add(p.BrRgVolumeDiscount2__c);
								fee.volumeRates.add(p.BrRgVolumeDiscount3__c);
								product.feeMaster.add(fee);
							} else if (p.BrRgSuccessFeeRatio__c != null){
								fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
								fee.rate = p.BrRgSuccessFeeRatio__c;
								product.feeMaster.add(fee);
							}
							if (p.Service__c == System.Label.ServiceBiz) {
								existsStandardContract = true;
							}
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSpecial)) {
							if (p.ProposedService__c == System.Label.ServiceTypeESS && p.BrRgVolumeDiscount1__c != null && p.BrRgVolumeDiscount1__c > 0) {
								fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeVD;
								fee.volumeRates = new List<Decimal>();
								fee.volumeRates.add(p.BrRgVolumeDiscount1__c);
								fee.volumeRates.add(p.BrRgVolumeDiscount2__c);
								fee.volumeRates.add(p.BrRgVolumeDiscount3__c);
							} else if (p.BrRgSuccessFeeRatio__c != null && p.BrRgSuccessFeeRatio__c > 0){
								fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
								fee.rate = p.BrRgSuccessFeeRatio__c;
							} else {
								// 特別プランで料率が設定されていないということは常に0円の成功報酬を支払っている。
								fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
								fee.amount = p.BrRgSuccessFee__c != null ? p.BrRgSuccessFee__c : 0;
							}
							product.feeMaster.add(fee);
							if (p.Service__c == System.Label.ServiceBiz) {
								existsStandardContract = true;
							}
        	}

					fee = new ReplaceFeeMaster();
        	fee.name = p.name;
        	fee.candidateClassType = System.Label.BrCandidateClassTT;
        	fee.minimumGuarantee = p.BrTtMinimumFee__c;
        	if (p.hirePlanCategory__c.contains(System.Label.HirePlanFix) && p.BrTtSuccessFee__c != null) {
        		fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
						fee.amount = p.BrTtSuccessFee__c;
						product.feeMaster.add(fee);
						if (p.Service__c == System.Label.ServiceBiz) {
							existsStandardContract = true;
						}
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSuccess) && p.BrTtSuccessFeeRatio__c != null) {
							fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
							fee.rate = p.BrTtSuccessFeeRatio__c;
							product.feeMaster.add(fee);
							if (p.Service__c == System.Label.ServiceBiz) {
								existsStandardContract = true;
							}
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSpecial)) {
							if (p.BrTtSuccessFeeRatio__c != null && p.BrTtSuccessFeeRatio__c > 0){
								fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
								fee.rate = p.BrTtSuccessFeeRatio__c;
								product.feeMaster.add(fee);
							} else {
								// 特別プランで料率が設定されていないということは常に0円の成功報酬を支払っている。
								fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
								fee.amount = p.BrTtSuccessFee__c != null ? p.BrTtSuccessFee__c : 0;
								product.feeMaster.add(fee);
							}
							if (p.Service__c == System.Label.ServiceBiz) {
								existsStandardContract = true;
							}
        	}

        	if (p.Service__c.contains(System.Label.RS)) {
        		existsRsContract = true;
        	}
        }
        if (p.Service__c.contains(System.Label.ServiceCt)) {
        	ReplaceFeeMaster fee = new ReplaceFeeMaster();
        	fee.name = p.Name;
        	fee.minimumGuarantee = p.CtMinimumFee__c;
        	if (p.hirePlanCategory__c.contains(System.Label.HirePlanFix)) {
        		fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
						fee.amount = p.CtSuccessFee__c;
						product.feeMaster.add(fee);
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSuccess)) {
							fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
							fee.rate = p.CtSuccessFeeRatio__c;
							product.feeMaster.add(fee);
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSpecial)) {
							if (p.CtSuccessFeeRatio__c != null && p.CtSuccessFeeRatio__c > 0){
								fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
								fee.rate = p.CtSuccessFeeRatio__c;
							} else {
								// 特別プランで料率が設定されていないということは常に0円の成功報酬を支払っている。
								fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
								fee.amount = p.CtSuccessFee__c;
							}
							product.feeMaster.add(fee);
        	}
        }
        if (p.Service__c.contains(System.Label.ServiceNk)) {
        	ReplaceFeeMaster fee = new ReplaceFeeMaster();
        	fee.name = p.Name;
        	fee.minimumGuarantee = p.NrMinimumFee__c;
        	if (p.hirePlanCategory__c.contains(System.Label.HirePlanFix)) {
        		fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
						fee.amount = p.NrSuccessFee__c;
						product.feeMaster.add(fee);
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSuccess)) {
							fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
							fee.rate = p.NrSuccessFeeRatio__c;
							product.feeMaster.add(fee);
        	} else if (p.hirePlanCategory__c.contains(System.Label.HirePlanSpecial)) {
							if (p.NrSuccessFeeRatio__c != null && p.NrSuccessFeeRatio__c > 0){
								fee.replaceFeeType = System.Label.ContractApiReplaceFeeTypeFR;
								fee.rate = p.NrSuccessFeeRatio__c;
							} else {
								// 特別プランで料率が設定されていないということは常に0円の成功報酬を支払っている。
								fee.replaceFeeType = System.Label.ContractAPIReplaceFeeTypeFA;
								fee.amount = p.NrSuccessFee__c;
							}
							product.feeMaster.add(fee);
        	}
        }
        detail.product = product;
        info.detailList.add(detail);
      }

			info.assistContractFlg = !existsStandardContract && existsRsContract;
			if (existsStandardContract && existsRsContract) {
				info.parentContractApplicationNo = opportunity.ContractApplicationNo__c;
			}
      outputJson.add(info);
    }
    String encodeJsonStr = JSON.serializePretty(outputJson);
    System.Debug(encodeJsonStr);
    return encodeJsonStr;
  }

  public class ContractInfoJsonObject {
    public Integer num;
    public List<ContractInformation> results;

    public ContractInfoJsonObject() {
      num = 0;
      results = new List<ContractInformation>();
    }

    public void add(ContractInformation info) {
      results.add(info);
      num = results.size();
    }
  }

  public class ContractInformation {
    public String contractApplicationNo;
    public Decimal contractApplicationVersionNo;
    public String parentContractApplicationNo;
    public String contractName;
    public String contractApplicationType;
    public Boolean delFlg;
    public Date startDate;
    public Date endDate;

    public Company company;
    public BillingDetail companyBilling;
    public List<ContractDetail> detailList;
    public String contractPdfPath;
    public String contractBosPdfPath;
    public List<String> attachedPdfPathList;
    
    public String sfId;
    public String webUrl;
    public String representative;
    public String companySize;
    public String companyProfile;
    public Decimal capital;
    public String industryCd;
    public Date establishmentDate;
    
    public String proposedService;
    public String appoChannel;
    public String appoAcquisitionUser;
    public String appoAcquisitionEmail;
    public Date appoAcquisitionDate;
    public String appoTeam;
    public String appoType;
    public String ownerName;
    public String ownerEmail;
    public String ownerRoleDepartment;
    public String ownerRoleTerritory;
    public Date visitDate;
    public String approvalOperatorName;
    public String approvalOperatorEmail;
    public Datetime lastModifiedDate;
    public String lastUpdateOperatorName;
    public String lastUpdateOperatorEmail;
    public Date collectionDate;
    public String memo;
    public String contractTransferMemo;
    public Boolean inboundFlg;
    public Boolean agencyFlg;
    public Boolean assistContractFlg;
  }

  public abstract class AbstractCompany {
    public String contactPosition;
    public String contactDepartment;
    public String contactName;
    public String contactNameKana;
    public String contactEmail;
    public String companyName;
    public String companyNameKana;
    public String zipCode;
    public String prefectureCd;
    public String address1;
    public String address2;
    public String addressKana;
    public String phoneNumber;
    public String faxNumber;
  }

  public class Company extends AbstractCompany {
  }

  public class BillingDetail extends AbstractCompany {
    public Decimal paymentScheduleMonth;
    public Decimal paymentScheduleDay;
    public Boolean mustSendFlg;
    public Boolean mainFlg;
    public Boolean lastDayFlg;
    public Boolean businessDayFlg;
  }

  public class ContractDetail {
    public String name;
    public Decimal quantity;
    public Date startDate;
    public Date endDate;
    public ProductMaster product;
  }

  public class ProductMaster {
    public String name;
    public String serviceName;
    public String serviceType;
    public String ProductType;
    public String ProductCode;
    public String DisplayName;
    public String BillName;
    public Decimal price;
    public List<Decimal> monthlyPrice;
    public Decimal platinumScoutHolder;
    public Decimal platinumScoutHolderFirstMonth;
    public String platinumScoutType;
    public List<ReplaceFeeMaster> feeMaster;
  }

  public class ReplaceFeeMaster {
    public String name;
    public String replaceFeeType;
    public String candidateClassType;
    public Decimal amount;
    public Decimal rate;
    public List<Decimal> volumeRates;
    public Decimal minimumGuarantee;
  }

	/**
	 * 商談の開始日と終了日が変更したかどうかのチェック時に使用する。
	 */
  private class DiffDay {
    public Integer startDiff;
    public Date startDate;
    public Integer endDiff;
    public Date endDate;
  }

}