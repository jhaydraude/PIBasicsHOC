trigger AppAnalyticsQueryRequestTrigger on AppAnalyticsQueryRequest (before update) {    
/*
This Trigger will loop through updated AppAnalytics Query Request records.

If the request is a PackageUsageSummary and if RequestState has changed to "Complete" then we can download the CSV

*/  
    for (AppAnalyticsQueryRequest aaqr: Trigger.new) {
        if ((aaqr.DataType == 'CustomObjectUsageSummary' || aaqr.DataType == 'PackageUsageSummary')
            	&& aaqr.RequestState == 'Complete' 
            	&& aaqr.RequestState != Trigger.oldMap.get(aaqr.id).RequestState) {
			
            if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) {
                System.debug('Enqueueing log Download');
                System.enqueueJob(new LogDownloader(aaqr));
            }
            else {
                system.debug('Not Enqueing Download -- Limit Exceeded');
            }
        }
        else {
            system.debug('Not Enqueing Download');
        }
    }
}