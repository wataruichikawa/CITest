/**
 * 契約申込登録・編集・閲覧画面のコントローラです。
 * 閲覧の場合、Extensionの役割をします。
 */
public with sharing class ContractApplicationController {
	// 定数
	private static String DISAPPROVAL_STATUS = '不承認';
	private static String REAPPLY_STATUS = '再申請待ち';
	
  // フィールド
  private ApexPages.StandardController standardController;
  private ContractLogic contractLogic;
  private ProductLogic productLogic;
  private ContractApplicationApprovalRequestLogic approvalRequestLogic;
  private List<Attachment> attachmentList;
  private ApplicationInputFormDto inputFormDto;
  private CompanyAndSalesPersonDto companyAndSalesPersonDto;
  private BillingDto editBillingDto;
  private String opportunityId;
  private String infoId;
	private ContractOperatorMemoDto memoDto;
  private List<SelectOption> selectPlatinumScoutTypeItems;
	private List<SelectOption> selectParentContractIds;
	private String contractApplicationNo;
	
  public List<ProductDto> productDtoList { get; set; } 
	public Boolean isAlive { get; set; }

  public ContractApplicationController() {
  	initialize();
  }
  
  public ContractApplicationController(ApexPages.StandardController controller) {
  	standardController = controller;
  	initialize();
  }
  
  private void initialize() {
    contractLogic = new ContractLogic();
    productLogic = new ProductLogic();
    approvalRequestLogic = new ContractApplicationApprovalRequestLogic();
		memoDto = new ContractOperatorMemoDto();
		attachmentList = new List<Attachment>();
		selectParentContractIds = new List<SelectOption>();
		editBillingDto = new BillingDto();
		productDtoList = new List<ProductDto>();
		selectPlatinumScoutTypeItems = new List<SelectOption>();
		selectPlatinumScoutTypeItems.add(new SelectOption(System.Label.PlatinumScoutTypeDefault, System.Label.PlatinumScoutTypeDefault));
		
		isAlive = true;

		// 呼び出し元によってIDが異なる。
    Map<String, String> parameters = ApexPages.currentPage().getParameters();
    opportunityId = parameters.get('opportunityId');
    infoId = parameters.get('infoId');

    // いずれも取れないときはContract_Application_Information__cの編集・閲覧経由
    if(String.isBlank(opportunityId) && String.isBlank(infoId)) {
    	infoId = parameters.get('Id');
    }
    System.Debug('### Debug opportunityId : ' + opportunityId + ', infoId : ' + infoId);
    
    String serviceName = '';
    if (String.isNotBlank(infoId)) {
    	Contract_Application_Information__c info = contractLogic.searchContractInfoById(infoId);

			// なぜか正しいinfoIdを取れないことがあるのでnullチェックする。
			if (info != null) {
				System.Debug('### Debug infoId : ' + infoId + ', Object -> ' + info);
				opportunityId = info.Opportunity__c;
				memoDto.memo = info.Contract_Application_Memo__c;
				memoDto.transferMemo = info.Contract_Transfer_Memo__c;
				memoDto.ParentContractApplicationNo = info.Parent_Contract_Application_No__c;
				editBillingDto.convertFromInfo(info);
				serviceName = info.Service_Name__c;
				isAlive = !info.Del_Flg__c;
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '契約内容の読み込みに失敗しました。', 'URLに不正なIDが指定されています。'));
				infoId = ''; // 取れなかったら空白にする。(Visualforceでページ遷移を制御するため)
			}
    }
    
		System.Debug('### Debug : opportuntyId -> ' + opportunityId);
    if (String.isNotBlank(opportunityId)) {
      Opportunity opportunity = contractLogic.searchOpportunityById(opportunityId);
      // Contract_Application_InfoのIDが変えられるケースがあるということは商談IDも変更されるおそれがある。
      if (opportunity == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '商談の読み込みに失敗しました。', 'URLに不正なIDが指定されています。'));
				return;
      }

      opportunityId = opportunity.Id;
      contractApplicationNo = opportunity.ContractApplicationNo__c;
      productDtoList = productLogic.initializeProductDtoByOpportunityId(opportunityId, serviceName, opportunity.shinkisyoudanflag__c);

			// 親契約の入力が必要かどうかをチェックする。
      boolean existsRsContractFlg = false;
      boolean existsStandardContractFlg = false;
      boolean isBizreachService = false;
      for (ProductDto dto: productDtoList) {
      	System.Debug('### Debug : ProductType -> ' + dto.ProductType);
      	System.Debug('### Debug : serviceName -> ' + serviceName);
      	if (dto.ProductType == ProductDto.MstProductType.STD) {
      		existsStandardContractFlg = true;
      		if (dto.serviceType == System.Label.ServiceTypeESS) {
						selectPlatinumScoutTypeItems.add(new SelectOption(System.Label.PlatinumScoutTypeTT, System.Label.PlatinumScoutTypeTT));
      		}
      	} else if (dto.ProductType == ProductDto.MstProductType.BOS) {
      		existsRsContractFlg = true;
      	}
      	
      	if (dto.serviceName.contains(System.Label.ServiceBiz)) {
      		isBizreachService = true;
      	}
      }
      System.Debug('### Debug : serviceName(' + serviceName + '), existsRsContractFlg(' + existsRsContractFlg + '), existsStandardContractFlg(' + existsStandardContractFlg + ')');
      if (isBizreachService && existsRsContractFlg && !existsStandardContractFlg) {
      	// 親契約の条件:
      	// 契約終了日が今日より後かつ契約内容がある。
				List<Contract_Application_Information__c> parentContractInfo = [SELECT o.ID,
																											                         o.Name,
																											                         o.ContractApplicationNo__c
																								                          FROM Contract_Application_Information__c i,
																								                               Contract_Application_Information__c.Opportunity__r o,
																											                         Contract_Application_Information__c.Opportunity__r.Account a
																								                         WHERE i.Del_Flg__c = false
																								                           AND a.Id = :opportunity.Account.Id
																									                         AND o.Id <> :opportunity.Id
																									                         AND o.UseEndDate__c >= :Date.today()
																									                       ORDER BY o.useStartDate__c desc];

				for (Contract_Application_Information__c info: parentContractInfo) {
					selectParentContractIds.add(new SelectOption(info.Opportunity__r.ContractApplicationNo__c, info.Opportunity__r.Name));
				}
      }

      System.Debug('### Debug : productDtoList -> ' + productDtoList);
      if (String.isBlank(infoId)) {
				editBillingDto.convertFromOpportunity(opportunity);
				memoDto.memo = opportunity.AdminContractApplicationMemo__c;
      }

      companyAndSalesPersonDto = new CompanyAndSalesPersonDto(opportunity);
      inputFormDto = new ApplicationInputFormDto();
      inputFormDto.convertFromOpportunity(opportunity);
      
      attachmentList = contractLogic.getAttachmentList(opportunity, serviceName);
    }
  }
  
  public CompanyAndSalesPersonDto getCompanyAndSalesPersonDto() {
  	return companyAndSalesPersonDto;
  }

  public BillingDto getEditBillingDto() {
  	return editBillingDto;
  }
  
  public String getInfoId() {
  	return infoId;
  }
  
  public List<attachment> getAttachmentList() {
  	return attachmentList;
  }

  public List<SelectOption> getSelectPlatinumScoutTypeItems() {
    return selectPlatinumScoutTypeItems;
  }

	public ContractOperatorMemoDto getContractOperatorMemoDto() {
		return memoDto;
	}
	
	public List<SelectOption> getSelectParentContractIds() {
		return selectParentContractIds;
	}
	
	public Boolean getIsDisplayParentContract() {
		return !(selectParentContractIds == null || selectParentContractIds.isEmpty());
	}
	
	public Boolean getIsRegister() {
		return companyAndSalesPersonDto != null && inputFormDto != null && 
		       !(companyAndSalesPersonDto.hasError || inputFormDto.hasError);
	}

  public PageReference doRegister() {
    PageReference reRend = null;
    if (validate()) {
    	Savepoint sp = Database.setSavePoint();
			try {
				Map<String, List<Contract_Application_Product__c>> productMap = productLogic.convertFromDtoToProductMap(productDtoList);
				if (productMap.isEmpty()) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '契約登録に失敗しました。', '契約申込商品が存在しません。'));
					System.Debug('### Debug : 契約登録に失敗しました。');
				}
				for (String key: productMap.keySet()) {
					Contract_Application_Information__c info = new Contract_Application_Information__c();
					info.Opportunity__c = opportunityId;
					info.Name = contractApplicationNo + '_1';

					info.Parent_Contract_Application_No__c = memoDto.parentContractApplicationNo;
					info.Contract_Application_Memo__c = memoDto.memo;
					info.Contract_Transfer_Memo__c = memoDto.transferMemo;
					info.Last_Edit_User__c = UserInfo.getUserId();
					info.Billing_Company_Name__c = editBillingDto.companyName;
					info.Billing_Zip_Code__c = editBillingDto.zipCode;
					info.Billing_Prefecture_Name__c = editBillingDto.prefectureName;
					info.Billing_Address__c = editBillingDto.address;
					info.Billing_Building_Name__c = editBillingDto.buildingName;
					info.Billing_Phone_Number__c = editBillingDto.phoneNumber;
					info.Billing_Contact_Department__c = editBillingDto.contactDepartment;
					info.Billing_Contact_Position__c = editBillingDto.contactPosition;
					info.Billing_Contact_Name__c = editBillingDto.contactName;
					info.Service_Name__c = key;
					insert info;
					
					List<Contract_Application_Product__c> productList = productMap.get(key);
					for (Contract_Application_Product__c product: productList) {
						product.Contract_Application_Information__c = info.Id;
					}
					insert productList;
					
					if (!approvalRequestLogic.approvalRequest(info.Id, true)) {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '承認申請に失敗しました。', '発生売上承認申請者が登録されていません。'));
						System.Debug('### Debug : 承認申請に失敗しました。');
						Database.rollback(sp);
						return null;
					}
					
					// 一つ目の契約内容に飛ばす
					if (reRend == null) {
						reRend = new ApexPages.standardController(info).view();
						reRend.setRedirect(true);
					}
				}
				
			} catch (DmlException e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'レコードの登録失敗', e.getMessage()));
				System.Debug('### Debug : レコードの登録に失敗しました。 -> ' + e.getMessage());
				Database.rollback(sp);
				reRend = null;
			}
    }
    return reRend;
  }
  
  public PageReference doEdit() {
    PageReference reRend = null;
    if (validate()) {
    	Savepoint sp = Database.setSavePoint();
			try {
				Map<String, List<Contract_Application_Product__c>> productMap = productLogic.convertFromDtoToProductMap(productDtoList);
				if (productMap.isEmpty()) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '契約登録に失敗しました。', '契約申込商品が存在しません。'));
					System.Debug('### Debug : 契約登録に失敗しました。');
				}
				for (String key: productMap.keySet()) {
					Contract_Application_Information__c info;
					if (standardController != null) {
						info = (Contract_Application_Information__c)standardController.getRecord();
					} 
					if (info == null || infoId != null) {
						info = [SELECT ID,Service_Name__c,Version_No__c FROM Contract_Application_Information__c WHERE ID = :infoId];
					}
					// 同一のサービスじゃなければ飛ばす!
					if (key != info.Service_Name__c) {
						continue;
					}
					
					// 承認申請中であれば一度キャンセルします。
					String processName = approvalRequestLogic.tryCancelRequest(info.Id);
					
					// 現在紐づくすべての契約申込商品のステータスを無効にする。
					productLogic.switchProductActiveStatusByInfoId(infoId);

					info.Name = contractApplicationNo + '_' + info.Version_No__c;
					info.Last_Edit_User__c = UserInfo.getUserId();
					info.Billing_Company_Name__c = editBillingDto.companyName;
					info.Billing_Zip_Code__c = editBillingDto.zipCode;
					info.Billing_Prefecture_Name__c = editBillingDto.prefectureName;
					info.Billing_Address__c = editBillingDto.address;
					info.Billing_Building_Name__c = editBillingDto.buildingName;
					info.Billing_Phone_Number__c = editBillingDto.phoneNumber;
					info.Billing_Contact_Department__c = editBillingDto.contactDepartment;
					info.Billing_Contact_Position__c = editBillingDto.contactPosition;
					info.Billing_Contact_Name__c = editBillingDto.contactName;
					info.Contract_Application_Memo__c = memoDto.memo;
					info.Contract_Transfer_Memo__c = memoDto.transferMemo;
					if (approvalRequestLogic.isNewApprovalProcessName(processName)) {
						info.Approval_Status__c = '未申請';
					} else {
						info.Approval_Status__c = '再申請待ち';
					}
					update info;
					
					// 契約申込商品を登録する。
					List<Contract_Application_Product__c> productList = productMap.get(key);
					for (Contract_Application_Product__c product: productList) {
						product.Contract_Application_Information__c = info.Id;
					}
					insert productList;
					
					if (!approvalRequestLogic.approvalRequest(info.Id, approvalRequestLogic.isNewApprovalProcessName(processName))) {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '承認申請に失敗しました。', '発生売上承認申請者が登録されていません。'));
						System.Debug('### Debug : 承認申請に失敗しました。');
						Database.rollback(sp);
						return null;
					}
					
					// 一つ目の契約内容に飛ばす
					if (reRend == null) {
						reRend = new ApexPages.standardController(info).view();
						reRend.setRedirect(true);
					}
				}
			} catch (DmlException e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'レコードの登録失敗', e.getMessage()));
				System.Debug('### Debug : レコードの登録に失敗しました。 -> ' + e.getMessage());
				Database.rollback(sp);
				reRend = null;
			}
    }
  	return reRend;
  }
  
  public PageReference doDelete() {
    PageReference reRend = null;
		Savepoint sp = Database.setSavePoint();
    try {
			Contract_Application_Information__c info;
			if (standardController != null) {
				info = (Contract_Application_Information__c)standardController.getRecord();
			} 
			if (info == null || infoId == null) {
				info = [SELECT ID FROM Contract_Application_Information__c WHERE ID = :infoId];
			}
			
			// 承認申請中であれば一度キャンセルします。
			String processName = approvalRequestLogic.tryCancelRequest(info.Id);
					
			info.Last_Edit_User__c = UserInfo.getUserId();
			info.Del_Flg__c = true;
			update info;
			// 紐づく申込商品は売上承認時に削除する。

			if (!approvalRequestLogic.approvalRequest(info.Id, approvalRequestLogic.isNewApprovalProcessName(processName))) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '承認申請に失敗しました。', '発生売上承認申請者が登録されていません。'));
				System.Debug('### Debug : 承認申請に失敗しました。');
				Database.rollback(sp);
				return null;
			}

			Opportunity opp = new Opportunity();
			opp.Id = opportunityId;
			reRend = new ApexPages.standardController(opp).view();
			reRend.setRedirect(true);
    } catch (DmlException e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'レコードの更新失敗', e.getMessage()));
			System.Debug('### Debug : レコードの更新に失敗しました。 -> ' + e.getMessage());
			Database.rollback(sp);
			reRend = null;
    }
    
  	return reRend;
  }
  
  private boolean validate() {
    String errorMessage = '';
    if (editBillingDto.hasError()) {
    	if (String.isNotBlank(editBillingDto.errorCompanyName())) {
    		errorMessage += editBillingDto.errorCompanyName() + '\n';
    	}
    	if (String.isNotBlank(editBillingDto.errorZipCode())) {
    		errorMessage += editBillingDto.errorZipCode() + '\n';
    	}
    	if (String.isNotBlank(editBillingDto.errorAddress())) {
    		errorMessage += editBillingDto.errorAddress() + '\n';
    	}
    	if (String.isNotBlank(editBillingDto.errorPhoneNumber())) {
    		errorMessage += editBillingDto.errorPhoneNumber() + '\n';
    	}
    	if (String.isNotBlank(editBillingDto.errorContactName())) {
    		errorMessage += editBillingDto.errorContactName() + '\n';
    	}
    }
    
    if (!selectParentContractIds.isEmpty() && String.isBlank(memoDto.parentContractApplicationNo)) {
    	errorMessage += '親契約の商談番号が登録されていません。\n';
    }
    
    if (String.isNotBlank(errorMessage)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'レコードの登録失敗', errorMessage));
    }
    
    return String.isBlank(errorMessage);
  }
  
  public class CompanyAndSalesPersonDto {
  	public String opportunityId {get; set;}
  	public String accountId {get; set;}
  	public String serviceType {get; set;}
  	public String contractType {get; set;}
  	public String salesPersonName {get; set;}
  	public String salesPersonDepartment {get; set;}
  	public String salesTerritory {get; set;}
  	public String appointmentType {get; set;}
  	public Date appointmentAcquiredDate {get; set;}
  	public String appointmentAcquiredName {get; set;}
  	public String appointmentAcquiredTeam {get; set;}
  	public String appointmentAcquiredType {get; set;}
  	public String inboundType {get; set;}
  	public String companyProfile {get; set;}
  	public String companySizeStr {get; set;}
  	public String companyUrl {get; set;}
  	public String representative {get; set;}
  	public Date establishmentDate {get; set;}
  	public String industryCd {get; set;}
  	
  	public CompanyAndSalesPersonDto(Opportunity opportunity) {
  		opportunityId = opportunity.Id;
  		accountId = opportunity.Account.Id;
  		serviceType = opportunity.ProposedService__c;
  		contractType = opportunity.Type;
  		salesPersonName = opportunity.Owner.Name;
  		salesPersonDepartment = opportunity.OwnerRoleDepartment__c;
  		salesTerritory = opportunity.OwnerRoleTerritory__c;
  		appointmentType = opportunity.AppoChannel__c;
  		appointmentAcquiredDate = opportunity.AppoAcquisitionDate__c;
  		appointmentAcquiredName = opportunity.AppoAcquisitionUserName__c;
  		appointmentAcquiredTeam = opportunity.apo_team__c;
  		appointmentAcquiredType = opportunity.apo_chanel__c;
			if (opportunity.inbound__c) {
				inboundType = 'インバウンド';
			} else {
				inboundType = 'アウトバウンド';
			}
			companyProfile = opportunity.CompanyProfile__c;
			// 何も設定されていなかったら非公開にする。(業務フロー的に契約申込の段階ではこの項目は不要)
			companySizeStr = opportunity.Account.CompanySize__c != null ? opportunity.Account.CompanySize__c : System.Label.UNOPEN_COMPANY_SIZE;
			companyUrl = opportunity.Account.Website;
			representative = opportunity.Account.Field195__c;
			establishmentDate = opportunity.Account.Field38__c;
			industryCd = opportunity.Account.Field221__c;
  	}

    public String errorSalesPersonName {
    	get {
				return String.isBlank(salesPersonName) ? '商談の所有者項目の入力は必須です。' : '';
    	}
    }

    public String errorAppointmentType {
    	get {
				return serviceType == 'CRS' && String.isBlank(appointmentType) ? '商談のアポ獲得経路項目の入力は必須です。' : '';
    	}
    }

    public String errorAppointmentAcquiredName {
    	get {
				return serviceType == 'CRS' && String.isBlank(appointmentAcquiredName) ? '商談の★アポ取得者項目の入力は必須です。' : '';
    	}
    }

    public String errorAppointmentAcquiredTeam {
    	get {
				return serviceType == 'CRS' && String.isBlank(appointmentAcquiredTeam) ? '商談のチーム(アポ取得)項目の入力は必須です。' : '';
    	}
    }

    public String errorAppointmentAcquiredType {
    	get {
				return serviceType == 'CRS' && String.isBlank(appointmentAcquiredType) ? '商談のアポ種別項目の入力は必須です。' : '';
    	}
    }

    public String errorIndustryCd {
    	get {
				return serviceType == 'CRS' && String.isBlank(industryCd) ? '取引先のビズリーチ業種コード項目の入力は必須です。' : '';
    	}
    }

    public Boolean hasError {
    	get {
				return String.isNotBlank(errorSalesPersonName) || String.isNotBlank(errorAppointmentType) || String.isNotBlank(errorAppointmentAcquiredName) ||
							 String.isNotBlank(errorAppointmentAcquiredTeam) || String.isNotBlank(errorAppointmentAcquiredType) ||
							 String.isNotBlank(errorIndustryCd);
    	}
    }
  }
}