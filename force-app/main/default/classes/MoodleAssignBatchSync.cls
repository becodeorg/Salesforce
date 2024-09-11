global class MoodleAssignBatchSync implements Database.Batchable<sObject>, Database.AllowsCallouts {
	global Iterable<sObject> start(Database.BatchableContext BC) {
        List<Account> learners = [SELECT Id, Name,  Becode_Class__r.Name, BeCode_Learner_ID__c FROM Account];
        return learners;
    }
        
	global void execute(Database.BatchableContext BC, List<sObject> records) {
        for (sObject s : records) {
        	MoodleService.assignLearnerToCohortNF(((Account) s).Becode_Class__r.Name , ((Account) s).BeCode_Learner_ID__c);
        }
    }
    
	global void finish(Database.BatchableContext BC) {
        // Actions to perform after all batches are processed
    }
}