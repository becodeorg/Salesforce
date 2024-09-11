@isTest
private class TestMoodleAssignBatchSync {
    @isTest
    static void testMoodleAssignBatchSync() {
        // Set up a BeCode_Class__c record
       

        Test.startTest();

        // Set up and run your batch job
        MoodleAssignBatchSync batch = new MoodleAssignBatchSync();
        ID batchID = Database.executeBatch(batch);

        Test.stopTest();

       
    }
}