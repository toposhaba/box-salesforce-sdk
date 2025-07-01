/**
 * Represents a Box Collection.
 */
public class BoxCollection extends BoxResource {
    private static String COLLECTIONS_URL = 'collections';
    private static String COLLECTION_ITEMS_URL = 'collections/{0}/items';
    
    /**
     * Constructs a BoxCollection with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the collection.
     */
    public BoxCollection(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets all collections for the current user.
     *
     * @param api the API connection to use.
     * @param fields the fields to include in the response.
     * @param offset the offset of the first collection to return.
     * @param limit the maximum number of collections to return.
     * @return a list of collections.
     */
    public static List<BoxCollection.Info> getAll(
        BoxApiConnection api,
        List<String> fields,
        Integer offset,
        Integer limit
    ) {
        String url = api.baseUrl + COLLECTIONS_URL;
        
        List<String> params = new List<String>();
        if (fields != null && !fields.isEmpty()) {
            params.add('fields=' + String.join(fields, ','));
        }
        if (offset != null) {
            params.add('offset=' + offset);
        }
        if (limit != null) {
            params.add('limit=' + limit);
        }
        
        if (!params.isEmpty()) {
            url += '?' + String.join(params, '&');
        }
        
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxCollection.getAll');
        
        List<BoxCollection.Info> collections = new List<BoxCollection.Info>();
        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        
        if (responseObject.children.get('entries') != null) {
            BoxJsonObject entriesObject = responseObject.children.get('entries');
            if (entriesObject.children != null) {
                for (BoxJsonObject collectionObject : entriesObject.children.values()) {
                    collections.add(new BoxCollection.Info(collectionObject.getJsonString()));
                }
            }
        }
        
        return collections;
    }
    
    /**
     * Gets items in this collection.
     *
     * @param fields the fields to include in the response.
     * @param offset the offset of the first item to return.
     * @param limit the maximum number of items to return.
     * @return an iterable collection of items.
     */
    public BoxResourceIterable<BoxItem.Info> getItems(
        List<String> fields,
        Integer offset,
        Integer limit
    ) {
        String url = this.api.baseUrl + String.format(COLLECTION_ITEMS_URL, new String[] { this.id });
        
        List<String> params = new List<String>();
        if (fields != null && !fields.isEmpty()) {
            params.add('fields=' + String.join(fields, ','));
        }
        if (offset != null) {
            params.add('offset=' + offset);
        }
        if (limit != null) {
            params.add('limit=' + limit);
        }
        
        if (!params.isEmpty()) {
            url += '?' + String.join(params, '&');
        }
        
        return new BoxResourceIterable<BoxItem.Info>(
            this.api,
            url,
            new ItemPagedCollection(this.api, url)
        );
    }
    
    /**
     * Adds an item to this collection.
     *
     * @param item the item to add.
     */
    public void addItem(BoxItem item) {
        String url = this.api.baseUrl + COLLECTIONS_URL;
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        
        // Get current collections
        List<BoxCollection.Info> collections = BoxCollection.getAll(this.api, null, null, null);
        
        // Build collections array including this collection
        List<Map<String, String>> collectionsList = new List<Map<String, String>>();
        for (BoxCollection.Info collection : collections) {
            Map<String, String> collectionMap = new Map<String, String>();
            collectionMap.put('id', collection.getID());
            collectionsList.add(collectionMap);
        }
        
        // Add this collection if not already present
        Boolean found = false;
        for (Map<String, String> collectionMap : collectionsList) {
            if (collectionMap.get('id') == this.id) {
                found = true;
                break;
            }
        }
        if (!found) {
            Map<String, String> thisCollection = new Map<String, String>();
            thisCollection.put('id', this.id);
            collectionsList.add(thisCollection);
        }
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('collections', JSON.serialize(collectionsList));
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        // Update the item's collections
        String itemUrl = this.api.baseUrl + item.getItemType() + 's/' + item.getId();
        BoxApiRequest itemRequest = new BoxApiRequest(this.api, itemUrl, BoxApiRequest.METHOD_PUT);
        itemRequest.setBody(requestBody.getJsonString());
        itemRequest.setTimeout(this.api.timeout);
        itemRequest.addJsonContentTypeHeader();
        
        HttpResponse response = itemRequest.send();
        BoxApiRequest.getBoxResourceResponseBody(response, 'BoxCollection.addItem');
    }
    
    /**
     * Removes an item from this collection.
     *
     * @param item the item to remove.
     */
    public void removeItem(BoxItem item) {
        // Get current collections
        List<BoxCollection.Info> collections = BoxCollection.getAll(this.api, null, null, null);
        
        // Build collections array excluding this collection
        List<Map<String, String>> collectionsList = new List<Map<String, String>>();
        for (BoxCollection.Info collection : collections) {
            if (collection.getID() != this.id) {
                Map<String, String> collectionMap = new Map<String, String>();
                collectionMap.put('id', collection.getID());
                collectionsList.add(collectionMap);
            }
        }
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('collections', JSON.serialize(collectionsList));
        
        // Update the item's collections
        String itemUrl = this.api.baseUrl + item.getItemType() + 's/' + item.getId();
        BoxApiRequest itemRequest = new BoxApiRequest(this.api, itemUrl, BoxApiRequest.METHOD_PUT);
        itemRequest.setBody(requestBody.getJsonString());
        itemRequest.setTimeout(this.api.timeout);
        itemRequest.addJsonContentTypeHeader();
        
        HttpResponse response = itemRequest.send();
        BoxApiRequest.getBoxResourceResponseBody(response, 'BoxCollection.removeItem');
    }
    
    /**
     * Contains information about a Box Collection.
     */
    public class Info extends BoxResource.Info {
        private String type;
        private String name;
        private String collectionType;
        
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
            if (jsonObject.getValue('collection_type') != null) {
                this.collectionType = jsonObject.getValue('collection_type');
            }
        }
        
        /**
         * Gets the type of the collection.
         *
         * @return the type.
         */
        public String getType() {
            return this.type;
        }
        
        /**
         * Gets the name of the collection.
         *
         * @return the name.
         */
        public String getName() {
            return this.name;
        }
        
        /**
         * Gets the collection type.
         *
         * @return the collection type.
         */
        public String getCollectionType() {
            return this.collectionType;
        }
    }
    
    /**
     * Used to paginate through a collection of items.
     */
    private class ItemPagedCollection extends BoxResourcePagedCollection<BoxItem.Info> {
        
        public ItemPagedCollection(BoxApiConnection api, String url) {
            super(api, url);
        }
        
        protected override BoxResource.Info factory(BoxJsonObject jsonObject) {
            String type = jsonObject.getValue('type');
            String id = jsonObject.getValue('id');
            
            if ('file'.equals(type)) {
                BoxFile file = new BoxFile(this.api, id);
                return file.new Info(jsonObject.getJsonString());
            } else if ('folder'.equals(type)) {
                BoxFolder folder = new BoxFolder(this.api, id);
                return folder.new Info(jsonObject.getJsonString());
            } else if ('web_link'.equals(type)) {
                BoxWebLink webLink = new BoxWebLink(this.api, id);
                return webLink.new Info(jsonObject.getJsonString());
            } else {
                throw new BoxApiConnectionException('Unknown item type: ' + type);
            }
        }
    }
    
    /**
     * Enum for collection types.
     */
    public enum CollectionType {
        FAVORITES
    }
    
    /**
     * Gets the string representation of a collection type.
     *
     * @param type the collection type.
     * @return the string representation.
     */
    public static String getCollectionTypeString(CollectionType type) {
        switch on type {
            when FAVORITES { return 'favorites'; }
            when else { return null; }
        }
    }
}