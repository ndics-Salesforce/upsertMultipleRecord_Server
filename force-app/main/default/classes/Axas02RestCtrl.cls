@RestResource(urlMapping='/axas02/restctrl')
global class Axas02RestCtrl {

    public static final Integer BEGIN_INDEX_ID = 0;
    public static final Integer END_INDEX_ID = 18;
    public static final Integer BEGIN_INDEX_NAME = 20;

    @httpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        System.debug(JSON.deserializeUntyped(req.requestBody.toString()));
        List<Object> recordList = (List<Object>)JSON.deserializeUntyped(req.requestBody.toString());
        List<JobSeeker__c> upsertList = new List<JobSeeker__c>();

        if(recordList != null || recordList.size() < 0) {
            try {
                for (Object o : recordList) {
                    /** 受け取ったリストを成型 */
                    String record = o.toString();
                    String result = record.replace('(', '').replace(')', '');
                    System.debug('String result : ' + result);
                    String tedevId = result.substring(BEGIN_INDEX_ID, END_INDEX_ID);
                    String name = result.substring(BEGIN_INDEX_NAME);

                    JobSeeker__c job = new JobSeeker__c();
                    job.tedev01Id__c = tedevId;
                    job.Name = name;
                    upsertList.add(job);
                }
            } catch (Exception e) {
                System.debug('次のエラーが発生しました : ' + e.getMessage());
            }
        } else {
            System.debug('No record obtained.');
        }
        upsert upsertList tedev01Id__c;
    }
}