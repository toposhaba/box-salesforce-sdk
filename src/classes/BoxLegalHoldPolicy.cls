/**
 * Represents a legal hold policy in Box.
 */
public class BoxLegalHoldPolicy extends BoxResource {
    private static String LEGAL_HOLD_POLICIES_URL = 'legal_hold_policies';
    private static String LEGAL_HOLD_POLICY_URL = 'legal_hold_policies/{0}';

    /**
     * Constructs a BoxLegalHoldPolicy for a policy with a given ID.
     *
     * @param api the API connection to be used by the policy.
     * @param id the ID of the policy.
     */
    public BoxLegalHoldPolicy(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'legal_hold_policy';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxLegalHoldPolicy.Info) jsonObject;
    }

    /**
     * Information about BoxLegalHoldPolicy
     */
    public class Info extends BoxResource.Info {
        public String policyName;
        public String description;
        public String status;
        public BoxUser.Info createdBy;
        public DateTime createdAt;
        public DateTime modifiedAt;
        public DateTime deletedAt;
        public DateTime filterStartedAt;
        public DateTime filterEndedAt;
        public String releaseNotes;

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
                } else if (key == 'description') {
                    this.description = value;
                } else if (key == 'status') {
                    this.status = value;
                } else if (key == 'created_by') {
                    this.createdBy = new BoxUser.Info(value);
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'deleted_at') {
                    this.deletedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'filter_started_at') {
                    this.filterStartedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'filter_ended_at') {
                    this.filterEndedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'release_notes') {
                    this.releaseNotes = value;
                }
            }
        }
    }
}