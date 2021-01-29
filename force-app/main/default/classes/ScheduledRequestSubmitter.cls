global with sharing class ScheduledRequestSubmitter Implements Schedulable {
    global void execute(SchedulableContext ctx) {

        List<AppAnalyticsQueryRequest> aaqrList = new List<AppAnalyticsQueryRequest>();


        Date s = Date.today().addMonths(-1).toStartOfMonth();
        Date e = Date.today().toStartOfMonth().addDays(-1);


        for (sfLma__Package__c p: [select sfLma__Package_ID__c from sfLma__Package__c]) {
            AppAnalyticsQueryRequest aaqr = new AppAnalyticsQueryRequest();
            aaqr.DataType = 'PackageUsageSummary';
            aaqr.StartTime = (Datetime) s;
            aaqr.EndTime = (DateTime) e;
            aaqr.PackageIds =  p.sfLma__Package_ID__c;
            aaqrList.add(aaqr);
        }
        insert aaqrList;

     }   
}
