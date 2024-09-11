@isTest
public class MoodleServiceTest {
    private static final String MOODLE_BASE_URL = 'http://moodle.becode.org/moodle';
    private static final String MOODLE_TOKEN = '5d7e0a5b5eef54f0e4f3d41ead2955ce';
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
                res.setBody(MOCKED_RESPONSE_USER_ID);
            } else {
                res.setBody('{}');
            }
            
            return res;
        }
    }
    
    @isTest static void testCreateUser() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.createUser('testuser', 'John', 'Doe', 'johndoe@test.com', 'test', 'test');
        Test.stopTest();

        // Asserts
    }
    
    @isTest static void testCreateUserNF() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.createUserNF('testuser', 'John', 'Doe', 'johndoe@test.com', 'test', 'test');
        Test.stopTest();

        // Asserts
    }
    
    //@isTest static void testUpdateUser() {
        // Set up the mock
      //  Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

       // Test.startTest();
        //MoodleService.updateUser('Becode123', 'Jane', 'Doe', 'janedoe@test.com');
        //Test.stopTest();

        // Asserts
    //}

    @isTest static void testCreateCohort() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.createCohort('Cohort123', 'Cohort Name', 'Cohort Description', 'system', 'system');
        Test.stopTest();

        // Asserts
    }

    @isTest static void testCreateCohortNF() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.createCohortNF('Cohort123', 'Cohort Name', 'Cohort Description', 'system', 'system');
        Test.stopTest();

        // Asserts
    }
    
    @isTest static void testCreateCategory() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.createCategory('Category Name', 'Parent Category', 'Cat123', 'Category Description', '1');
        Test.stopTest();

        // Asserts
    }
    
    @isTest static void testCreateCategoryNF() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.createCategoryNF('Category Name', 'Parent Category', 'Cat123', 'Category Description', '1');
        Test.stopTest();

        // Asserts
    }
    
    @isTest static void testUpdateCareerCoachFeedback() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.updateCareerCoachFeedback('Becode123', 'johndoe@test.com', 'Great progress!');
        Test.stopTest();

        // Asserts
    }

    @isTest static void testAssignLearnerToCohort() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.assignLearnerToCohort('Cohort123', 'User123');
        Test.stopTest();

        // Asserts
    }
    
	@isTest static void testAssignLearnerToCohortNF() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new MoodleServiceMock());

        Test.startTest();
        MoodleService.assignLearnerToCohortNF('Cohort123', 'User123');
        Test.stopTest();

        // Asserts
    }
}