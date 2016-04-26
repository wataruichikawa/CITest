/**
 * ACC_UpdateTegamiFromCA
 * ----------------------------------------
 * @createdName      : A.Tsuno
 * @lastModifiedName : A.Tsuno
 * ----------------------------------------
 */
public class ACC_UpdateTegamiFromCA {

      /**
       * CA依頼（手紙）より、手紙送付完了日を取引先に記録
       * @param tgmNewList CARequest__cリスト(トリガー無効データ除くtrriger.new)
       */
      public void updateTegamiDate(List<CARequest__c> tgmNewList) {
          final String tegamiRecordTypeId = System.Label.CA_Tegami_RecordtypeId;
          if (tgmNewList.isEmpty()) return;

          Set<String> tgmAccIdSet = new Set<String>();
          List<CARequest__c> tgmUpdList = new List<CARequest__c>();

          for (CARequest__c tgm : tgmNewList) {
              if (String.isNotBlank(tgm.Iraisya__c) && String.isNotBlank(tgm.Account__c) && String.isNotBlank(tgm.Status__c) && tgm.Status__c.equals('3.完了') && String.isNotBlank(tgm.CARequestItem__c) && tgm.CARequestItem__c.equals('15.手紙') && tgm.RecordTypeId.equals(tegamiRecordTypeId) && String.isNotBlank(tgm.letter_type__c)) {
                  tgmAccIdSet.add(tgm.Account__c);
                  if (tgm.Tegami_sofu_kanryobi__c == null){
                      CARequest__c ca = new CARequest__c(Id = tgm.Id, Tegami_sofu_kanryobi__c = System.Today(), TriggerInvalid__c = true);
                      tgmUpdList.add(ca);
                  }
              }
          }

          // 手紙のCA依頼を取得する
          if (!tgmAccIdSet.isEmpty()) {
              List<CARequest__c> tgmList = [SELECT Account__c, Iraisya__c,Tegami_sofu_kanryobi__c, letter_type__c, letter_Count__c FROM CARequest__c WHERE Status__c = '3.完了' AND Account__c != null AND Account__c IN :tgmAccIdSet AND CARequestItem__c = '15.手紙' AND RecordTypeId = :tegamiRecordTypeId];

                Map<Id, Account> acMap = new Map<Id, Account>();

                if (!tgmList.isEmpty()){
                    for (CARequest__c tg : tgmList){

                        Account ac = new Account();

                        // CA手紙依頼から取引先オブジェクトに必要項目をキャスト
                        if (String.isNotBlank(tg.Account__c)){
                            ac.Id = String.ValueOf(tg.Account__c);
                            if (tg.Tegami_sofu_kanryobi__c == null){
                                ac.chokkin_tegami_sofu_date__c = System.Today();
                            }else{
                                ac.chokkin_tegami_sofu_date__c = Date.ValueOf(tg.Tegami_sofu_kanryobi__c);
                            }
                            if (String.isNotBlank(tg.Iraisya__c)){
                                ac.chokkin_tegami_sofu_iraisya__c = String.ValueOf(tg.Iraisya__c);
                            }
                            ac.TriggerInvalid__c = true;
                            // Map内に同一取引先Idが存在しない場合
                            if (!acMap.containsKey(ac.Id)){
                                acMap.put(ac.Id, ac);
                            // Map内にすでに同一取引先Idが存在する場合
                            // 現AccountとMap内のAccountの手紙送付完了日の新旧を比較する >> 既存Map要素のAccountのほうが新しい日付の場合、古い日付を上書きする
                            }else if(acMap.containsKey(ac.Id)){
                                Account ac1 = acMap.get(ac.Id);
                                if (ac1.chokkin_tegami_sofu_date__c <= ac.chokkin_tegami_sofu_date__c){
                                    acMap.put(ac.Id, ac);
                                }else{
                                    ac.chokkin_tegami_sofu_date__c = ac1.chokkin_tegami_sofu_date__c;
                                    acMap.put(ac.Id, ac);
                                }
                            }
                        }
                    }
                }
                update acMap.values();
            }
            update tgmUpdList;
      }
}