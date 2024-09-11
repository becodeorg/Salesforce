public class MoodleTriggerHandler {
    //MoodleService moodleService = new MoodleService();
    Id learnerRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Learner' LIMIT 1].Id;

    public void handleAfterUpdate(Map<Id, Account> newAccounts, Map<Id, Account> oldAccounts) {
        for (Id accountId : newAccounts.keySet()) {
            Account newAccount = newAccounts.get(accountId);
            Account oldAccount = oldAccounts.get(accountId);

            if (newAccount.RecordTypeId == learnerRecordTypeId && newAccount.Career_Coach_Feedback__c != oldAccount.Career_Coach_Feedback__c) {
                moodleService.updateCareerCoachFeedback(newAccount.BeCode_Learner_ID__c, newAccount.PersonEmail, newAccount.Career_Coach_Feedback__c);
            }
        }
    }
}