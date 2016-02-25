global with sharing class InvoiceUtilities {

//--------------------------------------------------------------------------------------------
// re-orders all of the 'Line Item Number' fields in a particular invoice in a linear pattern starting with '1'
//--------------------------------------------------------------------------------------------

    webservice static String renumberLineItems(String invoiceName) {

    Invoice__c invoice = [Select i.Name, (Select Name From Line_Items__r ORDER BY Name) 
                          From Invoice__c i 
                          Where i.Name = :invoiceName LIMIT 1];

    Integer startingLineItemNumber = 1;
    for (Line_Item__c item : invoice.Line_Items__r) {
      item.Name = String.valueOf(startingLineItemNumber);
      System.debug(item.Name);
      startingLineItemNumber++;
    }

    try {
      database.update(invoice.Line_Items__r);
    } catch (DmlException e) {
      return e.getMessage();
    }

    return 'Line items renumbered successfully.'; 
  }
}

//--------------------------------------------------------------------------------------------
// BLOCKERS:
//--------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------
// QUESTIONS:
// --setting the variable 'i' in the select statement?
// --using Line_Items__r without referencing anything [oh, is this referencing ALL fields from Line_Items??]
//--------------------------------------------------------------------------------------------