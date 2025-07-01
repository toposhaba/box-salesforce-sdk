/**
 * Utility class for Box AI operations.
 */
public class BoxAIUtils {
    
    /**
     * Creates a simple AI item from a Box file.
     *
     * @param file the Box file.
     * @return the AI item.
     */
    public static BoxAI.Item createItemFromFile(BoxFile file) {
        return new BoxAI.Item(file.getId(), 'file');
    }
    
    /**
     * Creates a simple AI item from a Box folder.
     *
     * @param folder the Box folder.
     * @return the AI item.
     */
    public static BoxAI.Item createItemFromFolder(BoxFolder folder) {
        return new BoxAI.Item(folder.getId(), 'folder');
    }
    
    /**
     * Creates an AI item with content.
     *
     * @param id the item ID.
     * @param itemType the item type.
     * @param content the content.
     * @return the AI item.
     */
    public static BoxAI.Item createItemWithContent(String id, String itemType, String content) {
        return new BoxAI.Item(id, itemType, content);
    }
    
    /**
     * Creates a default AI agent for question answering.
     *
     * @return the AI agent.
     */
    public static BoxAI.Agent createDefaultQAAgent() {
        BoxAI.Agent agent = new BoxAI.Agent('ai_agent_ask');
        
        // Configure basic text model
        BoxAI.Config basicConfig = new BoxAI.Config()
            .setModel('openai__gpt_3_5_turbo')
            .setNumTokensForCompletion(500)
            .setOpenAIParams(0.7, 1.0, null, null, null);
        
        agent.setBasicTextConfig(basicConfig);
        
        return agent;
    }
    
    /**
     * Creates a default AI agent for text generation.
     *
     * @return the AI agent.
     */
    public static BoxAI.Agent createDefaultTextGenAgent() {
        BoxAI.Agent agent = new BoxAI.Agent('ai_agent_text_gen');
        
        // Configure long text model
        BoxAI.Config longTextConfig = new BoxAI.Config()
            .setModel('openai__gpt_3_5_turbo_16k')
            .setNumTokensForCompletion(2000)
            .setOpenAIParams(0.7, 1.0, null, null, null);
        
        agent.setLongTextConfig(longTextConfig);
        
        return agent;
    }
    
    /**
     * Creates a default AI agent for extraction.
     *
     * @return the AI agent.
     */
    public static BoxAI.Agent createDefaultExtractionAgent() {
        BoxAI.Agent agent = new BoxAI.Agent('ai_agent_extract');
        
        // Configure extract model
        BoxAI.Config extractConfig = new BoxAI.Config()
            .setModel('openai__gpt_3_5_turbo')
            .setNumTokensForCompletion(1000)
            .setOpenAIParams(0.0, 1.0, null, null, null); // Lower temperature for extraction
        
        agent.setExtractConfig(extractConfig);
        
        return agent;
    }
    
    /**
     * Creates a custom AI agent with specific configurations.
     *
     * @param agentType the agent type.
     * @param model the model to use.
     * @param temperature the temperature parameter.
     * @param maxTokens the maximum tokens for completion.
     * @return the AI agent.
     */
    public static BoxAI.Agent createCustomAgent(
        String agentType,
        String model,
        Decimal temperature,
        Integer maxTokens
    ) {
        BoxAI.Agent agent = new BoxAI.Agent(agentType);
        
        BoxAI.Config config = new BoxAI.Config()
            .setModel(model)
            .setNumTokensForCompletion(maxTokens)
            .setOpenAIParams(temperature, 1.0, null, null, null);
        
        // Apply config to all relevant agent types
        if (agentType == 'ai_agent_ask') {
            agent.setBasicTextConfig(config);
            agent.setBasicTextMultiConfig(config);
        } else if (agentType == 'ai_agent_text_gen') {
            agent.setLongTextConfig(config);
            agent.setLongTextMultiConfig(config);
        } else if (agentType == 'ai_agent_extract') {
            agent.setExtractConfig(config);
            agent.setExtractStructuredConfig(config);
        }
        
        return agent;
    }
    
    /**
     * Creates an extraction field for structured data extraction.
     *
     * @param key the field key.
     * @param fieldType the field type.
     * @param description the field description.
     * @return the extraction field.
     */
    public static BoxAI.ExtractField createExtractionField(
        String key,
        BoxAI.FieldType fieldType,
        String description
    ) {
        return new BoxAI.ExtractField(key)
            .setType(BoxAI.getFieldTypeString(fieldType))
            .setDescription(description)
            .setDisplayName(key);
    }
    
    /**
     * Creates an extraction field with options for enum/multiselect types.
     *
     * @param key the field key.
     * @param fieldType the field type.
     * @param description the field description.
     * @param options list of option keys.
     * @return the extraction field.
     */
    public static BoxAI.ExtractField createExtractionFieldWithOptions(
        String key,
        BoxAI.FieldType fieldType,
        String description,
        List<String> options
    ) {
        BoxAI.ExtractField field = createExtractionField(key, fieldType, description);
        
        List<BoxAI.ExtractFieldOption> fieldOptions = new List<BoxAI.ExtractFieldOption>();
        for (String option : options) {
            fieldOptions.add(new BoxAI.ExtractFieldOption(option));
        }
        field.setOptions(fieldOptions);
        
        return field;
    }
    
    /**
     * Creates a dialogue entry for conversation history.
     *
     * @param prompt the user prompt.
     * @param answer the AI answer.
     * @return the dialogue entry.
     */
    public static BoxAI.DialogueEntry createDialogueEntry(String prompt, String answer) {
        return new BoxAI.DialogueEntry(prompt, answer);
    }
    
    /**
     * Example: Ask a question about a file.
     *
     * @param api the API connection.
     * @param fileId the file ID.
     * @param question the question to ask.
     * @return the AI response.
     */
    public static BoxAI.Response askAboutFile(
        BoxApiConnection api,
        String fileId,
        String question
    ) {
        // Create item from file
        BoxFile file = new BoxFile(api, fileId);
        BoxAI.Item item = createItemFromFile(file);
        
        // Create default QA agent
        BoxAI.Agent agent = createDefaultQAAgent();
        
        // Ask the question
        return BoxAI.ask(
            api,
            question,
            new List<BoxAI.Item>{ item },
            BoxAI.getModeString(BoxAI.Mode.SINGLE_ITEM_QA),
            agent
        );
    }
    
    /**
     * Example: Extract invoice data from a file.
     *
     * @param api the API connection.
     * @param fileId the file ID.
     * @return the structured extraction response.
     */
    public static BoxAI.StructuredResponse extractInvoiceData(
        BoxApiConnection api,
        String fileId
    ) {
        // Create item from file
        BoxFile file = new BoxFile(api, fileId);
        BoxAI.Item item = createItemFromFile(file);
        
        // Define extraction fields
        List<BoxAI.ExtractField> fields = new List<BoxAI.ExtractField>{
            createExtractionField('invoice_number', BoxAI.FieldType.STRING_VALUE, 'The invoice number'),
            createExtractionField('invoice_date', BoxAI.FieldType.DATE_VALUE, 'The invoice date'),
            createExtractionField('total_amount', BoxAI.FieldType.NUMBER_VALUE, 'The total amount'),
            createExtractionField('vendor_name', BoxAI.FieldType.STRING_VALUE, 'The vendor or company name'),
            createExtractionField('due_date', BoxAI.FieldType.DATE_VALUE, 'The payment due date'),
            createExtractionFieldWithOptions(
                'status',
                BoxAI.FieldType.ENUM_VALUE,
                'The invoice status',
                new List<String>{ 'paid', 'unpaid', 'overdue', 'pending' }
            )
        };
        
        // Create extraction agent
        BoxAI.Agent agent = createDefaultExtractionAgent();
        
        // Extract structured data
        return BoxAI.extractStructured(
            api,
            new List<BoxAI.Item>{ item },
            fields,
            agent
        );
    }
}