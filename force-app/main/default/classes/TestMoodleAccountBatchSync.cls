@isTest
private class TestMoodleAccountBatchSync {
    @isTest
    static void testMoodleAccountBatchSync() {


        Test.startTest();

        // Set up and run your batch job
        MoodleAccountBatchSync batch = new MoodleAccountBatchSync();
        ID batchID = Database.executeBatch(batch);

        Test.stopTest();
    }
}