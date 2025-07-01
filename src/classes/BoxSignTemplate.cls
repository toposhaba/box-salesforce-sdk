/**
 * Represents a Box Sign Template.
 */
public class BoxSignTemplate extends BoxResource {
    private static String SIGN_TEMPLATES_URL = 'sign_templates';
    private static String SIGN_TEMPLATE_URL = 'sign_templates/{0}';
    
    /**
     * Constructs a BoxSignTemplate with a given ID.
     *
     * @param api the API connection to use.
     * @param id the ID of the sign template.
     */
    public BoxSignTemplate(BoxApiConnection api, String id) {
        super(api, id);
    }
    
    /**
     * Gets information about this sign template.
     *
     * @return the sign template information.
     */
    public BoxSignTemplate.Info getInfo() {
        String url = this.api.baseUrl + String.format(SIGN_TEMPLATE_URL, new String[] { this.id });
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxSignTemplate.getInfo');
        
        return new BoxSignTemplate.Info(responseBody);
    }
    
    /**
     * Lists all sign templates.
     *
     * @param api the API connection to use.
     * @param limit the maximum number of items to return.
     * @param marker the position marker for pagination.
     * @return an iterable collection of sign templates.
     */
    public static BoxResourceIterable<BoxSignTemplate.Info> getAll(
        BoxApiConnection api,
        Integer limit,
        String marker
    ) {
        String url = api.baseUrl + SIGN_TEMPLATES_URL;
        
        if (limit != null || marker != null) {
            url += '?';
            if (limit != null) {
                url += 'limit=' + limit;
                if (marker != null) {
                    url += '&';
                }
            }
            if (marker != null) {
                url += 'marker=' + marker;
            }
        }
        
        return new BoxResourceIterable<BoxSignTemplate.Info>(
            api,
            url,
            new BoxSignTemplate.InfoPagedCollection(api, url)
        );
    }
    
    /**
     * Contains information about a Box Sign Template.
     */
    public class Info extends BoxResource.Info {
        private String type;
        private String name;
        private String emailSubject;
        private String emailMessage;
        private Integer daysValid;
        private BoxFolder.Info parentFolder;
        private List<BoxFile.Info> sourceFiles;
        private Boolean areFieldsLocked;
        private Boolean areOptionsLocked;
        private Boolean areRecipientsLocked;
        private Boolean areEmailSettingsLocked;
        private Boolean areFilesLocked;
        private List<Signer> signers;
        private List<ReadySignLink> readySignLinks;
        private CustomBranding customBranding;
        
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
            if (jsonObject.getValue('email_subject') != null) {
                this.emailSubject = jsonObject.getValue('email_subject');
            }
            if (jsonObject.getValue('email_message') != null) {
                this.emailMessage = jsonObject.getValue('email_message');
            }
            if (jsonObject.getValue('days_valid') != null) {
                this.daysValid = Integer.valueOf(jsonObject.getValue('days_valid'));
            }
            if (jsonObject.getValue('are_fields_locked') != null) {
                this.areFieldsLocked = Boolean.valueOf(jsonObject.getValue('are_fields_locked'));
            }
            if (jsonObject.getValue('are_options_locked') != null) {
                this.areOptionsLocked = Boolean.valueOf(jsonObject.getValue('are_options_locked'));
            }
            if (jsonObject.getValue('are_recipients_locked') != null) {
                this.areRecipientsLocked = Boolean.valueOf(jsonObject.getValue('are_recipients_locked'));
            }
            if (jsonObject.getValue('are_email_settings_locked') != null) {
                this.areEmailSettingsLocked = Boolean.valueOf(jsonObject.getValue('are_email_settings_locked'));
            }
            if (jsonObject.getValue('are_files_locked') != null) {
                this.areFilesLocked = Boolean.valueOf(jsonObject.getValue('are_files_locked'));
            }
            
            // Parse parent folder
            if (jsonObject.children.get('parent_folder') != null) {
                BoxGenericJsonObject folderObject = jsonObject.children.get('parent_folder');
                this.parentFolder = new BoxFolder.Info(folderObject.getJsonString());
            }
            
            // Parse source files
            if (jsonObject.children.get('source_files') != null) {
                this.sourceFiles = new List<BoxFile.Info>();
                BoxJsonObject filesArray = jsonObject.children.get('source_files');
                if (filesArray.children != null) {
                    for (BoxJsonObject fileObject : filesArray.children.values()) {
                        this.sourceFiles.add(new BoxFile.Info(fileObject.getJsonString()));
                    }
                }
            }
            
            // Parse signers
            if (jsonObject.children.get('signers') != null) {
                this.signers = new List<Signer>();
                BoxJsonObject signersArray = jsonObject.children.get('signers');
                if (signersArray.children != null) {
                    for (BoxJsonObject signerObject : signersArray.children.values()) {
                        this.signers.add(new Signer(signerObject));
                    }
                }
            }
            
            // Parse ready sign links
            if (jsonObject.children.get('ready_sign_links') != null) {
                this.readySignLinks = new List<ReadySignLink>();
                BoxJsonObject linksArray = jsonObject.children.get('ready_sign_links');
                if (linksArray.children != null) {
                    for (BoxJsonObject linkObject : linksArray.children.values()) {
                        this.readySignLinks.add(new ReadySignLink(linkObject));
                    }
                }
            }
            
            // Parse custom branding
            if (jsonObject.children.get('custom_branding') != null) {
                BoxJsonObject brandingObject = jsonObject.children.get('custom_branding');
                this.customBranding = new CustomBranding(brandingObject);
            }
        }
        
        public String getType() {
            return this.type;
        }
        
        public String getName() {
            return this.name;
        }
        
        public String getEmailSubject() {
            return this.emailSubject;
        }
        
        public String getEmailMessage() {
            return this.emailMessage;
        }
        
        public Integer getDaysValid() {
            return this.daysValid;
        }
        
        public BoxFolder.Info getParentFolder() {
            return this.parentFolder;
        }
        
        public List<BoxFile.Info> getSourceFiles() {
            return this.sourceFiles;
        }
        
        public Boolean getAreFieldsLocked() {
            return this.areFieldsLocked;
        }
        
        public Boolean getAreOptionsLocked() {
            return this.areOptionsLocked;
        }
        
        public Boolean getAreRecipientsLocked() {
            return this.areRecipientsLocked;
        }
        
        public Boolean getAreEmailSettingsLocked() {
            return this.areEmailSettingsLocked;
        }
        
        public Boolean getAreFilesLocked() {
            return this.areFilesLocked;
        }
        
        public List<Signer> getSigners() {
            return this.signers;
        }
        
        public List<ReadySignLink> getReadySignLinks() {
            return this.readySignLinks;
        }
        
        public CustomBranding getCustomBranding() {
            return this.customBranding;
        }
    }
    
    /**
     * Represents a signer in a sign template.
     */
    public class Signer {
        private String email;
        private String role;
        private Boolean isInPerson;
        private Integer order;
        private List<SignerInput> inputs;
        
        public Signer(BoxJsonObject jsonObject) {
            if (jsonObject.getValue('email') != null) {
                this.email = jsonObject.getValue('email');
            }
            if (jsonObject.getValue('role') != null) {
                this.role = jsonObject.getValue('role');
            }
            if (jsonObject.getValue('is_in_person') != null) {
                this.isInPerson = Boolean.valueOf(jsonObject.getValue('is_in_person'));
            }
            if (jsonObject.getValue('order') != null) {
                this.order = Integer.valueOf(jsonObject.getValue('order'));
            }
            
            // Parse inputs
            if (jsonObject.children.get('inputs') != null) {
                this.inputs = new List<SignerInput>();
                BoxJsonObject inputsArray = jsonObject.children.get('inputs');
                if (inputsArray.children != null) {
                    for (BoxJsonObject inputObject : inputsArray.children.values()) {
                        this.inputs.add(new SignerInput(inputObject));
                    }
                }
            }
        }
        
        public String getEmail() {
            return this.email;
        }
        
        public String getRole() {
            return this.role;
        }
        
        public Boolean getIsInPerson() {
            return this.isInPerson;
        }
        
        public Integer getOrder() {
            return this.order;
        }
        
        public List<SignerInput> getInputs() {
            return this.inputs;
        }
    }
    
    /**
     * Represents an input field for a signer.
     */
    public class SignerInput {
        private String type;
        private String contentType;
        private Boolean isRequired;
        private Integer pageIndex;
        private String documentId;
        private Coordinates coordinates;
        private Dimensions dimensions;
        private String label;
        private String readOnly;
        
        public SignerInput(BoxJsonObject jsonObject) {
            if (jsonObject.getValue('type') != null) {
                this.type = jsonObject.getValue('type');
            }
            if (jsonObject.getValue('content_type') != null) {
                this.contentType = jsonObject.getValue('content_type');
            }
            if (jsonObject.getValue('is_required') != null) {
                this.isRequired = Boolean.valueOf(jsonObject.getValue('is_required'));
            }
            if (jsonObject.getValue('page_index') != null) {
                this.pageIndex = Integer.valueOf(jsonObject.getValue('page_index'));
            }
            if (jsonObject.getValue('document_id') != null) {
                this.documentId = jsonObject.getValue('document_id');
            }
            if (jsonObject.getValue('label') != null) {
                this.label = jsonObject.getValue('label');
            }
            if (jsonObject.getValue('read_only') != null) {
                this.readOnly = jsonObject.getValue('read_only');
            }
            
            // Parse coordinates
            if (jsonObject.children.get('coordinates') != null) {
                BoxJsonObject coordObject = jsonObject.children.get('coordinates');
                this.coordinates = new Coordinates(coordObject);
            }
            
            // Parse dimensions
            if (jsonObject.children.get('dimensions') != null) {
                BoxJsonObject dimObject = jsonObject.children.get('dimensions');
                this.dimensions = new Dimensions(dimObject);
            }
        }
        
        public String getType() {
            return this.type;
        }
        
        public String getContentType() {
            return this.contentType;
        }
        
        public Boolean getIsRequired() {
            return this.isRequired;
        }
        
        public Integer getPageIndex() {
            return this.pageIndex;
        }
        
        public String getDocumentId() {
            return this.documentId;
        }
        
        public Coordinates getCoordinates() {
            return this.coordinates;
        }
        
        public Dimensions getDimensions() {
            return this.dimensions;
        }
        
        public String getLabel() {
            return this.label;
        }
        
        public String getReadOnly() {
            return this.readOnly;
        }
    }
    
    /**
     * Represents coordinates for a sign input.
     */
    public class Coordinates {
        private Decimal x;
        private Decimal y;
        
        public Coordinates(BoxJsonObject jsonObject) {
            if (jsonObject.getValue('x') != null) {
                this.x = Decimal.valueOf(jsonObject.getValue('x'));
            }
            if (jsonObject.getValue('y') != null) {
                this.y = Decimal.valueOf(jsonObject.getValue('y'));
            }
        }
        
        public Decimal getX() {
            return this.x;
        }
        
        public Decimal getY() {
            return this.y;
        }
    }
    
    /**
     * Represents dimensions for a sign input.
     */
    public class Dimensions {
        private Decimal width;
        private Decimal height;
        
        public Dimensions(BoxJsonObject jsonObject) {
            if (jsonObject.getValue('width') != null) {
                this.width = Decimal.valueOf(jsonObject.getValue('width'));
            }
            if (jsonObject.getValue('height') != null) {
                this.height = Decimal.valueOf(jsonObject.getValue('height'));
            }
        }
        
        public Decimal getWidth() {
            return this.width;
        }
        
        public Decimal getHeight() {
            return this.height;
        }
    }
    
    /**
     * Represents a ready sign link.
     */
    public class ReadySignLink {
        private String url;
        private String name;
        private String instructions;
        private String folderId;
        private Boolean isNotificationDisabled;
        private Boolean isActive;
        
        public ReadySignLink(BoxJsonObject jsonObject) {
            if (jsonObject.getValue('url') != null) {
                this.url = jsonObject.getValue('url');
            }
            if (jsonObject.getValue('name') != null) {
                this.name = jsonObject.getValue('name');
            }
            if (jsonObject.getValue('instructions') != null) {
                this.instructions = jsonObject.getValue('instructions');
            }
            if (jsonObject.getValue('folder_id') != null) {
                this.folderId = jsonObject.getValue('folder_id');
            }
            if (jsonObject.getValue('is_notification_disabled') != null) {
                this.isNotificationDisabled = Boolean.valueOf(jsonObject.getValue('is_notification_disabled'));
            }
            if (jsonObject.getValue('is_active') != null) {
                this.isActive = Boolean.valueOf(jsonObject.getValue('is_active'));
            }
        }
        
        public String getUrl() {
            return this.url;
        }
        
        public String getName() {
            return this.name;
        }
        
        public String getInstructions() {
            return this.instructions;
        }
        
        public String getFolderId() {
            return this.folderId;
        }
        
        public Boolean getIsNotificationDisabled() {
            return this.isNotificationDisabled;
        }
        
        public Boolean getIsActive() {
            return this.isActive;
        }
    }
    
    /**
     * Represents custom branding for a sign template.
     */
    public class CustomBranding {
        private String companyName;
        private String logoUri;
        private String brandingColor;
        private String emailFooterText;
        
        public CustomBranding(BoxJsonObject jsonObject) {
            if (jsonObject.getValue('company_name') != null) {
                this.companyName = jsonObject.getValue('company_name');
            }
            if (jsonObject.getValue('logo_uri') != null) {
                this.logoUri = jsonObject.getValue('logo_uri');
            }
            if (jsonObject.getValue('branding_color') != null) {
                this.brandingColor = jsonObject.getValue('branding_color');
            }
            if (jsonObject.getValue('email_footer_text') != null) {
                this.emailFooterText = jsonObject.getValue('email_footer_text');
            }
        }
        
        public String getCompanyName() {
            return this.companyName;
        }
        
        public String getLogoUri() {
            return this.logoUri;
        }
        
        public String getBrandingColor() {
            return this.brandingColor;
        }
        
        public String getEmailFooterText() {
            return this.emailFooterText;
        }
    }
    
    /**
     * Used to paginate through a collection of sign templates.
     */
    private class InfoPagedCollection extends BoxResourcePagedCollection<BoxSignTemplate.Info> {
        
        public InfoPagedCollection(BoxApiConnection api, String url) {
            super(api, url);
        }
        
        protected override BoxResource.Info factory(BoxJsonObject jsonObject) {
            BoxSignTemplate template = new BoxSignTemplate(this.api, jsonObject.getValue('id'));
            return template.new Info(jsonObject.getJsonString());
        }
    }
}