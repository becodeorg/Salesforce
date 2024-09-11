@isTest
public with sharing class JsonParser_Tests {
    @isTest static void testParseJson() {
        String jsonStr = '{"name":"John","age":30,"city":"New York"}';
        
        Map<String, Object> result = JsonParser.parseJson(jsonStr);
        
        // Assert the returned map has the correct number of keys
        System.assertEquals(3, result.keySet().size(), 'Map should have 3 keys');
        
        // Assert the values in the map are as expected
        System.assertEquals('John', result.get('name'), 'Name should be John');
        System.assertEquals(30, result.get('age'), 'Age should be 30');
        System.assertEquals('New York', result.get('city'), 'City should be New York');
    }
}