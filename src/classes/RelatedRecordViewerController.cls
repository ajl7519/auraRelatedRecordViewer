public class RelatedRecordViewerController {
    
    @TestVisible
    private static String invalidFieldMessage(String fieldApiName, String sObjectName) {
        return String.format(
            'No such field, {0} on {1}.',
            new String[]{fieldApiName, sObjectName}
        );
    }
    
    @AuraEnabled
    public static String getRelatedRecordId(String recordId, String fieldApiName) {
        try {
            DescribeSObjectResult dsor = ((Id)recordId).getSObjectType().getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = dsor.fields.getMap();
            String sObjectName = dsor.getName();
            if (fieldsMap.get(fieldApiName) == null) {
                throw new RelatedRecordViewerException(invalidFieldMessage(fieldApiName, sObjectName));
            }
            String query = 'SELECT Id, ' + fieldApiName + ' FROM ' + sObjectName + ' WHERE Id = :recordId';
            SObject record = Database.query(query);
            return (String)record.get(fieldApiName);
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            AuraHandledException auraException = new AuraHandledException(errorMsg);
        	auraException.setMessage(errorMsg);
            throw auraException;
        }
    }
   
    public class RelatedRecordViewerException extends Exception {}
}