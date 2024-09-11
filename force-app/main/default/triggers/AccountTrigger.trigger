trigger AccountTrigger on Account (after insert, after update) {
    MoodleTriggerHandler handler = new MoodleTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            handler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}