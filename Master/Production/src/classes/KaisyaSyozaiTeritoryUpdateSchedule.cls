//振り分けマスタを使用して、真・会社所在テリトリーを埋める処理（バッチ）

global class KaisyaSyozaiTeritoryUpdateSchedule implements Schedulable {
	global void execute(SchedulableContext sc){
		KaisyaSyozaiTeritoryUpdateBatch KSTUB = new KaisyaSyozaiTeritoryUpdateBatch();
		KSTUB.query = 'select id,address_all__c, BillingState, CompanyTeritory__c, BillingCity, Ootetantoukigyou__c from account';
		ID batchprocessid = Database.executeBatch(KSTUB);

	}

}