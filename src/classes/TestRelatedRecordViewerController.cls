@IsTest
private class TestRelatedRecordViewerController {
    
    @TestSetup
    private static void setup() {
        Account acct = new Account(
            Name = 'Test Account'
        );
        insert acct;
        Contact con = new Contact(
            AccountId = acct.Id,
            LastName = 'Test Contact'
        );
        insert con;
    }
    
    @IsTest
    private static void getRelatedRecordId() {
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        String acctId = con.AccountId;
        Test.startTest();
        String expectedAcctId = RelatedRecordViewerController.getRelatedRecordId(con.Id, 'AccountId');
        Test.stopTest();
        System.assertEquals(acctId, expectedAcctId, 'Confirm the related record Id');
    }
    
    @IsTest
    private static void getRelatedRecordIdInvalidFieldApiName() {
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        String acctId = con.AccountId;
        String exceptionMsg;
        String expectedExceptionMsg = RelatedRecordViewerController.invalidFieldMessage('InvalidFieldApiName', 'Contact');
        Test.startTest();
        try {
            RelatedRecordViewerController.getRelatedRecordId(con.Id, 'InvalidFieldApiName');
        } catch (Exception e) {
            exceptionMsg = e.getMessage();
        }
        Test.stopTest(); 
        System.assertEquals(exceptionMsg, expectedExceptionMsg, 'Confirm the exception message');
    }

}