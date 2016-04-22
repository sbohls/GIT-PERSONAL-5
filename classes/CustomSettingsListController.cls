


// MAKE A REPOSITORY AND CHECK THIS IN ON GITHUB: https://git.corp.adobe.com/bohls





public with sharing class CustomSettingsListController {
// -----------------------------------------------------------------------------------------------------
// CLASS VARIABLES
// -----------------------------------------------------------------------------------------------------
	public Map<String, List<SObject>> 				mapSettingsSObjects			{ get; set; } // a map of the settings objects by API
	public List<Settings_for_Custom_Settings__c> 	listSettingsSettings		{ get; set; } // a list of all of the different types of Custom Settings
	public List<selectOption> 						picklistSettings 			{ get; set; } // a picklist of all of the different types of Custom Settings
	public List<SObject> 							dynamicSObject 				{ get; set; } // a dynamic, empty object used to add new Custom Settings objects in-page
	public String 									selectionSetting 			{ get; set; } // the picklist value of the currently selected Custom Setting 
	public Boolean 									editMode 					{ get; set; } // a rendered condition to switch from inputFields to outputFields 
	public Boolean 									addMode 					{ get; set; } // a rendered condition to add inputFields to add new Custom Settings
	public Boolean 									settingSelected 			{ get; set; } // waits to populate buttons and pageBlocks until a setting has been selected
	public String 									emptyPicklistString = '--enter name--';   // inputField filler to indicate required fields


	// BAD CODE TO FIX
	public List<Map_Key_Value__c> 					mkvTable 					{ get; set; } // filtered list of Map_Key_Value__c objects
	public List<selectOption> 						picklistMkvNames 			{ get; set; } // picklist of Map_Key_Value__c.Name values
	public List<selectOption> 						picklistMkvKeys 			{ get; set; } // picklist of Map_Key_Value__c.Map_Key values
	public List<selectOption> 						picklistMkvValues 			{ get; set; } // picklist of Map_Key_Value__c.Map_Value values
	public String 									selectionMkvName 			{ get; set; } // de-duplicated list of Map_Key_Value__c.Name values
	public String 									selectionMkvKey 			{ get; set; } // de-duplicated list of Map_Key_Value__c.Map_Key values
	public String 									selectionMkvValue 			{ get; set; } // de-duplicated list of Map_Key_Value__c.Map_Value values


// -----------------------------------------------------------------------------------------------------
// CONSTRUCTOR
// -----------------------------------------------------------------------------------------------------
	public CustomSettingsListController() {
		buildListOfCustomSettings();
		buildPicklistOfCustomSettings();
		buildMkvLists(); 
	}


// -----------------------------------------------------------------------------------------------------
// METHODS
// -----------------------------------------------------------------------------------------------------
	public void buildListOfCustomSettings() {
		// query for and build the list of Custom Settings' APIs and Custom Settings' names 
		listSettingsSettings = [SELECT 	API__c, 
										SettingName__c, 
										Title__c

								FROM 	Settings_for_Custom_Settings__c];

		// build the map of the settings objects by API
		mapSettingsSObjects = new Map<String, List<SObject>>();
		for(Settings_for_Custom_Settings__c setting : listSettingsSettings) {
			List<String> listApi = new List<String>();
			listApi = getListFields(setting.API__c);
			mapSettingsSObjects.put(setting.API__c, listSettingsSObjects(setting.API__c, listApi));
		}
	}

	public void buildPicklistOfCustomSettings() {
		// build the picklist of all of the different types of Custom Settings
		picklistSettings = new List<selectOption>();
		picklistSettings.add(new SelectOption('-none-', '-none-'));
		for (Settings_for_Custom_Settings__c setting : listSettingsSettings) {
			picklistSettings.add(new SelectOption(setting.settingName__c, setting.settingName__c));
		}
	}

	public void editModeOn() {
		// VF BUTTON: visualforce page button to tell VF page to switch from outputFields to inputFields
		editMode = true;
	}

	public void editModeOff() {
		// VF BUTTON: visualforce page button to tell VF page to switch from inputFields to outputFields
		editMode = false;
	}

	public void enterAdd() {
		// VF BUTTON: adds inputFields to the VF page as dynamic fields to the active Custom Setting
		addMode = true;

		// populates the 'name' field with '--enter name--' to indicate that it is a required field
		dynamicSObject[0].put('Name', emptyPicklistString);
	}

	public void exitAdd() {
		// VF BUTTON: removes the object-adding inputFields from the VF page
		addMode = false;
	}

	public void addNewEntry() {
		// VF BUTTON: insert a new custom setting as long as the 'name' field is not set to its default value
		if(dynamicSObject[0].get('Name') != emptyPicklistString) {

			insert dynamicSObject;
		}

		// build a new, empty, dynamic object for 'adding' a new Custom Setting if necessary
		buildSelectList();

		// re-build the Custom Settings objects to immediatly refresh the new added changes on the table
		buildListOfCustomSettings();

		// refresh the text for adding a new Custom Setting object
		dynamicSObject[0].put('Name', emptyPicklistString);
    }    

	public void saveTableChanges() {
		// VF BUTTON: update table changes
		update mapSettingsSObjects.get(activeApi());

		// change from inputFields to outputFields on the page
		editMode = false;
	}

	public String activeApi() {
		// return the active Custom Setting's API
		String api = '';
		for(Settings_for_Custom_Settings__c setting : listSettingsSettings) {
			if(setting.settingName__c == selectionSetting) {
				api = setting.API__c;
			}
		}
		return api;
	}

	public void buildSelectList() {
		// this method builds an empty, dynamic object for 'adding' a new Custom Setting and runs once on page load, then each time a new setting is added
		Schema.SObjectType t = Schema.getGlobalDescribe().get(activeApi());
		SObject s = t.newSObject();
		dynamicSObject = new List<SObject>();
		dynamicSObject.add(s);
		
		// set 'settingSelected' to 'true' to let the page know that it can populate buttons and pageBlocks because a setting has been selected
		settingSelected = true;
	}

	public List<String> getListFields(String api) {
		// returns a list of all custom fields (including 'name') given an API
		Map<String, SObjectField> mapFields = Schema.getGlobalDescribe().get(api).getDescribe().fields.getMap();
		List<String> listApi = new List<String>();

		// filter for '__c' to get custom fields
		for (String field : mapFields.keySet()) {
			if(field.contains('__c') || field.contains('name')) {
				listApi.add(field);
			}
		}

		return listApi;
	}

	public List<sObject> listSettingsSObjects(String api, List<String> listFields) {
		// this method builds and executes a query given an API and a list of fields, and then returns that query as a list of SObjects

		// concatenate the fields into a string
		String fields = '';
		for(String field : listFields) {

			if(fields != '') {
				fields += ', ';
			}

			fields += field;
		}

		// execute the query
		return Database.query('SELECT ' + fields + ' FROM ' + api);
	}

	public List<String> getTableFields() {
		// this method returns a list of names given an API
		return getListFields(activeApi());
	}



// -----------------------------------------------------------------------------------------------------
// BAD CODE TO FIX
// -----------------------------------------------------------------------------------------------------
	
	// build the filters for the Map_Key_Value__c object
	public void buildMkvLists() {

		// build the 3 picklists for the filters
		picklistMkvNames = new List<selectOption>();
		picklistMkvKeys = new List<selectOption>();
		picklistMkvValues = new List<selectOption>();

		// build corresponding 'sets' to de-dupe the picklists
		Set<selectOption> 	setPicklistMkvNames = new Set<selectOption>();
		Set<selectOption> 	setPicklistMkvKeys = new Set<selectOption>();
		Set<selectOption> 	setPicklistMkvValues = new Set<selectOption>();

		// add an empty selectOption to make the picklists blank when the page loads
		setPicklistMkvNames.add  (new SelectOption ('', ''));
		setPicklistMkvKeys.add 	 (new SelectOption ('', ''));
		setPicklistMkvValues.add (new SelectOption ('', ''));

		// query for the names, keys, and values of all Map_Key_Value__c objects
		List<Map_Key_Value__c> listMkv = [	SELECT 	Name, Map_Key__c, 
													Map_Value__c, 
													Map_Name__c
											
											FROM 	Map_Key_Value__c];

		// add the objects to their sets for de-duping
		for (Map_Key_Value__c mkv : listMkv) {	
			setPicklistMkvNames.add(new SelectOption(mkv.Map_Name__c, mkv.Map_Name__c));
			setPicklistMkvKeys.add(new SelectOption(mkv.name, mkv.Map_Key__c));
			setPicklistMkvValues.add(new SelectOption(mkv.Map_Value__c, mkv.Map_Value__c));
		}

		// add the de-duped items to their lists
		for(selectOption sOp : setPicklistMkvNames)		{	picklistMkvNames.add(sOp);	}
		for(selectOption sOp : setPicklistMkvKeys)		{	picklistMkvKeys.add(sOp);	}
		for(selectOption sOp : setPicklistMkvValues)	{	picklistMkvValues.add(sOp);	}
	}
	
	// pass the field name, the active picklist selection, and a boolean token of the field (Name, Key, Value) to the 'buildTable' method
	public void mkvNames() 	{	mkvTable = buildTable('Map_Name__c = ' 	+ '\'' + selectionMkvName + '\'', 	true, false, false);	}
	public void mkvKeys() 	{	mkvTable = buildTable('Name = ' 		+ '\'' + selectionMkvKey + '\'', 	false, true, false);	}
	public void mkvValues() {	mkvTable = buildTable('Map_Value__c = ' + '\'' + selectionMkvValue + '\'', 	false, false, true);	}
	
	// build the Map_Key_Value__c table based on the received filters

	public List<Map_Key_Value__c> buildTable(String fld, Boolean mkvName, Boolean mkvKey, Boolean mkvValue) {
		// empty the other picklists to avoid user confusion
		if(mkvName==false) 	{	selectionMkvName 	= '';	}
		if(mkvKey==false) 	{	selectionMkvKey 	= '';	}
		if(mkvValue==false) {	selectionMkvValue 	= '';	}

		// query for the new table based on the filters
		String qString = 'SELECT name, Description__c, IsKeyCaseSensitive__c, Map_Key__c, Map_Name__c, Map_Value__c FROM Map_Key_Value__c WHERE ' + fld;
		List<SObject> listSo = Database.query(qString);

		// convert the results to 'Map_Key_Value__c' objects
		List<Map_Key_Value__c> convertedMap = new List<Map_Key_Value__c>();
		for(SObject so : listSo) {
			convertedMap.add( (Map_Key_Value__c) so);
		}

		// return the table results
		return convertedMap;
	}
}