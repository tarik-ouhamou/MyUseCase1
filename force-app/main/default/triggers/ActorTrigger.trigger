trigger ActorTrigger on Actor__c (after update, before delete) {
    new ActorTriggerHandler().run();
}