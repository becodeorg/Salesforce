@isTest
public class MoodleClassesBatchSyncTest {
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
    static void testMoodleClassesBatchSync() {
        // Create BeCode_Class__c records
        BeCode_Class__c record1 = new BeCode_Class__c(
            Name = 'TestClass1',
            BeCode_Campus__c = 'Brussels',
            Class_Type__c = '7 Month Bootcamp',
            BeCode_Start_Date__c = Date.today(),
            BeCode_End_Date__c = Date.today().addDays(10),
            BeCode_Training__c = 'a0y68000001fiOuAAI',
            BeCode_Fundings_Needed__c = 5000
        );
        insert record1;
        
        // Create BeCode_Class__c records
        BeCode_Class__c record2 = new BeCode_Class__c(
            Name = 'TestClass2',
            BeCode_Campus__c = 'Brussels',
            Class_Type__c = '7 Month Bootcamp',
            BeCode_Start_Date__c = Date.today(),
            BeCode_End_Date__c = Date.today().addDays(10),
            BeCode_Training__c = 'a0y68000001fiOuAAI',
            BeCode_Fundings_Needed__c = 5000
        );
        insert record2;

        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        // Create a new instance of our batch class
        MoodleClassesBatchSync batchInstance = new MoodleClassesBatchSync();
        
        Test.startTest();
        
        // Begin the batch
        Database.executeBatch(batchInstance);
        
        Test.stopTest();

        // Asserts
        // Depending on what the MoodleService.createCohortNF method does, you need to add proper assertions here.
    }
}