public with sharing class MovieActorTriggerHelper {
  private static final String MALE = 'Male';
  private static final String FEMALE = 'Female';

  public static void updateMovieNumber(
    List<MovieActor__c> moviesActors,
    Boolean isInsert
  ) {
    Set<Id> actorsIds = new Set<Id>();

    for (MovieActor__c ma : moviesActors) {
      actorsIds.add(ma.Actor__c);
    }

    Map<Id, AggregateResult> actorsMapCount = new Map<Id, AggregateResult>(
      [
        SELECT Actor__r.Id, Count(Name)
        FROM MovieActor__c
        WHERE Id IN :moviesActors
        WITH SECURITY_ENFORCED
        GROUP BY Actor__r.Id
        HAVING Actor__r.Id IN :actorsIds
      ]
    );

    List<Actor__c> actors = [
      SELECT Id, Number_of_movies__c
      FROM Actor__c
      WHERE Id IN :actorsIds
      WITH SECURITY_ENFORCED
    ];

    for (Actor__c actor : actors) {
      Integer k = isInsert ? 1 : -1;
      actor.Number_of_movies__c +=
        Integer.valueOf(actorsMapCount.get(actor.Id).get('expr0')) * k;
    }

    if (
      Schema.SObjectType.Actor__c.isUpdateable() &&
      Schema.SObjectType.Actor__c.fields.Number_of_movies__c.isUpdateable()
    ) {
      update actors;
    }
  }

  public static void updateGenderPercentage(List<MovieActor__c> moviesActors) {
    Set<Id> moviesIds = new Set<Id>();

    for (MovieActor__c ma : moviesActors) {
      moviesIds.add(ma.Movie__c);
    }

    List<Movie__c> movies = [
      SELECT Id
      FROM Movie__c
      WHERE Id IN :moviesIds
      WITH SECURITY_ENFORCED
    ];

    Map<Id, AggregateResult> maleCountMap = getGenderCountByMovie(MALE);
    Map<Id, AggregateResult> femaleCountMap = getGenderCountByMovie(FEMALE);

    for (Movie__c movie : movies) {
      Integer maleCount = maleCountMap.get(movie.Id) != null
        ? Integer.valueOf(maleCountMap.get(movie.Id).get('expr0'))
        : 0;
      Integer femaleCount = femaleCountMap.get(movie.Id) != null
        ? Integer.valueOf(femaleCountMap.get(movie.Id).get('expr0'))
        : 0;
      Integer total = maleCount + femaleCount;

      movie.MaleActorsPercentage__c = ((Decimal) maleCount / total) * 100;
      movie.FemaleActorsPercentage__c = ((Decimal) femaleCount / total) * 100;
    }

    if (
      Schema.SObjectType.Movie__c.isUpdateable() &&
      Schema.SObjectType.Movie__c.fields.MaleActorsPercentage__c.isUpdateable() &&
      Schema.SObjectType.Movie__c.fields.FemaleActorsPercentage__c.isUpdateable()
    ) {
      update movies;
    }
  }

  private static Map<Id, AggregateResult> getGenderCountByMovie(String gender) {
    Map<Id, AggregateResult> genderCount = new Map<Id, AggregateResult>(
      [
        SELECT movie__r.Id, actor__r.gender__c, COUNT(actor__r.Name)
        FROM MovieActor__c
        WITH SECURITY_ENFORCED
        GROUP BY movie__r.Id, actor__r.gender__c
        HAVING actor__r.gender__c = :gender
      ]
    );

    return genderCount;
  }
}
