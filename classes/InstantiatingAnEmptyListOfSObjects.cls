public with sharing class InstantiatingAnEmptyListOfSObjects {

	public InstantiatingAnEmptyListOfSObjects() {
		List<sObject> sObjects = new List<sObject>();
	}

	void methodOne () {
		//List<SObject> sObjects = Database.query('select id from ' + myObject.getSObjectType() + ' where id = null');

	}

	void methodTwo () {
		//String searchquery='FIND\'xxx\'IN ALL FIELDS RETURNING '+ myObject.getSObjectType() +'(name)';
		//List<List<SObject> searchList=search.query(searchquery);
		//List<SObject> sobjects = searchlist[0];
	}
		 
	public class myObject{
		sObject obj {get; set;}
	 
		public myObject(sObject obj){
			this.obj = obj;
		}
	}
}