public class ContractOperatorMemoDto {
	public String parentContractApplicationNo {get; set;}
	public String memo {get; set;}
	public String transferMemo {get; set;}
	
	public ContractOperatorMemoDto() {
		parentContractApplicationNo = '';
		memo = '';
		transferMemo = '';
	}
}