global class BAT_CreatePersonalKPIJissekiSyukeiBatch implements Database.Batchable<sObject> {
/**
 * BAT_CreatePersonalKPIJissekiSyukeiBatch
 * CRS候補者（新）から日別に個人別KPIを作成
 * ----------------------------------------
 * @createdName      : Ye
 * @lastModifiedName : Ye
 * ----------------------------------------
 */
	global Integer jobNo = -1;
    private final String JISSEKI = '実績';
    private Date targetDate = system.today() - Integer.valueOf(System.label.KPIDateChange);
    private Date jissekiDate = Date.valueOf(targetDate - 1);
    private string T_jissekiDate = string.valueOf(jissekiDate);

    //ユーザMapの作成
    private Map<id, User> userMap;
    
    public String query = 'SELECT Id,Name,Account__c,Account__r.CrsSale_Representative__c,CRSTantouUnyouTorihikisaki__c, '
                        + ' Field36__c,drop_sales_date__c,Field53__c,drop_sales_price__c ' 
                        + ' FROM CrsCandidate__c '
                        + ' WHERE Field36__c =: jissekiDate or drop_sales_date__c =: jissekiDate ';
                       
    global BAT_CreatePersonalKPIJissekiSyukeiBatch(Integer jobNo) {
		this.jobNo = jobNo;
	}
	
    /**
     * 個人別KPI作成開始処理
     * @param BC BatchableContextインターフェース
     * @param scope　CRS候補者（新）
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    /**
     * 個人別KPI作成処理
     * @param BC BatchableContextインターフェース
     * @param scope リスト
     */
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        User Usr;
        String kpiKey = '';
        PersonalKPI__c kpi = new PersonalKPI__c();
        List<PersonalKPI__c> kpiList = new List<PersonalKPI__c>();
        List<CrsCandidate__c> crsList = (List<CrsCandidate__c>) scope;
        Map<id, user> userMap = new Map<id, user>([SELECT Id, Name, Username,userRoleId, profileId FROM User WHERE isActive = true AND UserType = 'Standard']);
        if(crsList != null && crsList.size()>0){
            for(CrsCandidate__c crs: crsList){
                if(crs.Account__r.CrsSale_Representative__c != null){
                    Usr = userMap.get(crs.Account__r.CrsSale_Representative__c);
                    kpiKey = JISSEKI + T_jissekiDate + usr.name;
                }else{
                    Usr = null;
                    kpiKey = JISSEKI + T_jissekiDate;
                }
                kpi = createDefaultPersonalKPI(Usr, kpiKey);
            }
        }
    }

    /**
     * 個人別KPI集計終了処理
     * @param BC BatchableContextインターフェース
     */
    global void finish(Database.BatchableContext BC) {
        //BAT_JobExecutor.executeNextJob(jobNo);
    }
                        
	/**
	 * 新規登録用の個人別KPIオブジェクトを生成
	 * @param usr ユーザ
	 * @param kpiKey 個人別KPIのキー項目(実績+集計日+所属担当（テキスト）)
	 * @param syukeiDate 集計日
	 * @return 個人別KPI
	*/
	private PersonalKPI__c createDefaultPersonalKPI(User usr, String kpiKey) {

        PersonalKPI__c kpi = new PersonalKPI__c();
            if(usr != null){
	            kpi.Syozokutantou__c = usr.id;
	            kpi.SyozokuTantouText__c = usr.name;
	            kpi.Yojitsukubun__c = JISSEKI;
	            kpi.Syukeibi__c = targetDate;
	            kpi.Key__c = kpiKey;	
            }else{
            	kpi.SyozokuTantouText__c = '不明';
            	kpi.Yojitsukubun__c = JISSEKI;
	            kpi.Syukeibi__c = targetDate;
	            kpi.Key__c = kpiKey;
            }
        try {
            upsert kpi Key__c;
        } catch (DmlException e) {
            System.debug('@@@=' + e.getMessage());
        }
        return kpi;
    }

}