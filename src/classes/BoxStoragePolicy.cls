/**
 * Represents a Box Storage Policy.
 */
public class BoxStoragePolicy extends BoxResource {
    private static String STORAGE_POLICIES_URL = 'storage_policies';
    private static String STORAGE_POLICY_URL = 'storage_policies/{0}';
    
    /**
     * Constructs a BoxStoragePolicy with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the storage policy.
     */
    public BoxStoragePolicy(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets information about this storage policy.
     *
     * @return the storage policy information.
     */
    public BoxStoragePolicy.Info getInfo() {
        String url = this.api.baseUrl + String.format(STORAGE_POLICY_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxStoragePolicy.getInfo');
        
        return new BoxStoragePolicy.Info(responseBody);
    }
    
    /**
     * Lists all storage policies.
     *
     * @param api the API connection to use.
     * @param fields the fields to include in the response.
     * @param marker the position marker for pagination.
     * @param limit the maximum number of items to return.
     * @return an iterable collection of storage policies.
     */
    public static BoxResourceIterable<BoxStoragePolicy.Info> getAll(
        BoxApiConnection api,
        List<String> fields,
        String marker,
        Integer limit
    ) {
        String url = api.baseUrl + STORAGE_POLICIES_URL;
        
        List<String> params = new List<String>();
        if (fields != null && !fields.isEmpty()) {
            params.add('fields=' + String.join(fields, ','));
        }
        if (marker != null) {
            params.add('marker=' + marker);
        }
        if (limit != null) {
            params.add('limit=' + limit);
        }
        
        if (!params.isEmpty()) {
            url += '?' + String.join(params, '&');
        }
        
        return new BoxResourceIterable<BoxStoragePolicy.Info>(
            api,
            url,
            new BoxStoragePolicy.InfoPagedCollection(api, url)
        );
    }
    
    /**
     * Contains information about a Box Storage Policy.
     */
    public class Info extends BoxResource.Info {
        private String type;
        private String name;
        
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
            if (jsonObject.getValue('name') != null) {
                this.name = jsonObject.getValue('name');
            }
        }
        
        /**
         * Gets the type of the storage policy.
         *
         * @return the type.
         */
        public String getType() {
            return this.type;
        }
        
        /**
         * Gets the name of the storage policy.
         *
         * @return the name.
         */
        public String getName() {
            return this.name;
        }
    }
    
    /**
     * Used to paginate through a collection of storage policies.
     */
    private class InfoPagedCollection extends BoxResourcePagedCollection<BoxStoragePolicy.Info> {
        
        public InfoPagedCollection(BoxApiConnection api, String url) {
            super(api, url);
        }
        
        protected override BoxResource.Info factory(BoxJsonObject jsonObject) {
            BoxStoragePolicy policy = new BoxStoragePolicy(this.api, jsonObject.getValue('id'));
            return policy.new Info(jsonObject.getJsonString());
        }
    }
}