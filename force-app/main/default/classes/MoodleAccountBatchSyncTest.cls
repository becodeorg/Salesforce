@isTest
public class MoodleAccountBatchSyncTest {
    static final String MOCKED_RESPONSE_USER_ID = '[{"id":"testId"}]';
    static final String MOCKED_RESPONSE_EMPTY = '[]';
    
    class MoodleServiceMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            // Mock response based on the method (wsfunction parameter)
            if (req.getEndpoint().contains('wsfunction=core_user_create_users')) {
                res.setBody(MOCKED_RESPONSE_USER_ID);
            } else if (req.getEndpoint().contains('wsfunction=core_user_get_users_by_field')) {
                res.setBody(MOCKED_RESPONSE_EMPTY);
            } else {
                res.setBody('{}');
            }
            
            return res;
        }
    }

    @isTest
    static void testMoodleAccountBatchSync() {
        // Create BeCode_Class__c record
        BeCode_Class__c learnerClass = new BeCode_Class__c(
            Name = 'TestClass',
            BeCode_Campus__c = 'Brussels',
            BeCode_Fundings_Needed__c = 5000
        );
        insert learnerClass;

        // Create Account records
        Account account1 = new Account(
            FirstName = 'First1',
            LastName = 'Last1',
            PersonEmail = 'test1@test.com',
            BeCode_Class__r = learnerClass,
            BeCode_Learner_ID__c = 'Learner1',
            BeCode_National_Registry_Number__c = 'rgergergerg'
        );
        insert account1;
        
        Account account2 = new Account(
            FirstName = 'First2',
            LastName = 'Last2',
            PersonEmail = 'test2@test.com',
            BeCode_Class__r = learnerClass,
            BeCode_Learner_ID__c = 'Learner2',
            BeCode_National_Registry_Number__c = 'gerertgaerg'
        );
        insert account2;

        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        // Create a new instance of our batch class
        MoodleAccountBatchSync batchInstance = new MoodleAccountBatchSync();
        
        Test.startTest();
        
        // Begin the batch
        Database.executeBatch(batchInstance);
        
        Test.stopTest();

        // Asserts
        // Depending on what the MoodleService methods do, you need to add proper assertions here.
    }
}