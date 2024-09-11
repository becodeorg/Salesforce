public class MoodleScheduler implements Schedulable{
	public void execute(SchedulableContext SC) {
        MoodleAccountBatchSync mc = new MoodleAccountBatchSync();
        ID batch = Database.executeBatch(mc, 1); // sets the batch size to 33
    }
}