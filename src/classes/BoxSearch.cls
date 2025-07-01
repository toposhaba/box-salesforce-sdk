/**
 * Provides advanced search functionality for Box.
 */
public class BoxSearch {
    private static String SEARCH_URL = 'search';
    
    /**
     * Searches for items in Box.
     *
     * @param api the API connection to use.
     * @param query the search query.
     * @param scope the scope to search in (user_content or enterprise_content).
     * @param fileExtensions list of file extensions to filter by.
     * @param createdAtRange date range for creation date.
     * @param updatedAtRange date range for update date.
     * @param sizeRange size range in bytes.
     * @param ownerUserIds list of user IDs to filter by owner.
     * @param ancestorFolderIds list of folder IDs to search in.
     * @param contentTypes list of content types to filter by.
     * @param itemType type of items to search for (file, folder, or web_link).
     * @param trashContent whether to search in trash.
     * @param mdfilters metadata filters.
     * @param limitValue maximum number of items to return.
     * @param offset offset for pagination.
     * @return search results.
     */
    public static BoxSearch.Results search(
        BoxApiConnection api,
        String query,
        String scope,
        List<String> fileExtensions,
        DateRange createdAtRange,
        DateRange updatedAtRange,
        SizeRange sizeRange,
        List<String> ownerUserIds,
        List<String> ancestorFolderIds,
        List<String> contentTypes,
        String itemType,
        String trashContent,
        List<MetadataFilter> mdfilters,
        Integer limitValue,
        Integer offset
    ) {
        String url = api.baseUrl + SEARCH_URL;
        
        // Build query parameters
        List<String> queryParams = new List<String>();
        
        if (query != null) {
            queryParams.add('query=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        }
        if (scope != null) {
            queryParams.add('scope=' + scope);
        }
        if (fileExtensions != null && !fileExtensions.isEmpty()) {
            queryParams.add('file_extensions=' + String.join(fileExtensions, ','));
        }
        if (createdAtRange != null) {
            queryParams.add('created_at_range=' + createdAtRange.toString());
        }
        if (updatedAtRange != null) {
            queryParams.add('updated_at_range=' + updatedAtRange.toString());
        }
        if (sizeRange != null) {
            queryParams.add('size_range=' + sizeRange.toString());
        }
        if (ownerUserIds != null && !ownerUserIds.isEmpty()) {
            queryParams.add('owner_user_ids=' + String.join(ownerUserIds, ','));
        }
        if (ancestorFolderIds != null && !ancestorFolderIds.isEmpty()) {
            queryParams.add('ancestor_folder_ids=' + String.join(ancestorFolderIds, ','));
        }
        if (contentTypes != null && !contentTypes.isEmpty()) {
            queryParams.add('content_types=' + String.join(contentTypes, ','));
        }
        if (itemType != null) {
            queryParams.add('type=' + itemType);
        }
        if (trashContent != null) {
            queryParams.add('trash_content=' + trashContent);
        }
        if (mdfilters != null && !mdfilters.isEmpty()) {
            for (MetadataFilter filter : mdfilters) {
                queryParams.add('mdfilters=' + EncodingUtil.urlEncode(filter.toJson(), 'UTF-8'));
            }
        }
        if (limitValue != null) {
            queryParams.add('limit=' + String.valueOf(limitValue));
        }
        if (offset != null) {
            queryParams.add('offset=' + String.valueOf(offset));
        }
        
        if (!queryParams.isEmpty()) {
            url += '?' + String.join(queryParams, '&');
        }
        
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxSearch.search'
        );
        
        return new BoxSearch.Results(responseBody);
    }
    
    /**
     * Represents search results.
     */
    public class Results {
        public Integer totalCount;
        public Integer limitValue;
        public Integer offset;
        public List<BoxItem.Info> entries;
        
        /**
         * Constructs a Results object from JSON.
         *
         * @param jsonString the JSON string to parse.
         */
        public Results(String jsonString) {
            BoxGenericJsonObject responseObject = new BoxGenericJsonObject(jsonString);
            
            if (responseObject.getValue('total_count') != null) {
                this.totalCount = Integer.valueOf(responseObject.getValue('total_count'));
            }
            if (responseObject.getValue('limit') != null) {
                this.limitValue = Integer.valueOf(responseObject.getValue('limit'));
            }
            if (responseObject.getValue('offset') != null) {
                this.offset = Integer.valueOf(responseObject.getValue('offset'));
            }
            
            this.entries = new List<BoxItem.Info>();
            if (responseObject.getValue('entries') != null) {
                List<String> itemEntries = BoxJsonObject.parseJsonObjectArray(
                    responseObject.getValue('entries')
                );
                for (String entry : itemEntries) {
                    BoxGenericJsonObject entryObject = new BoxGenericJsonObject(entry);
                    String objectType = entryObject.getValue('type');
                    if (objectType == 'file') {
                        this.entries.add(new BoxFile.Info(entryObject));
                    } else if (objectType == 'folder') {
                        this.entries.add(new BoxFolder.Info(entryObject));
                    } else if (objectType == 'web_link') {
                        this.entries.add(new BoxWebLink.Info(entryObject));
                    }
                }
            }
        }
    }
    
    /**
     * Represents a date range for search filtering.
     */
    public class DateRange {
        private DateTime fromDate;
        private DateTime toDate;
        
        public DateRange(DateTime fromDate, DateTime toDate) {
            this.fromDate = fromDate;
            this.toDate = toDate;
        }
        
        public override String toString() {
            String result = '';
            if (this.fromDate != null) {
                result += BoxDateFormat.getBoxDateTimeString(this.fromDate);
            }
            result += ',';
            if (this.toDate != null) {
                result += BoxDateFormat.getBoxDateTimeString(this.toDate);
            }
            return result;
        }
    }
    
    /**
     * Represents a size range for search filtering.
     */
    public class SizeRange {
        private Long fromSize;
        private Long toSize;
        
        public SizeRange(Long fromSize, Long toSize) {
            this.fromSize = fromSize;
            this.toSize = toSize;
        }
        
        public override String toString() {
            String result = '';
            if (this.fromSize != null) {
                result += String.valueOf(this.fromSize);
            }
            result += ',';
            if (this.toSize != null) {
                result += String.valueOf(this.toSize);
            }
            return result;
        }
    }
    
    /**
     * Represents a metadata filter for search.
     */
    public class MetadataFilter {
        private String scope;
        private String templateKey;
        private Map<String, Object> filters;
        
        public MetadataFilter(String scope, String templateKey) {
            this.scope = scope;
            this.templateKey = templateKey;
            this.filters = new Map<String, Object>();
        }
        
        public void addFilter(String key, Object value) {
            this.filters.put(key, value);
        }
        
        public String toJson() {
            Map<String, Object> filterMap = new Map<String, Object>();
            filterMap.put('scope', this.scope);
            filterMap.put('templateKey', this.templateKey);
            filterMap.put('filters', this.filters);
            return JSON.serialize(filterMap);
        }
    }
}