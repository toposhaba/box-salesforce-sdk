/**
 * Represents a metadata template in Box.
 */
public class BoxMetadataTemplate extends BoxResource {
    private static String METADATA_TEMPLATES_URL = 'metadata_templates';
    private static String METADATA_TEMPLATE_URL = 'metadata_templates/{0}/{1}';
    private static String METADATA_TEMPLATE_BY_ID_URL = 'metadata_templates/{0}';
    private static String ENTERPRISE_METADATA_URL = 'metadata_templates/enterprise';

    /**
     * Constructs a BoxMetadataTemplate for a template with a given scope and template key.
     *
     * @param api the API connection to be used by the template.
     * @param scope the scope of the template (global or enterprise).
     * @param templateKey the key of the template.
     */
    public BoxMetadataTemplate(BoxApiConnection api, String scope, String templateKey) {
        super(api, scope + '/' + templateKey);
    }

    public override String getObjectType() {
        return 'metadata_template';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxMetadataTemplate.Info) jsonObject;
    }

    /**
     * Gets all metadata templates for the enterprise.
     *
     * @param api the API connection to use.
     * @param marker the position marker for pagination.
     * @param limitValue the maximum number of items to return.
     * @return a list of metadata templates.
     */
    public static List<BoxMetadataTemplate.Info> getEnterpriseTemplates(
        BoxApiConnection api,
        String marker,
        Integer limitValue
    ) {
        String url = api.baseUrl + ENTERPRISE_METADATA_URL;
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
            'BoxMetadataTemplate.getEnterpriseTemplates'
        );

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        List<String> entries = BoxJsonObject.parseJsonObjectArray(
            responseObject.getValue('entries')
        );
        List<BoxMetadataTemplate.Info> templates = new List<BoxMetadataTemplate.Info>();
        for (String entry : entries) {
            templates.add(new BoxMetadataTemplate.Info(entry));
        }
        return templates;
    }

    /**
     * Gets a metadata template by its scope and template key.
     *
     * @param api the API connection to use.
     * @param scope the scope of the template.
     * @param templateKey the key of the template.
     * @return the metadata template information.
     */
    public static BoxMetadataTemplate.Info getTemplate(
        BoxApiConnection api,
        String scope,
        String templateKey
    ) {
        String url = api.baseUrl + String.format(
            METADATA_TEMPLATE_URL,
            new List<String>{ scope, templateKey }
        );
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxMetadataTemplate.getTemplate'
        );
        return new BoxMetadataTemplate.Info(responseBody);
    }

    /**
     * Creates a new metadata template.
     *
     * @param api the API connection to use.
     * @param scope the scope for the template.
     * @param templateInfo the template information to create.
     * @return the created metadata template information.
     */
    public static BoxMetadataTemplate.Info createTemplate(
        BoxApiConnection api,
        String scope,
        BoxMetadataTemplate.Info templateInfo
    ) {
        String url = api.baseUrl + METADATA_TEMPLATES_URL + '/' + scope;
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_POST);
        request.setBody(templateInfo.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxMetadataTemplate.createTemplate'
        );
        return new BoxMetadataTemplate.Info(responseBody);
    }

    /**
     * Information about BoxMetadataTemplate
     */
    public class Info extends BoxResource.Info {
        public String templateKey;
        public String scope;
        public String displayName;
        public Boolean hidden;
        public List<Field> fields;
        public Boolean copyInstanceOnItemCopy;

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
                } else if (key == 'templateKey') {
                    this.templateKey = value;
                } else if (key == 'scope') {
                    this.scope = value;
                } else if (key == 'displayName') {
                    this.displayName = value;
                } else if (key == 'hidden') {
                    this.hidden = Boolean.valueOf(value);
                } else if (key == 'fields') {
                    this.fields = new List<Field>();
                    List<String> fieldList = BoxJsonObject.parseJsonObjectArray(value);
                    for (String field : fieldList) {
                        this.fields.add(new Field(field));
                    }
                } else if (key == 'copyInstanceOnItemCopy') {
                    this.copyInstanceOnItemCopy = Boolean.valueOf(value);
                }
            }
        }
    }

    /**
     * Represents a field in a metadata template.
     */
    public class Field extends BoxJsonObject {
        public String fieldType;
        public String key;
        public String displayName;
        public String description;
        public Boolean hidden;
        public List<Option> options;

        /**
         * Constructs an empty Field object.
         */
        public Field() {
            super();
        }

        /**
         * Constructs a Field object by parsing information from a JSON string.
         *
         * @param json the JSON string to parse.
         */
        public Field(String jsonString) {
            super(jsonString);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        @testvisible
        private void parseMember(String key, String value) {
            if (key != null) {
                if (key == 'type') {
                    this.fieldType = value;
                } else if (key == 'key') {
                    this.key = value;
                } else if (key == 'displayName') {
                    this.displayName = value;
                } else if (key == 'description') {
                    this.description = value;
                } else if (key == 'hidden') {
                    this.hidden = Boolean.valueOf(value);
                } else if (key == 'options') {
                    this.options = new List<Option>();
                    List<String> optionList = BoxJsonObject.parseJsonObjectArray(value);
                    for (String option : optionList) {
                        this.options.add(new Option(option));
                    }
                }
            }
        }
    }

    /**
     * Represents an option for a field in a metadata template.
     */
    public class Option extends BoxJsonObject {
        public String key;

        /**
         * Constructs an empty Option object.
         */
        public Option() {
            super();
        }

        /**
         * Constructs an Option object by parsing information from a JSON string.
         *
         * @param json the JSON string to parse.
         */
        public Option(String jsonString) {
            super(jsonString);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        @testvisible
        private void parseMember(String key, String value) {
            if (key != null && key == 'key') {
                this.key = value;
            }
        }
    }
}