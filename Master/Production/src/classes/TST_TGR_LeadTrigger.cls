/**
 * TST_TGR_LeadTrigger
 *
 * テスト対象
 * 1.TGR_LeadTrigger
 * 2.LED_LeadProcess
 * 3.LED_ConvertFromLeadToAccount
 * ----------------------------------------
 * @createdName      : Y.Yamamoto
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
@isTest
private class TST_TGR_LeadTrigger {

    @testSetUp
    static void setUp() {

        UserRole userRole = new UserRole(name = '企画室');
        insert userRole;
        User user = new User(LastName = 'TEST1', FirstName = 'TEST1', Username = 'test1@sutead.com', Email = 'yamamoto@sutead.com', Alias = 'test1', CommunityNickname = 'test1', TimeZoneSidKey = 'Asia/Tokyo', LocaleSidKey = 'ja_JP', EmailEncodingKey = 'ISO-2022-JP', ProfileId = '00e10000000WniU', LanguageLocaleKey = 'ja');
        insert user;

    }

    static testMethod void testLeadTriggerInsert() {

        insertSettingObjects();
        User user = findUser().get(0);
        Account ac = findAccount().get(0);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){

            // 人材採用塾連携のテスト
            Campaign c1 = new Campaign(name='1');
            Campaign c2 = new Campaign(name='1');
            Campaign c3 = new Campaign(name='1');
            List<Campaign> cpList = new Campaign[] { c1, c2, c3 };
            insert cpList;

            Lead lead1 = new Lead(Company = '株式会社山本テスト', state = '東京都', city = '千代田区', lastName = '山本', firstName = '雄二', status = '新規', email = 'yamamoto1@sutead.com', OwnerId = user.id, LeadSource = system.label.LeadLeadSourceDirectRecruitingSeminor, BasicSeminarCourse1Id__c = c1.Id, BasicSeminarCourse2Id__c = c2.Id, BasicSeminarCourse3Id__c = c3.Id);
            Lead lead2 = new Lead(Company = '株式会社祖川テスト2', state = '東京都', city = '千代田区', lastName = '祖川', firstName = '慎治', status = '新規', email = 'shinjisogawa@sutead.com', OwnerId = user.id, LeadSource = system.label.LeadLeadSourceSeikouJireiKyouyuSeminor, BasicSeminarCourse1Id__c = c1.Id, BasicSeminarCourse2Id__c = c2.Id, BasicSeminarCourse3Id__c = c3.Id);
            Lead lead3 = new Lead(Company = '株式会社祖川テスト3', state = '東京都', city = '千代田区', lastName = '祖川', firstName = '慎治', status = '新規', email = 'shinjisogawa@sutead2.com', OwnerId = user.id, LeadSource = system.label.LeadLeadSourceAcademy, BasicSeminarCourse1Id__c = c1.Id, BasicSeminarCourse2Id__c = c2.Id, BasicSeminarCourse3Id__c = c3.Id);
            Lead lead4 = new Lead(Company = '株式会社山本テスト4', state = 'てすとてすと', city = 'てすと市', lastName = '山本', firstName = '雄二', status = '新規', email = 'yamamoto@sutead.com', OwnerId = user.id, LeadSource = system.label.LeadLeadSourceDirectRecruitingSeminor, BasicSeminarCourse1Id__c = c1.Id, BasicSeminarCourse2Id__c = c2.Id, BasicSeminarCourse3Id__c = c3.Id);

            List<Lead> insertLead = new Lead[] { lead1, lead2, lead3, lead4 };

            Test.startTest();
            insert insertlead;
            Test.stopTest();

            List<Lead> newLeads = [SELECT Id, OwnerId, classifiedLabel__c, classifiedFlg__c FROM Lead WHERE Id = :lead1.Id];
            system.debug('************ newLead:' + newLeads[0]);

        }

    }

    static testMethod void testLeadTriggerUpdate() {
        insertSettingObjects();
        User user = findUser().get(0);
        Account ac = findAccount().get(0);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){

            CompetingMediumJob__c cmj = new CompetingMediumJob__c();
            cmj.Medium__c = 'イーキャリア';
            cmj.DBID__c = '';
            cmj.AcquisitionDate__c = Date.today();
            cmj.PublicationPeriod__c = '2013/12/30';
            cmj.PublicationUpdDate__c = '2013/12/30';
            cmj.CompanyName__c = 'TEST';
            cmj.CompanyNameCl__c = 'イエローテイルズ株式会社';
            cmj.CompanyNameKana__c = '';
            cmj.Department__c = '';
            cmj.PublicationCompanyName__c = '';
            cmj.JobCategory__c = 'オープン・Web系';
            cmj.JobCategorySub__c = 'データベースSE(オープン・Web系)';
            cmj.WantedJobCategory__c = 'ネットワーク／サーバー構築・運用エンジニア（未経験者歓迎）';
            cmj.ZipCode__c = '101-0024';
            cmj.State__c = '東京都';
            cmj.City__c = '千代田区';
            cmj.Street__c = '神田和泉町１－１－１４';
            cmj.Other__c = 'パシフィックビル７Ｆ';
            cmj.Phone__c = '';
            cmj.ChargePost__c = '';
            cmj.ContactName__c = '';
            cmj.Email__c = '';
            cmj.Url__c = '';
            cmj.JobIndustry__c = '';
            cmj.Description__c = '弊社のサービスポリシーは「技術力＋マーケティング力の両立」です。 3つのサービスと自社オリジナルの集客･PRソリューションで 顧客のWeb戦略を徹底的にサポートする事が可能な体制を構築しています。 1.システムインテグレーションサービス 　･システム設計／開発 　･WEBサイト企画／設計 　･インフラ設計／構築 　･システム運用保守／ユーザーサポート 2.Webサイト品質チェックサービス 　･WebサイトUI/UXテスト 　･携帯･スマートフォン実機テスト 　･ユーザビリティ調査サービス 3.Webマーケティングサービス 　･総合WEBコンサルティング 　･インターネット集客ソリューション ･SEM／SEO／LPO／EFO 4.YTオリジナルサービス 　･O2O集客ソリューション 　･Cubsプロモーション 　･Tech-MaMa';
            cmj.EstablishmentYear__c = '2012年';
            cmj.Qualifications__c = 'WebシステムにおけるITインフラ（ネットワーク／サーバー）の設計・構築、もしくは運用・暗視の経験が1年以上ある方。コールセンターにてオペレーターの経験がある方。';
            cmj.Workplace__c = '東京都千代田区神田和泉町1-1-14　パシフィックビル7F ※この仕事はクライアント先企業での常駐勤務となる場合があります。';
            cmj.JobDescription__c = '◎増大するトラフィックを支えるインフラの構築または運用をお任せします！ 弊社の顧客は、大規模Webサービス企業から中規模エンドユーザーが多く、 企画、開発、運用、プロモーション等、様々なフェーズに弊社が関わっています。 その中でも、非常に重要なのが、増大するトラフィックに対応するエンジニアの存在。 スマートフォンやクラウドが今後益々普及して行く中で、 トラフィックをどの様に捌くかという課題は、業界全体が試行錯誤しています。 インフラ系エンジニアが最も力を発揮できるインターネット市場で、あなたのスキルを存分に発揮して下さい！ 【業務内容】 ○ネットワークの設計・構築 ○Windows、UNIX、Linuxサーバーの構築 ○セキュリティシステムの導入・設計・構築 ○データベースの導入・設計・構築 【具体的な仕事内容】 ◎お客様のインフラ担当部署の代表として、事業側に席を設けてWebサービス構築を行う。 ◎70台のWindows、Linuxのサーバのインストール、初期パラメータの設定 大手ポータルサイトのネットワークの構築・設計や中・小規模の エンドユーザー様のインフラのサーバ設計・構築、弊社が運営している Webサイトのインフラ運用といったプロジェクトなど、インフラエンジニアとして 成長出来る環境が整っています。 入社後の一ヶ月間は 能力・経験により異なりますが、入社後一ヶ月は、会社を良く知って頂く期間として 代表を始め、役員、社員との交流を深める場を多く設けます。又、自社サービスの説明や、 最新のテクノロジー、トレンド、マーケティングについて講義を行います。 達成感を感じる瞬間 これは、ずばり「お客様に喜んで頂き、有り難うの一言を頂いた時」になります。 私達はお客様に喜ばれるシステムやソリューションを提供する「サービス業」ですので、 お客様に喜んで頂けるサービスを提供出来た時に、最も達成感を感じられます。 この仕事の大変なところ インターネット、ITの世界は「ドッグイヤー※」と呼ばれており、変化のスピードが速く、常にトップを維持するのがとても大変な業界です。常に情報収集をしていないと遅れを取ってしまう事に大変さを感じます。 ※ドッグイヤー：成長の速い犬にとっての1年は人間の7年に相当するという意味';
            cmj.AdvertisementSize__c = 'スタンダード';
            cmj.Charge__c = 400000;
            cmj.PublicationUrl__c = 'http://www.ecareer.ne.jp/ecareer.ShigotoInfoServlet?CORPCD=00038659001&JOBSEQ=4';
            cmj.AdvertisementImage__c = '';
            cmj.Salary__c = '月給35万円～　交通費・残業代別途支給 ※前職及び、年齢・経験・能力を考慮の上、決定いたします。';
            cmj.DataImportFlg__c = false;
            cmj.account__c = ac.id;
            insert cmj;
            system.debug('***************** cmj:' + cmj);

            // 取引先担当者連携のテスト
            Lead lead = new Lead(Company = 'TEST', lastName = 'T1', firstName = 'T1', status = '新規', LeadSource = '日本の人事部');
            insert lead;

            lead.Status = '評価済み';
            lead.Company = 'TEST2';

            Test.startTest();
            update lead;

            lead.TriggerInvalid__c = true;
            update lead;

            Test.stopTest();

            cmj = [SELECT CompanyName__c FROM CompetingMediumJob__c WHERE Id = :cmj.Id];
            System.debug('***************** cmj:' + cmj);

            system.assert(![SELECT Id, TriggerInvalid__c FROM Lead WHERE Id = :lead.Id].TriggerInvalid__c);
        }

    }

    /**
     * 取引開始テスト
     */
    static testMethod void testLeadConvert() {

        insertSettingObjects();
        CompetingMediumJob__c cmj = new CompetingMediumJob__c(CompanyName__c = 'TEST1', UqName__c = 'TEST1', Account__c = findAccount().get(0).Id);
        insert cmj;

        // Lead led1 = new Lead(Company = 'TEST1', lastName = 'T1', firstName = 'T1', status = '新規', LeadSource = '他社媒体掲載ピックアップリード');
        Lead led2 = new Lead(Company = 'TEST2', lastName = 'T2', firstName = 'T2', status = '新規', LeadSource = 'BtoBサイトWeb問い合わせリードソース');
        Lead led3 = new Lead(Company = 'TEST3', lastName = 'T3', firstName = 'T3', status = '新規', LeadSource = 'BtoBサイトWeb資料請求リードソース');
        Lead led4 = new Lead(Company = 'TEST4', lastName = 'T4', firstName = 'T4', status = '新規', LeadSource = 'BtoBサイトWeb資料請求リードソース');
        Lead led5 = new Lead(Company = 'TEST5', lastName = 'T5', firstName = 'T5', status = '新規', LeadSource = system.label.LeadLeadSourceAcademy);
        Lead led6 = new Lead(Company = 'TEST6', lastName = 'T6', firstName = 'T6', status = '新規', LeadSource = system.label.LeadLeadSourceDirectRecruitingSeminor);
        Lead led7 = new Lead(Company = 'TEST7', lastName = 'T7', firstName = 'T7', status = '新規', LeadSource = system.label.LeadLeadSourceSeikouJireiKyouyuSeminor);
        // Lead led8 = new Lead(Company = 'TEST8', lastName = 'T8', firstName = 'T8', status = '新規', LeadSource = 'ESS媒体');
        // Lead led9 = new Lead(Company = 'TEST9', lastName = 'T9', firstName = 'T9', status = '新規', LeadSource = 'ESS労働局');
        // List<Lead> ledList = new Lead[] { led1, led2, led3, led4, led5, led6, led7, led8, led9 };
        List<Lead> ledList = new Lead[] { led2, led3, led4, led5, led6, led7 };
        insert ledList;

        String mlabel = findLeadStatus().MasterLabel;

        List<Database.LeadConvert> convertList = new List<Database.LeadConvert>();

        for (Lead led : ledList) {
            Database.LeadConvert convert = new Database.LeadConvert();
            convert.setLeadId(led.Id);
            convert.setConvertedStatus(mlabel);
            convertList.add(convert);
        }


        Test.startTest();
        List<Database.LeadConvertResult> resultList = Database.convertLead(convertList);
        Test.stopTest();

        for (Database.LeadConvertResult result : resultList) {
            system.assert(result.isSuccess());
        }

    }

    /**
     * フォロー優先度のテスト
     */
    static testMethod void setFollowPriority() {

        Lead led1 = new Lead(Company = 'TEST1', lastName = 'T1', firstName = 'T1', status = '新規', LeadSource = '日本の人事部', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led2 = new Lead(Company = 'TEST2', lastName = 'T2', firstName = 'T2', status = '新規', LeadSource = 'HRPRO', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led3 = new Lead(Company = 'TEST3', lastName = 'T3', firstName = 'T3', status = '新規', LeadSource = 'BtoBサイトWeb問い合わせリードソース');
        Lead led4 = new Lead(Company = 'TEST4', lastName = 'T4', firstName = 'T4', status = '新規', LeadSource = 'BtoBサイト採用白書ダウンロードリードソース', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led5 = new Lead(Company = 'TEST5', lastName = 'T5', firstName = 'T5', status = '新規', LeadSource = 'BtoBサイトWeb導入実績DLリードソース', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led6 = new Lead(Company = 'TEST6', lastName = 'T6', firstName = 'T6', status = '新規', LeadSource = 'BtoBサイトWeb無料デモリードソース');
        Lead led7 = new Lead(Company = 'TEST7', lastName = 'T7', firstName = 'T7', status = '新規', LeadSource = 'キャリアトレックお問い合わせ');
        Lead led8 = new Lead(Company = 'TEST8', lastName = 'T8', firstName = 'T8', status = '新規', LeadSource = '外部アライアンス', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led9 = new Lead(Company = 'TEST9', lastName = 'T9', firstName = 'T9', status = '新規', LeadSource = 'ダウンロード', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led10 = new Lead(Company = 'TEST10', lastName = 'T10', firstName = 'T10', status = '新規', LeadSource = 'HR Review', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led11 = new Lead(Company = 'TEST11', lastName = 'T11', firstName = 'T11', status = '新規', LeadSource = 'メール', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led12 = new Lead(Company = 'TEST12', lastName = 'T12', firstName = 'T12', status = '新規', LeadSource = '定例セミナー（成功事例共有セミナー）');
        Lead led13 = new Lead(Company = 'TEST13', lastName = 'T13', firstName = 'T13', status = '新規', LeadSource = 'キャリトレ資料DL', AdoptionSupportService__c = '新たに採用支援サービスの選定を行っている');
        Lead led14 = new Lead(Company = 'TEST14', lastName = 'T14', firstName = 'T14', status = '新規', LeadSource = '【マス広告】BtoBサイト連動LP');
        Lead led15 = new Lead(Company = 'TEST15', lastName = 'T15', firstName = 'T15', status = '新規', LeadSource = '【マス広告】BtoBサイトお問い合わせ');
        Lead led16 = new Lead(Company = 'TEST16', lastName = 'T16', firstName = 'T16', status = '新規', LeadSource = '【マス広告】BtoBサイト無料デモ');
        Lead led17 = new Lead(Company = 'TEST17', lastName = 'T17', firstName = 'T17', status = '新規', LeadSource = 'BtoBサイトWeb資料請求リードソース');
        Lead led18 = new Lead(Company = 'TEST18', lastName = 'T18', firstName = 'T18', status = '新規', LeadSource = 'BtoBサイトWebセミナー申し込みリードソース');
        Lead led19 = new Lead(Company = 'TEST19', lastName = 'T19', firstName = 'T19', status = '新規', LeadSource = '定例セミナー（ダイレクトリクルーティングセミナー）');
        Lead led20 = new Lead(Company = 'TEST20', lastName = 'T20', firstName = 'T20', status = '新規', LeadSource = '外部セミナー');
        Lead led21 = new Lead(Company = 'TEST21', lastName = 'T21', firstName = 'T21', status = '新規', LeadSource = '展示会');
        Lead led22 = new Lead(Company = 'TEST22', lastName = 'T22', firstName = 'T22', status = '新規', LeadSource = 'BtoBサイトWeb求人特集リードソース');
        Lead led23 = new Lead(Company = 'TEST23', lastName = 'T23', firstName = 'T23', status = '新規', LeadSource = 'HRカンファレンス2013');
        Lead led24 = new Lead(Company = 'TEST24', lastName = 'T24', firstName = 'T24', status = '新規', LeadSource = 'HRカンファレンス2013秋（東京）');
        Lead led25 = new Lead(Company = 'TEST25', lastName = 'T25', firstName = 'T25', status = '新規', LeadSource = '自社セミナー(会える人事)');
        Lead led26 = new Lead(Company = 'TEST26', lastName = 'T26', firstName = 'T26', status = '新規', LeadSource = '自社セミナー');
        Lead led27 = new Lead(Company = 'TEST27', lastName = 'T27', firstName = 'T27', status = '新規', LeadSource = '日本の人事部', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led28 = new Lead(Company = 'TEST28', lastName = 'T28', firstName = 'T28', status = '新規', LeadSource = 'HRPRO', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led29 = new Lead(Company = 'TEST29', lastName = 'T29', firstName = 'T29', status = '新規', LeadSource = 'BtoBサイト採用白書ダウンロードリードソース', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led30 = new Lead(Company = 'TEST30', lastName = 'T30', firstName = 'T30', status = '新規', LeadSource = 'BtoBサイトWeb導入実績DLリードソース', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led31 = new Lead(Company = 'TEST31', lastName = 'T31', firstName = 'T31', status = '新規', LeadSource = '外部アライアンス', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led32 = new Lead(Company = 'TEST32', lastName = 'T32', firstName = 'T32', status = '新規', LeadSource = 'ダウンロード', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led33 = new Lead(Company = 'TEST33', lastName = 'T33', firstName = 'T33', status = '新規', LeadSource = 'HR Review', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led34 = new Lead(Company = 'TEST34', lastName = 'T34', firstName = 'T34', status = '新規', LeadSource = 'メール', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led35 = new Lead(Company = 'TEST35', lastName = 'T35', firstName = 'T35', status = '新規', LeadSource = 'キャリトレ資料DL', AdoptionSupportService__c = '新たに採用支援サービスを利用する予定はない');
        Lead led36 = new Lead(Company = 'TEST36', lastName = 'T36', firstName = 'T36', status = '新規', mkto2__Lead_Score__c = 70);

        List<Lead> ledList = new Lead[] { led1, led2, led3, led4, led5, led6, led7, led8, led9, led10, led11, led12, led13, led14, led15, led16, led17, led18, led19, led20, led21, led22, led23, led24, led25, led26,
        led27, led28, led29, led30, led31, led32, led33, led34, led35, led36 };
        Test.startTest();
        insert ledList;
        Test.stopTest();


    }


    private static List<User> findUser() {
        return [SELECT Id, Name, FirstName, LastName FROM User WHERE Username LIKE '%@sutead.com' ORDER BY Username];
    }

    private static List<Account> findAccount() {
        return [SELECT Id, Name FROM Account WHERE Name = 'Test Inc'];
    }

    private static LeadStatus findLeadStatus() {
        return [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
    }

    private static void insertSettingObjects(){
        User user = findUser().get(0);

        Account ac = new Account(name = 'Test Inc', Phone = '03-3333-3333', Field221__c = 'Internet', BillingState = '東京都', BillingCity = '港区', BillingStreet = '9-9-9');
        ac.Field1__c = '承認';
        ac.Website = 'http://sutead.com';
        ac.WebsiteDomain__c = 'sutead.com';
        ac.Field107__c = user.name;
        ac.OwnerId = user.id;
        insert ac;

        Contact ct1 = new Contact(AccountId = ac.id, lastname = '山本', firstname = '雄二', Email = 'yamamoto@sutead.com');
        insert ct1;

        Opportunity opt = new Opportunity();
        opt.AccountId = ac.Id;
        opt.Name = 'TEST';
        opt.StageName = 'TEST';
        opt.OwnerId = user.Id;
        opt.VisitChargeUser__c = user.Id;
        opt.CloseDate = Date.today();
        opt.VisitDate__c =  Date.today();
        opt.VisitCompletion__c = true;
        opt.sample_case__c = '*';
        opt.HiringPeriod__c = date.today();
        opt.Opportunity__c = '*';
        insert opt;
    }
}