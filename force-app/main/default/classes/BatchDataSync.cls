global class BatchDataSync implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Iterable<sObject> start(Database.BatchableContext BC) {
        SphinxAPIConnector connector = new SphinxAPIConnector();
        List<Map<String, Object>> responses = connector.fetchLatestResponses();
        while (responses.size() < 1) {
            responses = connector.fetchLatestResponses();
        }
        List<Account> existingAccounts = [SELECT Id, BeCode_Learner_ID__c FROM Account];
        List<Account> accountsToUpsert = new List<Account>();
        
        List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE Name = 'Learner' LIMIT 1];
        RecordType record_type = (recordTypes.size() > 0) ? recordTypes[0] : null;        
        
        List<Becode_Class__c> learner_classes = [SELECT Id, Name, BeCode_Training__c FROM Becode_Class__c];     
        List<Account> companies = [SELECT Id, Name FROM Account];

		for(Map<String, Object> response : responses) {
            String recordId;
            String learnerId;
            String hiringId;
            String classId;
            String trainingId;
            String internId;
            String becodeId;
            recordId = record_type.Id;
            for (Becode_Class__c className : learner_classes) {
                if (className.Name == response.get('Class_name')) {
                    classId = className.Id;
                    break;
                } else {
                    classId = Null;
                }
            }
            for (Account company : companies) {
                if (company.Name == response.get('3M_Company_name')) {
                    hiringId = company.Id;
                    break;
                } else {
                    hiringId = Null;
                }
            }
            for (Account company : companies) {
                if (company.Name == response.get('0M_Name_of_company')) {
                    internId = company.Id;
                    break;
                } else {
                    internId = Null;
                }
            }
            for (Account learner : existingAccounts) {
                if (learner.BeCode_Learner_ID__c == response.get('BeCode_ID')) {
                    becodeId = learner.BeCode_Learner_ID__c;
                    break;
                } else {
                    becodeId = Null;
                }
            }
            Account account = DataProcessor.mapResponseToAccount(response, recordId, learnerId, internId, hiringId, classId, trainingId);
            for (Account exacc : existingAccounts) {
                if (exacc.BeCode_Learner_ID__c == account.BeCode_Learner_ID__c) {
                    account.Id = exacc.Id;
                    break;
                }
            }
            accountsToUpsert.add(account);
        }
        return accountsToUpsert;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> records) {
        List<Account> accountsToUpsert = new List<Account>();
        for (sObject s : records) {
            Account account = (Account) s;
            accountsToUpsert.add(account);
        }
        upsert accountsToUpsert;
    }
    
    global void finish(Database.BatchableContext BC) {
        // Actions to perform after all batches are processed
    }
}