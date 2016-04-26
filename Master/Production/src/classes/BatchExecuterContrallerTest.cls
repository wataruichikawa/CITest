@isTest
private class BatchExecuterContrallerTest {

    static testMethod void myUnitTest() {
        BatchExecuterContraller be = new BatchExecuterContraller();
        be.executeConvertCMJobToCustomObject3();
    }

    static testMethod void myUnitTest2() {
        BatchExecuterContraller be = new BatchExecuterContraller();
        be.executeTaskAllUpdate();
        be.executeUpdateAccountOpportunityVisitData();
    }
}