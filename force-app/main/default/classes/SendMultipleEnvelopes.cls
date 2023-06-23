public with sharing class SendMultipleEnvelopes {
    /**
     * createEnvelopes method (List)
     *  Get Opportunity Id and Opportunity Contact Roles from autolaunched flow
     *  Pass ID and list of contact roles associated to the opportunity to the sendEnvelopesMethod
     *  
     */
    
    @InvocableMethod(
        label = 'Create Envelopes'
        description = 'Create Envelopes'
    )
    public static List<GenericResponse> createEnvelopes(List<SubmitRequest> requests){

        //List for error handling
        List<GenericResponse> responses = new List<GenericResponse>();
        GenericResponse obResponse = null;
        
        //Confirm that requests is not null
        If ((requests != null) || !requests.isEmpty()){
            SubmitRequest singleRequest = requests.get(0);

            // Pass source record Id and list of opportunity contact role Ids
            sendEnvelopesMethod(singleRequest.sourceRecId, singleRequest.contactIds);

            obResponse = new GenericResponse();
            obResponse.errorCode = 1;
            obResponse.errorMessage = 'None';
            responses.add(obResponse);
        }

        return (responses);

    }

    /**
     * sendEnvelopesMethod (Id and List)
     *  Based off contact role, create envelope specific to that role
     *  Add envelopes to list
     *  Send envelopes 
     */

    public static void sendEnvelopesMethod(Id recordId, List<String> contactIds){
        try {

            OpportunityContactRole ndaContact;
            OpportunityContactRole sowContact;
            OpportunityContactRole quoteContact;

            Id oppId = recordId;
            List<OpportunityContactRole> oppContacts = [SELECT Id, Contact.Email, Contact.Name, Role FROM OpportunityContactRole WHERE OpportunityId = :oppId WITH SECURITY_ENFORCED];

            List<dfsle.Envelope> envelopes = new List<dfsle.Envelope>();

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

                    envelopes.add(ndaEnvelope);

                } else if (c.Role == 'SOW Signer'){

                    sowContact = c;

                    dfsle.Envelope sowEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(oppId));

                    dfsle.Recipient sowSigner = dfsle.Recipient.fromSource(
                        sowContact.Contact.Name,
                        sowContact.Contact.Email,
                        null,
                        'SOW Signer',
                        new dfsle.Entity(sowContact.Id)
                    );

                    sowEnvelope = sowEnvelope.withRecipients(new List<dfsle.Recipient> {sowSigner});

                    dfsle.UUID sowTemplateId = dfsle.UUID.parse('532f31d7-4d83-4cd1-83e5-900c3b676cc4');

                    dfsle.Document sowDocument = dfsle.Document.fromTemplate(sowTemplateId, 'SOW Template');

                    sowEnvelope = sowEnvelope.withDocuments(new List<dfsle.Document> { sowDocument });

                    envelopes.add(sowEnvelope);

                } else if (c.Role == 'Quote Signer') {

                    quoteContact = c;

                    dfsle.Envelope quoteEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(oppId));

                    dfsle.Recipient quoteSigner = dfsle.Recipient.fromSource(
                        quoteContact.Contact.Name,
                        quoteContact.Contact.Email,
                        null,
                        'SOW Signer',
                        new dfsle.Entity(quoteContact.Id)
                    );

                    quoteEnvelope = quoteEnvelope.withRecipients(new List<dfsle.Recipient> {quoteSigner});

                    dfsle.UUID quoteTemplateId = dfsle.UUID.parse('52221a0e-f6b0-4965-8b2b-8067f4309bcb');

                    dfsle.Document quoteDocument = dfsle.Document.fromTemplate(quoteTemplateId, 'Quote Template');

                    quoteEnvelope = quoteEnvelope.withDocuments(new List<dfsle.Document> { quoteDocument });

                    envelopes.add(quoteEnvelope);

                }
            }
            

            List<dfsle.Envelope> sentEnvelopes = new List<dfsle.Envelope>();

            for (dfsle.Envelope e : dfsle.EnvelopeService.sendEnvelopes(envelopes)) {

                if (e.error == null) {

                    sentEnvelopes.add(e);
                } else {

                    System.debug('Envelope error: ' + e.error);

                }
            }
            

            
        } catch (Exception e) {
            
            System.debug('Error: ' + e);

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