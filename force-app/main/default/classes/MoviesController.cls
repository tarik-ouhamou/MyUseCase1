public with sharing class MoviesController {
    
    @AuraEnabled(cacheable = true)
    public static List<Movie__c> getAllMovies() {

        return [
            SELECT Name, Category__c, Description__c, Release_date__c
            FROM Movie__c
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<Movie__c> searchMovies(String searchTerm) {
        searchTerm = searchTerm.trim();

        if(searchTerm == '' || searchTerm == null ) {
            return getAllMovies();
        }

        searchTerm = '%' + searchTerm + '%';
        return [
            SELECT Name, Category__c, Description__c, Release_date__c
            FROM Movie__c
            WHERE Name LIKE :searchTerm
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

}
