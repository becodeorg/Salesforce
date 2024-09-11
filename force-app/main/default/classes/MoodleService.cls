public class MoodleService {
    private static final String MOODLE_BASE_URL = 'https://moodle.becode.org/';
    private static final String MOODLE_TOKEN = '4c158202e294009c19004d2f55ad367f';
    
    @future(callout=true)
    public static void createUser(String username, String firstname, String lastname, String email, String becodeID, String niss) {
        String password = generatePassword(12);
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_user_create_users'
            + '&moodlewsrestformat=json'
            + '&users[0][username]=' + EncodingUtil.urlEncode(username, 'UTF-8')
            + '&users[0][firstname]=' + EncodingUtil.urlEncode(firstname, 'UTF-8')
            + '&users[0][lastname]=' + EncodingUtil.urlEncode(lastname, 'UTF-8')
            + '&users[0][email]=' + EncodingUtil.urlEncode(email, 'UTF-8')
            + '&users[0][password]=' + EncodingUtil.urlEncode(password, 'UTF-8');
    
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
		String moodleUserID = '';
        List<Object> responseList = (List<Object>) JSON.deserializeUntyped(response.getBody());
        if (!responseList.isEmpty()) {
            Map<String, Object> firstUser = (Map<String, Object>) responseList.get(0);
            moodleUserID = String.valueOf(firstUser.get('id'));
        } 
        
        // Now update the custom field
        url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_user_update_users'
            + '&moodlewsrestformat=json'
            + '&users[0][id]=' + EncodingUtil.urlEncode(moodleUserID, 'UTF-8')  // Replace with the actual Moodle user id
            + '&users[0][customfields][0][type]=' + EncodingUtil.urlEncode('NISS', 'UTF-8')
            + '&users[0][customfields][0][value]=' + EncodingUtil.urlEncode(niss, 'UTF-8');
    
        // Make the HTTP request
        request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    
        response = http.send(request);
        System.debug(response.getBody());
    }
    
    public static String createUserNF(String username, String firstname, String lastname, String email, String becodeID, String niss) {
        String password = generatePassword(12);
        System.debug(password);        
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_user_create_users'
            + '&moodlewsrestformat=json'
            + '&users[0][username]=' + EncodingUtil.urlEncode(username.toLowerCase(), 'UTF-8')
            + '&users[0][firstname]=' + EncodingUtil.urlEncode(firstname, 'UTF-8')
            + '&users[0][lastname]=' + EncodingUtil.urlEncode(lastname, 'UTF-8')
            + '&users[0][email]=' + EncodingUtil.urlEncode(email, 'UTF-8')
            + '&users[0][password]=' + EncodingUtil.urlEncode(password, 'UTF-8');
    
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        String moodleUserID = '';
        if (response.getBody().contains('Invalid parameter value detected')) {
            moodleUserID = getMoodleUserID(becodeID, email);
        } else {        
            List<Object> responseList = (List<Object>) JSON.deserializeUntyped(response.getBody());
            if (!responseList.isEmpty()) {
                Map<String, Object> firstUser = (Map<String, Object>) responseList.get(0);
                moodleUserID = String.valueOf(firstUser.get('id'));
            } 
        }
        System.debug(moodleUserID);
        url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_user_update_users'
            + '&moodlewsrestformat=json'
            + '&users[0][id]=' + EncodingUtil.urlEncode(moodleUserID, 'UTF-8')  // Replace with the actual Moodle user id
            + '&users[0][customfields][0][type]=' + EncodingUtil.urlEncode('NISS', 'UTF-8')
            + '&users[0][customfields][0][value]=' + EncodingUtil.urlEncode(niss, 'UTF-8');
        
        // Make the HTTP request
        request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        response = http.send(request);
        System.debug(response.getBody());
        return moodleUserID;    	
    }

    public static String generatePassword(Integer length) {
        // Define all possible characters for each requirement
        String lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
        String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String numbers = '0123456789';
        String specialChars = '!@#$%^&*()';
    
        // Generate a fixed number of random characters from each string
        String password = getRandomChars(lowercaseLetters, 5) 
            + getRandomChars(uppercaseLetters, 5)
            + getRandomChars(numbers, 2)
            + getRandomChars(specialChars, 2);
    
        // If length is greater than 12, add additional lowercase and uppercase characters
        if(length > 12) {
            Integer extraLength = length - 12;
            Integer extraLowercase = Math.round(extraLength / 2.0);
            Integer extraUppercase = extraLength - extraLowercase;
            password += getRandomChars(lowercaseLetters, extraLowercase) 
                + getRandomChars(uppercaseLetters, extraUppercase);
        }
    
        // Randomly shuffle the characters in the password string
        password = shuffle(password);
    
        return password;
    }
    
    public static String getRandomChars(String str, Integer num) {
        String result = '';
        for(Integer i = 0; i < num; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), str.length());
            result += str.substring(idx, idx + 1);
        }
        return result;
    }
    
    public static String shuffle(String str) {
        List<String> chars = new List<String>();
        for(Integer i = 0; i < str.length(); i++) {
            chars.add(str.substring(i, i + 1));
        }
        Integer numChars = chars.size();
        while(numChars > 1) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), numChars--);
            String tmp = chars[idx];
            chars[idx] = chars[numChars];
            chars[numChars] = tmp;
        }
        return String.join(chars, '');
    }

   // @future(callout=true)
    //public static void updateUser(String becodeID, String firstname, String lastname, String email) {
        // Get the users by their email
     //   String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
      //      + '?wstoken=' + MOODLE_TOKEN
      //      + '&wsfunction=core_user_get_users_by_field'
      //      + '&moodlewsrestformat=json'
       //     + '&field=email'
       //     + '&values[0]=' + EncodingUtil.urlEncode(email, 'UTF-8');
    
        //Http http = new Http();
        //HttpRequest request = new HttpRequest();
        //request.setEndpoint(url);
        //request.setMethod('GET');
    
        //HttpResponse response = http.send(request);
    
        //List<Object> users = (List<Object>) JSON.deserializeUntyped(response.getBody());
    
        //for (Object userObject : users) {
        //    Map<String, Object> user = (Map<String, Object>) userObject;
    //		System.debug(user);
     //       List<Object> customfields = (List<Object>) user.get('customfields');
      //      for (Object customfieldObject : customfields) {
       //         Map<String, Object> customfield = (Map<String, Object>) customfieldObject;
        //        System.debug(customfield);
         //       if (customfield.get('name').equals('Becode_ID') && customfield.get('value').equals(becodeID)) {
          //          // This is the user we want to update
		//			String moodleUserID = String.valueOf(user.get('id'));
    
   //                 url = MOODLE_BASE_URL + '/webservice/rest/server.php'
     //                   + '?wstoken=' + MOODLE_TOKEN
       //                 + '&wsfunction=core_user_update_users'
         //               + '&moodlewsrestformat=json'
           //             + '&users[0][id]=' + EncodingUtil.urlEncode(moodleUserID, 'UTF-8')
             //           + '&users[0][firstname]=' + EncodingUtil.urlEncode(firstname, 'UTF-8')
               //         + '&users[0][lastname]=' + EncodingUtil.urlEncode(lastname, 'UTF-8')
                 //       + '&users[0][email]=' + EncodingUtil.urlEncode(email, 'UTF-8')
                        //+ '&users[0][customfields][0][type]=' + EncodingUtil.urlEncode('Becode_ID', 'UTF-8')
                        //+ '&users[0][customfields][0][value]=' + EncodingUtil.urlEncode(becodeID, 'UTF-8');
    
                   // request = new HttpRequest();
      //              request.setEndpoint(url);
       //             request.setMethod('POST');
        //            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
   // 
                //    response = http.send(request);
              //      System.debug(response.getBody());
                    // TODO: Check the response and handle any errors
    
            //        break;
          //      }
        //    }
      //  }
	//}
	
    public static void createCohortNF(String cohortId, String cohortName, String cohortDescription, String catType, String catVal) {
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_cohort_create_cohorts'
            + '&moodlewsrestformat=json'
            + '&cohorts[0][idnumber]=' + EncodingUtil.urlEncode(cohortId, 'UTF-8')
            + '&cohorts[0][name]=' + EncodingUtil.urlEncode(cohortName, 'UTF-8')
			+ '&cohorts[0][categorytype][type]=' + EncodingUtil.urlEncode(catType, 'UTF-8')
            + '&cohorts[0][categorytype][value]=' + EncodingUtil.urlEncode(catVal, 'UTF-8');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        HttpResponse response = http.send(request);
        //System.debug(response.getBody());
        // TODO: Check the response and handle any errors
    }
    
    @future(callout=true)
    public static void createCohort(String cohortId, String cohortName, String cohortDescription, String catType, String catVal) {
                String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_cohort_create_cohorts'
            + '&moodlewsrestformat=json'
            + '&cohorts[0][idnumber]=' + EncodingUtil.urlEncode(cohortId, 'UTF-8')
            + '&cohorts[0][name]=' + EncodingUtil.urlEncode(cohortName, 'UTF-8')
			+ '&cohorts[0][categorytype][type]=' + EncodingUtil.urlEncode(catType, 'UTF-8')
            + '&cohorts[0][categorytype][value]=' + EncodingUtil.urlEncode(catVal, 'UTF-8');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        
        // TODO: Check the response and handle any errors
    }
    
    
    public static void createCategoryNF(String cohortId, String cohortName, String cohortDescription, String catType, String catVal) {
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_cohort_create_cohorts'
            + '&moodlewsrestformat=json'
            + '&cohorts[0][idnumber]=' + EncodingUtil.urlEncode(cohortId, 'UTF-8')
            + '&cohorts[0][name]=' + EncodingUtil.urlEncode(cohortName, 'UTF-8')
			+ '&cohorts[0][categorytype][type]=' + EncodingUtil.urlEncode(catType, 'UTF-8')
            + '&cohorts[0][categorytype][value]=' + EncodingUtil.urlEncode(catVal, 'UTF-8');
        
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        HttpResponse response = http.send(request);
        System.debug(response.getBody());

        // TODO: Check the response and handle any errors
    }
    
    @future(callout=true)
    public static void createCategory(String name, String parent, String idnumber, String description, String descriptionformat) {
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_course_create_categories'
            + '&moodlewsrestformat=json'
            + '&categories[0][name]=' + EncodingUtil.urlEncode(name, 'UTF-8')
            + '&categories[0][parent]=' + EncodingUtil.urlEncode(parent, 'UTF-8')
            + '&categories[0][idnumber]=' + EncodingUtil.urlEncode(idnumber, 'UTF-8')
            + '&categories[0][description]=' + EncodingUtil.urlEncode(description, 'UTF-8')
            + '&categories[0][descriptionformat]=' + EncodingUtil.urlEncode(descriptionformat, 'UTF-8');

        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        HttpResponse response = http.send(request);
        System.debug(response.getBody());

        // TODO: Check the response and handle any errors
    }
    
    @future(callout=true)
    public static void updateCareerCoachFeedback(String becodeID, String email, String feedback) {
        // Get the Moodle user ID of the user with the specified becode ID
    	String moodleid = getMoodleUserID(becodeID, email);
        System.debug(moodleid);
        if (feedback == null || feedback == '') {
            feedback = ' ';            
        }
        if (moodleid != null) {
            String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
                + '?wstoken=' + MOODLE_TOKEN
                + '&wsfunction=core_user_update_users'
                + '&moodlewsrestformat=json'
                + '&users[0][id]=' + EncodingUtil.urlEncode(moodleid, 'UTF-8')
                + '&users[0][customfields][0][type]=Career_Coach_Feedback'
                + '&users[0][customfields][0][value]=' + EncodingUtil.urlEncode(feedback, 'UTF-8');
        
            // Make the HTTP request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
        
            // TODO: Check the response and handle any errors
        }
    }
    
    @future(callout=true)
    public static void assignLearnerToCohort(String cohortId, String userId) {
         String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_cohort_add_cohort_members'
            + '&moodlewsrestformat=json'
            + '&members[0][cohorttype][type]=' + EncodingUtil.urlEncode('idnumber', 'UTF-8')
            + '&members[0][cohorttype][value]=' + EncodingUtil.urlEncode(cohortId, 'UTF-8')
            + '&members[0][usertype][type]=' + EncodingUtil.urlEncode('idnumber', 'UTF-8')
            + '&members[0][usertype][value]=' + EncodingUtil.urlEncode(userId.toLowerCase(), 'UTF-8');
        
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        HttpResponse response = http.send(request);
        //System.debug(response.getBody());
    
        // TODO: Check the response and handle any errors
    }
    
    public static void assignLearnerToCohortNF(String cohortId, String userId) {
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_cohort_add_cohort_members'
            + '&moodlewsrestformat=json'
            + '&members[0][cohorttype][type]=' + EncodingUtil.urlEncode('idnumber', 'UTF-8')
            + '&members[0][cohorttype][value]=' + EncodingUtil.urlEncode(cohortId, 'UTF-8')
            + '&members[0][usertype][type]=' + EncodingUtil.urlEncode('username', 'UTF-8')
            + '&members[0][usertype][value]=' + EncodingUtil.urlEncode(userId.toLowerCase(), 'UTF-8');
        
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        HttpResponse response = http.send(request);
        if (cohortId == 'BXL-2024-03-Kamkar') {
        	System.debug(response.getBody());
        }
    
        // TODO: Check the response and handle any errors
    }
    
    public static String getMoodleUserID(String becodeID, String email) {
        String url = MOODLE_BASE_URL + '/webservice/rest/server.php'
            + '?wstoken=' + MOODLE_TOKEN
            + '&wsfunction=core_user_get_users_by_field'
            + '&moodlewsrestformat=json'
            + '&field=username'
            + '&values[0]=' + EncodingUtil.urlEncode(becodeID, 'UTF-8');
    
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
    
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        List<Object> users = (List<Object>) JSON.deserializeUntyped(response.getBody());
    
        if (!users.isEmpty()) {
            Map<String, Object> firstUser = (Map<String, Object>) users.get(0);
			String id = String.valueOf(firstUser.get('id'));
            return id;
        } else {
            return null;
        }
    }

}