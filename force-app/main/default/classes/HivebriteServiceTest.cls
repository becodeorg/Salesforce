@isTest
private class HivebriteServiceTest {

@isTest
    static void testGetHivebriteToken() {
        Test.setMock(HttpCalloutMock.class, new HivebriteTokenMock());
        HivebriteService service = new HivebriteService();
        Test.startTest();
        service.getHivebriteToken();
        Test.stopTest();
    }
}