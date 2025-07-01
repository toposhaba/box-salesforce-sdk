/**
 * Represents a Box webhook.
 */
public class BoxWebhook extends BoxResource {
    private static String WEBHOOKS_URL = 'webhooks';
    private static String WEBHOOK_URL = 'webhooks/{0}';

    /**
     * Constructs a BoxWebhook for a webhook with a given ID.
     *
     * @param api the API connection to be used by the webhook.
     * @param id the ID of the webhook.
     */
    public BoxWebhook(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'webhook';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxWebhook.Info) jsonObject;
    }

    /**
     * Gets information about this webhook.
     *
     * @return information about this webhook.
     */
    public BoxWebhook.Info getInfo() {
        String url = this.api.baseUrl + String.format(
            WEBHOOK_URL,
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
            'BoxWebhook.getInfo'
        );
        return new BoxWebhook.Info(responseBody);
    }

    /**
     * Updates information about this webhook.
     *
     * @param info the updated webhook information.
     * @return the updated webhook information.
     */
    public BoxWebhook.Info updateInfo(BoxWebhook.Info info) {
        String url = this.api.baseUrl + String.format(
            WEBHOOK_URL,
            new List<String>{ this.getId() }
        );
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_PUT
        );
        request.setBody(info.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebhook.updateInfo'
        );
        return new BoxWebhook.Info(responseBody);
    }

    /**
     * Deletes this webhook.
     *
     * @return true if deletion was successful.
     */
    public Boolean deleteWebhook() {
        String url = this.api.baseUrl + String.format(
            WEBHOOK_URL,
            new List<String>{ this.getId() }
        );
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_DELETE
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(
            response,
            'BoxWebhook.deleteWebhook',
            new Set<Integer>{ 204 }
        );
    }

    /**
     * Creates a new webhook.
     *
     * @param api the API connection to use.
     * @param target the target item for the webhook.
     * @param address the URL to receive webhook notifications.
     * @param triggers list of events that trigger the webhook.
     * @return the created webhook.
     */
    public static BoxWebhook.Info create(
        BoxApiConnection api,
        BoxResource target,
        String address,
        List<String> triggers
    ) {
        String url = api.baseUrl + WEBHOOKS_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );

        BoxGenericJsonObject targetObject = new BoxGenericJsonObject();
        targetObject.addValue('id', target.getId());
        targetObject.addValue('type', target.getObjectType());

        BoxWebhook.Info webhookInfo = new BoxWebhook.Info();
        webhookInfo.addValue('target', targetObject);
        webhookInfo.addValue('address', address);
        webhookInfo.addValue('triggers', JSON.serialize(triggers));

        request.setBody(webhookInfo.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebhook.create'
        );
        return new BoxWebhook.Info(responseBody);
    }

    /**
     * Gets all webhooks.
     *
     * @param api the API connection to use.
     * @param marker the position marker for pagination.
     * @param limitValue the maximum number of items to return.
     * @return a list of webhooks.
     */
    public static List<BoxWebhook.Info> getAll(
        BoxApiConnection api,
        String marker,
        Integer limitValue
    ) {
        String url = api.baseUrl + WEBHOOKS_URL;
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
            'BoxWebhook.getAll'
        );

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        List<String> entries = BoxJsonObject.parseJsonObjectArray(
            responseObject.getValue('entries')
        );
        List<BoxWebhook.Info> webhooks = new List<BoxWebhook.Info>();
        for (String entry : entries) {
            webhooks.add(new BoxWebhook.Info(entry));
        }
        return webhooks;
    }

    /**
     * Information about BoxWebhook
     */
    public class Info extends BoxResource.Info {
        public BoxResource.Info target;
        public BoxUser.Info createdBy;
        public DateTime createdAt;
        public String address;
        public List<String> triggers;

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
                } else if (key == 'target') {
                    BoxGenericJsonObject targetObject = new BoxGenericJsonObject(value);
                    String targetType = targetObject.getValue('type');
                    if (targetType == 'file') {
                        this.target = new BoxFile.Info(value);
                    } else if (targetType == 'folder') {
                        this.target = new BoxFolder.Info(value);
                    }
                } else if (key == 'created_by') {
                    this.createdBy = new BoxUser.Info(value);
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'address') {
                    this.address = value;
                } else if (key == 'triggers') {
                    this.triggers = (List<String>) JSON.deserialize(value, List<String>.class);
                }
            }
        }
    }

    /**
     * Webhook trigger events.
     */
    public enum Trigger {
        FILE_UPLOADED,
        FILE_PREVIEWED,
        FILE_DOWNLOADED,
        FILE_TRASHED,
        FILE_DELETED,
        FILE_RESTORED,
        FILE_COPIED,
        FILE_MOVED,
        FILE_LOCKED,
        FILE_UNLOCKED,
        FILE_RENAMED,
        COMMENT_CREATED,
        COMMENT_UPDATED,
        COMMENT_DELETED,
        TASK_ASSIGNMENT_CREATED,
        TASK_ASSIGNMENT_UPDATED,
        METADATA_INSTANCE_CREATED,
        METADATA_INSTANCE_UPDATED,
        METADATA_INSTANCE_DELETED,
        FOLDER_CREATED,
        FOLDER_RENAMED,
        FOLDER_DOWNLOADED,
        FOLDER_RESTORED,
        FOLDER_DELETED,
        FOLDER_COPIED,
        FOLDER_MOVED,
        FOLDER_TRASHED,
        WEBHOOK_DELETED,
        COLLABORATION_CREATED,
        COLLABORATION_ACCEPTED,
        COLLABORATION_REJECTED,
        COLLABORATION_REMOVED,
        COLLABORATION_UPDATED,
        SHARED_LINK_DELETED,
        SHARED_LINK_CREATED,
        SHARED_LINK_UPDATED,
        SIGN_REQUEST_COMPLETED,
        SIGN_REQUEST_DECLINED,
        SIGN_REQUEST_EXPIRED
    }

    /**
     * Gets the string representation of a trigger.
     *
     * @param trigger the trigger.
     * @return the string representation.
     */
    public static String getTriggerString(Trigger trigger) {
        switch on trigger {
            when FILE_UPLOADED { return 'FILE.UPLOADED'; }
            when FILE_PREVIEWED { return 'FILE.PREVIEWED'; }
            when FILE_DOWNLOADED { return 'FILE.DOWNLOADED'; }
            when FILE_TRASHED { return 'FILE.TRASHED'; }
            when FILE_DELETED { return 'FILE.DELETED'; }
            when FILE_RESTORED { return 'FILE.RESTORED'; }
            when FILE_COPIED { return 'FILE.COPIED'; }
            when FILE_MOVED { return 'FILE.MOVED'; }
            when FILE_LOCKED { return 'FILE.LOCKED'; }
            when FILE_UNLOCKED { return 'FILE.UNLOCKED'; }
            when FILE_RENAMED { return 'FILE.RENAMED'; }
            when COMMENT_CREATED { return 'COMMENT.CREATED'; }
            when COMMENT_UPDATED { return 'COMMENT.UPDATED'; }
            when COMMENT_DELETED { return 'COMMENT.DELETED'; }
            when TASK_ASSIGNMENT_CREATED { return 'TASK_ASSIGNMENT.CREATED'; }
            when TASK_ASSIGNMENT_UPDATED { return 'TASK_ASSIGNMENT.UPDATED'; }
            when METADATA_INSTANCE_CREATED { return 'METADATA_INSTANCE.CREATED'; }
            when METADATA_INSTANCE_UPDATED { return 'METADATA_INSTANCE.UPDATED'; }
            when METADATA_INSTANCE_DELETED { return 'METADATA_INSTANCE.DELETED'; }
            when FOLDER_CREATED { return 'FOLDER.CREATED'; }
            when FOLDER_RENAMED { return 'FOLDER.RENAMED'; }
            when FOLDER_DOWNLOADED { return 'FOLDER.DOWNLOADED'; }
            when FOLDER_RESTORED { return 'FOLDER.RESTORED'; }
            when FOLDER_DELETED { return 'FOLDER.DELETED'; }
            when FOLDER_COPIED { return 'FOLDER.COPIED'; }
            when FOLDER_MOVED { return 'FOLDER.MOVED'; }
            when FOLDER_TRASHED { return 'FOLDER.TRASHED'; }
            when WEBHOOK_DELETED { return 'WEBHOOK.DELETED'; }
            when COLLABORATION_CREATED { return 'COLLABORATION.CREATED'; }
            when COLLABORATION_ACCEPTED { return 'COLLABORATION.ACCEPTED'; }
            when COLLABORATION_REJECTED { return 'COLLABORATION.REJECTED'; }
            when COLLABORATION_REMOVED { return 'COLLABORATION.REMOVED'; }
            when COLLABORATION_UPDATED { return 'COLLABORATION.UPDATED'; }
            when SHARED_LINK_DELETED { return 'SHARED_LINK.DELETED'; }
            when SHARED_LINK_CREATED { return 'SHARED_LINK.CREATED'; }
            when SHARED_LINK_UPDATED { return 'SHARED_LINK.UPDATED'; }
            when SIGN_REQUEST_COMPLETED { return 'SIGN_REQUEST.COMPLETED'; }
            when SIGN_REQUEST_DECLINED { return 'SIGN_REQUEST.DECLINED'; }
            when SIGN_REQUEST_EXPIRED { return 'SIGN_REQUEST.EXPIRED'; }
            when else { return null; }
        }
    }
}