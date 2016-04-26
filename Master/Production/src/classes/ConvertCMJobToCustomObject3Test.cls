@isTest
private class ConvertCMJobToCustomObject3Test {

	public static testMethod void testBatch() {
    	Account ac = new Account(name = 'TEST', Phone = '03-3333-3333', Field221__c = 'インターネットサービス', BillingState = '東京都', BillingCity = '千代田区', BillingStreet = 'xxx');
    	insert ac;

		CompetingMediumJob__c cmj = new CompetingMediumJob__c();
		cmj.Medium__c = 'イーキャリア';
		cmj.DBID__c = '';
		cmj.AcquisitionDate__c = Date.newInstance(2014, 1, 19);
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

		List <CompetingMediumJob__c> cmjs = new List<CompetingMediumJob__c>();
		for(integer i = 0; i < 10; i++){
			CompetingMediumJob__c a = cmj.clone();
			a.CompanyName__c = 'TEST' + (i+1);
			cmjs.add(a);
		}
		for(integer i = 0; i < 10; i++){
			CompetingMediumJob__c a = cmj.clone();
			a.CompanyName__c = 'TEST' + (i+1);
			cmjs.add(a);
		}

		insert cmjs;

		ConvertCMJobToCustomObject3 testBatch = new ConvertCMJobToCustomObject3();
		testBatch.query = 'SELECT DBID__c, Url__c, DataImportFlg__c, Other__c, Email__c, Qualifications__c, CompanyName__c, CompanyNameCl__c, CompanyNameKana__c, Salary__c, JobIndustry__c, Workplace__c, PublicationUrl__c, PublicationPeriod__c, PublicationUpdDate__c, PublicationCompanyName__c, Medium__c, AdvertisementSize__c, AdvertisementImage__c, kingaku__c, ContactName__c, ChargePost__c, JobDescription__c, Description__c, AcquisitionDate__c, City__c, Street__c, EmployeeNumber__c, JobCategory__c, JobCategorySub__c, EstablishmentYear__c, Phone__c, State__c, Sales__c, Department__c, WantedJobCategory__c, ZipCode__c, Charge__c FROM CompetingMediumJob__c WHERE DataImportFlg__c = false';
		ID batchprocessid = Database.executeBatch(testBatch);

	}
}