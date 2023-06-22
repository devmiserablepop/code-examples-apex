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