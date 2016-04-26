public with sharing class BillingDto {
	// 請求先オブジェクト
	public String companyName {get; set;}
	public String zipCode {get; set;}
	public String prefectureName {get; set;}
	public String address {get; set;}
	public String buildingName {get; set;}
	public String phoneNumber {get; set;}
	public String contactDepartment {get; set;}
	public String contactPosition {get; set;}
	public String contactName {get; set;}

	public BillingDto() {
		companyName = '';
		zipCode = '';
		prefectureName = '';
		address = '';
		buildingName = '';
		phoneNumber = '';
		contactDepartment = '';
		contactPosition = '';
		contactName = '';
	}

	public void convertFromOpportunity(Opportunity o) {
		if (o.Account != null)	{
			Account a = o.Account;
			companyName = a.Name;
			zipCode = a.BillingPostalCode;
			prefectureName = a.BillingState;
			address = a.BillingCity;
			buildingName = a.BillingStreet;
			phoneNumber = a.Phone;
		}
		
		contactDepartment = o.ContactDepartment__c;
		contactPosition = o.ContactTitle__c;
		contactName = o.ContactName__c;
	}
	
	public void convertFromInfo(Contract_Application_Information__c info) {
		if (info != null) {
			companyName = info.Billing_Company_Name__c;
			zipCode = info.Billing_Zip_Code__c;
			prefectureName = info.Billing_Prefecture_Name__c;
			address = info.Billing_Address__c;
			buildingName = info.Billing_Building_Name__c;
			phoneNumber = info.Billing_Phone_Number__c;
			contactDepartment = info.Billing_Contact_Department__c;
			contactPosition = info.Billing_Contact_Position__c;
			contactName = info.Billing_Contact_Name__c;
		}
	}
	
	public String errorCompanyName() {
		return String.isBlank(companyName) ? '請求先会社名の入力は必須です。' : '';
	}
	
	public String errorZipCode() {
		return String.isBlank(zipCode) ? '請求先郵便番号の入力は必須です。' : '';
	}
	
	public String errorAddress() {
		return String.isBlank(address) ? '請求先住所の入力は必須です。' : '';
	}
	
	public String errorPhoneNumber() {
		return String.isBlank(phoneNumber) ? '請求先電話番号の入力は必須です。' : '';
	}
	
	public String errorContactName() {
		return String.isBlank(contactName) ? '請求先担当者の入力は必須です。' : '';
	}
	
	public Boolean hasError() {
		return String.isNotBlank(errorCompanyName()) || String.isNotBlank(errorZipCode()) ||
		       String.isNotBlank(errorAddress()) || String.isNotBlank(errorPhoneNumber()) ||
		       String.isNotBlank(errorContactName());
	}
}