/**
 * Represents a Box Sign request.
 */
public class BoxSignRequest extends BoxResource {
    private static String SIGN_REQUESTS_URL = 'sign_requests';
    private static String SIGN_REQUEST_URL = 'sign_requests/{0}';
    private static String SIGN_REQUEST_CANCEL_URL = 'sign_requests/{0}/cancel';
    private static String SIGN_REQUEST_RESEND_URL = 'sign_requests/{0}/resend';

    /**
     * Constructs a BoxSignRequest for a sign request with a given ID.
     *
     * @param api the API connection to be used by the sign request.
     * @param id the ID of the sign request.
     */
    public BoxSignRequest(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'sign_request';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxSignRequest.Info) jsonObject;
    }

    /**
     * Gets information about this sign request.
     *
     * @return information about this sign request.
     */
    public BoxSignRequest.Info getInfo() {
        String url = this.api.baseUrl + String.format(
            SIGN_REQUEST_URL,
            new List<String>{ this.getId() }
        );
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_GET
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxSignRequest.getInfo'
        );
        return new BoxSignRequest.Info(responseBody);
    }

    /**
     * Cancels this sign request.
     *
     * @return the cancelled sign request information.
     */
    public BoxSignRequest.Info cancel() {
        String url = this.api.baseUrl + String.format(
            SIGN_REQUEST_CANCEL_URL,
            new List<String>{ this.getId() }
        );
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_POST
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxSignRequest.cancel'
        );
        return new BoxSignRequest.Info(responseBody);
    }

    /**
     * Resends this sign request.
     *
     * @return true if resend was successful.
     */
    public Boolean resend() {
        String url = this.api.baseUrl + String.format(
            SIGN_REQUEST_RESEND_URL,
            new List<String>{ this.getId() }
        );
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_POST
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(
            response,
            'BoxSignRequest.resend',
            new Set<Integer>{ 202 }
        );
    }

    /**
     * Creates a new sign request.
     *
     * @param api the API connection to use.
     * @param requestInfo the sign request information.
     * @return the created sign request.
     */
    public static BoxSignRequest.Info create(
        BoxApiConnection api,
        BoxSignRequest.Info requestInfo
    ) {
        String url = api.baseUrl + SIGN_REQUESTS_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );
        request.setBody(requestInfo.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxSignRequest.create'
        );
        return new BoxSignRequest.Info(responseBody);
    }

    /**
     * Gets all sign requests.
     *
     * @param api the API connection to use.
     * @param marker the position marker for pagination.
     * @param limitValue the maximum number of items to return.
     * @return a list of sign requests.
     */
    public static List<BoxSignRequest.Info> getAll(
        BoxApiConnection api,
        String marker,
        Integer limitValue
    ) {
        String url = api.baseUrl + SIGN_REQUESTS_URL;
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        
        // Add query parameters
        List<String> queryParams = new List<String>();
        if (marker != null) {
            queryParams.add('marker=' + marker);
        }
        if (limitValue != null) {
            queryParams.add('limit=' + String.valueOf(limitValue));
        }
        if (!queryParams.isEmpty()) {
            url += '?' + String.join(queryParams, '&');
            request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        }
        
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxSignRequest.getAll'
        );

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        List<String> entries = BoxJsonObject.parseJsonObjectArray(
            responseObject.getValue('entries')
        );
        List<BoxSignRequest.Info> requests = new List<BoxSignRequest.Info>();
        for (String entry : entries) {
            requests.add(new BoxSignRequest.Info(entry));
        }
        return requests;
    }

    /**
     * Information about BoxSignRequest
     */
    public class Info extends BoxResource.Info {
        public List<BoxFile.Info> sourceFiles;
        public List<Signer> signers;
        public BoxFolder.Info parentFolder;
        public String name;
        public String emailSubject;
        public String emailMessage;
        public Boolean isDocumentPreparationNeeded;
        public Boolean areTextSignaturesEnabled;
        public Boolean areAttachmentsRequired;
        public Boolean isPhoneVerificationRequiredToView;
        public String redirectUrl;
        public String declinedRedirectUrl;
        public DateTime expiresAt;
        public String status;
        public String signFiles;
        public List<String> prefillTags;
        public Integer daysValid;
        public String externalId;
        public DateTime prepareUrl;
        public BoxUser.Info signingLog;
        public String templateId;

        /**
         * Constructs an empty Info object.
         */
        public Info() {
            super();
        }

        /**
         * Constructs an Info object by parsing information from a JSON string.
         *
         * @param json the JSON string to parse.
         */
        public Info(String jsonString) {
            super(jsonString);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        /**
         * Constructs an Info object using an already parsed JSON object.
         *
         * @param jsonObject the parsed JSON object.
         */
        public Info(BoxJsonObject jsonObject) {
            super(jsonObject);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        public override void addValue(String key, String value) {
            super.addValue(key, value);
            if (key != null) {
                this.parseMember(key, value);
                this.rebuildJsonString = true;
            }
        }

        public override void addValue(String key, BoxJsonObject value) {
            this.addValue(key, value.getJsonString());
        }

        @testvisible
        private void parseMember(String key, String value) {
            if (key != null) {
                if (key == 'id') {
                    this.id = value;
                } else if (key == 'type') {
                    this.typeName = value;
                } else if (key == 'source_files') {
                    this.sourceFiles = new List<BoxFile.Info>();
                    List<String> files = BoxJsonObject.parseJsonObjectArray(value);
                    for (String file : files) {
                        this.sourceFiles.add(new BoxFile.Info(file));
                    }
                } else if (key == 'signers') {
                    this.signers = new List<Signer>();
                    List<String> signerList = BoxJsonObject.parseJsonObjectArray(value);
                    for (String signer : signerList) {
                        this.signers.add(new Signer(signer));
                    }
                } else if (key == 'parent_folder') {
                    this.parentFolder = new BoxFolder.Info(value);
                } else if (key == 'name') {
                    this.name = value;
                } else if (key == 'email_subject') {
                    this.emailSubject = value;
                } else if (key == 'email_message') {
                    this.emailMessage = value;
                } else if (key == 'is_document_preparation_needed') {
                    this.isDocumentPreparationNeeded = Boolean.valueOf(value);
                } else if (key == 'are_text_signatures_enabled') {
                    this.areTextSignaturesEnabled = Boolean.valueOf(value);
                } else if (key == 'are_attachments_required') {
                    this.areAttachmentsRequired = Boolean.valueOf(value);
                } else if (key == 'is_phone_verification_required_to_view') {
                    this.isPhoneVerificationRequiredToView = Boolean.valueOf(value);
                } else if (key == 'redirect_url') {
                    this.redirectUrl = value;
                } else if (key == 'declined_redirect_url') {
                    this.declinedRedirectUrl = value;
                } else if (key == 'expires_at') {
                    this.expiresAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'status') {
                    this.status = value;
                } else if (key == 'sign_files') {
                    this.signFiles = value;
                } else if (key == 'prefill_tags') {
                    this.prefillTags = (List<String>) JSON.deserialize(value, List<String>.class);
                } else if (key == 'days_valid') {
                    this.daysValid = Integer.valueOf(value);
                } else if (key == 'external_id') {
                    this.externalId = value;
                } else if (key == 'prepare_url') {
                    this.prepareUrl = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'signing_log') {
                    this.signingLog = new BoxUser.Info(value);
                } else if (key == 'template_id') {
                    this.templateId = value;
                }
            }
        }
    }

    /**
     * Represents a signer in a sign request.
     */
    public class Signer extends BoxJsonObject {
        public String email;
        public String role;
        public Boolean isInPerson;
        public Integer order;
        public String embedUrlExternalUserId;
        public String redirectUrl;
        public String declinedRedirectUrl;
        public String loginRequired;
        public String verificationPhoneNumber;
        public String password;
        public String signerGroupId;

        /**
         * Constructs an empty Signer object.
         */
        public Signer() {
            super();
        }

        /**
         * Constructs a Signer object by parsing information from a JSON string.
         *
         * @param json the JSON string to parse.
         */
        public Signer(String jsonString) {
            super(jsonString);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        @testvisible
        private void parseMember(String key, String value) {
            if (key != null) {
                if (key == 'email') {
                    this.email = value;
                } else if (key == 'role') {
                    this.role = value;
                } else if (key == 'is_in_person') {
                    this.isInPerson = Boolean.valueOf(value);
                } else if (key == 'order') {
                    this.order = Integer.valueOf(value);
                } else if (key == 'embed_url_external_user_id') {
                    this.embedUrlExternalUserId = value;
                } else if (key == 'redirect_url') {
                    this.redirectUrl = value;
                } else if (key == 'declined_redirect_url') {
                    this.declinedRedirectUrl = value;
                } else if (key == 'login_required') {
                    this.loginRequired = value;
                } else if (key == 'verification_phone_number') {
                    this.verificationPhoneNumber = value;
                } else if (key == 'password') {
                    this.password = value;
                } else if (key == 'signer_group_id') {
                    this.signerGroupId = value;
                }
            }
        }
    }
}