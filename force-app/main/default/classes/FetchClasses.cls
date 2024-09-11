public with sharing class FetchClasses {
    @AuraEnabled(cacheable=true)
    public static List<BeCode_Class__c> FetchClasses() {
        return [SELECT Id, Name, BeCode_Start_Date__c, BeCode_End_Date__c FROM BeCode_Class__c ORDER BY BeCode_Start_Date__c];
    }
}