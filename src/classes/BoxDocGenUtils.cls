/**
 * Utility class for Box Doc Gen operations.
 */
public class BoxDocGenUtils {
    
    /**
     * Creates a simple document from a template.
     *
     * @param api the API connection.
     * @param templateId the template ID.
     * @param data the document data.
     * @param destinationFolderId the destination folder ID.
     * @return the generated file information.
     */
    public static BoxFile.Info generateSimpleDocument(
        BoxApiConnection api,
        String templateId,
        Map<String, Object> data,
        String destinationFolderId
    ) {
        BoxDocGen template = new BoxDocGen(api, templateId);
        BoxFolder destinationFolder = new BoxFolder(api, destinationFolderId);
        
        return template.generateDocument(data, destinationFolder, null, null);
    }
    
    /**
     * Creates a PDF document from a template.
     *
     * @param api the API connection.
     * @param templateId the template ID.
     * @param data the document data.
     * @param destinationFolderId the destination folder ID.
     * @param fileName the output file name.
     * @return the generated file information.
     */
    public static BoxFile.Info generatePDF(
        BoxApiConnection api,
        String templateId,
        Map<String, Object> data,
        String destinationFolderId,
        String fileName
    ) {
        BoxDocGen template = new BoxDocGen(api, templateId);
        BoxFolder destinationFolder = new BoxFolder(api, destinationFolderId);
        
        return template.generateDocument(
            data,
            destinationFolder,
            fileName,
            BoxDocGen.getFileTypeString(BoxDocGen.FileType.PDF)
        );
    }
    
    /**
     * Creates a Word document from a template.
     *
     * @param api the API connection.
     * @param templateId the template ID.
     * @param data the document data.
     * @param destinationFolderId the destination folder ID.
     * @param fileName the output file name.
     * @return the generated file information.
     */
    public static BoxFile.Info generateWord(
        BoxApiConnection api,
        String templateId,
        Map<String, Object> data,
        String destinationFolderId,
        String fileName
    ) {
        BoxDocGen template = new BoxDocGen(api, templateId);
        BoxFolder destinationFolder = new BoxFolder(api, destinationFolderId);
        
        return template.generateDocument(
            data,
            destinationFolder,
            fileName,
            BoxDocGen.getFileTypeString(BoxDocGen.FileType.DOCX)
        );
    }
    
    /**
     * Creates a document with advanced options.
     *
     * @param api the API connection.
     * @param templateId the template ID.
     * @param destinationFolderId the destination folder ID.
     * @return the document options builder.
     */
    public static BoxDocGen.DocumentOptions createDocumentOptions(
        String templateId,
        String destinationFolderId
    ) {
        return new BoxDocGen.DocumentOptions(templateId, destinationFolderId);
    }
    
    /**
     * Builds document data from Salesforce records.
     *
     * @param record the Salesforce record.
     * @param fieldMapping map of template fields to record fields.
     * @return the document data map.
     */
    public static Map<String, Object> buildDataFromRecord(
        SObject record,
        Map<String, String> fieldMapping
    ) {
        Map<String, Object> data = new Map<String, Object>();
        
        for (String templateField : fieldMapping.keySet()) {
            String recordField = fieldMapping.get(templateField);
            Object value = record.get(recordField);
            
            // Convert dates to string format
            if (value instanceof Date) {
                Date dateValue = (Date) value;
                value = dateValue.format();
            } else if (value instanceof DateTime) {
                DateTime dateTimeValue = (DateTime) value;
                value = dateTimeValue.format();
            }
            
            data.put(templateField, value);
        }
        
        return data;
    }
    
    /**
     * Generates an invoice document.
     *
     * @param api the API connection.
     * @param templateId the invoice template ID.
     * @param invoiceData the invoice data.
     * @param destinationFolderId the destination folder ID.
     * @return the generated invoice file.
     */
    public static BoxFile.Info generateInvoice(
        BoxApiConnection api,
        String templateId,
        InvoiceData invoiceData,
        String destinationFolderId
    ) {
        // Build document data
        Map<String, Object> data = new Map<String, Object>();
        data.put('invoice_number', invoiceData.invoiceNumber);
        data.put('invoice_date', invoiceData.invoiceDate.format());
        data.put('due_date', invoiceData.dueDate.format());
        data.put('customer_name', invoiceData.customerName);
        data.put('customer_address', invoiceData.customerAddress);
        data.put('items', invoiceData.getItemsData());
        data.put('subtotal', invoiceData.getSubtotal());
        data.put('tax_rate', invoiceData.taxRate);
        data.put('tax_amount', invoiceData.getTaxAmount());
        data.put('total', invoiceData.getTotal());
        
        // Generate with custom filename
        String fileName = 'Invoice_' + invoiceData.invoiceNumber + '_' + 
                         invoiceData.customerName.replaceAll(' ', '_');
        
        BoxDocGen.DocumentOptions options = new BoxDocGen.DocumentOptions(
            templateId,
            destinationFolderId
        )
        .setDocumentData(data)
        .setFileName(fileName)
        .setFileType(BoxDocGen.getFileTypeString(BoxDocGen.FileType.PDF))
        .setTags(new List<String>{ 'invoice', 'financial', invoiceData.customerName });
        
        BoxDocGen template = new BoxDocGen(api, templateId);
        return template.generateDocument(options);
    }
    
    /**
     * Generates a contract document.
     *
     * @param api the API connection.
     * @param templateId the contract template ID.
     * @param contractData the contract data.
     * @param destinationFolderId the destination folder ID.
     * @return the generated contract file.
     */
    public static BoxFile.Info generateContract(
        BoxApiConnection api,
        String templateId,
        Map<String, Object> contractData,
        String destinationFolderId
    ) {
        // Add standard contract fields if not present
        if (!contractData.containsKey('date_generated')) {
            contractData.put('date_generated', Date.today().format());
        }
        
        BoxDocGen.DocumentOptions options = new BoxDocGen.DocumentOptions(
            templateId,
            destinationFolderId
        )
        .setDocumentData(contractData)
        .setFileType(BoxDocGen.getFileTypeString(BoxDocGen.FileType.PDF))
        .setTags(new List<String>{ 'contract', 'legal' });
        
        BoxDocGen template = new BoxDocGen(api, templateId);
        return template.generateDocument(options);
    }
    
    /**
     * Creates a template from a Box file.
     *
     * @param api the API connection.
     * @param sourceFileId the source file ID.
     * @param templateName the template name.
     * @param description the template description.
     * @return the created template information.
     */
    public static BoxDocGen.Info createTemplateFromFile(
        BoxApiConnection api,
        String sourceFileId,
        String templateName,
        String description
    ) {
        return BoxDocGen.createTemplate(
            api,
            templateName,
            description,
            sourceFileId,
            null
        );
    }
    
    /**
     * Finds templates by tag.
     *
     * @param api the API connection.
     * @param tag the tag to search for.
     * @return list of matching templates.
     */
    public static List<BoxDocGen.Info> findTemplatesByTag(
        BoxApiConnection api,
        String tag
    ) {
        List<BoxDocGen.Info> matchingTemplates = new List<BoxDocGen.Info>();
        
        BoxResourceIterable<BoxDocGen.Info> templates = BoxDocGen.getAllTemplates(api, 100, null);
        for (BoxDocGen.Info template : templates) {
            if (template.getTags() != null && template.getTags().contains(tag)) {
                matchingTemplates.add(template);
            }
        }
        
        return matchingTemplates;
    }
    
    /**
     * Validates template data against required fields.
     *
     * @param template the template info.
     * @param data the document data.
     * @return list of missing required fields.
     */
    public static List<String> validateTemplateData(
        BoxDocGen.Info template,
        Map<String, Object> data
    ) {
        List<String> missingFields = new List<String>();
        
        if (template.getFields() != null) {
            for (BoxDocGen.TemplateField field : template.getFields()) {
                if (field.isRequired() && !data.containsKey(field.getKey())) {
                    missingFields.add(field.getKey());
                }
            }
        }
        
        return missingFields;
    }
    
    /**
     * Helper class for invoice data.
     */
    public class InvoiceData {
        public String invoiceNumber;
        public Date invoiceDate;
        public Date dueDate;
        public String customerName;
        public String customerAddress;
        public Decimal taxRate;
        public List<InvoiceItem> items;
        
        public InvoiceData() {
            this.items = new List<InvoiceItem>();
            this.taxRate = 0.0;
        }
        
        public void addItem(String description, Decimal quantity, Decimal unitPrice) {
            this.items.add(new InvoiceItem(description, quantity, unitPrice));
        }
        
        public Decimal getSubtotal() {
            Decimal subtotal = 0;
            for (InvoiceItem item : this.items) {
                subtotal += item.getTotal();
            }
            return subtotal;
        }
        
        public Decimal getTaxAmount() {
            return this.getSubtotal() * (this.taxRate / 100);
        }
        
        public Decimal getTotal() {
            return this.getSubtotal() + this.getTaxAmount();
        }
        
        public List<Map<String, Object>> getItemsData() {
            List<Map<String, Object>> itemsData = new List<Map<String, Object>>();
            for (InvoiceItem item : this.items) {
                itemsData.add(item.toMap());
            }
            return itemsData;
        }
    }
    
    /**
     * Helper class for invoice items.
     */
    public class InvoiceItem {
        public String description;
        public Decimal quantity;
        public Decimal unitPrice;
        
        public InvoiceItem(String description, Decimal quantity, Decimal unitPrice) {
            this.description = description;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
        }
        
        public Decimal getTotal() {
            return this.quantity * this.unitPrice;
        }
        
        public Map<String, Object> toMap() {
            Map<String, Object> data = new Map<String, Object>();
            data.put('description', this.description);
            data.put('quantity', this.quantity);
            data.put('unit_price', this.unitPrice);
            data.put('total', this.getTotal());
            return data;
        }
    }
}