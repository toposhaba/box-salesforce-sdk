/**
 * Provides access to Box Recent Items.
 */
public class BoxRecentItem {
    private static String RECENT_ITEMS_URL = 'recent_items';
    
    /**
     * Gets recent items for the current user.
     *
     * @param api the API connection to use.
     * @param fields the fields to include in the response.
     * @param limit the maximum number of items to return.
     * @param marker the position marker for pagination.
     * @return a list of recent items.
     */
    public static List<BoxRecentItem.Info> getRecentItems(
        BoxApiConnection api,
        List<String> fields,
        Integer limit,
        String marker
    ) {
        String url = api.baseUrl + RECENT_ITEMS_URL;
        
        List<String> params = new List<String>();
        if (fields != null && !fields.isEmpty()) {
            params.add('fields=' + String.join(fields, ','));
        }
        if (limit != null) {
            params.add('limit=' + limit);
        }
        if (marker != null) {
            params.add('marker=' + marker);
        }
        
        if (!params.isEmpty()) {
            url += '?' + String.join(params, '&');
        }
        
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxRecentItem.getRecentItems');
        
        List<BoxRecentItem.Info> recentItems = new List<BoxRecentItem.Info>();
        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        
        if (responseObject.children.get('entries') != null) {
            BoxJsonObject entriesObject = responseObject.children.get('entries');
            if (entriesObject.children != null) {
                for (BoxJsonObject recentItemObject : entriesObject.children.values()) {
                    recentItems.add(new BoxRecentItem.Info(recentItemObject.getJsonString()));
                }
            }
        }
        
        return recentItems;
    }
    
    /**
     * Contains information about a recent item.
     */
    public class Info {
        private String type;
        private DateTime interactedAt;
        private BoxItem.Info item;
        private String interactionType;
        private BoxSharedLink sharedLink;
        
        /**
         * Constructs an Info object from a JSON string.
         *
         * @param json the JSON string.
         */
        public Info(String json) {
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject(json);
            
            if (jsonObject.getValue('type') != null) {
                this.type = jsonObject.getValue('type');
            }
            if (jsonObject.getValue('interacted_at') != null) {
                this.interactedAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('interacted_at'));
            }
            if (jsonObject.getValue('interaction_type') != null) {
                this.interactionType = jsonObject.getValue('interaction_type');
            }
            
            // Parse item
            if (jsonObject.children.get('item') != null) {
                BoxGenericJsonObject itemObject = jsonObject.children.get('item');
                String itemType = itemObject.getValue('type');
                String itemId = itemObject.getValue('id');
                
                if ('file'.equals(itemType)) {
                    BoxFile file = new BoxFile(null, itemId);
                    this.item = file.new Info(itemObject.getJsonString());
                } else if ('folder'.equals(itemType)) {
                    BoxFolder folder = new BoxFolder(null, itemId);
                    this.item = folder.new Info(itemObject.getJsonString());
                } else if ('web_link'.equals(itemType)) {
                    BoxWebLink webLink = new BoxWebLink(null, itemId);
                    this.item = webLink.new Info(itemObject.getJsonString());
                }
            }
            
            // Parse shared link
            if (jsonObject.children.get('interaction_shared_link') != null) {
                BoxGenericJsonObject sharedLinkObject = jsonObject.children.get('interaction_shared_link');
                this.sharedLink = new BoxSharedLink(sharedLinkObject.getJsonString());
            }
        }
        
        /**
         * Gets the type of the recent item.
         *
         * @return the type.
         */
        public String getType() {
            return this.type;
        }
        
        /**
         * Gets when the item was interacted with.
         *
         * @return the interaction time.
         */
        public DateTime getInteractedAt() {
            return this.interactedAt;
        }
        
        /**
         * Gets the item information.
         *
         * @return the item.
         */
        public BoxItem.Info getItem() {
            return this.item;
        }
        
        /**
         * Gets the interaction type.
         *
         * @return the interaction type.
         */
        public String getInteractionType() {
            return this.interactionType;
        }
        
        /**
         * Gets the shared link if the interaction was through a shared link.
         *
         * @return the shared link.
         */
        public BoxSharedLink getSharedLink() {
            return this.sharedLink;
        }
    }
    
    /**
     * Enum for interaction types.
     */
    public enum InteractionType {
        ITEM_PREVIEW,
        ITEM_UPLOAD,
        ITEM_COMMENT,
        ITEM_OPEN,
        ITEM_MODIFY
    }
    
    /**
     * Gets the string representation of an interaction type.
     *
     * @param type the interaction type.
     * @return the string representation.
     */
    public static String getInteractionTypeString(InteractionType type) {
        switch on type {
            when ITEM_PREVIEW { return 'item_preview'; }
            when ITEM_UPLOAD { return 'item_upload'; }
            when ITEM_COMMENT { return 'item_comment'; }
            when ITEM_OPEN { return 'item_open'; }
            when ITEM_MODIFY { return 'item_modify'; }
            when else { return null; }
        }
    }
}