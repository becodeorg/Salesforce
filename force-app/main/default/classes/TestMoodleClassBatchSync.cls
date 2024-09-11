@isTest
private class TestMoodleClassBatchSync {
    @isTest
    static void testMoodleClassBatchSync() {
       
        Test.startTest();

        // Set up and run your batch job
        MoodleClassBatchSync batch = new MoodleClassBatchSync();
        ID batchID = Database.executeBatch(batch);

        Test.stopTest();

       
    }
}