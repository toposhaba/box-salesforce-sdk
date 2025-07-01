/**
 * Represents a Box Task Assignment.
 */
public class BoxTaskAssignment extends BoxResource {
    private static String TASK_ASSIGNMENTS_URL = 'task_assignments';
    private static String TASK_ASSIGNMENT_URL = 'task_assignments/{0}';
    
    /**
     * Constructs a BoxTaskAssignment with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the task assignment.
     */
    public BoxTaskAssignment(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets information about this task assignment.
     *
     * @return the task assignment information.
     */
    public BoxTaskAssignment.Info getInfo() {
        String url = this.api.baseUrl + String.format(TASK_ASSIGNMENT_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTaskAssignment.getInfo');
        
        return new BoxTaskAssignment.Info(responseBody);
    }
    
    /**
     * Updates information about this task assignment.
     *
     * @param message the updated message.
     * @param resolutionState the resolution state.
     * @return the updated task assignment information.
     */
    public BoxTaskAssignment.Info updateInfo(String message, String resolutionState) {
        String url = this.api.baseUrl + String.format(TASK_ASSIGNMENT_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        if (message != null) {
            requestBody.addValue('message', message);
        }
        if (resolutionState != null) {
            requestBody.addValue('resolution_state', resolutionState);
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTaskAssignment.updateInfo');
        
        return new BoxTaskAssignment.Info(responseBody);
    }
    
    /**
     * Deletes this task assignment.
     */
    public void delete() {
        String url = this.api.baseUrl + String.format(TASK_ASSIGNMENT_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        
        HttpResponse response = request.send();
        BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTaskAssignment.delete');
    }
    
    /**
     * Contains information about a Box Task Assignment.
     */
    public class Info extends BoxResource.Info {
        private String type;
        private BoxTask.Info item;
        private BoxUser.Info assignedTo;
        private String message;
        private DateTime completedAt;
        private DateTime assignedAt;
        private DateTime remindedAt;
        private String resolutionState;
        private BoxUser.Info assignedBy;
        
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
            if (jsonObject.getValue('message') != null) {
                this.message = jsonObject.getValue('message');
            }
            if (jsonObject.getValue('completed_at') != null) {
                this.completedAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('completed_at'));
            }
            if (jsonObject.getValue('assigned_at') != null) {
                this.assignedAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('assigned_at'));
            }
            if (jsonObject.getValue('reminded_at') != null) {
                this.remindedAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('reminded_at'));
            }
            if (jsonObject.getValue('resolution_state') != null) {
                this.resolutionState = jsonObject.getValue('resolution_state');
            }
            
            // Parse item (task)
            if (jsonObject.children.get('item') != null) {
                BoxGenericJsonObject itemObject = jsonObject.children.get('item');
                this.item = new BoxTask.Info(itemObject.getJsonString());
            }
            
            // Parse assigned_to
            if (jsonObject.children.get('assigned_to') != null) {
                BoxGenericJsonObject userObject = jsonObject.children.get('assigned_to');
                this.assignedTo = new BoxUser.Info(userObject.getJsonString());
            }
            
            // Parse assigned_by
            if (jsonObject.children.get('assigned_by') != null) {
                BoxGenericJsonObject userObject = jsonObject.children.get('assigned_by');
                this.assignedBy = new BoxUser.Info(userObject.getJsonString());
            }
        }
        
        public String getType() {
            return this.type;
        }
        
        public BoxTask.Info getItem() {
            return this.item;
        }
        
        public BoxUser.Info getAssignedTo() {
            return this.assignedTo;
        }
        
        public String getMessage() {
            return this.message;
        }
        
        public DateTime getCompletedAt() {
            return this.completedAt;
        }
        
        public DateTime getAssignedAt() {
            return this.assignedAt;
        }
        
        public DateTime getRemindedAt() {
            return this.remindedAt;
        }
        
        public String getResolutionState() {
            return this.resolutionState;
        }
        
        public BoxUser.Info getAssignedBy() {
            return this.assignedBy;
        }
    }
    
    /**
     * Enum for resolution states.
     */
    public enum ResolutionState {
        COMPLETED,
        INCOMPLETE,
        APPROVED,
        REJECTED
    }
    
    /**
     * Gets the string representation of a resolution state.
     *
     * @param state the resolution state.
     * @return the string representation.
     */
    public static String getResolutionStateString(ResolutionState state) {
        switch on state {
            when COMPLETED { return 'completed'; }
            when INCOMPLETE { return 'incomplete'; }
            when APPROVED { return 'approved'; }
            when REJECTED { return 'rejected'; }
            when else { return null; }
        }
    }
}