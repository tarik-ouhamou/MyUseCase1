public with sharing class ActorTriggerHandler extends TriggerHandler {
    Map<Id, Actor__c> oldActorsMap;
    Map<Id, Actor__c> newActorsMap;

    public ActorTriggerHandler() {
        this.oldActorsMap = (Map<Id, Actor__c>) Trigger.oldMap;
        this.newActorsMap = (Map<Id, Actor__c>) Trigger.newMap;
    }

    public override void beforeDelete() {
        List<MovieActor__c> moviesActors = [SELECT Id, Actor__c, Movie__c FROM MovieActor__c WHERE Actor__c IN :oldActorsMap.keySet() WITH SECURITY_ENFORCED];
        if (moviesActors.isEmpty()) {
            return;
        }
        MovieActorTriggerHelper.updateGenderPercentage(moviesActors);
    }

    public override void afterUpdate() {
        Set<Id> filteredActors = new Set<ID>();
        for (Actor__c actor : this.oldActorsMap.values()) {
            if (actor.Gender__c != this.newActorsMap.get(actor.Id).Gender__c) {
                filteredActors.add(actor.Id);
            }
        }

        List<MovieActor__c> moviesActors = [SELECT Id, Actor__c, Movie__c FROM MovieActor__c WHERE Actor__c IN :filteredActors WITH SECURITY_ENFORCED];
        if (moviesActors.isEmpty()) {
            return;
        }

        MovieActorTriggerHelper.updateGenderPercentage(moviesActors);
    }


}