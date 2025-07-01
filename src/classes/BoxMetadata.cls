/**
 * Represents a metadata instance on a Box file or folder.
 */
public class BoxMetadata extends BoxResource {
    
    /**
     * Constructs a BoxMetadata.
     *
     * @param api the API connection to be used.
     * @param id the ID of the metadata.
     */
    public BoxMetadata(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'metadata';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxMetadata.Info) jsonObject;
    }

    /**
     * Information about BoxMetadata
     */
    public class Info extends BoxResource.Info {
        public String parent;
        public String template;
        public String scope;
        public Map<String, Object> data;

        /**
         * Constructs an empty Info object.
         */
        public Info() {
            super();
            this.data = new Map<String, Object>();
        }

        /**
         * Constructs an Info object by parsing information from a JSON string.
         *
         * @param json the JSON string to parse.
         */
        public Info(String jsonString) {
            super(jsonString);
            this.data = new Map<String, Object>();
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
            this.data = new Map<String, Object>();
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
                if (key == '$parent') {
                    this.parent = value;
                } else if (key == '$template') {
                    this.template = value;
                } else if (key == '$scope') {
                    this.scope = value;
                } else if (key == '$id') {
                    this.id = value;
                } else if (key == '$type') {
                    this.typeName = value;
                } else if (key == '$version') {
                    // Skip version field
                } else if (!key.startsWith('$')) {
                    // All non-$ fields are metadata values
                    this.data.put(key, value);
                }
            }
        }

        /**
         * Gets a metadata value by key.
         *
         * @param key the metadata key.
         * @return the metadata value.
         */
        public Object getValue(String key) {
            return this.data.get(key);
        }

        /**
         * Sets a metadata value.
         *
         * @param key the metadata key.
         * @param value the metadata value.
         */
        public void setValue(String key, Object value) {
            this.data.put(key, value);
            this.addValue(key, String.valueOf(value));
        }
    }

    /**
     * Represents a metadata update operation.
     */
    public class Update {
        private String op;
        private String path;
        private Object value;
        private String fromValue;

        /**
         * Creates an add operation.
         *
         * @param path the path to add.
         * @param value the value to add.
         * @return the update operation.
         */
        public static Update add(String path, Object value) {
            Update updateOp = new Update();
            updateOp.op = 'add';
            updateOp.path = '/' + path;
            updateOp.value = value;
            return updateOp;
        }

        /**
         * Creates a replace operation.
         *
         * @param path the path to replace.
         * @param value the new value.
         * @return the update operation.
         */
        public static Update replace(String path, Object value) {
            Update updateOp = new Update();
            updateOp.op = 'replace';
            updateOp.path = '/' + path;
            updateOp.value = value;
            return updateOp;
        }

        /**
         * Creates a test operation.
         *
         * @param path the path to test.
         * @param value the value to test against.
         * @return the update operation.
         */
        public static Update test(String path, Object value) {
            Update updateOp = new Update();
            updateOp.op = 'test';
            updateOp.path = '/' + path;
            updateOp.value = value;
            return updateOp;
        }

        /**
         * Creates a remove operation.
         *
         * @param path the path to remove.
         * @return the update operation.
         */
        public static Update remove(String path) {
            Update updateOp = new Update();
            updateOp.op = 'remove';
            updateOp.path = '/' + path;
            return updateOp;
        }

        /**
         * Creates a move operation.
         *
         * @param fromPath the path to move from.
         * @param path the path to move to.
         * @return the update operation.
         */
        public static Update move(String fromPath, String path) {
            Update updateOp = new Update();
            updateOp.op = 'move';
            updateOp.fromValue = '/' + fromPath;
            updateOp.path = '/' + path;
            return updateOp;
        }

        /**
         * Creates a copy operation.
         *
         * @param fromPath the path to copy from.
         * @param path the path to copy to.
         * @return the update operation.
         */
        public static Update copy(String fromPath, String path) {
            Update updateOp = new Update();
            updateOp.op = 'copy';
            updateOp.fromValue = '/' + fromPath;
            updateOp.path = '/' + path;
            return updateOp;
        }

        /**
         * Converts this update to a map for serialization.
         *
         * @return the update as a map.
         */
        public Map<String, String> toMap() {
            Map<String, String> result = new Map<String, String>();
            result.put('op', this.op);
            result.put('path', this.path);
            if (this.value != null) {
                result.put('value', String.valueOf(this.value));
            }
            if (this.fromValue != null) {
                result.put('from', this.fromValue);
            }
            return result;
        }
    }
}