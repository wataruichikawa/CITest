/**
 * DTO_TriggerDto
 * ----------------------------------------
 * @createdName      : Y.Uehara
 * @lastModifiedName : Y.Uehara
 * ----------------------------------------
 */
public class DTO_TriggerDto {

	/**
	 * コンストラクタ
	 * インスタンス変数の初期化
	 */
	public DTO_TriggerDto() {
		oldList = new List<sObject>();
		newList = new List<sObject>();
		invalidList = new List<id>();
	}

	/** trigger.old からトリガー無効フラグがtrueのデータを除いたリスト */
	public List<sObject> oldList {get; set;}
	/** trigger.new からトリガー無効フラグがtrueのデータを除いたリスト */
	public List<sObject> newList {get; set;}
	/** trigger.new でトリガー無効フラグがtrueのデータのIDリスト */
	public List<Id> invalidList {get; set;}

}