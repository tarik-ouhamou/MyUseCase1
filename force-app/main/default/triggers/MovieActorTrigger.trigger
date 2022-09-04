trigger MovieActorTrigger on MovieActor__c (after insert) {

    //MovieActorTriggerHandler handler = new MovieActorTriggerHandler(Trigger.new, Trigger.old, Trigger.isInsert);

    MovieActorTriggerHandler.updateMovieNumber(Trigger.new, Trigger.old, Trigger.isInsert);
    MovieActorTriggerHandler.updateGenderPercentage(Trigger.new, Trigger.old, Trigger.isInsert);
}
