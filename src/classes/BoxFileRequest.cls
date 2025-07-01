/**
 * Represents a Box File Request.
 */
public class BoxFileRequest extends BoxResource {
    private static String FILE_REQUESTS_URL = 'file_requests';
    private static String FILE_REQUEST_URL = 'file_requests/{0}';
    private static String FILE_REQUEST_COPY_URL = 'file_requests/{0}/copy';
    
    /**
     * Constructs a BoxFileRequest with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the file request.
     */
    public BoxFileRequest(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets information about this file request.
     *
     * @return the file request information.
     */
    public BoxFileRequest.Info getInfo() {
        String url = this.api.baseUrl + String.format(FILE_REQUEST_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFileRequest.getInfo');
        
        return new BoxFileRequest.Info(responseBody);
    }
    
    /**
     * Updates information about this file request.
     *
     * @param info the updated file request information.
     * @return the updated file request information.
     */
    public BoxFileRequest.Info updateInfo(BoxFileRequest.Info info) {
        String url = this.api.baseUrl + String.format(FILE_REQUEST_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        if (info.getTitle() != null) {
            requestBody.addValue('title', info.getTitle());
        }
        if (info.getDescription() != null) {
            requestBody.addValue('description', info.getDescription());
        }
        if (info.getStatus() != null) {
            requestBody.addValue('status', info.getStatus());
        }
        if (info.getIsEmailRequired() != null) {
            requestBody.addValue('is_email_required', info.getIsEmailRequired());
        }
        if (info.getIsDescriptionRequired() != null) {
            requestBody.addValue('is_description_required', info.getIsDescriptionRequired());
        }
        if (info.getExpiresAt() != null) {
            requestBody.addValue('expires_at', BoxDateFormat.getBoxDateTimeString(info.getExpiresAt()));
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFileRequest.updateInfo');
        
        return new BoxFileRequest.Info(responseBody);
    }
    
    /**
     * Deletes this file request.
     */
    public void delete() {
        String url = this.api.baseUrl + String.format(FILE_REQUEST_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        
        HttpResponse response = request.send();
        BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFileRequest.delete');
    }
    
    /**
     * Copies this file request to a new folder.
     *
     * @param folder the folder to copy the file request to.
     * @return the copied file request information.
     */
    public BoxFileRequest.Info copy(BoxFolder folder) {
        String url = this.api.baseUrl + String.format(FILE_REQUEST_COPY_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        BoxGenericJsonObject folderObject = new BoxGenericJsonObject();
        folderObject.addValue('id', folder.getId());
        folderObject.addValue('type', 'folder');
        requestBody.children.put('folder', folderObject);
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFileRequest.copy');
        
        return new BoxFileRequest.Info(responseBody);
    }
    
    /**
     * Creates a new file request.
     *
     * @param api the API connection to use.
     * @param folder the folder to create the file request in.
     * @param title the title of the file request.
     * @param description the description of the file request.
     * @return the created file request information.
     */
    public static BoxFileRequest.Info create(
        BoxApiConnection api,
        BoxFolder folder,
        String title,
        String description
    ) {
        String url = api.baseUrl + FILE_REQUESTS_URL;
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_POST);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('title', title);
        if (description != null) {
            requestBody.addValue('description', description);
        }
        
        BoxGenericJsonObject folderObject = new BoxGenericJsonObject();
        folderObject.addValue('id', folder.getId());
        folderObject.addValue('type', 'folder');
        requestBody.children.put('folder', folderObject);
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFileRequest.create');
        
        return new BoxFileRequest.Info(responseBody);
    }
    
    /**
     * Contains information about a Box File Request.
     */
    public class Info extends BoxResource.Info {
        private String type;
        private String title;
        private String description;
        private String status;
        private Boolean isEmailRequired;
        private Boolean isDescriptionRequired;
        private DateTime expiresAt;
        private BoxFolder.Info folder;
        private String url;
        private String etag;
        private BoxUser.Info createdBy;
        private DateTime createdAt;
        private BoxUser.Info updatedBy;
        private DateTime updatedAt;
        
        /**
         * Constructs an Info object from a JSON string.
         *
         * @param json the JSON string.
         */
        public Info(String json) {
            super(json);
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject(json);
            
            if (jsonObject.getValue('type') != null) {
                this.type = jsonObject.getValue('type');
            }
            if (jsonObject.getValue('title') != null) {
                this.title = jsonObject.getValue('title');
            }
            if (jsonObject.getValue('description') != null) {
                this.description = jsonObject.getValue('description');
            }
            if (jsonObject.getValue('status') != null) {
                this.status = jsonObject.getValue('status');
            }
            if (jsonObject.getValue('is_email_required') != null) {
                this.isEmailRequired = Boolean.valueOf(jsonObject.getValue('is_email_required'));
            }
            if (jsonObject.getValue('is_description_required') != null) {
                this.isDescriptionRequired = Boolean.valueOf(jsonObject.getValue('is_description_required'));
            }
            if (jsonObject.getValue('expires_at') != null) {
                this.expiresAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('expires_at'));
            }
            if (jsonObject.getValue('url') != null) {
                this.url = jsonObject.getValue('url');
            }
            if (jsonObject.getValue('etag') != null) {
                this.etag = jsonObject.getValue('etag');
            }
            if (jsonObject.getValue('created_at') != null) {
                this.createdAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('created_at'));
            }
            if (jsonObject.getValue('updated_at') != null) {
                this.updatedAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('updated_at'));
            }
            
            // Parse folder
            if (jsonObject.children.get('folder') != null) {
                BoxGenericJsonObject folderObject = jsonObject.children.get('folder');
                this.folder = new BoxFolder.Info(folderObject.getJsonString());
            }
            
            // Parse created_by
            if (jsonObject.children.get('created_by') != null) {
                BoxGenericJsonObject userObject = jsonObject.children.get('created_by');
                this.createdBy = new BoxUser.Info(userObject.getJsonString());
            }
            
            // Parse updated_by
            if (jsonObject.children.get('updated_by') != null) {
                BoxGenericJsonObject userObject = jsonObject.children.get('updated_by');
                this.updatedBy = new BoxUser.Info(userObject.getJsonString());
            }
        }
        
        public String getType() {
            return this.type;
        }
        
        public String getTitle() {
            return this.title;
        }
        
        public void setTitle(String title) {
            this.title = title;
        }
        
        public String getDescription() {
            return this.description;
        }
        
        public void setDescription(String description) {
            this.description = description;
        }
        
        public String getStatus() {
            return this.status;
        }
        
        public void setStatus(String status) {
            this.status = status;
        }
        
        public Boolean getIsEmailRequired() {
            return this.isEmailRequired;
        }
        
        public void setIsEmailRequired(Boolean isEmailRequired) {
            this.isEmailRequired = isEmailRequired;
        }
        
        public Boolean getIsDescriptionRequired() {
            return this.isDescriptionRequired;
        }
        
        public void setIsDescriptionRequired(Boolean isDescriptionRequired) {
            this.isDescriptionRequired = isDescriptionRequired;
        }
        
        public DateTime getExpiresAt() {
            return this.expiresAt;
        }
        
        public void setExpiresAt(DateTime expiresAt) {
            this.expiresAt = expiresAt;
        }
        
        public BoxFolder.Info getFolder() {
            return this.folder;
        }
        
        public String getUrl() {
            return this.url;
        }
        
        public String getEtag() {
            return this.etag;
        }
        
        public BoxUser.Info getCreatedBy() {
            return this.createdBy;
        }
        
        public DateTime getCreatedAt() {
            return this.createdAt;
        }
        
        public BoxUser.Info getUpdatedBy() {
            return this.updatedBy;
        }
        
        public DateTime getUpdatedAt() {
            return this.updatedAt;
        }
    }
    
    /**
     * Enum for file request status.
     */
    public enum Status {
        ACTIVE,
        INACTIVE
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
            when else { return null; }
        }
    }
}