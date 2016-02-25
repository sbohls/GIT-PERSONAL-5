trigger PRACTICE_2_11_SEND_EMAIL_TRIGGER on Opportunity (after update) {
    Id sourceRecordId;
    String emailBody, emailSubject, emailReceiver;
    List<Opportunity> listOpty;

    getValues();
    
    if(emailReceiver != 'RECEIVER NOT FOUND') {
        sendMail();
    }
    
    void getValues() {
        for(Opportunity o : trigger.new) {
            sourceRecordId = o.id;
        }

        listOpty = [select EmailBody__c, EmailReceiver__c, EmailSubject__c from Opportunity where Id =: sourceRecordId];

        if(listOpty[0].EmailBody__c != null) {            emailBody = listOpty[0].EmailBody__c;         } else emailBody = 'BODY NOT FOUND';
        if(listOpty[0].EmailSubject__c != null) {         emailSubject = listOpty[0].EmailSubject__c;   } else emailSubject = 'SUBJECT NOT FOUND';
        if(listOpty[0].EmailBody__c != null) {            emailReceiver = listOpty[0].EmailReceiver__c; } else emailReceiver = 'RECEIVER NOT FOUND';
    }
    
    public void sendMail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {emailReceiver};
        mail.setToAddresses(toAddresses);
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailBody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        inspectResults(results);
    }

    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
}