/**
 * AddressAndTeritoryMatchLogic
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : S.Sogawa
 * 住所の振り分けマスタ化対応
 * ----------------------------------------
 */


public with sharing class AddressAndTeritoryMatchLogic {

	private List<HuriwakeMaster__c>  addressMaster;
	private List<UserRole> UserRoleList;
	private Map<id, UserRole> RoleMap;
	private Map<String, List<HuriwakeMaster__c>> teritoryMap;

	public AddressAndTeritoryMatchLogic(List<Account> accList){

		String ooteHuriwakeRoleId = system.label.OoteHuriwakeRoleId;
		Id ooteRoleId = null;
		if (String.isNotBlank(ooteHuriwakeRoleId)) {
			ooteRoleId = Id.valueOf(ooteHuriwakeRoleId);
		}

        teritoryMap = new Map<String, List<HuriwakeMaster__c>>();

		//都道府県のみとする
		Set<string> PrefectureCity = new Set<String>();
		for(Account a  : accList){
			//市区町村以下でグループがわかれている場合、下記を追加
			if(a.BillingState == '東京都' || a.BillingState == '神奈川県'){
				if(a.BILLINGSTATE != null && a.BillingCity == null){
					PrefectureCity.add(a.BILLINGSTATE);
				}else if(a.BILLINGSTATE != null && a.BillingCity != null){
					PrefectureCity.add(a.BILLINGSTATE+a.BillingCity);
				}
			}
			else{
				system.debug('a.BillingState = ' + a.BillingState);
				PrefectureCity.add(a.BILLINGSTATE);
			}

		}

		//振り分けマスタ取得
		try{
			system.debug('PrefectureCity = '+ PrefectureCity);
			addressMaster = [select id, name, Todouhuken__c, Shikutyouson__c, Tyouiki__c, TodouhukenShikutyouson__c, TodouhukenShikutyousonTyouiki__c, RoleID__c from HuriwakeMaster__c where TodouhukenShikutyouson__c in :PrefectureCity order by TodouhukenShikutyouson__c];
			system.debug('address = '+ addressMaster.size());
		}

		catch(Exception e){

		}

		system.debug('AddressAndTeritoryMatchLogic2');
		system.debug('huriwake = '+ addressMaster.size());


		if(addressMaster.size() == 0){
			system.debug('振り分けマスタレコード数0件');
			//大手ロールだけは取得しておく
			if (String.isNotBlank(ooteRoleId)) {
				RoleMap = new Map<id, UserRole>([select id, name, RollupDescription from UserRole where id = :ooteRoleId]);
			}
			return;
		}

		Set<id> addressMasterRoleId = new Set<id>();
        String ts = addressMaster.get(0).TodouhukenShikutyouson__c;
        List<HuriwakeMaster__c> hmList = new List<HuriwakeMaster__c>();
        //都道府県市区町村単位でListを作成
        for (Integer i = 0; i < addressMaster.size(); i++) {
            HuriwakeMaster__c hm = addressMaster.get(i);
            addressMasterRoleId.add(hm.RoleID__c);
            if (!ts.equals(hm.TodouhukenShikutyouson__c)) {
                teritoryMap.put(ts, hmList);
                hmList = new List<HuriwakeMaster__c>();
            }
            hmList.add(hm);
            ts = hm.TodouhukenShikutyouson__c;
        }
        teritoryMap.put(ts, hmList);

		if (String.isNotBlank(ooteRoleId)) {
			addressMasterRoleId.add(ooteRoleId);
		}
		system.debug('addressMasterRoleId = '+ addressMasterRoleId.size());
		UserRoleList = [select id, name, RollupDescription from UserRole where id In :addressMasterRoleId];

		RoleMap = new Map<id, UserRole>();

		for(UserRole u : UserRoleList){
			RoleMap.put(u.id, u);
		}

		system.debug('RoleMap = '+ RoleMap.size());
	}

/*
	public AddressAndTeritoryMatchLogic(List<lead> ListLead){

		//都道府県のみとする
		Set<string> PrefectureCity = new Set<String>();
		for(Lead l: ListLead){

			system.debug('ListLead STATE = '+ l.STATE);
			system.debug('ListLead City = '+ l.City);
			if(l.STATE != null && l.City == null){
				PrefectureCity.add(l.STATE);
			}
			else if(l.STATE != null && l.City != null){
				PrefectureCity.add(l.STATE+l.City);
			}

		}

		//振り分けマスタ取得
		try{
			system.debug('ListLead PrefectureCity = '+ PrefectureCity);
			addressMaster = [select id, name, Todouhuken__c, Shikutyouson__c, Tyouiki__c, RoleID__c from HuriwakeMaster__c where TodouhukenShikutyouson__c in :PrefectureCity];
			system.debug('ListLead address = '+ addressMaster.size());
		}

		catch(Exception e){

		}

		if(addressMaster.size() == 0){
			system.debug('振り分けマスタレコード数0件');
			return;
		}

		Set<id> addressMasterRoleId = new Set<id>();

		for(HuriwakeMaster__c h : addressMaster){
			addressMasterRoleId.add(h.RoleID__c);
		}

		system.debug('addressMasterRoleId = '+ addressMasterRoleId.size());
		UserRoleList = [select id, name from UserRole where id In :addressMasterRoleId];

		RoleMap = new Map<id, UserRole>();

		for(UserRole u : UserRoleList){
			RoleMap.put(u.id, u);
		}

	}
*/
	//リードの時の処理
	public AddressAndTeritoryMatchLogic(String address){

		//振り分けマスタ取得
		String a = address;
		try{
			addressMaster = [select id, name, Todouhuken__c, Shikutyouson__c, Tyouiki__c, TodouhukenShikutyousonTyouiki__c, InboundRoleId__c from HuriwakeMaster__c where TodouhukenShikutyouson__c = :address];
			system.debug('ListLead address = '+ addressMaster.size());
		}

		catch(Exception e){

		}

		if(addressMaster.size() == 0){
			system.debug('振り分けマスタレコード数0件');
			return;
		}

		Set<id> addressMasterRoleId = new Set<id>();

		for(HuriwakeMaster__c h : addressMaster){
			addressMasterRoleId.add(h.InboundRoleId__c);
		}

		UserRoleList = [select id, name, RollupDescription from UserRole where id In :addressMasterRoleId];

		RoleMap = new Map<id, UserRole>();

		for(UserRole u : UserRoleList){
			RoleMap.put(u.id, u);
		}

		system.debug('RoleMap = '+ RoleMap.size());

	}

	/*
	 * 振り分けマスタで取得した内容を用いて、住所とマッチングさせ、ロール名を入れる
	 * @see LeadTrigger
	 */
	public String matchAddressAndTeritoryLead(String address){

		system.debug('matchAddressAndTeritoryLead Start');
		system.debug('address = ' + address);
		//振り分けマスタが0件だった場合空白として返却
		if(addressMaster.size() == 0){
			system.debug('addressMaster.size() == 0 matchAddressAndTeritoryLead end');
			return system.label.other;
		}

		for(HuriwakeMaster__c h1: addressMaster){
			//振り分けマスタの都道府県、市区町村、町域を連結
			if(address.contains(h1.TodouhukenShikutyousonTyouiki__c)){
				system.debug('h1.InboundRoleId__c = '+ h1.InboundRoleId__c);
				system.debug('rolename = '+ RoleMap.get(h1.InboundRoleId__c).RollupDescription);
				system.debug('HuriwakeMaster__c matchAddressAndTeritoryLead end');
				return RoleMap.get(h1.InboundRoleId__c).RollupDescription;
			}
		}

		system.debug('matchAddressAndTeritoryLead end');
		return system.label.other;
	}

    /**
     * 振り分けマスタで取得した内容を用いて、住所とマッチングさせ、ロール名を入れる
     * 取引先の大手担当企業がONの場合は大手ロールIDでロール名を入れる
     * @see AccountTrigger
     * @see KaisyaSyozaiTeritoryUpdateBatch
     */
    public String matchAddressAndTeritoryAccount(String address, String billingState, String billingCity, boolean ootetantoukigyou){

		if (ootetantoukigyou) {
			String ooteHuriwakeRoleId = system.label.OoteHuriwakeRoleId;
			if (String.isNotBlank(ooteHuriwakeRoleId)) {
				UserRole oote = RoleMap.get(Id.valueOf(ooteHuriwakeRoleId));
				if (oote != null) {
					return oote.RollupDescription;
				}
			}
		}

        if (String.isBlank(address)) {
            return system.label.other;
        }

        String sc;
        if (billingState == '東京都' || billingState == '神奈川県') {
            sc = (String.isBlank(billingState) ? '' : billingState) + (String.isBlank(billingCity) ? '': billingCity);
        } else {
            sc = String.isBlank(billingState) ? '' : billingState;
        }

        List<HuriwakeMaster__c> hmList = teritoryMap.get(sc);
        //振り分けマスタが0件だった場合はその他
        if(hmList == null || hmList.isEmpty()){
            return system.label.other;
        }

        for(HuriwakeMaster__c hm : hmList){
            if(address.contains(hm.TodouhukenShikutyousonTyouiki__c)){
                return RoleMap.get(hm.RoleID__c).RollupDescription;
            }
        }
        return system.label.other;

    }

}