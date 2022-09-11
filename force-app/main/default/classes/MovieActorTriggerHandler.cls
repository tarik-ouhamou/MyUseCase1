public with sharing class MovieActorTriggerHandler extends TriggerHandler {
    private List<MovieActor__c> newMoviesActors;
    private List<MovieActor__c> oldMoviesActors;

    public MovieActorTriggerHandler() {
        this.newMoviesActors = (List<MovieActor__c>) Trigger.new;
        this.oldMoviesActors = (List<MovieActor__c>) Trigger.old;
        this.setMaxLoopCount(1);
    }

    protected override void afterInsert() {
        MovieActorTriggerHelper.updateMovieNumber(this.newMoviesActors, true);
        MovieActorTriggerHelper.updateGenderPercentage(this.newMoviesActors);
    }

    protected override void afterDelete() {
        MovieActorTriggerHelper.updateMovieNumber(this.oldMoviesActors, false);
        MovieActorTriggerHelper.updateGenderPercentage(this.oldMoviesActors);
    }
}