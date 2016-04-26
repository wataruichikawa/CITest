public with sharing class NotYetRegisterContractList {
  private ApexPages.StandardController controller;
  private List<NotExistsContractDto> dtoList;
  private List<String> registerStatusList = new List<String> { '登録申請中', '修正申請中', '承認済', '再申請待ち', '不承認' };
  private List<String> waitApprovalStatusList = new List<String> { '再申請待ち', '不承認' };

  public NotYetRegisterContractList(ApexPages.StandardController standardController) {
    controller = standardController;
    dtoList = new List<NotExistsContractDto>();
  }
  
  // 表示する条件
  // すべて : 契約終了日が本日より未来のもの
  // (1) 有効な契約内容オブジェクトがなく、業推が申込書を承認した商談
  // (2) 発生売上が不承認となったもの。
  // (3) 商談の開始日・終了日または申込書PDFが更新されたもの。
  public PageReference selectList() {
		// 不承認のものと未登録のものは同時に取得できないため、SOQLを分ける。
		// 不承認, 再申請待ち
		// 順序は不承認のほうが先
		List<Contract_Application_Information__c> infoList = [SELECT o.ID,
																																 o.Name,
																																 o.useStartDate__c,
																																 o.useEndDate__c,
																																 ow.Name,
																																 a.Id,
																																 a.Name,
																																 i.Approval_Status__c
																													  FROM Contract_Application_Information__c i,
																																 Contract_Application_Information__c.Opportunity__r o,
																																 Contract_Application_Information__c.Opportunity__r.Account a,
																																 Contract_Application_Information__c.Opportunity__r.Owner ow
																													 WHERE i.Approval_Status__c in :waitApprovalStatusList
																													   AND i.Del_Flg__c = false
																														 AND o.useEndDate__c >= :Date.today()
																													 ORDER BY i.Approval_Status__c asc,
																													          i.LastModifiedDate desc,
																													          o.CreditDivisionDenialCount__c desc,
																																	  o.ApplicationApprovalDate__c desc];
		
		// 未登録
		List<Contract_Application_Information__c> registerInfoList = [SELECT o.Id
		                                                                FROM Contract_Application_Information__c i,
		                                                                     Contract_Application_Information__c.Opportunity__r o
		                                                               WHERE i.Approval_Status__c IN :registerStatusList
		                                                                 AND i.Del_Flg__c = false
		                                                                 AND o.useEndDate__c >= :Date.today()];

		Set<ID> opportunityIdsExistsContract = new Set<ID>();
		for (Contract_Application_Information__c i: registerInfoList) {
			opportunityIdsExistsContract.add(i.Opportunity__r.Id);
		}

		List<Opportunity> opportunityList = [SELECT o.ID,
																								o.Name,
																								o.useStartDate__c,
																								o.useEndDate__c,
																								ow.Name,
																								a.Id,
																								a.Name
																					 FROM Opportunity o,
																								Opportunity.Account a,
																								Opportunity.Owner ow
																					WHERE o.useEndDate__c >= :Date.today()
																						AND o.Id NOT IN :opportunityIdsExistsContract
																						AND o.ContractCollectionDate__c != NULL
																					ORDER BY o.useStartDate__c asc,
																					         o.CreditDivisionDenialCount__c desc];
																						
		for (Contract_Application_Information__c i: infoList) {
			NotExistsContractDto dto = new NotExistsContractDto();
			dto.accountId = i.Opportunity__r.Account.Id;
			dto.opportunityId = i.Opportunity__r.Id;
			dto.infoId = i.Id;
			dto.opportunityName = i.Opportunity__r.Name;
			dto.useStartDate = i.Opportunity__r.useStartDate__c;
			dto.useEndDate = i.Opportunity__r.useEndDate__c;
			dto.accountName = i.Opportunity__r.Account.Name;
			dto.salesPersonName = i.Opportunity__r.Owner.Name;
			if (i.Approval_Status__c == '再申請待ち') {
				dto.status = '契約申込書更新';
			} else {
				dto.status = '不承認';
			}
			dtoList.add(dto);
		}
		for (Opportunity o: opportunityList) {
			NotExistsContractDto dto = new NotExistsContractDto();
			dto.accountId = o.Account.Id;
			dto.opportunityId = o.Id;
			dto.opportunityName = o.Name;
			dto.useStartDate = o.useStartDate__c;
			dto.useEndDate = o.useEndDate__c;
			dto.accountName = o.Account.Name;
			dto.salesPersonName = o.Owner.Name;
			dto.status = '未登録';
			dtoList.add(dto);
		}
  	return null;
  }
  
  public List<NotExistsContractDto> getDtoList() {
  	return dtoList;
  }
    
}