/**
 * Represents a legal hold policy assignment in Box.
 */
public class BoxLegalHoldPolicyAssignment extends BoxResource {
    private static String LEGAL_HOLD_POLICY_ASSIGNMENTS_URL = 'legal_hold_policy_assignments';
    private static String LEGAL_HOLD_POLICY_ASSIGNMENT_URL = 'legal_hold_policy_assignments/{0}';

    /**
     * Constructs a BoxLegalHoldPolicyAssignment for an assignment with a given ID.
     *
     * @param api the API connection to be used by the assignment.
     * @param id the ID of the assignment.
     */
    public BoxLegalHoldPolicyAssignment(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'legal_hold_policy_assignment';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxLegalHoldPolicyAssignment.Info) jsonObject;
    }

    /**
     * Information about BoxLegalHoldPolicyAssignment
     */
    public class Info extends BoxResource.Info {
        public BoxLegalHoldPolicy.Info legalHoldPolicy;
        public BoxResource.Info assignedTo;
        public BoxUser.Info assignedBy;
        public DateTime assignedAt;
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
                } else if (key == 'legal_hold_policy') {
                    this.legalHoldPolicy = new BoxLegalHoldPolicy.Info(value);
                } else if (key == 'assigned_to') {
                    // Parse based on type
                    BoxGenericJsonObject obj = new BoxGenericJsonObject(value);
                    String objType = obj.getValue('type');
                    if (objType == 'file') {
                        this.assignedTo = new BoxFile.Info(value);
                    } else if (objType == 'file_version') {
                        this.assignedTo = new BoxFileVersion.Info(value);
                    } else if (objType == 'folder') {
                        this.assignedTo = new BoxFolder.Info(value);
                    } else if (objType == 'user') {
                        this.assignedTo = new BoxUser.Info(value);
                    }
                } else if (key == 'assigned_by') {
                    this.assignedBy = new BoxUser.Info(value);
                } else if (key == 'assigned_at') {
                    this.assignedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'deleted_at') {
                    this.deletedAt = BoxDateFormat.parseBoxDateTimeString(value);
                }
            }
        }
    }
}