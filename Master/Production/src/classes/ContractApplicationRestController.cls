@RestResource(urlMapping='/ContractApplication/*')
global with sharing class ContractApplicationRestController {
  @HttpGet
  global static String doGet() {
    String serviceType = RestContext.request.params.get('serviceType');

    if (serviceType == null) {
      return '{"response":"error", "reason":"Required parameter serviceType and lastModifiedTimeStr"}';
    }

    // TODO conditionには検索条件のJSONが入力されるが一旦後回し。
    String conditionJson = RestContext.request.params.get('condition');

    ContractLogic logic = new ContractLogic();
    return logic.searchContract(serviceType);
  }

  @HttpPost
  global static String doPost() {
    String fetchedContractApplicationNos = RestContext.request.params.get('contractApplicationNos');
    String serviceType = RestContext.request.params.get('serviceType');
    System.debug('Request parameters : ' + fetchedContractApplicationNos);
    ContractLogic logic = new ContractLogic();
    List<String> applicationNoList = new List<String>();
    if (fetchedContractApplicationNos.contains(',')) {
      applicationNoList = fetchedContractApplicationNos.split(',');
    } else {
      applicationNoList.add(fetchedContractApplicationNos);
    }
    logic.updateFetchedContract(serviceType, applicationNoList);
    return null;
  }
}