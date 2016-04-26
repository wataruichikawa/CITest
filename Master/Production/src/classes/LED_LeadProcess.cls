/**
 * LED_LeadProcess
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Yokoo
 * ----------------------------------------
 */
public class LED_LeadProcess {

    /**
     * アプローチ禁止設定
     * アプローチ禁止設定
     * @param acc
     */
    public static void setProhibitedApproach(Account acc) {
        acc.iInboundApproach__c = true;
        acc.inboundApproachDate__c = date.today();
// 従来のアタック禁止との同期は一旦やめる
//      ac.Field14__c = true;
//      if (String.isBlank(ac.Field90__c)) {
//          ac.Field90__c = 'インバウンドフォロー中のためアプローチ禁止';
//      }
    }

    /**
     * リード分類・所有者振り分け処理
     * @param ledNewList リードリスト(トリガー無効データ除くtrriger.new)
     * @param ledOldList リードリスト(トリガー無効データ除くtrriger.old)
     * @param ledNewMap  リードマップ(トリガー無効データ除くtrriger.newMap)
     * @param ledOldMap  リードマップ(トリガー無効データ除くtrriger.oldMap)
     */
    public void divideCategoryAndOwner(List<Lead> ledNewList, List<Lead> ledOldList,
    	Map<Id, Lead> ledNewMap, Map<Id, Lead> ledOldMap, boolean isInsert, boolean isUpdate) {

        if (ledNewList.isEmpty()) return;

        // ユーザ情報の取得
        Map<String, Object> umap = DAO_UserDao.findStdActiveUserMap();
        Map<Id, User> userIdMap = (Map<Id, User>) umap.get(DAO_UserDao.MAP_KEY_ID);

        // 取引先ドメインチェック
        Set<String> emailSet = new Set<String>();
        Set<String> domainSet = new Set<String>();
        Set<String> acIdSet = new Set<String>();

        for (Lead led : ledNewList) {
            if (String.isNotBlank(led.Email)) {
                emailSet.add(led.Email);
            }
            String emailDomain = UTL_EmailUtil.splitEmailDomain(led.Email);
            if (String.isNotBlank(emailDomain) && !domainSet.contains(emailDomain)) {
                domainSet.add(emailDomain);
            }
            if (String.isNotBlank(led.LeadCategoryAccount__c)) {
                acIdSet.add(led.LeadCategoryAccount__c);
            }
        }

        Map<String, Account> domainMap = new Map<String, Account>();
        // 一旦取引先種別CRSのみマッチング対象とする
        if (!domainSet.isEmpty()) {
        	//メールドメインで該当した取引先の数だけ処理
            for (Account acc : selectAccountListDomain(domainSet)) {
                domainMap.put(acc.WebsiteDomain__c, acc);
            }
        }

        Map<Id, Account> acIdMap = new Map<Id, Account>();
        if (!acIdSet.isEmpty()) {
        	//リード分類時引き当て取引先項目（取引先参照）で該当した取引先を取得
            List<Account> accList = selectAccountListAccountId(acIdSet);
            if (!accList.isEmpty()) acIdMap = new Map<Id, Account>(accList);
        }

        Map<String, Contact> contactMap = new Map<String, Contact>();
        Map<String, Contact> contactMap2 = new Map<String, Contact>();
        Map<String, Contact> contactMap3 = new Map<String, Contact>();
        //メールドメインで該当した取引先担当者の数だけ処理
        for (Contact con : selectContactListDomain(domainSet)) {
            contactMap.put(con.Email, con);
            contactMap2.put(con.EMaildomain__c + UTL_CommonUtil.replaceCompanyName(con.Account.Name), con);
            contactMap3.put(con.EMaildomain__c, con);
        }

        // 取引先担当者の更新
        for (Lead lead : ledNewList) {
            system.debug('***** lead.Status : ' + lead.Status);
            system.debug('***** lead.LeadSource : ' + lead.LeadSource);
            system.debug('***** lead.IsConverted : ' + lead.IsConverted);
            String oldOwnerId = lead.OwnerId;

            Lead oldLead = null;
            if (ledOldMap != null) {
                oldLead = ledOldMap.get(lead.Id);
            }
            Account acc = null;
            // リード分類振り分け
            if (!divideCategory(acc, lead, contactMap, contactMap2, contactMap3, domainMap)) {
                continue;
            }
            // リード所有者振り分け
            //
            //
            // 2016/04/11 現ISチーム体制では不要なためコメントアウト実施
            /*
            if (isInsert || (isUpdate && lead.TriggerAssignmentExecuteFlg__c)) {
                divideOwner(acc, lead, acIdMap, userIdMap, oldOwnerId, ledNewList.size(), isUpdate);
            }
            */
            // 上のdivideOwnerを無効化したため、念のため、下記1行を追加
            lead.SendMailFlg__c = false;
            lead.TriggerAssignmentExecuteFlg__c = false;
        }
    }

    /**
     * 定例セミナーの場合、キャンペーンメンバーに追加し、取引先をアプローチ禁止にする
     * @param ledNewList リードリスト(トリガー無効データ除くtrriger.new)
     * @param ledOldList リードリスト(トリガー無効データ除くtrriger.old)
     */
    public void addCampaignMemberOfRegularSeminar(List<Lead> ledNewList, Map<Id, Lead> ledNewMap) {

        if (ledNewList.isEmpty()) return;

        Set<String> accIdSet = new Set<String>();
        Map<Id, Account> accIdMap = new Map<Id, Account>();
        Map<Id, Account> accUpdateMap = new Map<Id, Account>();

        for(Lead led : ledNewList){
            if (String.isNotBlank(led.LeadCategoryAccount__c)) {
                accIdSet.add(led.LeadCategoryAccount__c);
            }
        }

        if (!accIdSet.isEmpty()) {
            List<Account> accList = [SELECT Id, iInboundApproach__c FROM Account WHERE Id IN :accIdSet AND IsDeleted = false AND AccountType__c = 'CRS'];
            if (!accList.isEmpty()) accIdMap = new Map<Id, Account>(accList);
        }

        // 人材採用塾のみ実行
        // Shinji Sogawa Update(2015-03-25)
        List<CampaignMember> cmpMbInsetList = new List<CampaignMember>();
        List<Account> updAcs = new List<Account>();

        for (Lead lead : ledNewList) {
            // ダイレクトリクルーティングセミナー 経営者向け
            addCampaignMember(system.label.LeadLeadSourceDirectRecruitingSeminor, lead.DrsSeminarKeieiId__c, lead, cmpMbInsetList);
            // ダイレクトリクルーティングセミナー 人事向け
            addCampaignMember(system.label.LeadLeadSourceDirectRecruitingSeminor, lead.DrsSeminarJinjiId__c, lead, cmpMbInsetList);
            // 成功事例共有セミナー
            addCampaignMember(system.label.LeadLeadSourceSeikouJireiKyouyuSeminor, lead.ZireiSeminarId__c, lead, cmpMbInsetList);
            //アカデミー
            addCampaignMember(system.label.LeadLeadSourceAcademy, lead.AcademySeminarKihonId__c, lead, cmpMbInsetList);
            //アカデミー
            addCampaignMember(system.label.LeadLeadSourceAcademy, lead.AcademySeminarAdvanceId__c, lead, cmpMbInsetList);

            // インバウンドフラグON
            system.debug('***** lead.LeadCategoryAccount__c:' + lead.LeadCategoryAccount__c);
            if (accIdMap.containsKey(lead.LeadCategoryAccount__c)) {
                Account ac = accIdMap.get(lead.LeadCategoryAccount__c);
                setProhibitedApproach(ac);
                accUpdateMap.put(ac.Id, ac);
            }
        }

        if (!cmpMbInsetList.isEmpty()) {
            insert cmpMbInsetList;
        }

        if (!accUpdateMap.isEmpty()) {
            update accUpdateMap.values();
        }

    }

    /**
     * フォロー優先度の設定
     * @param ledNewList リードリスト(トリガー無効データ除くtrriger.new)
     */
    public void setFollowPriority(List<Lead> ledNewList){

        if (ledNewList.isEmpty()) return;

        for (Lead led : ledNewList) {
            Lead resultLead = checkFollowPriority(led, 'Lead');
            led.follow_priority__c = resultLead.follow_priority__c;
        }
    }

    /**
     * フォロー優先度の設定（リードのチェック）
     * @param Lead
     * @return Lead
     */
    public Lead checkFollowPriority(Lead chechLead, String objName){
        Lead resultLead = chechLead;
        system.debug('resultLead.follow_priority__c========'+resultLead.follow_priority__c);
        // フォロー優先度 高
        if(objName.equals('Lead')){
            if( resultLead.mkto2__Lead_Score__c >= 70 ){
                resultLead.follow_priority__c = '高';
            }
        }else if(objName.equals('CampaignMember')){
            // マルケトLead Scoreを無視するために、一度フォロー優先度を初期化
            resultLead.follow_priority__c = null;
            system.debug('resultLead.follow_priority__c========null????'+resultLead.follow_priority__c);
        }
        // フォロー優先度 高
        if (
            ('新たに採用支援サービスの選定を行っている'.equals(resultLead.AdoptionSupportService__c) || '新たに採用支援サービスの利用を検討しており、情報収集をしている'.equals(resultLead.AdoptionSupportService__c))
            ||'BtoBサイトWeb問い合わせリードソース'.equals(resultLead.LeadSource)
            ||'BtoBサイトWeb無料デモリードソース'.equals(resultLead.LeadSource)
            ||'キャリアトレックお問い合わせ'.equals(resultLead.LeadSource)
            ||'【マス広告】BtoBサイト連動LP'.equals(resultLead.LeadSource)
            ||'【マス広告】BtoBサイトお問い合わせ'.equals(resultLead.LeadSource)
            ||'【マス広告】BtoBサイト無料デモ'.equals(resultLead.LeadSource)
        ) {
            // 上記各行いずれかの条件一致でフォロー優先度を'高'に設定する
            resultLead.follow_priority__c = '高';
        // フォロー優先度 中
        }else if(
            !'新たに採用支援サービスの選定を行っている'.equals(resultLead.AdoptionSupportService__c) && !'新たに採用支援サービスの利用を検討しており、情報収集をしている'.equals(resultLead.AdoptionSupportService__c)&&(
                     '自社セミナー'.equals(resultLead.LeadSource)
                ||   'BtoBサイトWeb資料請求リードソース'.equals(resultLead.LeadSource)
                ||   'BtoBサイトWeb導入実績DLリードソース'.equals(resultLead.LeadSource)
                ||   'BtoBサイトWebセミナー申し込みリードソース'.equals(resultLead.LeadSource)
                ||   '定例セミナー（ダイレクトリクルーティングセミナー）'.equals(resultLead.LeadSource)
                ||   '定例セミナー（成功事例共有セミナー）'.equals(resultLead.LeadSource)
            )
        ){
            // 上記各行いずれかの条件一致でフォロー優先度を'中'に設定する
            resultLead.follow_priority__c = '中';
        // フォロー優先度 低
        }else if(
            !'新たに採用支援サービスの選定を行っている'.equals(resultLead.AdoptionSupportService__c) && !'新たに採用支援サービスの利用を検討しており、情報収集をしている'.equals(resultLead.AdoptionSupportService__c)&&(
                     '日本の人事部'.equals(resultLead.LeadSource)
                ||   'HRPRO'.equals(resultLead.LeadSource)
                ||   '外部セミナー'.equals(resultLead.LeadSource)
                ||   '展示会'.equals(resultLead.LeadSource)
                ||   'BtoBサイト採用白書ダウンロードリードソース'.equals(resultLead.LeadSource)
                ||   'BtoBサイトWeb求人特集リードソース'.equals(resultLead.LeadSource)
                ||   'HRカンファレンス2013'.equals(resultLead.LeadSource)
                ||   'HRカンファレンス2013秋（東京）'.equals(resultLead.LeadSource)
                ||   '外部アライアンス'.equals(resultLead.LeadSource)
                ||   'ダウンロード'.equals(resultLead.LeadSource)
                ||   'HR Review'.equals(resultLead.LeadSource)
                ||   'メール'.equals(resultLead.LeadSource)
                ||   'キャリトレ資料DL'.equals(resultLead.LeadSource)
                ||   '自社セミナー(会える人事)'.equals(resultLead.LeadSource)
            )
        ){
            // 上記各行いずれかの条件一致でフォロー優先度を'低'に設定する
            resultLead.follow_priority__c = '低';
        }
        return resultLead;
    }



    /**
     * キャンペーンメンバー追加(ドメイン検索)
     * @param domainSet リードのメール項目から抽出したドメイン Set<String>
     * @return List<Account> 取引先リスト
     */
    private List<Account> selectAccountListDomain(Set<String> domainSet){
	    return [SELECT a.Id, a.Name, a.Owner.LastName, a.Owner.FirstName, a.BillingState,
	    		a.BillingCity, a.BillingStreet, a.Field1__c, a.last_visit_date__c,
	    		a.WebsiteDomain__c, a.Field107__c, a.OwnerId,
	    		a.company_contract__c, a.CrsSales_RepresentativeMain__c,
	    		(SELECT o.Id, o.VisitChargeUser__c
	    		  FROM Opportunities o
	    		  WHERE o.VisitCompletion__c = true ORDER BY o.VisitDate__c DESC LIMIT 1)
	    		FROM Account a
	    		WHERE WebsiteDomain__c IN :domainSet AND a.AccountType__c = 'CRS'];
    }

    /**
     * キャンペーンメンバー追加(ドメイン検索)
     * @param acIdSet リードのリード分類時引き当て取引先項目（取引先参照） Set<String>
     * @return List<Account> 取引先リスト
     */
    private List<Account> selectAccountListAccountId(Set<String> acIdSet){
	    return [SELECT a.Id, a.Name, a.Owner.LastName, a.Owner.FirstName, a.BillingState,
	    		a.BillingCity, a.BillingStreet, a.Field1__c, a.last_visit_date__c,
	    		a.WebsiteDomain__c, a.Field107__c, a.OwnerId,
	    		a.company_contract__c, a.CrsSales_RepresentativeMain__c,
	    		(select o.id, o.VisitChargeUser__c
	    		  FROM Opportunities o
	    		  WHERE o.VisitCompletion__c = true ORDER BY o.VisitDate__c DESC LIMIT 1)
	    		FROM Account a
	    		WHERE a.Id IN :acIdSet AND a.AccountType__c = 'CRS'];
    }

    /**
     * キャンペーンメンバー追加(ドメイン検索)
     * @param domainSet リードのメール項目から抽出したドメイン Set<String>
     * @return List<Contact> 取引先リスト
     */
    private List<Contact> selectContactListDomain(Set<String> domainSet){
	    return [SELECT c.Id, c.Email, c.CreatedDate, c.EMaildomain__c, a.Id, a.Name,
	    		a.Owner.LastName, a.Owner.FirstName, a.BillingState, a.BillingCity,
	    		a.BillingStreet, a.Field1__c, a.last_visit_date__c, a.WebsiteDomain__c,
	    		a.Field107__c, a.OwnerId, a.company_contract__c,
	    		a.CrsSales_RepresentativeMain__c,
	    		(SELECT o.Id, o.VisitChargeUser__c
	    		  FROM Opportunities o
	    		  WHERE o.VisitCompletion__c = true ORDER BY o.VisitDate__c DESC LIMIT 1)
	    		FROM Contact c, Contact.Account a
	    		WHERE c.EMaildomain__c IN :domainSet AND a.AccountType__c = 'CRS'];
    }

    /**
     * リード分類振り分け処理
     * @param acc 取引先
     * @param lead リード
     * @param contactMap Emailがキーの取引先責任者マップ
     * @param contactMap2 Emailドメイン+会社名がキーの取引先責任者マップ
     * @param contactMap3 Emailドメインがキーの取引先責任者マップ
     * @param domainMap Webサイトドメインがキーの取引先マップ
     * @return リードのEmailアドレスがプライベートアドレスの場合：false、それ以外の場合：true
     */
    private boolean divideCategory(Account acc, Lead lead, Map<String, Contact> contactMap,
        Map<String, Contact> contactMap2, Map<String, Contact> contactMap3, Map<String, Account> domainMap) {

        system.debug('***** lead.Email : ' + lead.Email);
        if (String.isBlank(lead.lead_category__c)) {

            if (String.isNotBlank(lead.Email)) {
                // 取引先責任者のメールアドレス完全一致で判定
                Contact con = contactMap.get(lead.Email);
                if (con != null) {
                    acc = con.Account;
                    Datetime ctCreateddate = con.CreatedDate;
                    Datetime ldCreateddate = lead.CreatedDate != null ? lead.CreatedDate : Datetime.now();
                } else {
                    if (!UTL_EmailUtil.isPrivateEmailAddress(lead.Company, lead.Email)) {
                        // 取引先のWebサイトドメイン、取引先責任者のEmailドメイン+会社名、取引先責任者のEmailドメインの順で振り分け
                        String domainStr = UTL_EmailUtil.splitEmailDomain(lead.Email);
                        system.debug('***** domainStr : ' + domainStr);
                        acc = searchAccountForDomain(domainMap, contactMap2, contactMap3, domainStr, lead);
                    } else {
                        // プライベートアドレスの場合は未分類として振り分け
                        lead.lead_category__c = system.label.Leadlead_categoryMibunrui;
                        lead.LeadCategoryAccount__c = null;
                        return false;
                    }
                }

                if (acc == null) {
                    // 取引先が割り当たらなかった場合は新規リードを設定
                    lead.lead_category__c = system.label.Leadlead_categoryShinkilead;
                    lead.LeadCategoryAccount__c = null;
                } else {
                    lead.LeadCategoryAccount__c = acc.Id;
                    lead.lead_category__c = getLeadCategory(acc, lead);
                }

            } else {
                // Emailアドレスが未入力の場合は未分類を設定
                lead.lead_category__c = system.label.Leadlead_categoryMibunrui;
                lead.LeadCategoryAccount__c = null;
            }

        }
        return true;
    }

    /**
     * 所有者振り分け処理
     * リードの紐づいているアカウントがあるかどうか、紐付けがあれば、アカウントの状態によってリード所有者振り分けを行う
     * @param acc 取引先
     * @param lead リード
     * @param acIdMap 取引先マップ
     * @param isUpdate 更新かどうか
     * 2016/04/11 現ISチームでは不要なため、コメントアウト実施
     */
     /*
    private void divideOwner(Account acc, Lead lead, Map<Id, Account> acIdMap, Map<Id, User> userIdMap,
        String oldOwnerId, Integer listSize, boolean isUpdate) {

        if (acc == null && String.isNotBlank(lead.LeadCategoryAccount__c)) {
            acc = acIdMap.get(lead.LeadCategoryAccount__c);
        }
        system.debug('***** acc : ' + acc);

        String salesType = 'SR';
        if ('BtoBサイトWeb問い合わせリードソース'.equals(lead.LeadSource)
            || 'BtoBサイトWeb無料デモリードソース'.equals(lead.LeadSource) || 'BtoBサイトWeb資料請求リードソース'.equals(lead.LeadSource)) {
            salesType = 'DRC';
        }

        // 住所判定
        String addr = String.isNotBlank(lead.State) ? lead.State : '';
        addr = addr + (String.isNotBlank(lead.City) ? lead.City : '');
        String statecity = addr;
        addr = addr + (String.isNotBlank(lead.Street) ? lead.Street : '');

        if (String.isBlank(addr) && acc != null) {
            addr = String.isNotBlank(acc.BillingState) ? acc.BillingState : '';
            addr = addr + (String.isNotBlank(acc.BillingCity) ? acc.BillingCity : '');
            statecity = addr;
            addr = addr + (String.isNotBlank(acc.BillingStreet) ? acc.BillingStreet : '');
        }
        system.debug('***** addr : ' + addr);

        if (String.isNotBlank(addr) && listSize == 1) {
            // 振り分けロール前処理起動
            AddressAndTeritoryMatchLogic AATML = new AddressAndTeritoryMatchLogic(statecity);
            String teritory = AATML.matchAddressAndTeritoryLead(addr);
            lead.classifiedLabel__c = teritory;
            system.debug('***** lead.classifiedLabel__c : ' + lead.classifiedLabel__c);
        }

        // 更新時にトリガー実行される場合未振り分けなら広域チームへ振り分ける
        if (isUpdate && lead.TriggerAssignmentExecuteFlg__c && String.isNotBlank(lead.classifiedLabel__c) && lead.classifiedLabel__c.equals('未振り分けリード')) {
            lead.classifiedLabel__c = '広域';
        }

        if (acc != null && 'DRC'.equals(salesType)) {
            if ('契約中'.equals(lead.lead_category__c) || '未契約（契約なし）'.equals(lead.lead_category__c) || '未契約（過去契約あり）'.equals(lead.lead_category__c)) {
                //引き当てた取引先の担当運用を割り当て
                String newId = UTL_CommonUtil.searchUserId(acc.CrsSales_RepresentativeMain__c, userIdMap);
                system.debug('***** newId : ' + newId);
                if (String.isNotBlank(newId) && !newId.equals(oldOwnerId)) {
                    lead.OwnerId = newId;
                    lead.classifiedFlg__c = true;
                    system.debug('***** lead.OwnerId : ' + lead.OwnerId);
                }
            } else if('未契約（直近3ヶ月訪問あり）'.equals(lead.lead_category__c)) {
                List<Opportunity> oppList = acc.Opportunities;
                if (oppList != null && !oppList.isEmpty()) {
                    Opportunity opp = oppList.get(0);
                    if (opp != null) {
                        String newId = opp.VisitChargeUser__c;
                        system.debug('***** newId:' + newId);
                        if(String.isNotBlank(newId) && !newId.equals(oldOwnerId)){
                            lead.Ownerid = newId;
                            lead.classifiedFlg__c = true;
                            system.debug('***** lead.OwnerId : ' + lead.OwnerId);
                        }
                    }
                }
            }
        }
        lead.SendMailFlg__c = false;
    }
    */

    /**
     * ドメインから取引先を検索
     * @domainMap リードのメールアドレスから取引先URLドメインとマッチングして抽出した取引先マップ
     * @contactMap2 リードのメールアドレスから取引先担当者メールアドレスドメイン取引先名とマッチングして抽出した取引先マップ
     * @contactMap3 リードのメールアドレスから取引先担当者メールアドレスドメインとマッチングして抽出した取引先マップ
     * @domainStr 検索対象ドメイン
     * @return ヒットした取引先
     */
    private Account searchAccountForDomain(Map<String, Account> domainMap, Map<String, Contact> contactMap2, Map<String, Contact> contactMap3, String domainStr, Lead lead) {
        // 1.取引先のWebサイトドメインで取引先を検索
        Account acc = domainMap.get(domainStr);
        if (acc == null) {
            String comNm = UTL_CommonUtil.replaceCompanyName(lead.Company);
            // 2.取引先責任者のEmailドメイン+会社名で取引先を検索
            Contact con = contactMap2.get(domainStr + comNm);
            if (con != null) {
                acc = con.Account;
            }
            if (acc == null) {
                // 3.取引先責任者のEmailドメインで取引先を検索
                con = contactMap3.get(domainStr);
                if (con != null) {
                    acc = con.Account;
                }
            }
        }
        return acc;
    }

    /**
     * 取引先のCRS_契約状態・直近訪問日からリード分類を決定する
     * @param acc 取引先
     * @param lead リード
     * @param リード分類
     */
    private String getLeadCategory(Account acc, Lead lead) {

        system.debug('***** acc.company_contract__c : ' + acc.company_contract__c);
        system.debug('***** acc.last_visit_date__c : ' + acc.last_visit_date__c);

        if ('契約中'.equals(acc.company_contract__c) || '契約終了１ヶ月前'.equals(acc.company_contract__c)) {
            return '契約中';
        } else if ('契約なし'.equals(acc.company_contract__c)) {
            return '未契約（契約なし）';
        } else {
            Datetime crd = lead.CreatedDate == null ? DateTime.Now() - 90 : lead.CreatedDate - 90;
            if (acc.last_visit_date__c > crd) {
                return '未契約（直近3ヶ月訪問あり）';
            }
            crd = lead.CreatedDate == null ? DateTime.Now() - 180 : lead.CreatedDate - 180;
            if (acc.last_visit_date__c > crd) {
                return '未契約（直近6ヶ月訪問あり）';
            }
            return '未契約（過去契約あり）';
        }

    }

    /**
     * キャンペーンメンバー追加
     * @param leadSource メンバー追加対象リードソース名
     * @param campaignId キャンペーンID
     * @param led リード
     * @param cmpMbInsetList 登録用キャンペーンメンバーリスト
     */
    private void addCampaignMember(String leadSource, String campaignId, Lead led, List<CampaignMember> cmpMbInsetList) {
        if (led.LeadSource == leadSource && String.isNotBlank(campaignId)) {
            cmpMbInsetList.add(new CampaignMember(CampaignId = campaignId, LeadId = led.Id));
        }
    }

}