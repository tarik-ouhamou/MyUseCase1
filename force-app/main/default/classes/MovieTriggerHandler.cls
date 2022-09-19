public with sharing class MovieTriggerHandler extends TriggerHandler {

    Map<Id, Movie__c> moviesMap;

    public MovieTriggerHandler() {
        this.moviesMap = (Map<Id, Movie__c>) Trigger.oldMap;
    }

    public override void beforeDelete() {
        List<MovieActor__c> moviesActors = [SELECT Id, Actor__c, Movie__c FROM MovieActor__c WHERE Movie__c IN :moviesMap.keySet() WITH SECURITY_ENFORCED];
        MovieActorTriggerHelper.updateMovieNumber(moviesActors, false);
    }
}