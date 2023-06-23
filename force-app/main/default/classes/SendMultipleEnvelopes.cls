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

            OpportunityContactRole ndaContact;
            OpportunityContactRole sowContact;
            OpportunityContactRole quoteContact;

            Id oppId = recordId;
            List<OpportunityContactRole> oppContacts = [SELECT Id, Contact.Email, Contact.Name, Role FROM OpportunityContactRole WHERE OpportunityId = :contactIds WITH SECURITY_ENFORCED];

            for (OpportunityContactRole c : oppContacts) {

                if (c.Role == 'NDA Signer') {

                    ndaContact = c;

                    dfsle.Envelope ndaEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(oppId));

                    dfsle.Recipient ndaSigner = dfsle.Recipient.fromSource(
                        ndaContact.Contact.Name,
                        ndaContact.Contact.Email,
                        null,
                        'NDA Signer',
                        new dfsle.Entity(ndaContact.Id)
                    );

                    ndaEnvelope = ndaEnvelope.withRecipients(new List<dfsle.Recipient> {ndaSigner});

                    dfsle.UUID ndaTemplateId = dfsle.UUID.parse('fc64b82b-b513-4346-b6b9-4659658a88c3');

                    dfsle.Document ndaDocument = dfsle.Document.fromTemplate(ndaTemplateId, 'NDA Template');

                    ndaEnvelope = ndaEnvelope.withDocuments(new List<dfsle.Document> { ndaDocument });

                } else if (c.Role == 'SOW Signer'){

                    sowContact = c;

                    dfsle.Envelope sowEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(oppId));

                    dfsle.Recipient sowSigner = dfsle.Recipient.fromSource(
                        sowContact.Contact.Name,
                        sowContact.Contact.Email,
                        null,
                        'SOW Signer',
                        new dfsle.Entity(sowContact.Id);
                    );

                    sowEnvelope = sowEnvelope.withRecipients(new List<dfsle.Recipient> {sowSigner});

                    

                } else if (c.Role == 'Quote Signer') {

                    quoteContact = c;
                }
            }

            
            
            List<dfsle.Envelope> envelopes = new List<dfsle.Envelope>();

            

            
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