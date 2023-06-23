public with sharing class SendMultipleEnvelopes {
    
    @InvocableMethod(
        label = 'Create Envelopes'
        description = 'Create Envelopes'
    )
    public static List<GenericResponse> createEnvelopes(List<SubmitRequest> requests){

        List<GenericResponse> responses = new List<GenericResponse>();
        GenericResponse obResponse = null;
        String envelopeId = null;

        If ((requests != null) || !requests.isEmpty()){
            SubmitRequest singleRequest = requests.get(0);

            envelopeId = sendEnvelopesMethod(singleRequest.sourceRecId, singleRequest.contactIds);

            obResponse = new GenericResponse();
            obResponse.errorCode = 1;
            obResponse.errorMessage = 'None';
            obResponse.envelopeId = envelopeId;
            responses.add(obResponse);
        }

        return (responses);

    }

    @AuraEnabled
    public static string sendEnvelopesMethod(Id recordId, List<String> contactIds){
        try {

            Id oppId = recordId;
            List<Contact> signers = [SELECT Id, Contact.Email, Contact.Name, Role FROM OpportunityContactRole WHERE OpportunityId = :contactIds WITH SECURITY_ENFORCED];

            List<dfsle.Envelope> envelopes = new List<dfsle.Envelope>();

            dfsle.Envelope ndaEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(oppId));

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
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

    public class GenericResponse {

        @InvocableVariable (
            label = 'Error Code'
            description = 'Error Code'
        )
        public Integer errorCode;

        @InvocableVariable (
            label = 'Error Message'
            description = 'Error Message'
        )
        public String errorMessage;
    }
}