# Box SDK Doc Gen Implementation Summary

## Overview
This document summarizes the implementation of Box Doc Gen capabilities in the Box for Salesforce SDK, enabling automated document generation from templates.

## Implemented Classes

### 1. BoxDocGen.cls
The main class providing Box Doc Gen capabilities for document generation from templates.

#### Key Features:
- **Template Management**: Create, update, delete, and list templates
- **Document Generation**: Generate documents from templates with data
- **Field Support**: Various field types including text, date, number, boolean, list, image, and table
- **Output Formats**: Support for PDF and Word (DOCX) formats
- **Metadata & Tags**: Add metadata and tags to generated documents

#### Methods:

##### Template Operations

###### createTemplate()
```apex
BoxDocGen.Info template = BoxDocGen.createTemplate(
    api,
    'Invoice Template',
    'Template for generating invoices',
    'source_file_id',
    new List<String>{ 'invoice', 'financial' }
);
```

###### getInfo()
```apex
BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxDocGen.Info info = template.getInfo();
System.debug('Template name: ' + info.getName());
```

###### updateTemplate()
```apex
BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxDocGen.Info updated = template.updateTemplate(
    'Updated Template Name',
    'Updated description',
    new List<String>{ 'updated', 'tag' }
);
```

###### delete()
```apex
BoxDocGen template = new BoxDocGen(api, 'template_id');
template.delete();
```

###### getAllTemplates()
```apex
BoxResourceIterable<BoxDocGen.Info> templates = BoxDocGen.getAllTemplates(api, 100, null);
for (BoxDocGen.Info template : templates) {
    System.debug('Template: ' + template.getName());
}
```

##### Document Generation

###### generateDocument() - Simple
```apex
Map<String, Object> data = new Map<String, Object>();
data.put('customer_name', 'Acme Corp');
data.put('invoice_date', Date.today().format());

BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxFolder folder = new BoxFolder(api, 'folder_id');

BoxFile.Info generatedDoc = template.generateDocument(
    data,
    folder,
    'Invoice_2024_001',
    'pdf'
);
```

###### generateDocument() - Advanced
```apex
BoxDocGen.DocumentOptions options = new BoxDocGen.DocumentOptions(
    'template_id',
    'folder_id'
)
.addDataField('customer_name', 'Acme Corp')
.addDataField('invoice_date', Date.today().format())
.setFileName('Invoice_2024_001')
.setFileType('pdf')
.setTags(new List<String>{ 'invoice', 'q1-2024' });

BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxFile.Info generatedDoc = template.generateDocument(options);
```

#### Inner Classes:

##### Info
Contains template information:
- `name`: Template name
- `description`: Template description
- `status`: Template status (active, inactive, draft)
- `tags`: Associated tags
- `sourceFileId`: Source file ID
- `createdAt/modifiedAt`: Timestamps
- `createdBy/modifiedBy`: User information
- `fields`: Template fields

##### TemplateField
Represents a template field:
- `key`: Field identifier
- `displayName`: Display name
- `fieldType`: Type (text, date, number, etc.)
- `description`: Field description
- `required`: Whether field is required
- `defaultValue`: Default value
- `options`: Options for list fields

##### DocumentOptions
Builder for document generation options:
```apex
BoxDocGen.DocumentOptions options = new BoxDocGen.DocumentOptions(templateId, folderId)
    .setDocumentData(dataMap)
    .setFileName('MyDocument')
    .setFileType('pdf')
    .setMetadata(metadataMap)
    .setTags(tagsList)
    .setIsTest(false);
```

### 2. BoxDocGenUtils.cls
Utility class providing helper methods for Box Doc Gen operations.

#### Key Features:
- Simplified document generation methods
- Salesforce record integration
- Pre-built document type generators (invoices, contracts)
- Template validation utilities

#### Helper Methods:

##### Simple Generation
```apex
// Generate simple document
BoxFile.Info doc = BoxDocGenUtils.generateSimpleDocument(
    api,
    'template_id',
    dataMap,
    'folder_id'
);

// Generate PDF
BoxFile.Info pdf = BoxDocGenUtils.generatePDF(
    api,
    'template_id',
    dataMap,
    'folder_id',
    'MyDocument'
);

// Generate Word document
BoxFile.Info word = BoxDocGenUtils.generateWord(
    api,
    'template_id',
    dataMap,
    'folder_id',
    'MyDocument'
);
```

##### Salesforce Integration
```apex
// Build data from Salesforce record
Account acc = [SELECT Name, BillingStreet, Phone FROM Account LIMIT 1];
Map<String, String> fieldMapping = new Map<String, String>{
    'company_name' => 'Name',
    'address' => 'BillingStreet',
    'phone' => 'Phone'
};

Map<String, Object> data = BoxDocGenUtils.buildDataFromRecord(acc, fieldMapping);
```

##### Invoice Generation
```apex
// Create invoice data
BoxDocGenUtils.InvoiceData invoice = new BoxDocGenUtils.InvoiceData();
invoice.invoiceNumber = 'INV-2024-001';
invoice.invoiceDate = Date.today();
invoice.dueDate = Date.today().addDays(30);
invoice.customerName = 'Acme Corp';
invoice.customerAddress = '123 Main St, City, State 12345';
invoice.taxRate = 8.5;

// Add items
invoice.addItem('Product A', 10, 99.99);
invoice.addItem('Product B', 5, 149.99);
invoice.addItem('Service C', 1, 500.00);

// Generate invoice
BoxFile.Info invoiceDoc = BoxDocGenUtils.generateInvoice(
    api,
    'invoice_template_id',
    invoice,
    'folder_id'
);
```

##### Template Management
```apex
// Create template from file
BoxDocGen.Info template = BoxDocGenUtils.createTemplateFromFile(
    api,
    'source_file_id',
    'My Template',
    'Template for generating documents'
);

// Find templates by tag
List<BoxDocGen.Info> invoiceTemplates = BoxDocGenUtils.findTemplatesByTag(
    api,
    'invoice'
);

// Validate template data
BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxDocGen.Info info = template.getInfo();
Map<String, Object> data = new Map<String, Object>();
data.put('customer_name', 'Acme Corp');

List<String> missingFields = BoxDocGenUtils.validateTemplateData(info, data);
if (!missingFields.isEmpty()) {
    System.debug('Missing required fields: ' + String.join(missingFields, ', '));
}
```

## Usage Examples

### 1. Basic Document Generation
```apex
// Create API connection
BoxApiConnection api = new BoxApiConnection('YOUR_ACCESS_TOKEN');

// Prepare document data
Map<String, Object> data = new Map<String, Object>();
data.put('recipient_name', 'John Doe');
data.put('date', Date.today().format());
data.put('amount', 1500.00);

// Generate document
BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxFolder destinationFolder = new BoxFolder(api, 'folder_id');

BoxFile.Info generatedDoc = template.generateDocument(
    data,
    destinationFolder,
    'Agreement_JohnDoe',
    'pdf'
);

System.debug('Generated document ID: ' + generatedDoc.getID());
```

### 2. Advanced Document Generation with Options
```apex
// Create document options with all features
BoxDocGen.DocumentOptions options = new BoxDocGen.DocumentOptions(
    'template_id',
    'folder_id'
);

// Add document data
options.addDataField('company_name', 'Acme Corporation')
       .addDataField('contract_date', Date.today().format())
       .addDataField('contract_value', 50000)
       .addDataField('payment_terms', '30 days')
       .addDataField('services', new List<String>{ 'Consulting', 'Support' });

// Set file options
options.setFileName('Contract_Acme_2024')
       .setFileType(BoxDocGen.getFileTypeString(BoxDocGen.FileType.PDF));

// Add metadata
Map<String, Object> metadata = new Map<String, Object>();
metadata.put('contract_type', 'service_agreement');
metadata.put('department', 'sales');
options.setMetadata(metadata);

// Add tags
options.setTags(new List<String>{ 'contract', 'sales', 'q1-2024' });

// Generate document
BoxDocGen template = new BoxDocGen(api, 'template_id');
BoxFile.Info generatedDoc = template.generateDocument(options);
```

### 3. Generate from Salesforce Records
```apex
// Query Opportunity and related data
Opportunity opp = [
    SELECT Id, Name, Amount, CloseDate, Account.Name, Account.BillingAddress
    FROM Opportunity
    WHERE Id = :opportunityId
];

// Create field mapping
Map<String, String> fieldMapping = new Map<String, String>{
    'opportunity_name' => 'Name',
    'amount' => 'Amount',
    'close_date' => 'CloseDate',
    'account_name' => 'Account.Name'
};

// Build document data
Map<String, Object> data = BoxDocGenUtils.buildDataFromRecord(opp, fieldMapping);

// Add additional calculated fields
data.put('generated_date', Date.today().format());
data.put('valid_until', Date.today().addDays(30).format());

// Generate proposal document
BoxFile.Info proposal = BoxDocGenUtils.generatePDF(
    api,
    'proposal_template_id',
    data,
    'proposals_folder_id',
    'Proposal_' + opp.Account.Name.replaceAll(' ', '_')
);
```

### 4. Batch Document Generation
```apex
// Generate multiple invoices
List<Invoice__c> invoices = [
    SELECT Id, Invoice_Number__c, Customer_Name__c, Amount__c, Due_Date__c
    FROM Invoice__c
    WHERE Status__c = 'Pending'
    LIMIT 10
];

for (Invoice__c inv : invoices) {
    // Create invoice data
    BoxDocGenUtils.InvoiceData invoiceData = new BoxDocGenUtils.InvoiceData();
    invoiceData.invoiceNumber = inv.Invoice_Number__c;
    invoiceData.invoiceDate = Date.today();
    invoiceData.dueDate = inv.Due_Date__c;
    invoiceData.customerName = inv.Customer_Name__c;
    
    // Generate invoice document
    try {
        BoxFile.Info doc = BoxDocGenUtils.generateInvoice(
            api,
            'invoice_template_id',
            invoiceData,
            'invoices_folder_id'
        );
        
        // Update invoice record with document ID
        inv.Box_Document_Id__c = doc.getID();
        inv.Status__c = 'Generated';
    } catch (Exception e) {
        System.debug('Error generating invoice: ' + e.getMessage());
    }
}

update invoices;
```

### 5. Template Management
```apex
// Create a new template
BoxFile templateFile = new BoxFile(api, 'template_file_id');
BoxDocGen.Info newTemplate = BoxDocGen.createTemplate(
    api,
    'Customer Agreement Template',
    'Template for generating customer agreements',
    templateFile.getId(),
    new List<String>{ 'agreement', 'customer', 'legal' }
);

// List all templates with specific tag
List<BoxDocGen.Info> legalTemplates = BoxDocGenUtils.findTemplatesByTag(
    api,
    'legal'
);

for (BoxDocGen.Info template : legalTemplates) {
    System.debug('Template: ' + template.getName());
    
    // Display template fields
    if (template.getFields() != null) {
        for (BoxDocGen.TemplateField field : template.getFields()) {
            System.debug('  Field: ' + field.getKey() + 
                        ' (' + field.getFieldType() + ')' +
                        (field.isRequired() ? ' *required' : ''));
        }
    }
}
```

## Field Types

### Supported Field Types
1. **TEXT** - Single line or multi-line text
2. **DATE** - Date values (formatted automatically)
3. **NUMBER** - Numeric values (integer or decimal)
4. **BOOLEAN** - True/false values
5. **LIST** - Array of values
6. **IMAGE** - Image placeholders
7. **TABLE** - Tabular data

### Field Type Examples
```apex
Map<String, Object> data = new Map<String, Object>();

// Text field
data.put('customer_name', 'Acme Corporation');

// Date field
data.put('contract_date', Date.today().format());

// Number field
data.put('amount', 15000.50);

// Boolean field
data.put('is_recurring', true);

// List field
data.put('services', new List<String>{ 'Consulting', 'Support', 'Training' });

// Table field
List<Map<String, Object>> items = new List<Map<String, Object>>();
items.add(new Map<String, Object>{
    'description' => 'Product A',
    'quantity' => 10,
    'price' => 99.99
});
items.add(new Map<String, Object>{
    'description' => 'Product B',
    'quantity' => 5,
    'price' => 149.99
});
data.put('line_items', items);
```

## Best Practices

### 1. Template Design
- Use clear, descriptive field names
- Mark required fields appropriately
- Provide default values where applicable
- Use consistent naming conventions

### 2. Data Validation
```apex
// Always validate data before generation
BoxDocGen template = new BoxDocGen(api, templateId);
BoxDocGen.Info info = template.getInfo();

List<String> missingFields = BoxDocGenUtils.validateTemplateData(info, data);
if (!missingFields.isEmpty()) {
    throw new BoxDocGenException('Missing required fields: ' + 
                                 String.join(missingFields, ', '));
}
```

### 3. Error Handling
```apex
try {
    BoxFile.Info doc = template.generateDocument(options);
    // Process successful generation
} catch (BoxApiConnectionException e) {
    System.debug('API Error: ' + e.getMessage());
    // Handle API errors
} catch (Exception e) {
    System.debug('Unexpected error: ' + e.getMessage());
    // Handle other errors
}
```

### 4. Performance Optimization
- Cache template information when generating multiple documents
- Use batch processing for large volumes
- Consider asynchronous processing for heavy workloads

### 5. Security Considerations
- Validate user permissions before generation
- Sanitize user input data
- Use appropriate folder permissions
- Consider encryption for sensitive documents

## Integration Patterns

### 1. Trigger-Based Generation
```apex
trigger OpportunityClosedWon on Opportunity (after update) {
    List<Opportunity> wonOpps = new List<Opportunity>();
    
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Closed Won' && 
            Trigger.oldMap.get(opp.Id).StageName != 'Closed Won') {
            wonOpps.add(opp);
        }
    }
    
    if (!wonOpps.isEmpty()) {
        BoxDocGenService.generateContracts(wonOpps);
    }
}
```

### 2. Scheduled Generation
```apex
public class ScheduledInvoiceGenerator implements Schedulable {
    public void execute(SchedulableContext ctx) {
        // Query invoices to generate
        List<Invoice__c> invoices = [
            SELECT Id, Customer__c, Amount__c
            FROM Invoice__c
            WHERE Status__c = 'Pending'
            AND Generation_Date__c = TODAY
        ];
        
        // Generate documents
        BoxDocGenService.generateInvoices(invoices);
    }
}
```

### 3. On-Demand Generation
```apex
@AuraEnabled
public static String generateDocument(Id recordId, String templateId) {
    try {
        // Get record data
        SObject record = getRecord(recordId);
        
        // Generate document
        BoxApiConnection api = BoxUtils.getConnection();
        Map<String, Object> data = buildDataFromRecord(record);
        
        BoxFile.Info doc = BoxDocGenUtils.generatePDF(
            api,
            templateId,
            data,
            getFolderId(recordId),
            getFileName(record)
        );
        
        return doc.getID();
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
```

## Limitations and Considerations

1. **Template Complexity**: Complex templates may take longer to process
2. **File Size**: Generated documents have size limitations
3. **API Rate Limits**: Consider Box API rate limits for bulk generation
4. **Supported Formats**: Currently supports PDF and DOCX output
5. **Field Limitations**: Some complex field types may have limitations

## Conclusion

The Box Doc Gen implementation provides powerful document generation capabilities within Salesforce, enabling automated creation of professional documents from templates. It seamlessly integrates with Salesforce data and workflows, supporting various use cases from simple document generation to complex batch processing scenarios.