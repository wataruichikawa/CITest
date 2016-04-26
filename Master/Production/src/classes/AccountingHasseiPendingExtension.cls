/**
 * 発生売上承認待ちの契約内容を表示するリストです。
 */
public with sharing class AccountingHasseiPendingExtension {
  private ApexPages.StandardController controller;
  private List<AccountingHasseiPendingDto> dtoList;
  private List<String> approvalStatusList = new List<String> {'登録申請中', '修正申請中'};

  public AccountingHasseiPendingExtension(ApexPages.StandardController standardController) {
    controller = standardController;
    dtoList = new List<AccountingHasseiPendingDto>();
  }
	
  public PageReference selectList() {
  	// ログイン中のユーザの承認待ちのデータを取得
  	Id loginId = UserInfo.getUserId();
    List<ProcessInstanceWorkitem> wortItemList= [SELECT ProcessInstance.TargetObjectId 
                                                   FROM ProcessInstanceWorkitem 
                                                  WHERE ActorId =:loginId];
  	
  	Set<String> infoIdList= new Set<String>();
    for (ProcessInstanceWorkitem piwi : wortItemList){
      System.debug('TargetObjectId is ' + piwi.ProcessInstance.TargetObjectId);
      infoIdList.add(piwi.ProcessInstance.TargetObjectId);
    }

  	// 対象データの検索
		List<Contract_Application_Product__c> productList = [SELECT i.Id,
		                                                            o.Name,
																																ow.Name,
																																a.Name,
																																i.Approval_Status__c,
																																i.LastModifiedDate,
																																p.Service__c,
																																i.Del_Flg__c
																													 FROM Contract_Application_Product__c p,
																													      Contract_Application_Product__c.Contract_Application_Information__r i,
																																Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r o,
																																Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.Account a,
																																Contract_Application_Product__c.Contract_Application_Information__r.Opportunity__r.Owner ow
																													WHERE i.Id in :infoIdList
																													  AND i.Approval_Status__c in :approvalStatusList
																													ORDER BY i.Approval_Status__c desc,
																													         i.LastModifiedDate asc,
																													         p.Service__c asc];
																													 
		// 取得したデータをDTOにつめる。
		Set<ID> alreadyInsertInfoId = new Set<ID>();
		for (Contract_Application_Product__c p: productList) {
			if (!alreadyInsertInfoId.contains(p.Contract_Application_Information__r.Id)) {
				Contract_Application_Information__c i = p.Contract_Application_Information__r;
				AccountingHasseiPendingDto dto = new AccountingHasseiPendingDto();
				dto.accountName = i.Opportunity__r.Account.Name;
				dto.opportunityName = i.Opportunity__r.Name;
				dto.status = i.Approval_Status__c;
				if (i.Del_Flg__c) {
					dto.status = 'キャンセル承認待ち';
				}
				dto.salesPersonName = i.Opportunity__r.Owner.Name;
				dto.hasseiDate = i.LastModifiedDate.date();
				dto.infoId = i.Id;
				if (p.Service__c.contains(System.Label.ServiceBiz)) {
					dto.serviceName = System.Label.ServiceBiz;
				} else if (p.Service__c.contains(System.Label.ServiceCt)) {
					dto.serviceName = System.Label.ServiceCt;
				} else if (p.Service__c.contains(System.Label.ServiceNk)) {
					dto.serviceName = System.Label.ServiceNk;
				}
				dtoList.add(dto);
				alreadyInsertInfoId.add(p.Contract_Application_Information__r.Id);
			}
		}

  	return null;
  }
  
  public List<AccountingHasseiPendingDto> getDtoList() {
  	return dtoList;
  }
}