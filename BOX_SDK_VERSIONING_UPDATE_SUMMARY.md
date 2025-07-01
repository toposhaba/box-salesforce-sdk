# Box for Salesforce SDK - Versioning Update Summary

## Overview
This document summarizes the versioning capabilities added to the Box for Salesforce SDK based on the latest Box API specifications.

## Updates Implemented

### 1. Enhanced File Versioning Capabilities

#### BoxFileVersion.cls
- **Added `restoreVersion()` method**: Restores a file version that was deleted to the trash
- **Added `restoreVersion(String trashedAt)` method**: Restores a file version with optional trashed timestamp
- **Enhanced Info class** with additional fields:
  - `trashedAt`: DateTime when version was trashed
  - `trashedBy`: BoxUser.Info who trashed the version
  - `restoredAt`: DateTime when version was restored
  - `restoredBy`: BoxUser.Info who restored the version
  - `purgedAt`: DateTime when version will be permanently deleted
  - `uploaderDisplayName`: Display name of the uploader

#### BoxFile.cls
- **Added `getVersion(String versionId)` method**: Gets a specific version of a file
- **Added FILE_VERSIONS_URL constant**: URL pattern for specific version endpoints

### 2. File Version Legal Holds

#### BoxFileVersionLegalHold.cls (New)
- Represents a legal hold on a file version
- **Methods**:
  - `getInfo()`: Gets information about the legal hold
  - `getAll()`: Static method to list all file version legal holds with filtering options
- **Info class fields**:
  - `fileVersionId`: ID of the file version
  - `file`: BoxFile.Info
  - `fileVersion`: BoxFileVersion.Info
  - `legalHoldPolicyAssignments`: List of assignments
  - `deletedAt`: DateTime when deleted

#### BoxLegalHoldPolicyAssignment.cls (New)
- Represents a legal hold policy assignment
- **Info class fields**:
  - `legalHoldPolicy`: BoxLegalHoldPolicy.Info
  - `assignedTo`: BoxResource.Info (can be file, folder, user, etc.)
  - `assignedBy`: BoxUser.Info
  - `assignedAt`: DateTime
  - `deletedAt`: DateTime

#### BoxLegalHoldPolicy.cls (New)
- Represents a legal hold policy
- **Info class fields**:
  - `policyName`: String
  - `description`: String
  - `status`: String
  - `createdBy`: BoxUser.Info
  - `createdAt`: DateTime
  - `modifiedAt`: DateTime
  - `deletedAt`: DateTime
  - `filterStartedAt`: DateTime
  - `filterEndedAt`: DateTime
  - `releaseNotes`: String

### 3. File Version Retentions

#### BoxFileVersionRetention.cls (New)
- Represents a retention on a file version
- **Methods**:
  - `getInfo()`: Gets information about the retention
  - `getAll()`: Static method to list all file version retentions with extensive filtering options
- **Info class fields**:
  - `file`: BoxFile.Info
  - `fileVersion`: BoxFileVersion.Info
  - `retentionPolicy`: BoxRetentionPolicy.Info
  - `appliedAt`: DateTime
  - `dispositionAt`: DateTime
  - `winningRetentionPolicy`: BoxUser.Info

#### BoxRetentionPolicy.cls (New)
- Represents a retention policy
- **Info class fields**:
  - `policyName`: String
  - `policyType`: String
  - `retentionLength`: Integer
  - `dispositionAction`: String
  - `status`: String
  - `createdBy`: BoxUser.Info
  - `createdAt`: DateTime
  - `modifiedAt`: DateTime
  - `canOwnerExtendRetention`: Boolean
  - `areOwnersNotified`: Boolean
  - `customNotificationRecipients`: List<BoxUser.Info>
  - `description`: String

### 4. API Versioning Support

#### BoxApiConnection.cls
- **Added `apiVersion` property**: Stores the Box API version to use
- **Added `getApiVersion()` method**: Gets the current API version
- **Added `setApiVersion(String apiVersion)` method**: Sets the API version

#### BoxApiRequest.cls
- **Added automatic box-version header**: If apiVersion is set on the connection, it automatically adds the `box-version` header to all requests

#### BoxDateFormat.cls
- **Added `formatBoxDateTimeString()` method**: Alias for getBoxDateTimeString() to support retention filtering

## Usage Examples

### Setting API Version
```apex
BoxApiConnection api = new BoxApiConnection('accessToken');
api.setApiVersion('2024.0'); // Set API version
```

### Restore File Version
```apex
BoxFile file = new BoxFile(api, 'fileId');
BoxFileVersion version = new BoxFileVersion(api, 'versionId');
version.setFileId('fileId');
BoxFileVersion.Info restoredVersion = version.restoreVersion();
```

### Get Specific File Version
```apex
BoxFile file = new BoxFile(api, 'fileId');
BoxFileVersion.Info versionInfo = file.getVersion('versionId');
```

### List File Version Legal Holds
```apex
List<BoxFileVersionLegalHold.Info> legalHolds = BoxFileVersionLegalHold.getAll(
    api,
    'policyId', // optional policy ID filter
    100,        // limit
    null        // marker for pagination
);
```

### List File Version Retentions
```apex
List<BoxFileVersionRetention.Info> retentions = BoxFileVersionRetention.getAll(
    api,
    'fileId',           // optional file ID
    'fileVersionId',    // optional file version ID
    'policyId',         // optional policy ID
    'permanently_delete', // optional disposition action
    null,               // optional disposition before date
    null,               // optional disposition after date
    100,                // limit
    null                // marker for pagination
);
```

## Next Steps

1. **Testing**: Create comprehensive test classes for all new functionality
2. **Documentation**: Update SDK documentation with new features
3. **Additional Features**: Implement remaining missing features identified in the update plan:
   - Box AI capabilities
   - Box Sign integration
   - Box Doc Gen
   - Metadata support
   - Advanced search
   - Webhooks
   - Workflows

## Notes

- All new classes follow the existing SDK patterns and conventions
- Metadata files are created with API version 52.0
- Error handling follows existing BoxResource exception patterns
- Pagination support is included for list operations