public with sharing class Utils {
    @AuraEnabled(cacheable=true)
    public static String getRecordTypeIdByRecordId(Id recordId) {
        try {
            String objectApiName = recordId.getSObjectType().getDescribe().getName();
            String quotedRecordId = '\'' + recordId + '\'';

            String query = String.format(
                'SELECT RecordTypeId FROM {0} WHERE Id = {1} WITH SECURITY_ENFORCED LIMIT 1',
                new List<Object>{ objectApiName, quotedRecordId }
            );

            List<SObject> queryResult = Database.query(query);

            Id recordTypeId = (Id) queryResult[0].get('RecordTypeId');

            return recordTypeId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}