public class DynamicFieldDetermining {
// 	-----------------------------------------------------------------------------
// 	CLASS VARIABLES
// 	-----------------------------------------------------------------------------
	List<String> listOfFields = new List<String>();
	List<String> listOfFieldTypes = new List<String>();

// 	-----------------------------------------------------------------------------
// 	CONSTRUCTOR
// 	-----------------------------------------------------------------------------
	public DynamicFieldDetermining() {
		getFieldType('Age__c', 'Castle__c');

		for (String s : objList()) {
			System.debug(s);
		}
	}

	//public static String getFieldType(String fieldName) {
 //       System.debug('1');

	//}

// 	-----------------------------------------------------------------------------
// 	METHODS
// 	-----------------------------------------------------------------------------
	public void getFieldType(String fieldName, String sObjectName){
		// prints in String format, the field TYPE
		Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName);
		 
		Schema.DescribeSObjectResult r = t.getDescribe();
		Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();

		// getLabel =			Age;
		// getLocalName =		Age__c;
		// getName =			Age__c;
		// getPrecision =		18;
		// getSoapType =		DOUBLE;			// using this as example
		// getSobjectField =	Age__c;
		// getType =			DOUBLE;

		system.debug(f.getSoapType());
	}

	public List<String> objList () {
		// returns a list of ALL the objects
		for (Schema.SObjectType field : Schema.getGlobalDescribe().Values()) {
		   listOfFields.add(field.getDescribe().getName());
		}
		return listOfFields;
	}
}