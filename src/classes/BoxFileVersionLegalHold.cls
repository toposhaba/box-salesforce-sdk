/**
 * Represents a legal hold on a file version in Box.
 */
public class BoxFileVersionLegalHold extends BoxResource {
    private static String FILE_VERSION_LEGAL_HOLDS_URL = 'file_version_legal_holds';
    private static String FILE_VERSION_LEGAL_HOLD_URL = 'file_version_legal_holds/{0}';

    /**
     * Constructs a BoxFileVersionLegalHold for a legal hold with a given ID.
     *
     * @param api the API connection to be used by the file version legal hold.
     * @param id the ID of the file version legal hold.
     */
    public BoxFileVersionLegalHold(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'file_version_legal_hold';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxFileVersionLegalHold.Info) jsonObject;
    }

    /**
     * Gets information about this file version legal hold.
     *
     * @return information about this file version legal hold.
     */
    public BoxFileVersionLegalHold.Info getInfo() {
        String url = this.api.baseUrl + String.format(
            FILE_VERSION_LEGAL_HOLD_URL, 
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
            'BoxFileVersionLegalHold.getInfo'
        );
        return new BoxFileVersionLegalHold.Info(responseBody);
    }

    /**
     * Gets a list of all file version legal holds.
     *
     * @param api the API connection to use.
     * @param policyId optional policy ID to filter by.
     * @param limit the maximum number of items to return.
     * @param marker the position marker to use for pagination.
     * @return a list of file version legal holds.
     */
    public static List<BoxFileVersionLegalHold.Info> getAll(
        BoxApiConnection api,
        String policyId,
        Integer limitValue,
        String marker
    ) {
        String url = api.baseUrl + FILE_VERSION_LEGAL_HOLDS_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_GET
        );

        // Add query parameters
        List<String> queryParams = new List<String>();
        if (policyId != null) {
            queryParams.add('policy_id=' + policyId);
        }
        if (limitValue != null) {
            queryParams.add('limit=' + String.valueOf(limitValue));
        }
        if (marker != null) {
            queryParams.add('marker=' + marker);
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
            'BoxFileVersionLegalHold.getAll'
        );

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        List<String> entries = BoxJsonObject.parseJsonObjectArray(
            responseObject.getValue('entries')
        );
        List<BoxFileVersionLegalHold.Info> legalHolds = new List<BoxFileVersionLegalHold.Info>();
        for (String entry : entries) {
            legalHolds.add(new BoxFileVersionLegalHold.Info(entry));
        }
        return legalHolds;
    }

    /**
     * Information about BoxFileVersionLegalHold
     */
    public class Info extends BoxResource.Info {
        public String fileVersionId;
        public BoxFile.Info file;
        public BoxFileVersion.Info fileVersion;
        public List<BoxLegalHoldPolicyAssignment.Info> legalHoldPolicyAssignments;
        public DateTime deletedAt;

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
                } else if (key == 'file_version') {
                    this.fileVersion = new BoxFileVersion.Info(value);
                    if (this.fileVersion != null && this.fileVersion.id != null) {
                        this.fileVersionId = this.fileVersion.id;
                    }
                } else if (key == 'file') {
                    this.file = new BoxFile.Info(value);
                } else if (key == 'legal_hold_policy_assignments') {
                    this.legalHoldPolicyAssignments = new List<BoxLegalHoldPolicyAssignment.Info>();
                    List<String> assignments = BoxJsonObject.parseJsonObjectArray(value);
                    for (String assignment : assignments) {
                        this.legalHoldPolicyAssignments.add(
                            new BoxLegalHoldPolicyAssignment.Info(assignment)
                        );
                    }
                } else if (key == 'deleted_at') {
                    this.deletedAt = BoxDateFormat.parseBoxDateTimeString(value);
                }
            }
        }
    }
}