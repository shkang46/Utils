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

    @AuraEnabled
    public static Map<String, String> getAllFieldsByObjectApiName(String objectApiName) {
        try {
            Map<String, Schema.SObjectField> fieldsSchemaMap = Schema.getGlobalDescribe()
                .get(objectApiName)
                .getDescribe()
                .fields.getMap();
            Map<String, String> result = new Map<String, String>();

            for (Schema.SObjectField fieldValue : fieldsSchemaMap.values()) {
                Schema.DescribeFieldResult fieldResult = fieldValue.getDescribe();
                result.put(fieldResult.getName(), fieldResult.getLabel());
            }

            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}