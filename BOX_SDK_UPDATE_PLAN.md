# Box for Salesforce SDK Update Plan

## Overview
This document outlines the missing API features and capabilities in the Box for Salesforce SDK based on the latest Box OpenAPI specification.

## Current Implementation Status

### Implemented Features:
- **Core Resources**: BoxFile, BoxFolder, BoxUser, BoxGroup, BoxCollaboration, BoxComment
- **Basic Versioning**: BoxFileVersion (with basic operations: delete, promote)
- **Authentication**: BoxApiConnection, BoxPlatformApiConnection (JWT)
- **Sharing**: BoxSharedLink
- **Events**: BoxEvent
- **Enterprise**: BoxEnterprise
- **Web Links**: BoxWebLink
- **Upload Email**: BoxUploadEmail
- **Email Aliases**: BoxEmailAlias

### Missing Major Features:

#### 1. Enhanced File Versioning Capabilities
- **File Version Legal Holds** (`/file_version_legal_holds`)
- **File Version Retentions** (`/file_version_retentions`)
- **Restore File Version** (PUT `/files/{file_id}/versions/{file_version_id}`)
- **File Versions on Hold** (`/legal_hold_policy_assignments/{id}/file_versions_on_hold`)
- **File Versions Under Retention** (`/retention_policy_assignments/{id}/file_versions_under_retention`)

#### 2. AI and Intelligence Features
- **Box AI** (`/ai/ask`, `/ai/text_gen`, `/ai/extract`, `/ai/extract_structured`)
- **AI Agent Configuration**
- **Skills** (`/skill_invocations`)

#### 3. Box Sign
- **Sign Requests** (`/sign_requests`)
- **Sign Templates** (`/sign_templates`)

#### 4. Box Doc Gen
- **Doc Gen Templates** (`/docgen_templates`)
- **Doc Gen Jobs** (`/docgen_jobs`)
- **Doc Gen Batches** (`/docgen_batches`)

#### 5. Governance and Compliance
- **Legal Hold Policies** (`/legal_hold_policies`)
- **Legal Hold Policy Assignments** (`/legal_hold_policy_assignments`)
- **Retention Policies** (`/retention_policies`)
- **Retention Policy Assignments** (`/retention_policy_assignments`)
- **Shield Information Barriers** (`/shield_information_barriers`)
- **Shield Lists** (`/shield_lists`)

#### 6. Metadata
- **Metadata Templates** (`/metadata_templates`)
- **Metadata Instances** (`/files/{id}/metadata`, `/folders/{id}/metadata`)
- **Metadata Cascade Policies** (`/metadata_cascade_policies`)
- **Metadata Query** (`/metadata_queries`)

#### 7. Advanced Collaboration
- **Tasks** (`/tasks`, `/task_assignments`)
- **Collections** (`/collections`)
- **Recent Items** (`/recent_items`)
- **File Requests** (`/file_requests`)

#### 8. Storage Management
- **Storage Policies** (`/storage_policies`)
- **Storage Policy Assignments** (`/storage_policy_assignments`)
- **Zip Downloads** (`/zip_downloads`)

#### 9. Enterprise Features
- **Terms of Service** (`/terms_of_services`)
- **Terms of Service User Statuses** (`/terms_of_service_user_statuses`)
- **Device Pinners** (`/device_pinners`)
- **Webhooks** (`/webhooks`)
- **Workflows** (`/workflows`)

#### 10. Hub Features (Beta)
- **Hubs** (`/hubs`)
- **Hub Collaborations** (`/hub_collaborations`)
- **Enterprise Hubs** (`/enterprise_hubs`)

#### 11. Integration Features
- **Integration Mappings** (`/integration_mappings`)
- **App Item Associations** (`/app_item_associations`)

#### 12. Search
- **Advanced Search** (`/search`) - Currently missing advanced search capabilities

### 6. Box AI ✅ IMPLEMENTED
- [ ] ✅ AI ask (ask questions about files)
- [ ] ✅ AI text generation
- [ ] ✅ AI extract (extract information from files)
- [ ] ✅ AI extract structured (with defined fields)
- [ ] ✅ AI agent configuration support

## Implementation Priority

### Phase 1: Core Versioning Enhancements
1. Implement file version restoration
2. Add file version legal holds
3. Add file version retentions

### Phase 2: Metadata and Governance
1. Implement metadata templates and instances
2. Add retention policies
3. Add legal hold policies

### Phase 3: Modern Features
1. Box Sign integration
2. Box Doc Gen
3. Box AI capabilities

### Phase 4: Enterprise Features
1. Shield Information Barriers
2. Terms of Service
3. Workflows
4. Webhooks

## Technical Considerations

1. **API Versioning**: The SDK should support Box API versioning with the `box-version` header
2. **Pagination**: Implement proper pagination for list endpoints
3. **Error Handling**: Enhanced error handling for new error types
4. **Async Operations**: Support for long-running operations
5. **Streaming**: Support for streaming large file downloads/uploads

## Next Steps

1. Start with Phase 1 implementation
2. Update test coverage for new features
3. Update documentation
4. Consider backward compatibility