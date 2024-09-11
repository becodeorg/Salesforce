public with sharing class PasswordValidator {
    @AuraEnabled(cacheable=false)
    public static Boolean checkPassword(String inputPassword) {
        // Retrieve the password from Custom Metadata or Custom Setting
        String actualPassword = 'InCodeWeTrust!'; // Replace with actual retrieval
        return inputPassword == actualPassword;
    }
}