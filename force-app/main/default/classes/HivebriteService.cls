public class HivebriteService {
    private static final String HIVEBRITE_BASE_URL = 'https://community.becode.org';
    private static final String CLIENT_ID = 'y2-Kd-HioZkbQ5zMvhIH3x1bDhkOs1Uc_rTjBDWW9tM';
    private static final String CLIENT_SECRET = 's4zA9aEvGY2OEbbVkgeCBJx92pUbCGvuMT-fWe2AZsw';
    private static final String SCOPE = 'admin';
    private static final String USERNAME = 'pierre-yves.dehon@becode.org';
    private static final String PASSWORD = 'xJWqKTiDxBw7S7';
    private static final String GRANT_TYPE = 'password';

    private static final String AUTH_EP = '/api/oauth/token';
    private static final String NETWORKS_EP = '/api/admin/v1/network';
    private static final String ROLES_EP = '/api/admin/v1/roles';
    private static final String INDUSTRIES_EP = '/api/admin/v1/settings/industries';
    private static final String COMPANIES_EP = '/api/admin/v1/companies';
    private static final String USERS_EP = '/api/admin/v1/users';
    private static final String OPPORTUNITIES_EP = '/api/admin/v1/business_opportunities';

    private static String token = '';
    private static Integer becode_net_id = 0;
    private static String becode_net_title = '';
    private static Integer alumini_role_id = 0;
    private static Integer student_role_id = 0;
    private static Integer staff_role_id = 0;
    private static Integer admin_role_id = 0;

    private static List<Object> subnets = new List<Object>();
    private static List<Object> industries = new List<Object>();
    private static List<Object> companies = new List<Object>();
    private static List<Object> users = new List<Object>();
    private static List<Object> opportunities = new List<Object>();

    public HivebriteService(){
        System.debug('Getting token');
        getHivebriteToken();
        System.debug('Token :' + token);
        System.debug('Getting industries');
        getIndustries();
        System.debug('Industries :' + industries);
        System.debug('Getting networks');
        getNetworks();
        System.debug('becode net id :' + becode_net_id);
        System.debug('Getting roles');
        getRoles();
        System.debug('admin role id :' + admin_role_id);
        System.debug('Getting companies');
        getCompanies();
        System.debug(companies.size());
        System.debug('Getting users');
        getUsers();
        for (Object user : users) {
            System.debug(((Map<String,Object>)user).get('email'));
            System.debug(((Map<String,Object>)user).get('id'));
        }
        System.debug('Getting opportunities');
        getOpportunities();
        System.debug(opportunities.size());
    }

    private void getHivebriteToken() {
        String url = HIVEBRITE_BASE_URL + AUTH_EP;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Accept', 'application/json');
        request.setBody('grant_type='+ GRANT_TYPE + '&scope=' + SCOPE + '&admin_email=' + USERNAME +'&password=' + PASSWORD + '&client_id=' + CLIENT_ID + '&client_secret=' + CLIENT_SECRET);
        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug(response.getStatus());
        } else {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            token = (String)responseList.get('access_token');
        }
    }

    private void getNetworks() {
        String url = HIVEBRITE_BASE_URL + NETWORKS_EP;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug(response.getStatus());
        } else {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            becode_net_id = (Integer)responseList.get('id');
            becode_net_title = (String)responseList.get('title');
            subnets = (List<Object>)responseList.get('sub_networks');
        }    
    }

    private void getRoles() {
        String url = HIVEBRITE_BASE_URL + ROLES_EP;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug(response.getStatus());
        } else {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            for (Object role : (List<Object>)responseList.get('roles')) {
                if (((Map<String, Object>)role).get('name') == 'Alumni') {
                    alumini_role_id = (Integer)((Map<String, Object>)role).get('id');
                } else if (((Map<String, Object>)role).get('name') == 'BeCode staff') {
                    staff_role_id = (Integer)((Map<String, Object>)role).get('id');
                } else if (((Map<String, Object>)role).get('name') == 'Learner') {
                    student_role_id = (Integer)((Map<String, Object>)role).get('id');
                } else if (((Map<String, Object>)role).get('name') == 'Platform admins') {
                    admin_role_id = (Integer)((Map<String, Object>)role).get('id');
                }
            }
        }    
    }

    private void getIndustries() {
        String url = HIVEBRITE_BASE_URL + INDUSTRIES_EP;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug(response.getStatus());
        } else {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            industries = (List<Object>)responseList.get('industries');
        }
    }

    private void getCompanies() {
        Integer page = 1;
        String perpage = '99';
        String url = HIVEBRITE_BASE_URL + COMPANIES_EP + '?page=' + String.valueOf(page) + '&per_page=' + perpage + '&full_profile=true';
        List<HttpResponse> responses = new List<HttpResponse>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);

        HttpResponse response = http.send(request);

        while (response.getStatusCode() == 200) {
            responses.add(response);
            page = page + 1;
            url = HIVEBRITE_BASE_URL + COMPANIES_EP + '?page=' + String.valueOf(page) + '&per_page=' + perpage + '&full_profile=true';
            request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + token);

            response = http.send(request);
        }

        for (HttpResponse res : responses) {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            for (Object comp : (List<Object>)responseList.get('companies')){
                companies.add(comp);
            }
        }
    }

    private void getUsers() {
        Integer page = 1;
        String perpage = '99';
        String url = HIVEBRITE_BASE_URL + USERS_EP + '?page=' + String.valueOf(page) + '&per_page=' + perpage + '&full_profile=true';
        List<HttpResponse> responses = new List<HttpResponse>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);

        HttpResponse response = http.send(request);

        while (response.getStatusCode() == 200) {
            responses.add(response);
            page = page + 1;
            url = HIVEBRITE_BASE_URL + USERS_EP + '?page=' + String.valueOf(page) + '&per_page=' + perpage + '&full_profile=true';
            request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + token);

            response = http.send(request);
        }

        for (HttpResponse res : responses) {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            for (Object user : (List<Object>)responseList.get('users')){
                users.add(user);
            }
        }
    }

    private void getOpportunities() {
        Integer page = 1;
        String perpage = '99';
        String url = HIVEBRITE_BASE_URL + OPPORTUNITIES_EP + '?page=' + String.valueOf(page) + '&per_page=' + perpage + '&full_profile=true';
        List<HttpResponse> responses = new List<HttpResponse>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);

        HttpResponse response = http.send(request);

        while (response.getStatusCode() == 200) {
            responses.add(response);
            page = page + 1;
            url = HIVEBRITE_BASE_URL + OPPORTUNITIES_EP + '?page=' + String.valueOf(page) + '&per_page=' + perpage + '&full_profile=true';
            request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + token);

            response = http.send(request);
        }

        for (HttpResponse res : responses) {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            for (Object opp : (List<Object>)responseList.get('business_opportunities')){
                opportunities.add(opp);
            }
        }
    }

    private Integer findNetID(String netname) {
        for (Object net : (List<Object>)subnets) {
            if (((Map<String, Object>)net).get('title') == netname) {
                return Integer.valueOf(((Map<String, Object>)net).get('id'));
            }
        }
        return null;
    }

    public Map<String, Integer> matchNetworks(String training, String campus, Datetime training_end) {
        Integer training_net = 0;
        Integer campus_net = 0;
        Integer status = 0;

        if (training.contains('AI')) {
            training_net = findNetID('Artificial Intelligence');
        } else if (training.contains('Junior developer')) {
            training_net = findNetID('Junior Dev');
        } else if (training.contains('CyberSec')) {
            training_net = findNetID('Cybersecurity');
        } else if (training.contains('SAP')) {
            training_net = findNetID('SAP');
        } 
        if (campus.contains('Antwerp')) {
            campus_net = findNetID('Antwerp campus');
        } else if (campus.contains('Charleroi')) {
            campus_net = findNetID('Charleroi campus');
        } else if (campus.contains('Liege')) {
            campus_net = findNetID('Liège campus');
        } else if (campus.contains('Ghent')) {
            campus_net = findNetID('Ghent campus');
        } else if (campus.contains('Brussels')) {
            campus_net = findNetID('Brussels campus');
        }
        if (training_end < DateTime.now()) {
            status = findNetID('Current Learner');
        } else {
            status = findNetID('Alumni');
        }
        
        return new Map<String, Integer>{
            'training_net' => training_net,
            'campus_net' => campus_net,
            'status' => status
        };
    }

    public Object addLearner(String firstname, String lastname, String externalID, String email, String birthdate, String birthplace, String gender, String campus, String street, String postalcode, String state, String city, String country, String streetnumber, String training, Boolean sendInvite, String linkedin, Datetime trainingEnd) {
        String url = HIVEBRITE_BASE_URL + USERS_EP;
        Map<String, Integer> net_ids = matchNetworks(training, campus, trainingEnd);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json'); // Important to specify content type
    
        // Creating the JSON body
        Map<String, Object> user = new Map<String, Object>();
        user.put('email', email);
        user.put('sub_network_ids', new List<Integer>{net_ids.get('training_net'), net_ids.get('campus_net'), net_ids.get('status')});
        user.put('external_id', externalID);
        user.put('is_active', true);
        user.put('gender', gender);
        user.put('birthday', birthdate);
        user.put('postal_personal', new Map<String, Object>{
            'address_1' => streetnumber + ' ' + street,
            'city' => city,
            'state' => state,
            'country' => country,
            'postal_code' => postalcode
        });
        user.put('firstname', firstname);
        user.put('lastname', lastname);
        user.put('linkedin_profile_url', linkedin);
        user.put('birthplace', birthplace);
        user.put('role_id', student_role_id);
    
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('user', user);
    
        // Serializing the Map to JSON
        String jsonBody = JSON.serialize(requestBody);
        request.setBody(jsonBody);
    
        // Sending the request
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 201) {
            System.debug(response.getStatus());
            return null;
        } else {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return ((Map<String, Object>)responseList.get('user')).get('id');
        }
    }
    
    public void activate_learner(String learner_id){
        String url = HIVEBRITE_BASE_URL + USERS_EP + '/' + learner_id;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('PUT');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json'); // Important to specify content type

        Map<String, Object> payload = new Map<String, Object>();
        payload.put('key', 'external_id');
        Map<String, Object> userMap = new Map<String, Object>();
        userMap.put('is_active', true);
        payload.put('user', userMap);
        // Serializing the Map to JSON
        String jsonBody = JSON.serialize(payload);
        request.setBody(jsonBody);
        System.debug(jsonBody);
        HttpResponse response = http.send(request);
    }

    public void deactivate_learner(String learner_id){
        String url = HIVEBRITE_BASE_URL + USERS_EP + '/' + learner_id;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('PUT');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json'); // Important to specify content type

        Map<String, Object> payload = new Map<String, Object>();
        payload.put('key', 'external_id');
        Map<String, Object> userMap = new Map<String, Object>();
        userMap.put('is_active', false);
        payload.put('user', userMap);
        // Serializing the Map to JSON
        String jsonBody = JSON.serialize(payload);
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);
    }

    public void invite_learner(String learner_id) {
        String url = HIVEBRITE_BASE_URL + USERS_EP + '/' + learner_id + '/notify';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json'); // Important to specify content type

        Map<String, Object> payload = new Map<String, Object>();
        payload.put('recipient_type', 'email');
        String jsonBody = JSON.serialize(payload);
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);
    }

    public Object addCompany(String name, String streetnumber, String street, String city, String state, String postal_code, String country, String external_id) {
        String url = HIVEBRITE_BASE_URL + COMPANIES_EP;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json'); // Important to specify content type
    
        // Creating the JSON body
        Map<String, Object> company = new Map<String, Object>();
        company.put('name', name);
        company.put('postal_location', new Map<String, Object>{
            'address_1' => streetnumber + ' ' + street,
            'city' => city,
            'state' => state,
            'country' => country,
            'postal_code' => postal_code
        });
        company.put('external_id', external_id);

    
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('company', company);
    
        // Serializing the Map to JSON
        String jsonBody = JSON.serialize(requestBody);
        request.setBody(jsonBody);
    
        // Sending the request
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 201) {
            System.debug(response.getStatus());
            return null;
        } else {
            Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return ((Map<String, Object>)responseList.get('company')).get('id');
        }
    }

    public void addOpportunity(String title, String company_id, String email, String description, String kind, Map<String, Object> location, String expires, String start_date) {
        String url = HIVEBRITE_BASE_URL + OPPORTUNITIES_EP;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', 'application/json'); // Important to specify content type
    
        // Creating the JSON body   KIND = offer_internship, full_time_job   {address=Brussels, Belgium, city=Brussels, country=Belgium, country_code=BE, lat=50.847642, lng=4.35717}
        Map<String, Object> business_opportunity = new Map<String, Object>();
        business_opportunity.put('title', title);
        business_opportunity.put('location', new Map<String, Object>{
            'address_1' => location.get('streetnumber') + ' ' + location.get('street'),
            'city' => location.get('city'),
            'state' => location.get('state'),
            'country' => location.get('country'),
            'postal_code' => location.get('postal_code')
        });
        business_opportunity.put('company_id', company_id);
        business_opportunity.put('email', email);
        business_opportunity.put('description', description);
        business_opportunity.put('kind', kind);
        business_opportunity.put('start_date', start_date);
        business_opportunity.put('expires_at', expires);

        System.debug(business_opportunity);
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('business_opportunity', business_opportunity);
    
        // Serializing the Map to JSON
        String jsonBody = JSON.serialize(requestBody);
        request.setBody(jsonBody);
    
        // Sending the request
        HttpResponse response = http.send(request);

        System.debug(response);
        System.debug(response.getBody());
        if (response.getStatusCode() != 201) {
            System.debug(response.getStatus());

            //return null;
        } else {
            System.debug(response.getBody());
            //return null;
            // Map<String, Object> responseList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // return ((Map<String, Object>)responseList.get('business_opportunity')).get('id');
        }
    }
}