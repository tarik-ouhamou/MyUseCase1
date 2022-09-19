@isTest
public with sharing class MovieActorTriggerTest {
    private static final String MALE = 'Male';
    private static final String FEMALE = 'Female';

    @TestSetup
    static void makeData(){
        TestDataFactory.createSObjectList('Movie__c', 15);
        TestDataFactory.createSObjectList('Actor__c', new Map<String, Object> {
            'Gender__c' => MALE
        }, 15);

        TestDataFactory.createSObjectList('Actor__c', new Map<String, Object> {
            'Gender__c' => FEMALE
        }, 15);
    }

    @isTest static void testUpdateMovieNumberAfterInsertion() {
        List<Movie__c> movies = [SELECT Id FROM Movie__c];
        List<Actor__c> actors = [SELECT Id FROM Actor__c WHERE Gender__c = :MALE LIMIT 5];
        
        List<MovieActor__c> moviesActors = new List<MovieActor__c> {
            new MovieActor__c(Name= 'test1', Movie__c = movies.get(0).Id, Actor__c = actors.get(0).Id),
            new MovieActor__c(Name= 'test2', Movie__c = movies.get(1).Id, Actor__c = actors.get(1).Id),
            new MovieActor__c(Name= 'test3', Movie__c = movies.get(2).Id, Actor__c = actors.get(0).Id),
            new MovieActor__c(Name= 'test4', Movie__c = movies.get(3).Id, Actor__c = actors.get(0).Id)
        };

        Test.startTest();
            Database.SaveResult[] results = Database.insert(moviesActors, false);
        Test.stopTest();

        Map<Id, Actor__c> updatedActors = new Map<Id, Actor__c>([SELECT Id, Number_of_movies__c FROM Actor__c WHERE (Id = :actors.get(0).Id OR Id = :actors.get(1).Id)]); 

        System.assertEquals(3, updatedActors.get(actors.get(0).Id).Number_of_movies__c, 'Movie number in movie is updated succefully');
        System.assertEquals(1, updatedActors.get(actors.get(1).Id).Number_of_movies__c, 'Movie number in movie is updated succefully');
    }

    @isTest static void testUpdateGenderPercentage() {
        List<Movie__c> movies = [SELECT Id FROM Movie__c];
        List<Actor__c> maleActors = [SELECT Id FROM Actor__c WHERE Gender__c = :MALE LIMIT 5];
        List<Actor__c> femaleActors = [SELECT Id FROM Actor__c WHERE Gender__c = :FEMALE LIMIT 5];

        List<MovieActor__c> moviesActors = new List<MovieActor__c> {
            new MovieActor__c(Name= 'test1', Movie__c = movies.get(0).Id, Actor__c = maleActors.get(0).Id),
            new MovieActor__c(Name= 'test2', Movie__c = movies.get(0).Id, Actor__c = maleActors.get(1).Id),
            new MovieActor__c(Name= 'test3', Movie__c = movies.get(0).Id, Actor__c = femaleActors.get(0).Id),
            new MovieActor__c(Name= 'test4', Movie__c = movies.get(0).Id, Actor__c = femaleActors.get(1).Id)
        };

        Test.startTest();
        Database.SaveResult[] res = Database.insert(moviesActors, false);
        Test.stopTest();

        for(Database.SaveResult result : res) {
            System.debug(result.getErrors());
        }

        
        Map<Id, Movie__c> updatedMovies = new Map<Id, Movie__c>([SELECT Id, FemaleActorsPercentage__c, 	MaleActorsPercentage__c FROM Movie__c WHERE Id = :movies.get(0).Id]);
        System.assertEquals(50,  updatedMovies.get(movies.get(0).Id).FemaleActorsPercentage__c,'Percentage updated succeddully');
        System.assertEquals(50,  updatedMovies.get(movies.get(0).Id).MaleActorsPercentage__c,'Percentage updated succeddully');

    }

}