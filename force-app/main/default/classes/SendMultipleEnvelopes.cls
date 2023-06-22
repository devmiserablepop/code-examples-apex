public with sharing class SendMultipleEnvelopes {
    
    @InvocableMethod{
        label = 'Create Envelopes'
        description = 'Create Envelopes'
    }
    public SendMultipleEnvelopes() {

    }


    public class SubmitRequest {

        @InvocableVariable (
            label = 'Contact Ids'
            description = 'Contact Ids'
        )
        public List<String> contactIds;

        @InvocableVariable (
            label = 'Source Record Id'
            description = 'Source Record Id'
        )
        public Id sourceRecId;

    }
}