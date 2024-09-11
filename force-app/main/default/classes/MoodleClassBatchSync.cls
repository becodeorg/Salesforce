global class MoodleClassBatchSync implements Database.Batchable<sObject>, Database.AllowsCallouts {
	global Iterable<sObject> start(Database.BatchableContext BC) {
        List<Becode_Class__c> learner_classes = [SELECT Id, Name, BeCode_Training__c FROM Becode_Class__c];
        return learner_classes;
    }
        
	global void execute(Database.BatchableContext BC, List<sObject> records) {
        for (sObject s : records) {
        	MoodleService.createCohortNF(((Becode_Class__c) s).Name, ((Becode_Class__c) s).Name, '', 'idnumber', 'Becode');
        }
    }
    
	global void finish(Database.BatchableContext BC) {
        // Actions to perform after all batches are processed
    }
}