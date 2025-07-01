/**
 * Represents a Box Task.
 */
public class BoxTask extends BoxResource {
    private static String TASKS_URL = 'tasks';
    private static String TASK_URL = 'tasks/{0}';
    private static String TASK_ASSIGNMENTS_URL = 'tasks/{0}/assignments';
    private static String FILE_TASKS_URL = 'files/{0}/tasks';
    
    /**
     * Constructs a BoxTask with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the task.
     */
    public BoxTask(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets information about this task.
     *
     * @return the task information.
     */
    public BoxTask.Info getInfo() {
        String url = this.api.baseUrl + String.format(TASK_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.getInfo');
        
        return new BoxTask.Info(responseBody);
    }
    
    /**
     * Updates information about this task.
     *
     * @param info the updated task information.
     * @return the updated task information.
     */
    public BoxTask.Info updateInfo(BoxTask.Info info) {
        String url = this.api.baseUrl + String.format(TASK_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        if (info.getMessage() != null) {
            requestBody.addValue('message', info.getMessage());
        }
        if (info.getDueAt() != null) {
            requestBody.addValue('due_at', BoxDateFormat.getBoxDateTimeString(info.getDueAt()));
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.updateInfo');
        
        return new BoxTask.Info(responseBody);
    }
    
    /**
     * Deletes this task.
     */
    public void delete() {
        String url = this.api.baseUrl + String.format(TASK_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        
        HttpResponse response = request.send();
        BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.delete');
    }
    
    /**
     * Gets all assignments for this task.
     *
     * @return a list of task assignments.
     */
    public List<BoxTaskAssignment.Info> getAssignments() {
        String url = this.api.baseUrl + String.format(TASK_ASSIGNMENTS_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.getAssignments');
        
        List<BoxTaskAssignment.Info> assignments = new List<BoxTaskAssignment.Info>();
        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        
        if (responseObject.children.get('entries') != null) {
            BoxJsonObject entriesObject = responseObject.children.get('entries');
            if (entriesObject.children != null) {
                for (BoxJsonObject assignmentObject : entriesObject.children.values()) {
                    assignments.add(new BoxTaskAssignment.Info(assignmentObject.getJsonString()));
                }
            }
        }
        
        return assignments;
    }
    
    /**
     * Creates a new task assignment.
     *
     * @param assignTo the user to assign the task to.
     * @return the created task assignment.
     */
    public BoxTaskAssignment.Info createAssignment(BoxUser assignTo) {
        String url = this.api.baseUrl + String.format(TASK_ASSIGNMENTS_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        BoxGenericJsonObject assignToObject = new BoxGenericJsonObject();
        assignToObject.addValue('id', assignTo.getId());
        assignToObject.addValue('type', 'user');
        requestBody.children.put('assign_to', assignToObject);
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.createAssignment');
        
        return new BoxTaskAssignment.Info(responseBody);
    }
    
    /**
     * Creates a new task on a file.
     *
     * @param api the API connection to use.
     * @param file the file to create the task on.
     * @param action the action type for the task.
     * @param message the task message.
     * @param dueAt when the task is due.
     * @return the created task information.
     */
    public static BoxTask.Info create(
        BoxApiConnection api,
        BoxFile file,
        String action,
        String message,
        DateTime dueAt
    ) {
        String url = api.baseUrl + String.format(FILE_TASKS_URL, new String[] { file.getId() });
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_POST);
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('action', action);
        
        if (message != null) {
            requestBody.addValue('message', message);
        }
        if (dueAt != null) {
            requestBody.addValue('due_at', BoxDateFormat.getBoxDateTimeString(dueAt));
        }
        
        // Add item
        BoxGenericJsonObject itemObject = new BoxGenericJsonObject();
        itemObject.addValue('id', file.getId());
        itemObject.addValue('type', 'file');
        requestBody.children.put('item', itemObject);
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.create');
        
        return new BoxTask.Info(responseBody);
    }
    
    /**
     * Gets all tasks on a file.
     *
     * @param api the API connection to use.
     * @param file the file to get tasks for.
     * @return a list of tasks.
     */
    public static List<BoxTask.Info> getTasks(BoxApiConnection api, BoxFile file) {
        String url = api.baseUrl + String.format(FILE_TASKS_URL, new String[] { file.getId() });
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxTask.getTasks');
        
        List<BoxTask.Info> tasks = new List<BoxTask.Info>();
        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        
        if (responseObject.children.get('entries') != null) {
            BoxJsonObject entriesObject = responseObject.children.get('entries');
            if (entriesObject.children != null) {
                for (BoxJsonObject taskObject : entriesObject.children.values()) {
                    tasks.add(new BoxTask.Info(taskObject.getJsonString()));
                }
            }
        }
        
        return tasks;
    }
    
    /**
     * Contains information about a Box Task.
     */
    public class Info extends BoxResource.Info {
        private String type;
        private BoxFile.Info item;
        private DateTime dueAt;
        private String action;
        private String message;
        private List<BoxTaskAssignment.Info> taskAssignmentCollection;
        private Boolean isCompleted;
        private BoxUser.Info createdBy;
        private DateTime createdAt;
        private String completionRule;
        
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
            if (jsonObject.getValue('due_at') != null) {
                this.dueAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('due_at'));
            }
            if (jsonObject.getValue('action') != null) {
                this.action = jsonObject.getValue('action');
            }
            if (jsonObject.getValue('message') != null) {
                this.message = jsonObject.getValue('message');
            }
            if (jsonObject.getValue('is_completed') != null) {
                this.isCompleted = Boolean.valueOf(jsonObject.getValue('is_completed'));
            }
            if (jsonObject.getValue('created_at') != null) {
                this.createdAt = BoxDateFormat.parseDateTimeString(jsonObject.getValue('created_at'));
            }
            if (jsonObject.getValue('completion_rule') != null) {
                this.completionRule = jsonObject.getValue('completion_rule');
            }
            
            // Parse item
            if (jsonObject.children.get('item') != null) {
                BoxGenericJsonObject itemObject = jsonObject.children.get('item');
                this.item = new BoxFile.Info(itemObject.getJsonString());
            }
            
            // Parse created_by
            if (jsonObject.children.get('created_by') != null) {
                BoxGenericJsonObject userObject = jsonObject.children.get('created_by');
                this.createdBy = new BoxUser.Info(userObject.getJsonString());
            }
            
            // Parse task assignments
            if (jsonObject.children.get('task_assignment_collection') != null) {
                this.taskAssignmentCollection = new List<BoxTaskAssignment.Info>();
                BoxGenericJsonObject collectionObject = jsonObject.children.get('task_assignment_collection');
                if (collectionObject.children.get('entries') != null) {
                    BoxJsonObject entriesObject = collectionObject.children.get('entries');
                    if (entriesObject.children != null) {
                        for (BoxJsonObject assignmentObject : entriesObject.children.values()) {
                            this.taskAssignmentCollection.add(new BoxTaskAssignment.Info(assignmentObject.getJsonString()));
                        }
                    }
                }
            }
        }
        
        public String getType() {
            return this.type;
        }
        
        public BoxFile.Info getItem() {
            return this.item;
        }
        
        public DateTime getDueAt() {
            return this.dueAt;
        }
        
        public void setDueAt(DateTime dueAt) {
            this.dueAt = dueAt;
        }
        
        public String getAction() {
            return this.action;
        }
        
        public String getMessage() {
            return this.message;
        }
        
        public void setMessage(String message) {
            this.message = message;
        }
        
        public List<BoxTaskAssignment.Info> getTaskAssignmentCollection() {
            return this.taskAssignmentCollection;
        }
        
        public Boolean getIsCompleted() {
            return this.isCompleted;
        }
        
        public BoxUser.Info getCreatedBy() {
            return this.createdBy;
        }
        
        public DateTime getCreatedAt() {
            return this.createdAt;
        }
        
        public String getCompletionRule() {
            return this.completionRule;
        }
    }
    
    /**
     * Enum for task actions.
     */
    public enum Action {
        REVIEW,
        COMPLETE
    }
    
    /**
     * Gets the string representation of a task action.
     *
     * @param action the action.
     * @return the string representation.
     */
    public static String getActionString(Action action) {
        switch on action {
            when REVIEW { return 'review'; }
            when COMPLETE { return 'complete'; }
            when else { return null; }
        }
    }
    
    /**
     * Enum for completion rules.
     */
    public enum CompletionRule {
        ALL_ASSIGNEES,
        ANY_ASSIGNEE
    }
    
    /**
     * Gets the string representation of a completion rule.
     *
     * @param rule the completion rule.
     * @return the string representation.
     */
    public static String getCompletionRuleString(CompletionRule rule) {
        switch on rule {
            when ALL_ASSIGNEES { return 'all_assignees'; }
            when ANY_ASSIGNEE { return 'any_assignee'; }
            when else { return null; }
        }
    }
}