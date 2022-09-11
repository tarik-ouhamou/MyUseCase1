public with sharing class MovieActorTriggerHelper {

    public static void updateMovieNumber(List<MovieActor__c> moviesActors, Boolean isInsert) {
        Map<String, Integer> mapper = new Map<String, Integer>();

        for(MovieActor__c ma : moviesActors) {
            if(!mapper.containsKey(ma.Actor__c)) {
                mapper.put(ma.Actor__c, 1);
            } else {
                Integer mapVal = mapper.get(ma.Actor__c);
                mapper.put(ma.Actor__c, mapVal + 1);   
            }
        }
        
        List<Actor__c> actors = [SELECT Id, Number_of_movies__c FROM Actor__c WHERE Id IN :mapper.keySet() WITH SECURITY_ENFORCED];
        
        for(Actor__c actor : actors) {
            Integer k = isInsert ? 1 : -1;
            actor.Number_of_movies__c += mapper.get(actor.Id)*k;
        }

        update actors;
    }

    public static void updateGenderPercentage(List<MovieActor__c> moviesActors) {
        Set<Id> movies = new Set<Id>();
        
        for(MovieActor__c ma : moviesActors) {
            movies.add(ma.Movie__c);
        }

        Map<Id, Movie__c> male = new Map<Id, Movie__c>([SELECT Id, (SELECT Id FROM MoviesActors__r WHERE Actor__r.Gender__c = 'Male') FROM Movie__c WHERE Id IN :movies WITH SECURITY_ENFORCED]);
        Map<Id, Movie__c> female = new Map<Id, Movie__c>([SELECT Id, (SELECT Id FROM MoviesActors__r WHERE Actor__r.Gender__c = 'Female') FROM Movie__c WHERE Id IN :movies WITH SECURITY_ENFORCED]);

        List<Movie__c> finalMovies = [SELECT Id FROM Movie__c WHERE Id IN :movies WITH SECURITY_ENFORCED];

        for(Movie__c movie : finalMovies) {
            Integer maleCount = male.get(movie.Id).MoviesActors__r.size();
            Integer femaleCount = female.get(movie.Id).MoviesActors__r.size();
            Integer total = maleCount + femaleCount;

            movie.MaleActorsPercentage__c = ((Decimal) maleCount/total) * 100;
            movie.FemaleActorsPercentage__c = ((Decimal) femaleCount/total) * 100;
        }

        update finalMovies;
    }
}