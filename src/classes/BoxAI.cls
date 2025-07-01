/**
 * Provides Box AI capabilities for intelligent content processing.
 */
public class BoxAI {
    private static String AI_ASK_URL = 'ai/ask';
    private static String AI_TEXT_GEN_URL = 'ai/text_gen';
    private static String AI_EXTRACT_URL = 'ai/extract';
    private static String AI_EXTRACT_STRUCTURED_URL = 'ai/extract_structured';
    
    /**
     * Ask AI a question about files.
     *
     * @param api the API connection to use.
     * @param prompt the question to ask.
     * @param items list of items to ask about.
     * @param mode the AI mode (single_item_qa, multiple_item_qa).
     * @param aiAgent optional AI agent configuration.
     * @return AI response.
     */
    public static BoxAI.Response ask(
        BoxApiConnection api,
        String prompt,
        List<BoxAI.Item> items,
        String mode,
        BoxAI.Agent aiAgent
    ) {
        String url = api.baseUrl + AI_ASK_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('prompt', prompt);
        requestBody.addValue('mode', mode);
        
        // Add items
        List<Map<String, String>> itemsList = new List<Map<String, String>>();
        for (BoxAI.Item item : items) {
            itemsList.add(item.toMap());
        }
        requestBody.addValue('items', JSON.serialize(itemsList));
        
        // Add AI agent if provided
        if (aiAgent != null) {
            requestBody.addValue('ai_agent', aiAgent.toJson());
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxAI.ask'
        );
        
        return new BoxAI.Response(responseBody);
    }
    
    /**
     * Generate text using AI.
     *
     * @param api the API connection to use.
     * @param prompt the prompt for text generation.
     * @param items list of items to use as context.
     * @param dialogueHistory optional dialogue history.
     * @param aiAgent optional AI agent configuration.
     * @return AI response.
     */
    public static BoxAI.Response generateText(
        BoxApiConnection api,
        String prompt,
        List<BoxAI.Item> items,
        List<BoxAI.DialogueEntry> dialogueHistory,
        BoxAI.Agent aiAgent
    ) {
        String url = api.baseUrl + AI_TEXT_GEN_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('prompt', prompt);
        
        // Add items
        List<Map<String, String>> itemsList = new List<Map<String, String>>();
        for (BoxAI.Item item : items) {
            itemsList.add(item.toMap());
        }
        requestBody.addValue('items', JSON.serialize(itemsList));
        
        // Add dialogue history if provided
        if (dialogueHistory != null && !dialogueHistory.isEmpty()) {
            List<Map<String, String>> history = new List<Map<String, String>>();
            for (BoxAI.DialogueEntry entry : dialogueHistory) {
                history.add(entry.toMap());
            }
            requestBody.addValue('dialogue_history', JSON.serialize(history));
        }
        
        // Add AI agent if provided
        if (aiAgent != null) {
            requestBody.addValue('ai_agent', aiAgent.toJson());
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxAI.generateText'
        );
        
        return new BoxAI.Response(responseBody);
    }
    
    /**
     * Extract information from files using AI.
     *
     * @param api the API connection to use.
     * @param prompt the extraction prompt.
     * @param items list of items to extract from.
     * @param aiAgent optional AI agent configuration.
     * @return AI response.
     */
    public static BoxAI.Response extract(
        BoxApiConnection api,
        String prompt,
        List<BoxAI.Item> items,
        BoxAI.Agent aiAgent
    ) {
        String url = api.baseUrl + AI_EXTRACT_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        requestBody.addValue('prompt', prompt);
        
        // Add items
        List<Map<String, String>> itemsList = new List<Map<String, String>>();
        for (BoxAI.Item item : items) {
            itemsList.add(item.toMap());
        }
        requestBody.addValue('items', JSON.serialize(itemsList));
        
        // Add AI agent if provided
        if (aiAgent != null) {
            requestBody.addValue('ai_agent', aiAgent.toJson());
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxAI.extract'
        );
        
        return new BoxAI.Response(responseBody);
    }
    
    /**
     * Extract structured data from files using AI.
     *
     * @param api the API connection to use.
     * @param items list of items to extract from.
     * @param fields list of fields to extract.
     * @param aiAgent optional AI agent configuration.
     * @return AI structured response.
     */
    public static BoxAI.StructuredResponse extractStructured(
        BoxApiConnection api,
        List<BoxAI.Item> items,
        List<BoxAI.ExtractField> fields,
        BoxAI.Agent aiAgent
    ) {
        String url = api.baseUrl + AI_EXTRACT_STRUCTURED_URL;
        BoxApiRequest request = new BoxApiRequest(
            api,
            url,
            BoxApiRequest.METHOD_POST
        );
        
        BoxGenericJsonObject requestBody = new BoxGenericJsonObject();
        
        // Add items
        List<Map<String, String>> itemsList = new List<Map<String, String>>();
        for (BoxAI.Item item : items) {
            itemsList.add(item.toMap());
        }
        requestBody.addValue('items', JSON.serialize(itemsList));
        
        // Add fields
        List<Map<String, Object>> fieldsList = new List<Map<String, Object>>();
        for (BoxAI.ExtractField field : fields) {
            fieldsList.add(field.toMap());
        }
        requestBody.addValue('fields', JSON.serialize(fieldsList));
        
        // Add AI agent if provided
        if (aiAgent != null) {
            requestBody.addValue('ai_agent', aiAgent.toJson());
        }
        
        request.setBody(requestBody.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxAI.extractStructured'
        );
        
        return new BoxAI.StructuredResponse(responseBody);
    }
    
    /**
     * Represents an item for AI processing.
     */
    public class Item {
        private String id;
        private String itemType;
        private String content;
        
        public Item(String id, String itemType) {
            this.id = id;
            this.itemType = itemType;
        }
        
        public Item(String id, String itemType, String content) {
            this.id = id;
            this.itemType = itemType;
            this.content = content;
        }
        
        public Map<String, String> toMap() {
            Map<String, String> result = new Map<String, String>();
            result.put('id', this.id);
            result.put('type', this.itemType);
            if (this.content != null) {
                result.put('content', this.content);
            }
            return result;
        }
    }
    
    /**
     * Represents a dialogue entry for conversation history.
     */
    public class DialogueEntry {
        private String prompt;
        private String answer;
        private DateTime createdAt;
        
        public DialogueEntry(String prompt, String answer) {
            this.prompt = prompt;
            this.answer = answer;
            this.createdAt = DateTime.now();
        }
        
        public DialogueEntry(String prompt, String answer, DateTime createdAt) {
            this.prompt = prompt;
            this.answer = answer;
            this.createdAt = createdAt;
        }
        
        public Map<String, String> toMap() {
            Map<String, String> result = new Map<String, String>();
            result.put('prompt', this.prompt);
            result.put('answer', this.answer);
            if (this.createdAt != null) {
                result.put('created_at', BoxDateFormat.getBoxDateTimeString(this.createdAt));
            }
            return result;
        }
    }
    
    /**
     * Represents an extraction field for structured extraction.
     */
    public class ExtractField {
        private String key;
        private String fieldType;
        private String description;
        private String displayName;
        private String prompt;
        private List<ExtractFieldOption> options;
        
        public ExtractField(String key) {
            this.key = key;
        }
        
        public ExtractField setType(String fieldType) {
            this.fieldType = fieldType;
            return this;
        }
        
        public ExtractField setDescription(String description) {
            this.description = description;
            return this;
        }
        
        public ExtractField setDisplayName(String displayName) {
            this.displayName = displayName;
            return this;
        }
        
        public ExtractField setPrompt(String prompt) {
            this.prompt = prompt;
            return this;
        }
        
        public ExtractField setOptions(List<ExtractFieldOption> options) {
            this.options = options;
            return this;
        }
        
        public Map<String, Object> toMap() {
            Map<String, Object> result = new Map<String, Object>();
            result.put('key', this.key);
            if (this.fieldType != null) {
                result.put('type', this.fieldType);
            }
            if (this.description != null) {
                result.put('description', this.description);
            }
            if (this.displayName != null) {
                result.put('display_name', this.displayName);
            }
            if (this.prompt != null) {
                result.put('prompt', this.prompt);
            }
            if (this.options != null && !this.options.isEmpty()) {
                List<Map<String, String>> optionsList = new List<Map<String, String>>();
                for (ExtractFieldOption option : this.options) {
                    optionsList.add(option.toMap());
                }
                result.put('options', optionsList);
            }
            return result;
        }
    }
    
    /**
     * Represents an option for an extraction field.
     */
    public class ExtractFieldOption {
        private String key;
        
        public ExtractFieldOption(String key) {
            this.key = key;
        }
        
        public Map<String, String> toMap() {
            Map<String, String> result = new Map<String, String>();
            result.put('key', this.key);
            return result;
        }
    }
    
    /**
     * Represents an AI response.
     */
    public class Response {
        public String answer;
        public Integer createdAt;
        public String completionReason;
        
        public Response(String jsonString) {
            BoxGenericJsonObject responseObject = new BoxGenericJsonObject(jsonString);
            
            if (responseObject.getValue('answer') != null) {
                this.answer = responseObject.getValue('answer');
            }
            if (responseObject.getValue('created_at') != null) {
                this.createdAt = Integer.valueOf(responseObject.getValue('created_at'));
            }
            if (responseObject.getValue('completion_reason') != null) {
                this.completionReason = responseObject.getValue('completion_reason');
            }
        }
    }
    
    /**
     * Represents an AI structured extraction response.
     */
    public class StructuredResponse {
        public Map<String, Object> data;
        public String sourceType;
        
        public StructuredResponse(String jsonString) {
            BoxGenericJsonObject responseObject = new BoxGenericJsonObject(jsonString);
            
            // Parse the response data
            this.data = new Map<String, Object>();
            for (String key : responseObject.children.keySet()) {
                if (key != 'source' && key != 'type') {
                    this.data.put(key, responseObject.getValue(key));
                }
            }
            
            if (responseObject.getValue('type') != null) {
                this.sourceType = responseObject.getValue('type');
            }
        }
        
        /**
         * Gets a value from the extracted data.
         *
         * @param key the field key.
         * @return the extracted value.
         */
        public Object getValue(String key) {
            return this.data.get(key);
        }
        
        /**
         * Gets a string value from the extracted data.
         *
         * @param key the field key.
         * @return the extracted string value.
         */
        public String getStringValue(String key) {
            Object value = this.data.get(key);
            return value != null ? String.valueOf(value) : null;
        }
    }
    
    /**
     * Represents an AI agent configuration.
     */
    public class Agent {
        private String agentType;
        private Config basicTextConfig;
        private Config basicTextMultiConfig;
        private Config longTextConfig;
        private Config longTextMultiConfig;
        private Config extractConfig;
        private Config extractStructuredConfig;
        
        public Agent(String agentType) {
            this.agentType = agentType;
        }
        
        public Agent setBasicTextConfig(Config config) {
            this.basicTextConfig = config;
            return this;
        }
        
        public Agent setBasicTextMultiConfig(Config config) {
            this.basicTextMultiConfig = config;
            return this;
        }
        
        public Agent setLongTextConfig(Config config) {
            this.longTextConfig = config;
            return this;
        }
        
        public Agent setLongTextMultiConfig(Config config) {
            this.longTextMultiConfig = config;
            return this;
        }
        
        public Agent setExtractConfig(Config config) {
            this.extractConfig = config;
            return this;
        }
        
        public Agent setExtractStructuredConfig(Config config) {
            this.extractStructuredConfig = config;
            return this;
        }
        
        public String toJson() {
            Map<String, Object> agentMap = new Map<String, Object>();
            agentMap.put('type', this.agentType);
            
            if (this.basicTextConfig != null) {
                agentMap.put('basic_text', this.basicTextConfig.toMap());
            }
            if (this.basicTextMultiConfig != null) {
                agentMap.put('basic_text_multi', this.basicTextMultiConfig.toMap());
            }
            if (this.longTextConfig != null) {
                agentMap.put('long_text', this.longTextConfig.toMap());
            }
            if (this.longTextMultiConfig != null) {
                agentMap.put('long_text_multi', this.longTextMultiConfig.toMap());
            }
            if (this.extractConfig != null) {
                agentMap.put('extract', this.extractConfig.toMap());
            }
            if (this.extractStructuredConfig != null) {
                agentMap.put('extract_structured', this.extractStructuredConfig.toMap());
            }
            
            return JSON.serialize(agentMap);
        }
    }
    
    /**
     * Represents AI agent configuration.
     */
    public class Config {
        private String model;
        private Integer numTokensForCompletion;
        private Map<String, Object> llmEndpointParams;
        private String systemMessage;
        private String promptTemplate;
        
        public Config() {
            this.llmEndpointParams = new Map<String, Object>();
        }
        
        public Config setModel(String model) {
            this.model = model;
            return this;
        }
        
        public Config setNumTokensForCompletion(Integer numTokens) {
            this.numTokensForCompletion = numTokens;
            return this;
        }
        
        public Config setSystemMessage(String systemMessage) {
            this.systemMessage = systemMessage;
            return this;
        }
        
        public Config setPromptTemplate(String promptTemplate) {
            this.promptTemplate = promptTemplate;
            return this;
        }
        
        /**
         * Sets LLM endpoint parameters for OpenAI.
         *
         * @param temperature the temperature parameter.
         * @param topP the top_p parameter.
         * @param frequencyPenalty the frequency penalty.
         * @param presencePenalty the presence penalty.
         * @param stop the stop sequences.
         * @return this config for chaining.
         */
        public Config setOpenAIParams(
            Decimal temperature,
            Decimal topP,
            Decimal frequencyPenalty,
            Decimal presencePenalty,
            String stop
        ) {
            this.llmEndpointParams.put('type', 'openai_params');
            if (temperature != null) {
                this.llmEndpointParams.put('temperature', temperature);
            }
            if (topP != null) {
                this.llmEndpointParams.put('top_p', topP);
            }
            if (frequencyPenalty != null) {
                this.llmEndpointParams.put('frequency_penalty', frequencyPenalty);
            }
            if (presencePenalty != null) {
                this.llmEndpointParams.put('presence_penalty', presencePenalty);
            }
            if (stop != null) {
                this.llmEndpointParams.put('stop', stop);
            }
            return this;
        }
        
        /**
         * Sets LLM endpoint parameters for Google.
         *
         * @param temperature the temperature parameter.
         * @param topP the top_p parameter.
         * @param topK the top_k parameter.
         * @return this config for chaining.
         */
        public Config setGoogleParams(
            Decimal temperature,
            Decimal topP,
            Integer topK
        ) {
            this.llmEndpointParams.put('type', 'google_params');
            if (temperature != null) {
                this.llmEndpointParams.put('temperature', temperature);
            }
            if (topP != null) {
                this.llmEndpointParams.put('top_p', topP);
            }
            if (topK != null) {
                this.llmEndpointParams.put('top_k', topK);
            }
            return this;
        }
        
        public Map<String, Object> toMap() {
            Map<String, Object> result = new Map<String, Object>();
            
            if (this.model != null) {
                result.put('model', this.model);
            }
            if (this.numTokensForCompletion != null) {
                result.put('num_tokens_for_completion', this.numTokensForCompletion);
            }
            if (!this.llmEndpointParams.isEmpty()) {
                result.put('llm_endpoint_params', this.llmEndpointParams);
            }
            if (this.systemMessage != null) {
                result.put('system_message', this.systemMessage);
            }
            if (this.promptTemplate != null) {
                result.put('prompt_template', this.promptTemplate);
            }
            
            return result;
        }
    }
    
    /**
     * Enum for AI modes.
     */
    public enum Mode {
        SINGLE_ITEM_QA,
        MULTIPLE_ITEM_QA
    }
    
    /**
     * Gets the string representation of an AI mode.
     *
     * @param mode the AI mode.
     * @return the string representation.
     */
    public static String getModeString(Mode mode) {
        switch on mode {
            when SINGLE_ITEM_QA { return 'single_item_qa'; }
            when MULTIPLE_ITEM_QA { return 'multiple_item_qa'; }
            when else { return null; }
        }
    }
    
    /**
     * Enum for field types in structured extraction.
     */
    public enum FieldType {
        STRING_VALUE,
        DATE_VALUE,
        NUMBER_VALUE,
        ENUM_VALUE,
        MULTISELECT_VALUE
    }
    
    /**
     * Gets the string representation of a field type.
     *
     * @param fieldType the field type.
     * @return the string representation.
     */
    public static String getFieldTypeString(FieldType fieldType) {
        switch on fieldType {
            when STRING_VALUE { return 'string'; }
            when DATE_VALUE { return 'date'; }
            when NUMBER_VALUE { return 'number'; }
            when ENUM_VALUE { return 'enum'; }
            when MULTISELECT_VALUE { return 'multiselect'; }
            when else { return null; }
        }
    }
}