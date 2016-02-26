public with sharing class SObjectValueOrReference {
// 	-----------------------------------------------------------------------------
// 	CLASS VARIABLES
// 	-----------------------------------------------------------------------------
	public String greeting = 'Hello';
	public Value val = new Value(greeting);

// 	-----------------------------------------------------------------------------
// 	CONSTRUCTOR
// 	-----------------------------------------------------------------------------
	public SObjectValueOrReference() {

		System.debug('Old class value is: ' + val.name);
		System.debug('Old regular val is: ' + greeting);

		byReference(val);
		byValue(greeting);

		System.debug('New class value is: ' + val.name);
		System.debug('New regular value is: ' + greeting);
	}

// 	-----------------------------------------------------------------------------
// 	METHODS
// 	-----------------------------------------------------------------------------
	public void byReference(Value v) {
		v.name = 'Goodbye';
	}

	public void byValue(String v) {
		v = 'Goodbye';
	}

// 	-----------------------------------------------------------------------------
// 	INNER CLASSES
// 	-----------------------------------------------------------------------------
	public class Value {
		// public String name{ get;set; }
		public String name;
		public Value(String n) {
			name= n;
		}
	}
}
