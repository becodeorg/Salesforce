public with sharing class ClassService {
    @AuraEnabled(cacheable=true)
    public static List<BeCode_Class__c> getClasses() {
        return [SELECT Id, Name, BeCode_Start_Date__c, BeCode_End_Date__c, BeCode_Campus__c, Class_Type__c,BeCode_Main_Coach__c,BeCode_Training__c, BeCode_Main_Coach__r.Name, registration_end_date__c, registration_start_date__c,BeCode_Support_Coach__c, BeCode_Support_Coach__r.Name, BeCode_Training__r.Name
        FROM BeCode_Class__c 
        ORDER BY BeCode_Start_Date__c ASC];
    }
}