public class LogDownloader implements Queueable,Database.AllowsCallouts{
/*
Class is asynchronous/queable to take advantage of the longer processing times and larger heap sizes necessary to download the summary log file
*/
    private AppAnalyticsQueryRequest aaqr;
    
    public LogDownloader(AppAnalyticsQueryRequest a) {
        this.aaqr = a;
    }
    
    public void execute(queueableContext qc) {
        //Don't download if the file size is greater than available heap or if the URL has expired. 
        if (aaqr.DownloadSize < (Limits.getLimitHeapSize() - Limits.getHeapSize()) && aaqr.DownloadExpirationTime > DateTime.now()) {
            Http h = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('GET');
            httpReq.setEndpoint(this.aaqr.DownloadUrl);
            httpResponse res = h.send(httpReq);
            system.debug(res.getBody());
            if (res.getStatusCode() == 200) {
                System.debug('File Downloaded. Parsing CSV');
                //Parse the downloaded log file.
                System.enqueueJob(new CSVParser(res.getBody()));    

            }
            else {
                system.debug('Download Failed. Code: ' + res.getStatusCode() + ' Message: ' + res.getStatusCode());
            }
        }
        else {
            system.debug('Request too large or expired: ' + aaqr);
        }
    }
    
    
}