/**
 * Represents a retention policy in Box.
 */
public class BoxRetentionPolicy extends BoxResource {
    private static String RETENTION_POLICIES_URL = 'retention_policies';
    private static String RETENTION_POLICY_URL = 'retention_policies/{0}';

    /**
     * Constructs a BoxRetentionPolicy for a policy with a given ID.
     *
     * @param api the API connection to be used by the policy.
     * @param id the ID of the policy.
     */
    public BoxRetentionPolicy(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'retention_policy';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxRetentionPolicy.Info) jsonObject;
    }

    /**
     * Information about BoxRetentionPolicy
     */
    public class Info extends BoxResource.Info {
        public String policyName;
        public String policyType;
        public Integer retentionLength;
        public String dispositionAction;
        public String status;
        public BoxUser.Info createdBy;
        public DateTime createdAt;
        public DateTime modifiedAt;
        public Boolean canOwnerExtendRetention;
        public Boolean areOwnersNotified;
        public List<BoxUser.Info> customNotificationRecipients;
        public String description;

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
                } else if (key == 'policy_name') {
                    this.policyName = value;
                } else if (key == 'policy_type') {
                    this.policyType = value;
                } else if (key == 'retention_length') {
                    this.retentionLength = Integer.valueOf(value);
                } else if (key == 'disposition_action') {
                    this.dispositionAction = value;
                } else if (key == 'status') {
                    this.status = value;
                } else if (key == 'created_by') {
                    this.createdBy = new BoxUser.Info(value);
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'can_owner_extend_retention') {
                    this.canOwnerExtendRetention = Boolean.valueOf(value);
                } else if (key == 'are_owners_notified') {
                    this.areOwnersNotified = Boolean.valueOf(value);
                } else if (key == 'custom_notification_recipients') {
                    this.customNotificationRecipients = new List<BoxUser.Info>();
                    List<String> recipients = BoxJsonObject.parseJsonObjectArray(value);
                    for (String recipient : recipients) {
                        this.customNotificationRecipients.add(new BoxUser.Info(recipient));
                    }
                } else if (key == 'description') {
                    this.description = value;
                }
            }
        }
    }
}