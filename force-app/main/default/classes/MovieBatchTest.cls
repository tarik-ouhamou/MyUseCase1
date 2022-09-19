@isTest
public with sharing class MovieBatchTest {
    
    @TestSetup
    static void makeData(){
        TestDataFactory.createSObjectList('Movie__c', new Map<String, Object> {
            'Release_date__c' => Date.today().addDays(-30)
        }, 180);
    }

    @isTest
    static void updateMoviesReleaseDate() {


        Test.startTest();
        MovieBatch mb = new MovieBatch();
        Id batchId = Database.executeBatch(mb);
        Test.stopTest();

        List<Movie__c> movies = [SELECT IsReleased__c FROM Movie__c WHERE IsReleased__c = TRUE];

        system.debug(movies);

        System.assertEquals(180, movies.size(), 'All 180 should be updated');
    }
}