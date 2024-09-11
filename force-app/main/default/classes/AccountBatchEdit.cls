public class AccountBatchEdit implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, BECODE_LEARNER_ID__C FROM Account');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Account> accounts = (List<Account>) scope;
        for (Account a : accounts) {
            if (a.BECODE_LEARNER_ID__C != null) {
                a.BECODE_LEARNER_ID__C = slugify(a.BECODE_LEARNER_ID__C);
            }
        }
        update accounts;
    }
    
    public static String slugify(String username) {
            // Lowercase the username
            username = username.toLowerCase();
    
            // Replace spaces with hyphens
            username = username.replace(' ', '-');
    
            // Remove non-alphanumeric characters
            username = username.replaceAll('[^a-z0-9-]', '');
    
            return username;
    }
    
    public void finish(Database.BatchableContext BC) {
        // code to execute after all batches have been processed
    }
}