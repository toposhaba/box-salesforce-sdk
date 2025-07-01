/**
 * Provides Box Doc Gen capabilities for document generation from templates.
 */
public class BoxDocGen extends BoxResource {
    private static String DOC_GEN_TEMPLATES_URL = 'doc_gen/templates';
    private static String DOC_GEN_TEMPLATES_ID_URL = 'doc_gen/templates/{0}';
    private static String DOC_GEN_DOCUMENTS_URL = 'doc_gen/documents';
    
    /**
     * Constructs a BoxDocGen with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the doc gen template.
     */
    public BoxDocGen(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets information about this doc gen template.
     *
     * @return the template information.
     */
    public BoxDocGen.Info getInfo() {
        String url = this.api.baseUrl + String.format(DOC_GEN_TEMPLATES_ID_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxDocGen.getInfo');
        
        return new BoxDocGen.Info(responseBody);
    }
    
    /**
     * Creates a new document from this template.
     *
     * @param documentData the data to fill the template.
     * @param destinationFolder the folder to save the generated document.
     * @param fileName optional custom file name.
     * @param fileType optional file type (pdf or docx).
     * @return information about the generated document.
     */
    public BoxFile.Info generateDocument(
        Map<String, Object> documentData,
        BoxFolder destinationFolder,
        String fileName,
        String fileType
    ) {
        String url = this.api.baseUrl + DOC_GEN_DOCUMENTS_URL;
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('template_id', this.id);
        requestBody.addValue('destination_folder_id', destinationFolder.getId());
        
        // Add document data
        requestBody.addValue('document_data', JSON.serialize(documentData));
        
        // Add optional parameters
        if (fileName != null) {
            requestBody.addValue('file_name', fileName);
        }
        if (fileType != null) {
            requestBody.addValue('file_type', fileType);
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxDocGen.generateDocument'
        );
        
        return new BoxFile.Info(responseBody);
    }
    
    /**
     * Creates a new document from this template with advanced options.
     *
     * @param options the document generation options.
     * @return information about the generated document.
     */
    public BoxFile.Info generateDocument(DocumentOptions options) {
        String url = this.api.baseUrl + DOC_GEN_DOCUMENTS_URL;
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        request.setBody(options.toJson());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxDocGen.generateDocument'
        );
        
        return new BoxFile.Info(responseBody);
    }
    
    /**
     * Lists all doc gen templates.
     *
     * @param api the API connection to use.
     * @param limit the maximum number of templates to return.
     * @param marker the position marker for pagination.
     * @return iterable collection of templates.
     */
    public static BoxResourceIterable<BoxDocGen.Info> getAllTemplates(
        BoxApiConnection api,
        Integer limit,
        String marker
    ) {
        String url = api.baseUrl + DOC_GEN_TEMPLATES_URL;
        
        if (limit != null || marker != null) {
            url += '?';
            if (limit != null) {
                url += 'limit=' + limit;
                if (marker != null) {
                    url += '&';
                }
            }
            if (marker != null) {
                url += 'marker=' + marker;
            }
        }
        
        return new BoxResourceIterable<BoxDocGen.Info>(
            api,
            url,
            new BoxDocGen.InfoPagedCollection(api, url)
        );
    }
    
    /**
     * Creates a new doc gen template.
     *
     * @param api the API connection to use.
     * @param name the template name.
     * @param description the template description.
     * @param sourceFileId the ID of the source file to use as template.
     * @param tags optional tags for the template.
     * @return the created template information.
     */
    public static BoxDocGen.Info createTemplate(
        BoxApiConnection api,
        String name,
        String description,
        String sourceFileId,
        List<String> tags
    ) {
        String url = api.baseUrl + DOC_GEN_TEMPLATES_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('name', name);
        requestBody.addValue('description', description);
        requestBody.addValue('source_file_id', sourceFileId);
        
        if (tags != null && !tags.isEmpty()) {
            requestBody.addValue('tags', JSON.serialize(tags));
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxDocGen.createTemplate'
        );
        
        return new BoxDocGen.Info(responseBody);
    }
    
    /**
     * Updates this doc gen template.
     *
     * @param name new template name.
     * @param description new template description.
     * @param tags new tags for the template.
     * @return the updated template information.
     */
    public BoxDocGen.Info updateTemplate(
        String name,
        String description,
        List<String> tags
    ) {
        String url = this.api.baseUrl + String.format(DOC_GEN_TEMPLATES_ID_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_PUT
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        if (name != null) {
            requestBody.addValue('name', name);
        }
        if (description != null) {
            requestBody.addValue('description', description);
        }
        if (tags != null) {
            requestBody.addValue('tags', JSON.serialize(tags));
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxDocGen.updateTemplate'
        );
        
        return new BoxDocGen.Info(responseBody);
    }
    
    /**
     * Deletes this doc gen template.
     */
    public void delete() {
        String url = this.api.baseUrl + String.format(DOC_GEN_TEMPLATES_ID_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_DELETE
        );
        
        HttpResponse response = request.send();
        BoxApiRequest.getBoxResourceResponseBody(response, 'BoxDocGen.delete');
    }
    
    /**
     * Contains information about a Box Doc Gen template.
     */
    public class Info extends BoxResource.Info {
        private String name;
        private String description;
        private String status;
        private List<String> tags;
        private String sourceFileId;
        private DateTime createdAt;
        private DateTime modifiedAt;
        private BoxUser.Info createdBy;
        private BoxUser.Info modifiedBy;
        private List<TemplateField> fields;
        
        /**
         * Constructs an Info object from a JSON string.
         *
         * @param json the JSON string.
         */
        public Info(String json) {
            super(json);
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject(json);
            
            if (jsonObject.getValue('name') != null) {
                this.name = jsonObject.getValue('name');
            }
            if (jsonObject.getValue('description') != null) {
                this.description = jsonObject.getValue('description');
            }
            if (jsonObject.getValue('status') != null) {
                this.status = jsonObject.getValue('status');
            }
            if (jsonObject.getValue('source_file_id') != null) {
                this.sourceFileId = jsonObject.getValue('source_file_id');
            }
            if (jsonObject.getValue('created_at') != null) {
                this.createdAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('created_at'));
            }
            if (jsonObject.getValue('modified_at') != null) {
                this.modifiedAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('modified_at'));
            }
            
            // Parse tags
            if (jsonObject.getValue('tags') != null) {
                this.tags = (List<String>) JSON.deserialize(jsonObject.getValue('tags'), List<String>.class);
            }
            
            // Parse created_by
            if (jsonObject.children.get('created_by') != null) {
                BoxGenericJsonObject createdByObject = jsonObject.children.get('created_by');
                this.createdBy = new BoxUser.Info(createdByObject.getJsonString());
            }
            
            // Parse modified_by
            if (jsonObject.children.get('modified_by') != null) {
                BoxGenericJsonObject modifiedByObject = jsonObject.children.get('modified_by');
                this.modifiedBy = new BoxUser.Info(modifiedByObject.getJsonString());
            }
            
            // Parse fields
            if (jsonObject.children.get('fields') != null) {
                this.fields = new List<TemplateField>();
                BoxJsonObject fieldsObject = jsonObject.children.get('fields');
                if (fieldsObject.children != null) {
                    for (String key : fieldsObject.children.keySet()) {
                        BoxJsonObject fieldObject = fieldsObject.children.get(key);
                        this.fields.add(new TemplateField(key, fieldObject));
                    }
                }
            }
        }
        
        /**
         * Gets the template name.
         *
         * @return the template name.
         */
        public String getName() {
            return this.name;
        }
        
        /**
         * Gets the template description.
         *
         * @return the template description.
         */
        public String getDescription() {
            return this.description;
        }
        
        /**
         * Gets the template status.
         *
         * @return the template status.
         */
        public String getStatus() {
            return this.status;
        }
        
        /**
         * Gets the template tags.
         *
         * @return the template tags.
         */
        public List<String> getTags() {
            return this.tags;
        }
        
        /**
         * Gets the source file ID.
         *
         * @return the source file ID.
         */
        public String getSourceFileId() {
            return this.sourceFileId;
        }
        
        /**
         * Gets when the template was created.
         *
         * @return the creation timestamp.
         */
        public DateTime getCreatedAt() {
            return this.createdAt;
        }
        
        /**
         * Gets when the template was last modified.
         *
         * @return the modification timestamp.
         */
        public DateTime getModifiedAt() {
            return this.modifiedAt;
        }
        
        /**
         * Gets who created the template.
         *
         * @return the creator information.
         */
        public BoxUser.Info getCreatedBy() {
            return this.createdBy;
        }
        
        /**
         * Gets who last modified the template.
         *
         * @return the modifier information.
         */
        public BoxUser.Info getModifiedBy() {
            return this.modifiedBy;
        }
        
        /**
         * Gets the template fields.
         *
         * @return the template fields.
         */
        public List<TemplateField> getFields() {
            return this.fields;
        }
    }
    
    /**
     * Represents a field in a doc gen template.
     */
    public class TemplateField {
        private String key;
        private String displayName;
        private String fieldType;
        private String description;
        private Boolean required;
        private String defaultValue;
        private List<String> options;
        
        public TemplateField(String key, BoxJsonObject fieldObject) {
            this.key = key;
            
            if (fieldObject.getValue('display_name') != null) {
                this.displayName = fieldObject.getValue('display_name');
            }
            if (fieldObject.getValue('type') != null) {
                this.fieldType = fieldObject.getValue('type');
            }
            if (fieldObject.getValue('description') != null) {
                this.description = fieldObject.getValue('description');
            }
            if (fieldObject.getValue('required') != null) {
                this.required = Boolean.valueOf(fieldObject.getValue('required'));
            }
            if (fieldObject.getValue('default_value') != null) {
                this.defaultValue = fieldObject.getValue('default_value');
            }
            if (fieldObject.getValue('options') != null) {
                this.options = (List<String>) JSON.deserialize(fieldObject.getValue('options'), List<String>.class);
            }
        }
        
        public String getKey() {
            return this.key;
        }
        
        public String getDisplayName() {
            return this.displayName;
        }
        
        public String getFieldType() {
            return this.fieldType;
        }
        
        public String getDescription() {
            return this.description;
        }
        
        public Boolean isRequired() {
            return this.required;
        }
        
        public String getDefaultValue() {
            return this.defaultValue;
        }
        
        public List<String> getOptions() {
            return this.options;
        }
    }
    
    /**
     * Used to paginate through a collection of doc gen templates.
     */
    private class InfoPagedCollection extends BoxResourcePagedCollection<BoxDocGen.Info> {
        
        public InfoPagedCollection(BoxApiConnection api, String url) {
            super(api, url);
        }
        
        protected override BoxResource.Info factory(BoxJsonObject jsonObject) {
            BoxDocGen template = new BoxDocGen(this.api, jsonObject.getValue('id'));
            return template.new Info(jsonObject.getJsonString());
        }
    }
    
    /**
     * Options for document generation.
     */
    public class DocumentOptions {
        private String templateId;
        private String destinationFolderId;
        private Map<String, Object> documentData;
        private String fileName;
        private String fileType;
        private Map<String, Object> metadata;
        private List<String> tags;
        private Boolean isTest;
        
        public DocumentOptions(String templateId, String destinationFolderId) {
            this.templateId = templateId;
            this.destinationFolderId = destinationFolderId;
            this.documentData = new Map<String, Object>();
        }
        
        /**
         * Sets the document data for template filling.
         *
         * @param documentData the data map.
         * @return this options object for chaining.
         */
        public DocumentOptions setDocumentData(Map<String, Object> documentData) {
            this.documentData = documentData;
            return this;
        }
        
        /**
         * Adds a single data field.
         *
         * @param key the field key.
         * @param value the field value.
         * @return this options object for chaining.
         */
        public DocumentOptions addDataField(String key, Object value) {
            this.documentData.put(key, value);
            return this;
        }
        
        /**
         * Sets the output file name.
         *
         * @param fileName the file name.
         * @return this options object for chaining.
         */
        public DocumentOptions setFileName(String fileName) {
            this.fileName = fileName;
            return this;
        }
        
        /**
         * Sets the output file type.
         *
         * @param fileType the file type (pdf or docx).
         * @return this options object for chaining.
         */
        public DocumentOptions setFileType(String fileType) {
            this.fileType = fileType;
            return this;
        }
        
        /**
         * Sets metadata for the generated document.
         *
         * @param metadata the metadata map.
         * @return this options object for chaining.
         */
        public DocumentOptions setMetadata(Map<String, Object> metadata) {
            this.metadata = metadata;
            return this;
        }
        
        /**
         * Sets tags for the generated document.
         *
         * @param tags the tags list.
         * @return this options object for chaining.
         */
        public DocumentOptions setTags(List<String> tags) {
            this.tags = tags;
            return this;
        }
        
        /**
         * Sets whether this is a test generation.
         *
         * @param isTest true for test mode.
         * @return this options object for chaining.
         */
        public DocumentOptions setIsTest(Boolean isTest) {
            this.isTest = isTest;
            return this;
        }
        
        /**
         * Converts options to JSON string.
         *
         * @return JSON representation.
         */
        public String toJson() {
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject();
            
            jsonObject.addValue('template_id', this.templateId);
            jsonObject.addValue('destination_folder_id', this.destinationFolderId);
            jsonObject.addValue('document_data', JSON.serialize(this.documentData));
            
            if (this.fileName != null) {
                jsonObject.addValue('file_name', this.fileName);
            }
            if (this.fileType != null) {
                jsonObject.addValue('file_type', this.fileType);
            }
            if (this.metadata != null) {
                jsonObject.addValue('metadata', JSON.serialize(this.metadata));
            }
            if (this.tags != null && !this.tags.isEmpty()) {
                jsonObject.addValue('tags', JSON.serialize(this.tags));
            }
            if (this.isTest != null) {
                jsonObject.addValue('is_test', this.isTest);
            }
            
            return jsonObject.getJsonString();
        }
    }
    
    /**
     * Enum for file types.
     */
    public enum FileType {
        PDF,
        DOCX
    }
    
    /**
     * Gets the string representation of a file type.
     *
     * @param fileType the file type.
     * @return the string representation.
     */
    public static String getFileTypeString(FileType fileType) {
        switch on fileType {
            when PDF { return 'pdf'; }
            when DOCX { return 'docx'; }
            when else { return null; }
        }
    }
    
    /**
     * Enum for template status.
     */
    public enum Status {
        ACTIVE,
        INACTIVE,
        DRAFT
    }
    
    /**
     * Gets the string representation of a status.
     *
     * @param status the status.
     * @return the string representation.
     */
    public static String getStatusString(Status status) {
        switch on status {
            when ACTIVE { return 'active'; }
            when INACTIVE { return 'inactive'; }
            when DRAFT { return 'draft'; }
            when else { return null; }
        }
    }
    
    /**
     * Enum for field types.
     */
    public enum FieldType {
        TEXT,
        DATE,
        NUMBER,
        BOOLEAN,
        LIST,
        IMAGE,
        TABLE
    }
    
    /**
     * Gets the string representation of a field type.
     *
     * @param fieldType the field type.
     * @return the string representation.
     */
    public static String getFieldTypeString(FieldType fieldType) {
        switch on fieldType {
            when TEXT { return 'text'; }
            when DATE { return 'date'; }
            when NUMBER { return 'number'; }
            when BOOLEAN { return 'boolean'; }
            when LIST { return 'list'; }
            when IMAGE { return 'image'; }
            when TABLE { return 'table'; }
            when else { return null; }
        }
    }
}