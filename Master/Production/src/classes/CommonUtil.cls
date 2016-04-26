public class CommonUtil {


    /**
     * リストのNull、要素なしチェック
     * @param       value：チェック対象のリスト
     * @return      true:Null または 要素なし
     *              false:要素あり
     * @throws
     */
    public static boolean IsEmpty(list<Object> lst){
        return ( (lst==null) || (lst.isEmpty()) );
    }

    /**
     * オブジェクトのBoolean変換
     * @param       value：Boolean変換対象Object
     * @return      オブジェクトがNULL、または　Booleanに変換出来ない値の場合はfalseを返却
     *              それ以外の場合はBoolean型にして返却
     * @throws
     */

    public static Boolean ToBoolean(object obj){
        return (obj!=null && obj instanceof Boolean) ? Boolean.valueOf(obj) : false;

    }

    /**
     * trigger.new、trigger.oldのトリガー無効フラグを統合して判別
     * @param       isInsert：trigger.isInsertを設定
     * @param       isUpdate：trigger.isUpdateを設定
     * @param       isDelete：trigger.isDeleteを設定
     * @param       newObjList：trigger.newのオブジェクトを設定
     * @param       oldObjList：trigger.oldのオブジェクトを設定
     * @return      トリガ実施対象のマップ
     *                   キー：'0'　値：トリガ実施対象のOldリスト
     *                   キー：'1'　値：トリガ実施対象のNewリスト
     *                   キー：'2'　値：トリガ無効フラグTRUEのレコードのIdリスト
     * @throws
     */

    public static Map<String, Object> createTriggerList(
    		boolean isInsert, boolean isUpdate, boolean isDelete, List<sObject> newObjList, List<sObject> oldObjList){
    		
    	Map<String, Object> ret = new Map<String, Object>();
    	
        List<sObject> tmpOldList = new List<sObject>();
	    List<sObject> tmpNewList = new List<sObject>();
	    List<id> mukoFuraguList = new List<id>();
    	
    	if(isInsert || isUpdate){
		    for(Integer i = 0; i < newObjList.size(); i++){
		    	sObject tmpNew = newObjList.get(i);
		    	sObject tmpOld;
		    	if(isUpdate){
		    		tmpOld = oldObjList.get(i);
		    	}
			    if (DoTriggerProcess(isInsert, tmpNew, tmpOld)){
			    	// トリガ実施対象の場合
			    	
		            tmpNewList.add(tmpNew);
		            
		            if(isUpdate){
		                // UPDATE時はOLDも
		                tmpOLDList.add(tmpOld);
		            }
			    	
			    }else if(ToBoolean(tmpNew.get('torigamukofuragu__c'))){
			    	// トリガ無効フラグがTrueの場合
			    	mukoFuraguList.add(tmpNew.id);
			    }
		    }
    	}
    	
    	if(isDelete){
    		for(Integer i = 0; i < oldObjList.size(); i++){
    			tmpOLDList.add(oldObjList.get(i));
    		}
    	}
	    
	    ret.put('0', tmpOldList);
	    ret.put('1', tmpNewList);
	    ret.put('2', mukoFuraguList);
	    
	    return ret;
    }

    /**
     * trigger.new、trigger.oldのトリガー無効フラグを統合して判別
     * @param       isInsert：trigger.isInsertを設定
     * @param       newObj  ：trigger.newのオブジェクトを設定
     * @param       oldObj  ：trigger.oldのオブジェクトを設定
     * @return      true    ：処理を実施する
     * @return      false   ：処理を実施しない
     * @throws
     */

    public static boolean DoTriggerProcess(boolean isInsert, sObject newObj, sObject oldObj){
        return (!ToBoolean(newObj.get('torigamukofuragu__c'))) && ( isInsert || (!ToBoolean(oldObj.get('torigamukofuragu__c'))));
    }

    /**
     * トリガー無効フラグがFalseではないレコードに対して、Updateをかける
     * @param       idList：トリガー無効フラグをUpdateするレコードのIDリスト
     * @param       objApi  ：UpdateするオブジェクトのAPI参照名
     * @return      true    ：Update成功
     * @return      false   ：Update失敗
     * @throws
     */

    public static boolean UpdateTorigaMukoFuragu(list<id> idList, string objApi){
        try{
            string soqlStr = 'SELECT Id, torigamukofuragu__c FROM ' + objApi + ' WHERE Id in (\'\'';
            for (string idStr : idList){    soqlStr += ',\'' + idStr + '\'';    }
            list<sObject> sObjList = Database.query(soqlStr+')');
            for (sObject sObj : sObjList){    sObj.put('torigamukofuragu__c',false);    }
            if (!CommonUtil.IsEmpty(sObjList))    update sObjList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            return false;
        }
        return true;
    }

    public static boolean RunningIsSandbox(){
        //true = sandbox, false = Product
        return [select id,isSandbox from Organization Limit 1].isSandbox;
    }

}