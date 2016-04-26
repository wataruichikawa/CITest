public class ApplicationInputFormDto {
  public String contractApplicationNo {get; set;}
  public String serviceType {get; set;}
  public Date collectionDate {get; set;}
  public Date startDate {get; set;}
  public Date endDate {get; set;}
  public String companyName {get; set;}
  public String companyNameKana {get; set;}
  public String zipCode {get; set;}
  public String prefecture {get; set;}
  public String address1 {get; set;}
  public String address2 {get; set;}
  public String phoneNumber {get; set;}
  public String contactDepartment {get; set;}
  public String contactPosition {get; set;}
  public String contactName {get; set;} 
  public String emailAddress {get; set;}
  public String opportunityId {get; set;}
  public String accountId {get; set;}
  
  public ApplicationInputFormDto() {
  	contractApplicationNo = '';
  	serviceType = '';
  	companyName = '';
  	companyNameKana = '';
  	zipCode = '';
  	prefecture = '';
  	address1 = '';
  	address2 = '';
  	phoneNumber = '';
  	contactDepartment = '';
  	contactPosition = '';
  	contactName = '';
  	emailAddress = '';
  	opportunityId = '';
  	accountId = '';
  }
  
  public void convertFromOpportunity(Opportunity opp) {
		if (opp != null) {
			contractApplicationNo = opp.ContractApplicationNo__c;
			serviceType = opp.ProposedService__c;
			collectionDate = opp.ContractCollectionDate__c;
			startDate = opp.UseStartDate__c;
			endDate = opp.UseEndDate__c;
			companyName = opp.Account.Name;
			zipCode = opp.Account.billingPostalCode;
			prefecture = opp.Account.billingState;
			address1 = opp.Account.billingCity;
			address2 = opp.Account.billingStreet;
			phoneNumber = opp.Account.Phone;
			contactDepartment = opp.ContactDepartment__c;
			contactPosition = opp.ContactTitle__c;
			contactName = opp.ContactName__c;
			emailAddress = opp.ContactEmail__c;
			opportunityId = opp.Id;
			accountId = opp.Account.Id;
		}
  }

	public String errorCollectionDate {
		get {
			return collectionDate == null ? '申込書回収日の入力は必須です。' : '';
		}
	}

	public String errorZipCode {
		get {
			return String.isBlank(zipCode) ? '取引先の郵便番号(請求先)項目の入力は必須です。' : '';
		}
	}

	public String errorPrefecture {
		get {
			return String.isBlank(prefecture) ? '取引先の都道府県(請求先)項目の入力は必須です。' : '';
		}
	}

	public String errorAddress1 {
		get {
			return String.isBlank(address1) ? '取引先の市区郡(請求先)項目の入力は必須です。' : '';
		}
	}

	public String errorPhoneNumber {
		get {
			return String.isBlank(phoneNumber) ? '取引先の電話項目の入力は必須です。' : '';
		}
	}

	public String errorContactName {
		get {
			return String.isBlank(contactName) ? '商談の担当者目項目の入力は必須です。' : '';
		}
	}
	
	public Boolean hasError {
		get {
			return String.isNotBlank(errorCollectionDate) || String.isNotBlank(errorZipCode) || String.isNotBlank(errorPrefecture) || 
						 String.isNotBlank(errorAddress1) || String.isNotBlank(errorPhoneNumber) || String.isNotBlank(errorContactName);
		}
	}
}