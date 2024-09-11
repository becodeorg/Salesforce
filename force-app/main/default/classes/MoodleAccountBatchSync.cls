global class MoodleAccountBatchSync implements Database.Batchable<sObject>, Database.AllowsCallouts {
	 global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, FirstName, LastName, PersonEmail, BeCode_Class__r.name, BeCode_Learner_ID__c, BeCode_National_Registry_Number__c FROM Account WHERE RecordTypeID = \'01268000000PvP9AAK\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> records) {
        for (Account learner : records) {
            System.debug(learner.BeCode_Learner_ID__c);
            String learnerId = MoodleService.createUserNF(learner.BeCode_Learner_ID__c, learner.FirstName, learner.LastName, learner.PersonEmail, learner.BeCode_Learner_ID__c, learner.BeCode_National_Registry_Number__c);
            if (learner.BeCode_Class__r.Name != Null) {
                System.debug(learner.BeCode_Class__r.Name);
                MoodleService.createCohortNF(learner.BeCode_Class__r.Name, learner.BeCode_Class__r.Name, '', 'idnumber', 'Becode');
                MoodleService.assignLearnerToCohortNF(learner.BeCode_Class__r.Name, learner.BeCode_Learner_ID__c);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        MoodleClassBatchSync mc = new MoodleClassBatchSync();
		ID batch = Database.executeBatch(mc, 1);
    }
}