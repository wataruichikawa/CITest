global class BAT_KpiSyukeiCandi_Batch implements Database.Batchable<sObject>{

/**
 * BAT_KpiSyukeiCandi_Batch
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
	private List<user> tantouLst;
	
	public String query = 'SELECT Id,Name,Account__c,Account__r.CrsSale_Representative__c,CRSTantouUnyouTorihikisaki__c, '
						+ ' Field36__c,drop_sales_date__c,Field53__c,drop_sales_price__c ,Shimei__c, position__c, position__r.name ' 
						+ ' FROM CrsCandidate__c '
						+ ' WHERE Field36__c =: jissekiDate or drop_sales_date__c =: jissekiDate ';
		
                       
    global BAT_KpiSyukeiCandi_Batch(Integer jobNo) {
		this.jobNo = jobNo;
	}
	
    
    /**
     * 個人別KPI集計開始処理
     * @param BC BatchableContextインターフェース
     * @param scope　CRS候補者（新）
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);        
        
    }
     
    /**
     * 個人別KPI集計処理
     * @param BC BatchableContextインターフェース
     * @param scope リスト
    */
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    	
    	List<CrsCandidate__c> crsList = (List<CrsCandidate__c>) scope;
        List<PersonalKPI__c> upsertkpiLst = new list<PersonalKPI__c>();
        set<id> tantouIds = new set<id>();
    	//CRS候補者（新）CRS運用担当者Idsの作成
    	for(CrsCandidate__c crs: crsList){
			if(crs.position__c != null && !crs.position__r.name.startsWith('CT')){
				if(crs.Account__c != null && crs.Account__r.CrsSale_Representative__c != null){
					tantouIds.add(crs.Account__r.CrsSale_Representative__c);
				}
			}
		}
		if(tantouIds != null){
			tantouLst = [SELECT id, Name from User Where id in: tantouIds];	
		}
		
		//CRS運用担当者がNullではない場合、CRS運用担当者ごとにBIZ決定数とBIZ後工程売上の集計
		if(tantouLst != null && tantouLst.size()>0){
			for(User u: tantouLst){
				Decimal kingaku = 0;
				Integer keteisu = 0;
				Decimal Mkingaku = 0;
				Integer Mketeisu = 0;
				Decimal keteikingaku = 0;
				Integer saisuketeisu = 0;
				string kpikey = '';
				
				//集計日の先日に発生した発生売上が担当者ごとに集計
				AggregateResult[] uriageLst =  [SELECT SUM(Field53__c) summary 
												FROM CrsCandidate__c 
												WHERE Account__r.CrsSale_Representative__c =:u.id 
												and Field36__c =: jissekiDate
												and (NOT position__r.Name like 'CT%')];
				if(uriageLst[0].get('summary') != null){
					kingaku = (decimal)uriageLst[0].get('summary');
				}
				
				//集計日の先日に発生した発生売上の決定数が担当者ごとに集計
				AggregateResult[] keteisuLst =  [SELECT count(id) summary 
												FROM CrsCandidate__c 
												WHERE Account__r.CrsSale_Representative__c =:u.id 
												and Field36__c =: jissekiDate
												and (NOT position__r.Name  like 'CT%')];
				keteisu  =  Integer.valueOf(keteisuLst[0].get('summary'));
				
				//集計日の先日に発生したマイナス計上金額が担当者ごとに集計
				AggregateResult[] MuriageLst =  [SELECT SUM(drop_sales_price__c) summary 
												FROM CrsCandidate__c 
												WHERE Account__r.CrsSale_Representative__c =:u.id 
												and drop_sales_date__c =:jissekiDate
												and (NOT position__r.Name  like 'CT%')];
				if(MuriageLst[0].get('summary') != null){
					Mkingaku = (decimal)MuriageLst[0].get('summary');
				}
				
				//集計日の先日に発生したマイナス計上金額の決定数が担当者ごとに集計
				AggregateResult[] MketeisuLst =  [SELECT count(id) summary 
												FROM CrsCandidate__c 
												WHERE Account__r.CrsSale_Representative__c =:u.id 
												and drop_sales_date__c =:jissekiDate
												and (NOT position__r.Name  like 'CT%')];
				Mketeisu = (Integer)MketeisuLst[0].get('summary');
				
				//集計日の先日に発生した合計金額および最終決定数が担当者ごろに集計
				keteikingaku = kingaku + Mkingaku;
				saisuketeisu = keteisu - Mketeisu;
				kpikey = JISSEKI  + T_jissekiDate  + u.name;
				
				PersonalKPI__c kpi = new PersonalKPI__c();
				kpi = createCandiKPI(u, kpikey, saisuketeisu, keteikingaku);
				upsertkpiLst.add(kpi);
			}
			
		}
		List<CrsCandidate__c> crsList_n =  [SELECT Id,Name, position__c, position__r.name, Field36__c, drop_sales_date__c,
											Account__c,Account__r.CrsSale_Representative__c
						 					FROM CrsCandidate__c 
										 	WHERE (Field36__c =: jissekiDate or drop_sales_date__c =: jissekiDate) 
										 	AND Account__r.CrsSale_Representative__c = null
										 	AND (NOT position__r.Name  like 'CT%')];
		if(crsList_n != null && crsList_n.size()>0){
			//CRS運用担当者が登録されていない場合、BIZ決定数とBIZ後工程売上の集計
			Decimal kingaku_n = 0;
			Integer keteisu_n= 0;
			Decimal Mkingaku_n = 0;
			Integer Mketeisu_n = 0;
			Decimal keteikingaku_n = 0;
			Integer saisuketeisu_n = 0;
			string kpikey = '';
				
			//集計日の先日に発生した発生売上を集計（担当者なし）
			AggregateResult[] uriageLst_n =  [SELECT SUM(Field53__c) summary 
											FROM CrsCandidate__c 
											WHERE Account__r.CrsSale_Representative__c = null 
											and Field36__c =: jissekiDate
											and (NOT position__r.Name  like 'CT%')];
			if(uriageLst_n[0].get('summary') != null){
				kingaku_n = (decimal)uriageLst_n[0].get('summary');
			}
			
			//集計日の先日に発生した発生売上の決定数を集計（担当者なし）
			AggregateResult[] keteisuLst_n =  [SELECT count(id) summary 
											FROM CrsCandidate__c 
											WHERE Account__r.CrsSale_Representative__c =:null
											and Field36__c =: jissekiDate
											and (NOT position__r.Name  like 'CT%')];
			keteisu_n = Integer.valueOf(keteisuLst_n[0].get('summary'));
			
			//集計日の先日に発生したマイナス計上金額を集計（担当者なし）
			AggregateResult[] MuriageLst_n =  [SELECT SUM(drop_sales_price__c) summary 
											FROM CrsCandidate__c 
											WHERE Account__r.CrsSale_Representative__c =:null
											and drop_sales_date__c =:jissekiDate
											and (NOT position__r.Name  like 'CT%')];
			if(MuriageLst_n[0].get('summary') != null){
				Mkingaku_n = (decimal)MuriageLst_n[0].get('summary');
			}
			
			//集計日の先日に発生したマイナス計上金額の決定数を集計
			AggregateResult[] MketeisuLst_n =  [SELECT count(id) summary 
											FROM CrsCandidate__c 
											WHERE Account__r.CrsSale_Representative__c =:null 
											and drop_sales_date__c =:jissekiDate
											and (NOT position__r.Name  like 'CT%')];
			Mketeisu_n = (Integer)MketeisuLst_n[0].get('summary');
			
			//集計日の先日に発生した合計金額および最終決定数を集計（担当者なし）
			keteikingaku_n = kingaku_n + Mkingaku_n;
			saisuketeisu_n = keteisu_n - Mketeisu_n;
			kpikey = JISSEKI  + T_jissekiDate;
			
			PersonalKPI__c kpi = new PersonalKPI__c();
			kpi = createCandiKPI(null, kpikey, saisuketeisu_n, keteikingaku_n);
			upsertkpiLst.add(kpi);
		}
		
		if(upsertkpiLst != null && upsertkpiLst.size()>0){
			try{
				upsert upsertkpiLst key__c;
			}catch (DmlException e) {
            	System.debug('@@@=' + e.getMessage());
        	}
		}
    } 
    /**
     * 個人別KPI集計終了処理
     * @param BC BatchableContextインターフェース
    */
    global void finish(Database.BatchableContext BC) {
        //BAT_JobExecutor.executeNextJob(JobNo);
    }
    
    /**
	 * 個人別KPIオブジェクトの生成および集計値のセット
	 * @param usr ユーザ
	 * @param kpiKey 個人別KPIのキー項目(実績+集計日+所属担当（テキスト）)
	 * @param syukeiDate 集計日
	 * @return 個人別KPI
	*/
	private PersonalKPI__c createCandiKPI(User usr, String kpiKey,Integer keteisu, Decimal uriage) {

        PersonalKPI__c kpi = new PersonalKPI__c();
            if(usr != null){
	            kpi.Syozokutantou__c = usr.id;
	            kpi.SyozokuTantouText__c = usr.name;
	            kpi.Yojitsukubun__c = JISSEKI;
	            kpi.Syukeibi__c = targetDate;
	            kpi.Key__c = kpiKey;
	            kpi.BIZKetteisuu__c = keteisu;
				kpi.BIZAtokouteiUriage__c = uriage;
            }else{
            	kpi.SyozokuTantouText__c = '不明';
            	kpi.Yojitsukubun__c = JISSEKI;
	            kpi.Syukeibi__c = targetDate;
	            kpi.Key__c = kpiKey;
	            kpi.BIZKetteisuu__c = keteisu;
				kpi.BIZAtokouteiUriage__c = uriage;
            }
        return kpi;
    }
}