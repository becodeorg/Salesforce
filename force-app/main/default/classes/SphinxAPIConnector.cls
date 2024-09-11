public class SphinxAPIConnector {
    // Connection details and credentials for Sphinx API
	public static final String API_BASE_URL = 'https://cvip.sphinxonline.net';
    public static final String CLIENT_ID = 'sphinxapiclient';
    public static final String USERNAME = 'BeCode';
    public static final String TOKEN = '6118496df124ca5c0722ac3f01f1aec61b8e1f7b8bff4f83e61180a71651dd22';
    public static final String GRANT_TYPE = 'personal_token';
    public static final Integer DEFAULT_DAYS = 3;
    
 
    public static String getNewSphinxApiKey() {
        String endpoint = '/sphinxauth/connect/token';
        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        headers.put('Accept', 'application/json');
        
        String body = 'username=' + USERNAME + '&token=' + TOKEN + '&grant_type=' + GRANT_TYPE + '&client_id=' + CLIENT_ID;
        HttpResponse response = makeRequest(endpoint, 'POST', headers, body);
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String sphinxJwt = (String) data.get('access_token');
        if (sphinxJwt == null || sphinxJwt == '') {
            // Handle the error here. You can throw a custom exception or return a default value.
        }
        return sphinxJwt;
    }
    
    public static HttpResponse makeRequest(String endpoint, String method, Map<String, String> headers, String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_BASE_URL + endpoint);
        request.setMethod(method);
        request.setHeader('Accept', 'application/json');
        request.setTimeout(120000); 
        for (String headerKey : headers.keySet()) {
            request.setHeader(headerKey, headers.get(headerKey));
        }
        if (body != null && body != '') {
            request.setBody(body);
        }
        HttpResponse response = http.send(request);
    
        // Check the status code
        if (response.getStatusCode() != 200) {
            System.debug('HTTP status code: ' + response.getStatusCode());
            System.debug('Response body: ' + response.getBody());
        }
    
        return response;
    }
    
    // Method to fetch data from Sphinx API
    public List<Map<String, Object>> fetchLastYear() {
        Date today = Date.today();
        Date startDate = today.addDays(-365);
        Datetime startDatetime = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
        String startDateTimeString = startDatetime.format('yyyy-MM-dd') + 'T07:00:00';
        
        String endpoint = '/sphinxapi/api/v4.1/survey/BeCode_Data/data?startdate=' + startDateTimeString;
        Map<String, String> headers = new Map<String, String>();
        headers.put('Authorization', 'Bearer ' + getNewSphinxApiKey());
        HttpResponse response = makeRequest(endpoint, 'GET', headers, null);
    
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        try {
            // Deserialize the response body as a list of maps
            List<Object> dataList = (List<Object>) JSON.deserializeUntyped(response.getBody());
    
            for(Object obj : dataList){
                if(obj instanceof Map<String, Object>){
                    Map<String, Object> learnerData = (Map<String, Object>) obj;
                    data.add(learnerData);
                }
            }
        } catch (System.JSONException e) {
            System.debug('Failed to parse response as JSON: ' + response.getBody());
            throw e;
        }
    
        return data;
    }
    // Method to fetch data from Sphinx API
    public List<Map<String, Object>> fetchLatestResponses() {
        Date today = Date.today();
        Date startDate = today.addDays(-DEFAULT_DAYS);
        Datetime startDatetime = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
        String startDateTimeString = startDatetime.format('yyyy-MM-dd') + 'T07:00:00';
        
        String endpoint = '/sphinxapi/api/v4.1/survey/BeCode_Data/data?startdate=' + startDateTimeString;
        Map<String, String> headers = new Map<String, String>();
        headers.put('Authorization', 'Bearer ' + getNewSphinxApiKey());
        HttpResponse response = makeRequest(endpoint, 'GET', headers, null);
    
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        try {
            // Deserialize the response body as a list of maps
            List<Object> dataList = (List<Object>) JSON.deserializeUntyped(response.getBody());
    
            for(Object obj : dataList){
                if(obj instanceof Map<String, Object>){
                    Map<String, Object> learnerData = (Map<String, Object>) obj;
                    data.add(learnerData);
                }
            }
        } catch (System.JSONException e) {
            System.debug('Failed to parse response as JSON: ' + response.getBody());
            throw e;
        }
    
        return data;
    }
}