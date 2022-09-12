public with sharing class TestScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        MovieBatch movieBatch = new MovieBatch();
        Database.executeBatch(movieBatch);
    }
}