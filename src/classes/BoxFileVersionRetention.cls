/**
 * Represents a retention on a file version in Box.
 */
public class BoxFileVersionRetention extends BoxResource {
    private static String FILE_VERSION_RETENTIONS_URL = 'file_version_retentions';
    private static String FILE_VERSION_RETENTION_URL = 'file_version_retentions/{0}';

    /**
     * Constructs a BoxFileVersionRetention for a retention with a given ID.
     *
     * @param api the API connection to be used by the file version retention.
     * @param id the ID of the file version retention.
     */
    public BoxFileVersionRetention(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'file_version_retention';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxFileVersionRetention.Info) jsonObject;
    }

    /**
     * Gets information about this file version retention.
     *
     * @return information about this file version retention.
     */
    public BoxFileVersionRetention.Info getInfo() {
        String url = this.api.baseUrl + String.format(
            FILE_VERSION_RETENTION_URL, 
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
            'BoxFileVersionRetention.getInfo'
        );
        return new BoxFileVersionRetention.Info(responseBody);
    }

    /**
     * Gets a list of all file version retentions.
     *
     * @param api the API connection to use.
     * @param fileId optional file ID to filter by.
     * @param fileVersionId optional file version ID to filter by.
     * @param policyId optional policy ID to filter by.
     * @param dispositionAction optional disposition action to filter by.
     * @param dispositionBefore optional disposition before date to filter by.
     * @param dispositionAfter optional disposition after date to filter by.
     * @param limit the maximum number of items to return.
     * @param marker the position marker to use for pagination.
     * @return a list of file version retentions.
     */
    public static List<BoxFileVersionRetention.Info> getAll(
        BoxApiConnection api,
        String fileId,
        String fileVersionId,
        String policyId,
        String dispositionAction,
        DateTime dispositionBefore,
        DateTime dispositionAfter,
        Integer limitValue,
        String marker
    ) {
        String url = api.baseUrl + FILE_VERSION_RETENTIONS_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_GET
        );

        // Add query parameters
        List<String> queryParams = new List<String>();
        if (fileId != null) {
            queryParams.add('file_id=' + fileId);
        }
        if (fileVersionId != null) {
            queryParams.add('file_version_id=' + fileVersionId);
        }
        if (policyId != null) {
            queryParams.add('policy_id=' + policyId);
        }
        if (dispositionAction != null) {
            queryParams.add('disposition_action=' + dispositionAction);
        }
        if (dispositionBefore != null) {
            queryParams.add('disposition_before=' + BoxDateFormat.formatBoxDateTimeString(dispositionBefore));
        }
        if (dispositionAfter != null) {
            queryParams.add('disposition_after=' + BoxDateFormat.formatBoxDateTimeString(dispositionAfter));
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
            'BoxFileVersionRetention.getAll'
        );

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        List<String> entries = BoxJsonObject.parseJsonObjectArray(
            responseObject.getValue('entries')
        );
        List<BoxFileVersionRetention.Info> retentions = new List<BoxFileVersionRetention.Info>();
        for (String entry : entries) {
            retentions.add(new BoxFileVersionRetention.Info(entry));
        }
        return retentions;
    }

    /**
     * Information about BoxFileVersionRetention
     */
    public class Info extends BoxResource.Info {
        public BoxFile.Info file;
        public BoxFileVersion.Info fileVersion;
        public BoxRetentionPolicy.Info retentionPolicy;
        public DateTime appliedAt;
        public DateTime dispositionAt;
        public BoxUser.Info winningRetentionPolicy;

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
                } else if (key == 'file') {
                    this.file = new BoxFile.Info(value);
                } else if (key == 'file_version') {
                    this.fileVersion = new BoxFileVersion.Info(value);
                } else if (key == 'retention_policy') {
                    this.retentionPolicy = new BoxRetentionPolicy.Info(value);
                } else if (key == 'applied_at') {
                    this.appliedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'disposition_at') {
                    this.dispositionAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'winning_retention_policy') {
                    this.winningRetentionPolicy = new BoxUser.Info(value);
                }
            }
        }
    }
}