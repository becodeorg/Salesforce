public with sharing class JsonParser {
    public static Map<String, Object> parseJson(String jsonStr) {
        return (Map<String, Object>) System.JSON.deserializeUntyped(jsonStr);
    }
}