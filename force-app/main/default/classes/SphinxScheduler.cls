public class SphinxScheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        BatchDataSync batch = new BatchDataSync();
        Database.executeBatch(batch);
    }
}