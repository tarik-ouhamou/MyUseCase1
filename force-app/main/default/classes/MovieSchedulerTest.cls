@isTest
public with sharing class MovieSchedulerTest {

    public static final String CRON_EXP = '0 30 1 1 1 1 2023';

    @TestSetup
    static void makeData(){
        TestDataFactory.createSObjectList('Movie__c', new Map<String, Object> {
            'Release_date__c' => Date.today().addDays(-30)
        }, 180);    
    }

    @isTest static void testSchedulerCallBatch() {
        Test.startTest();
        MovieScheduler ms = new MovieScheduler();
        System.schedule('Update Movies with old release date', CRON_EXP, ms);
        Test.stopTest();

        List<Movie__c> results = [SELECT IsReleased__c FROM Movie__c WHERE IsReleased__c = TRUE];

        System.assertEquals(180, results.size(), 'Updated movies should be set to released');
    }
}