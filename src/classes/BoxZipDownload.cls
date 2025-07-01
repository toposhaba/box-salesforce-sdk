/**
 * Provides Box Zip Download capabilities for bulk file downloads.
 */
public class BoxZipDownload {
    private static String ZIP_DOWNLOADS_URL = 'zip_downloads';
    private static String ZIP_DOWNLOAD_URL = 'zip_downloads/{0}/content';
    private static String ZIP_DOWNLOAD_STATUS_URL = 'zip_downloads/{0}/status';
    
    private BoxApiConnection api;
    private String downloadId;
    
    /**
     * Constructs a BoxZipDownload with a given download ID.
     *
     * @param api the API connection to use.
     * @param downloadId the ID of the zip download.
     */
    public BoxZipDownload(BoxApiConnection api, String downloadId) {
        this.api = api;
        this.downloadId = downloadId;
    }
    
    /**
     * Creates a new zip download.
     *
     * @param api the API connection to use.
     * @param items the items to include in the zip.
     * @param downloadFileName optional custom name for the zip file.
     * @return the created zip download information.
     */
    public static BoxZipDownload.Info create(
        BoxApiConnection api,
        List<ZipItem> items,
        String downloadFileName
    ) {
        String url = api.baseUrl + ZIP_DOWNLOADS_URL;
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_POST);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        
        // Add items
        List<Map<String, String>> itemsList = new List<Map<String, String>>();
        for (ZipItem item : items) {
            itemsList.add(item.toMap());
        }
        requestBody.addValue('items', JSON.serialize(itemsList));
        
        // Add optional download file name
        if (downloadFileName != null) {
            requestBody.addValue('download_file_name', downloadFileName);
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxZipDownload.create'
        );
        
        return new BoxZipDownload.Info(responseBody);
    }
    
    /**
     * Gets the download URL for this zip download.
     *
     * @return the download URL.
     */
    public String getDownloadUrl() {
        return this.api.baseUrl + String.format(ZIP_DOWNLOAD_URL, new String[] { this.downloadId });
    }
    
    /**
     * Gets the status of this zip download.
     *
     * @return the status information.
     */
    public BoxZipDownload.Status getStatus() {
        String url = this.api.baseUrl + String.format(ZIP_DOWNLOAD_STATUS_URL, new String[] { this.downloadId });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxZipDownload.getStatus'
        );
        
        return new BoxZipDownload.Status(responseBody);
    }
    
    /**
     * Downloads the zip file content.
     *
     * @return the zip file content as a Blob.
     */
    public Blob download() {
        String url = this.getDownloadUrl();
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        if (response.getStatusCode() == 200) {
            return response.getBodyAsBlob();
        } else {
            throw new BoxApiConnectionException(
                'Failed to download zip file: ' + response.getStatusCode() + ' ' + response.getStatus()
            );
        }
    }
    
    /**
     * Represents an item to include in a zip download.
     */
    public class ZipItem {
        private String id;
        private String type;
        
        /**
         * Creates a new zip item.
         *
         * @param id the ID of the item.
         * @param type the type of the item (file or folder).
         */
        public ZipItem(String id, String type) {
            this.id = id;
            this.type = type;
        }
        
        /**
         * Creates a zip item from a BoxFile.
         *
         * @param file the file to include.
         * @return the zip item.
         */
        public static ZipItem fromFile(BoxFile file) {
            return new ZipItem(file.getId(), 'file');
        }
        
        /**
         * Creates a zip item from a BoxFolder.
         *
         * @param folder the folder to include.
         * @return the zip item.
         */
        public static ZipItem fromFolder(BoxFolder folder) {
            return new ZipItem(folder.getId(), 'folder');
        }
        
        /**
         * Converts to a map for JSON serialization.
         *
         * @return the map representation.
         */
        public Map<String, String> toMap() {
            Map<String, String> result = new Map<String, String>();
            result.put('id', this.id);
            result.put('type', this.type);
            return result;
        }
    }
    
    /**
     * Contains information about a zip download.
     */
    public class Info {
        private String downloadUrl;
        private String statusUrl;
        private DateTime expiresAt;
        private Integer nameConflicts;
        
        /**
         * Constructs an Info object from a JSON string.
         *
         * @param json the JSON string.
         */
        public Info(String json) {
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject(json);
            
            if (jsonObject.getValue('download_url') != null) {
                this.downloadUrl = jsonObject.getValue('download_url');
            }
            if (jsonObject.getValue('status_url') != null) {
                this.statusUrl = jsonObject.getValue('status_url');
            }
            if (jsonObject.getValue('expires_at') != null) {
                this.expiresAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('expires_at'));
            }
            if (jsonObject.getValue('name_conflicts') != null) {
                this.nameConflicts = Integer.valueOf(jsonObject.getValue('name_conflicts'));
            }
        }
        
        /**
         * Gets the download URL.
         *
         * @return the download URL.
         */
        public String getDownloadUrl() {
            return this.downloadUrl;
        }
        
        /**
         * Gets the status URL.
         *
         * @return the status URL.
         */
        public String getStatusUrl() {
            return this.statusUrl;
        }
        
        /**
         * Gets when the download expires.
         *
         * @return the expiration time.
         */
        public DateTime getExpiresAt() {
            return this.expiresAt;
        }
        
        /**
         * Gets the number of name conflicts.
         *
         * @return the number of name conflicts.
         */
        public Integer getNameConflicts() {
            return this.nameConflicts;
        }
        
        /**
         * Extracts the download ID from the URLs.
         *
         * @return the download ID.
         */
        public String getDownloadId() {
            if (this.downloadUrl != null) {
                // Extract ID from download URL
                Integer lastSlash = this.downloadUrl.lastIndexOf('/');
                Integer secondLastSlash = this.downloadUrl.lastIndexOf('/', lastSlash - 1);
                if (secondLastSlash >= 0 && lastSlash > secondLastSlash) {
                    return this.downloadUrl.substring(secondLastSlash + 1, lastSlash);
                }
            }
            return null;
        }
    }
    
    /**
     * Contains status information about a zip download.
     */
    public class Status {
        private Integer totalFileCount;
        private Integer downloadedFileCount;
        private Integer skippedFileCount;
        private Integer skippedFolderCount;
        private String state;
        
        /**
         * Constructs a Status object from a JSON string.
         *
         * @param json the JSON string.
         */
        public Status(String json) {
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject(json);
            
            if (jsonObject.getValue('total_file_count') != null) {
                this.totalFileCount = Integer.valueOf(jsonObject.getValue('total_file_count'));
            }
            if (jsonObject.getValue('downloaded_file_count') != null) {
                this.downloadedFileCount = Integer.valueOf(jsonObject.getValue('downloaded_file_count'));
            }
            if (jsonObject.getValue('skipped_file_count') != null) {
                this.skippedFileCount = Integer.valueOf(jsonObject.getValue('skipped_file_count'));
            }
            if (jsonObject.getValue('skipped_folder_count') != null) {
                this.skippedFolderCount = Integer.valueOf(jsonObject.getValue('skipped_folder_count'));
            }
            if (jsonObject.getValue('state') != null) {
                this.state = jsonObject.getValue('state');
            }
        }
        
        /**
         * Gets the total file count.
         *
         * @return the total file count.
         */
        public Integer getTotalFileCount() {
            return this.totalFileCount;
        }
        
        /**
         * Gets the downloaded file count.
         *
         * @return the downloaded file count.
         */
        public Integer getDownloadedFileCount() {
            return this.downloadedFileCount;
        }
        
        /**
         * Gets the skipped file count.
         *
         * @return the skipped file count.
         */
        public Integer getSkippedFileCount() {
            return this.skippedFileCount;
        }
        
        /**
         * Gets the skipped folder count.
         *
         * @return the skipped folder count.
         */
        public Integer getSkippedFolderCount() {
            return this.skippedFolderCount;
        }
        
        /**
         * Gets the state of the download.
         *
         * @return the state (in_progress, succeeded, failed).
         */
        public String getState() {
            return this.state;
        }
        
        /**
         * Checks if the download is complete.
         *
         * @return true if complete, false otherwise.
         */
        public Boolean isComplete() {
            return 'succeeded'.equals(this.state) || 'failed'.equals(this.state);
        }
        
        /**
         * Checks if the download succeeded.
         *
         * @return true if succeeded, false otherwise.
         */
        public Boolean isSucceeded() {
            return 'succeeded'.equals(this.state);
        }
    }
    
    /**
     * Enum for download states.
     */
    public enum State {
        IN_PROGRESS,
        SUCCEEDED,
        FAILED
    }
    
    /**
     * Gets the string representation of a state.
     *
     * @param state the state.
     * @return the string representation.
     */
    public static String getStateString(State state) {
        switch on state {
            when IN_PROGRESS { return 'in_progress'; }
            when SUCCEEDED { return 'succeeded'; }
            when FAILED { return 'failed'; }
            when else { return null; }
        }
    }
}