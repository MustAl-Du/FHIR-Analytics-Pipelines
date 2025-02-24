CREATE EXTERNAL TABLE [fhir].[EvidenceVariable] (
    [resourceType] NVARCHAR(4000),
    [id] VARCHAR(64),
    [meta.id] NVARCHAR(4000),
    [meta.extension] NVARCHAR(MAX),
    [meta.versionId] VARCHAR(64),
    [meta.lastUpdated] VARCHAR(30),
    [meta.source] VARCHAR(256),
    [meta.profile] VARCHAR(MAX),
    [meta.security] VARCHAR(MAX),
    [meta.tag] VARCHAR(MAX),
    [implicitRules] VARCHAR(256),
    [language] NVARCHAR(4000),
    [text.id] NVARCHAR(4000),
    [text.extension] NVARCHAR(MAX),
    [text.status] NVARCHAR(64),
    [text.div] NVARCHAR(MAX),
    [extension] NVARCHAR(MAX),
    [modifierExtension] NVARCHAR(MAX),
    [url] VARCHAR(256),
    [identifier] VARCHAR(MAX),
    [version] NVARCHAR(4000),
    [name] NVARCHAR(4000),
    [title] NVARCHAR(4000),
    [shortTitle] NVARCHAR(4000),
    [subtitle] NVARCHAR(4000),
    [status] NVARCHAR(64),
    [date] VARCHAR(30),
    [publisher] NVARCHAR(4000),
    [contact] VARCHAR(MAX),
    [description] NVARCHAR(MAX),
    [note] VARCHAR(MAX),
    [useContext] VARCHAR(MAX),
    [jurisdiction] VARCHAR(MAX),
    [copyright] NVARCHAR(MAX),
    [approvalDate] VARCHAR(10),
    [lastReviewDate] VARCHAR(10),
    [effectivePeriod.id] NVARCHAR(4000),
    [effectivePeriod.extension] NVARCHAR(MAX),
    [effectivePeriod.start] VARCHAR(30),
    [effectivePeriod.end] VARCHAR(30),
    [topic] VARCHAR(MAX),
    [author] VARCHAR(MAX),
    [editor] VARCHAR(MAX),
    [reviewer] VARCHAR(MAX),
    [endorser] VARCHAR(MAX),
    [relatedArtifact] VARCHAR(MAX),
    [type] NVARCHAR(64),
    [characteristic] VARCHAR(MAX),
) WITH (
    LOCATION='/EvidenceVariable/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.EvidenceVariableIdentifier AS
SELECT
    [id],
    [identifier.JSON],
    [identifier.id],
    [identifier.extension],
    [identifier.use],
    [identifier.type.id],
    [identifier.type.extension],
    [identifier.type.coding],
    [identifier.type.text],
    [identifier.system],
    [identifier.value],
    [identifier.period.id],
    [identifier.period.extension],
    [identifier.period.start],
    [identifier.period.end],
    [identifier.assigner.id],
    [identifier.assigner.extension],
    [identifier.assigner.reference],
    [identifier.assigner.type],
    [identifier.assigner.identifier],
    [identifier.assigner.display]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [identifier.JSON]  VARCHAR(MAX) '$.identifier'
    ) AS rowset
    CROSS APPLY openjson (rowset.[identifier.JSON]) with (
        [identifier.id]                NVARCHAR(4000)      '$.id',
        [identifier.extension]         NVARCHAR(MAX)       '$.extension',
        [identifier.use]               NVARCHAR(64)        '$.use',
        [identifier.type.id]           NVARCHAR(4000)      '$.type.id',
        [identifier.type.extension]    NVARCHAR(MAX)       '$.type.extension',
        [identifier.type.coding]       NVARCHAR(MAX)       '$.type.coding',
        [identifier.type.text]         NVARCHAR(4000)      '$.type.text',
        [identifier.system]            VARCHAR(256)        '$.system',
        [identifier.value]             NVARCHAR(4000)      '$.value',
        [identifier.period.id]         NVARCHAR(4000)      '$.period.id',
        [identifier.period.extension]  NVARCHAR(MAX)       '$.period.extension',
        [identifier.period.start]      VARCHAR(30)         '$.period.start',
        [identifier.period.end]        VARCHAR(30)         '$.period.end',
        [identifier.assigner.id]       NVARCHAR(4000)      '$.assigner.id',
        [identifier.assigner.extension] NVARCHAR(MAX)       '$.assigner.extension',
        [identifier.assigner.reference] NVARCHAR(4000)      '$.assigner.reference',
        [identifier.assigner.type]     VARCHAR(256)        '$.assigner.type',
        [identifier.assigner.identifier] NVARCHAR(MAX)       '$.assigner.identifier',
        [identifier.assigner.display]  NVARCHAR(4000)      '$.assigner.display'
    ) j

GO

CREATE VIEW fhir.EvidenceVariableContact AS
SELECT
    [id],
    [contact.JSON],
    [contact.id],
    [contact.extension],
    [contact.name],
    [contact.telecom]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [contact.JSON]  VARCHAR(MAX) '$.contact'
    ) AS rowset
    CROSS APPLY openjson (rowset.[contact.JSON]) with (
        [contact.id]                   NVARCHAR(4000)      '$.id',
        [contact.extension]            NVARCHAR(MAX)       '$.extension',
        [contact.name]                 NVARCHAR(4000)      '$.name',
        [contact.telecom]              NVARCHAR(MAX)       '$.telecom' AS JSON
    ) j

GO

CREATE VIEW fhir.EvidenceVariableNote AS
SELECT
    [id],
    [note.JSON],
    [note.id],
    [note.extension],
    [note.time],
    [note.text],
    [note.author.reference.id],
    [note.author.reference.extension],
    [note.author.reference.reference],
    [note.author.reference.type],
    [note.author.reference.identifier],
    [note.author.reference.display],
    [note.author.string]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [note.JSON]  VARCHAR(MAX) '$.note'
    ) AS rowset
    CROSS APPLY openjson (rowset.[note.JSON]) with (
        [note.id]                      NVARCHAR(4000)      '$.id',
        [note.extension]               NVARCHAR(MAX)       '$.extension',
        [note.time]                    VARCHAR(30)         '$.time',
        [note.text]                    NVARCHAR(MAX)       '$.text',
        [note.author.reference.id]     NVARCHAR(4000)      '$.author.reference.id',
        [note.author.reference.extension] NVARCHAR(MAX)       '$.author.reference.extension',
        [note.author.reference.reference] NVARCHAR(4000)      '$.author.reference.reference',
        [note.author.reference.type]   VARCHAR(256)        '$.author.reference.type',
        [note.author.reference.identifier] NVARCHAR(MAX)       '$.author.reference.identifier',
        [note.author.reference.display] NVARCHAR(4000)      '$.author.reference.display',
        [note.author.string]           NVARCHAR(4000)      '$.author.string'
    ) j

GO

CREATE VIEW fhir.EvidenceVariableUseContext AS
SELECT
    [id],
    [useContext.JSON],
    [useContext.id],
    [useContext.extension],
    [useContext.code.id],
    [useContext.code.extension],
    [useContext.code.system],
    [useContext.code.version],
    [useContext.code.code],
    [useContext.code.display],
    [useContext.code.userSelected],
    [useContext.value.codeableConcept.id],
    [useContext.value.codeableConcept.extension],
    [useContext.value.codeableConcept.coding],
    [useContext.value.codeableConcept.text],
    [useContext.value.quantity.id],
    [useContext.value.quantity.extension],
    [useContext.value.quantity.value],
    [useContext.value.quantity.comparator],
    [useContext.value.quantity.unit],
    [useContext.value.quantity.system],
    [useContext.value.quantity.code],
    [useContext.value.range.id],
    [useContext.value.range.extension],
    [useContext.value.range.low],
    [useContext.value.range.high],
    [useContext.value.reference.id],
    [useContext.value.reference.extension],
    [useContext.value.reference.reference],
    [useContext.value.reference.type],
    [useContext.value.reference.identifier],
    [useContext.value.reference.display]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [useContext.JSON]  VARCHAR(MAX) '$.useContext'
    ) AS rowset
    CROSS APPLY openjson (rowset.[useContext.JSON]) with (
        [useContext.id]                NVARCHAR(4000)      '$.id',
        [useContext.extension]         NVARCHAR(MAX)       '$.extension',
        [useContext.code.id]           NVARCHAR(4000)      '$.code.id',
        [useContext.code.extension]    NVARCHAR(MAX)       '$.code.extension',
        [useContext.code.system]       VARCHAR(256)        '$.code.system',
        [useContext.code.version]      NVARCHAR(4000)      '$.code.version',
        [useContext.code.code]         NVARCHAR(4000)      '$.code.code',
        [useContext.code.display]      NVARCHAR(4000)      '$.code.display',
        [useContext.code.userSelected] bit                 '$.code.userSelected',
        [useContext.value.codeableConcept.id] NVARCHAR(4000)      '$.value.codeableConcept.id',
        [useContext.value.codeableConcept.extension] NVARCHAR(MAX)       '$.value.codeableConcept.extension',
        [useContext.value.codeableConcept.coding] NVARCHAR(MAX)       '$.value.codeableConcept.coding',
        [useContext.value.codeableConcept.text] NVARCHAR(4000)      '$.value.codeableConcept.text',
        [useContext.value.quantity.id] NVARCHAR(4000)      '$.value.quantity.id',
        [useContext.value.quantity.extension] NVARCHAR(MAX)       '$.value.quantity.extension',
        [useContext.value.quantity.value] float               '$.value.quantity.value',
        [useContext.value.quantity.comparator] NVARCHAR(64)        '$.value.quantity.comparator',
        [useContext.value.quantity.unit] NVARCHAR(4000)      '$.value.quantity.unit',
        [useContext.value.quantity.system] VARCHAR(256)        '$.value.quantity.system',
        [useContext.value.quantity.code] NVARCHAR(4000)      '$.value.quantity.code',
        [useContext.value.range.id]    NVARCHAR(4000)      '$.value.range.id',
        [useContext.value.range.extension] NVARCHAR(MAX)       '$.value.range.extension',
        [useContext.value.range.low]   NVARCHAR(MAX)       '$.value.range.low',
        [useContext.value.range.high]  NVARCHAR(MAX)       '$.value.range.high',
        [useContext.value.reference.id] NVARCHAR(4000)      '$.value.reference.id',
        [useContext.value.reference.extension] NVARCHAR(MAX)       '$.value.reference.extension',
        [useContext.value.reference.reference] NVARCHAR(4000)      '$.value.reference.reference',
        [useContext.value.reference.type] VARCHAR(256)        '$.value.reference.type',
        [useContext.value.reference.identifier] NVARCHAR(MAX)       '$.value.reference.identifier',
        [useContext.value.reference.display] NVARCHAR(4000)      '$.value.reference.display'
    ) j

GO

CREATE VIEW fhir.EvidenceVariableJurisdiction AS
SELECT
    [id],
    [jurisdiction.JSON],
    [jurisdiction.id],
    [jurisdiction.extension],
    [jurisdiction.coding],
    [jurisdiction.text]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [jurisdiction.JSON]  VARCHAR(MAX) '$.jurisdiction'
    ) AS rowset
    CROSS APPLY openjson (rowset.[jurisdiction.JSON]) with (
        [jurisdiction.id]              NVARCHAR(4000)      '$.id',
        [jurisdiction.extension]       NVARCHAR(MAX)       '$.extension',
        [jurisdiction.coding]          NVARCHAR(MAX)       '$.coding' AS JSON,
        [jurisdiction.text]            NVARCHAR(4000)      '$.text'
    ) j

GO

CREATE VIEW fhir.EvidenceVariableTopic AS
SELECT
    [id],
    [topic.JSON],
    [topic.id],
    [topic.extension],
    [topic.coding],
    [topic.text]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [topic.JSON]  VARCHAR(MAX) '$.topic'
    ) AS rowset
    CROSS APPLY openjson (rowset.[topic.JSON]) with (
        [topic.id]                     NVARCHAR(4000)      '$.id',
        [topic.extension]              NVARCHAR(MAX)       '$.extension',
        [topic.coding]                 NVARCHAR(MAX)       '$.coding' AS JSON,
        [topic.text]                   NVARCHAR(4000)      '$.text'
    ) j

GO

CREATE VIEW fhir.EvidenceVariableAuthor AS
SELECT
    [id],
    [author.JSON],
    [author.id],
    [author.extension],
    [author.name],
    [author.telecom]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [author.JSON]  VARCHAR(MAX) '$.author'
    ) AS rowset
    CROSS APPLY openjson (rowset.[author.JSON]) with (
        [author.id]                    NVARCHAR(4000)      '$.id',
        [author.extension]             NVARCHAR(MAX)       '$.extension',
        [author.name]                  NVARCHAR(4000)      '$.name',
        [author.telecom]               NVARCHAR(MAX)       '$.telecom' AS JSON
    ) j

GO

CREATE VIEW fhir.EvidenceVariableEditor AS
SELECT
    [id],
    [editor.JSON],
    [editor.id],
    [editor.extension],
    [editor.name],
    [editor.telecom]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [editor.JSON]  VARCHAR(MAX) '$.editor'
    ) AS rowset
    CROSS APPLY openjson (rowset.[editor.JSON]) with (
        [editor.id]                    NVARCHAR(4000)      '$.id',
        [editor.extension]             NVARCHAR(MAX)       '$.extension',
        [editor.name]                  NVARCHAR(4000)      '$.name',
        [editor.telecom]               NVARCHAR(MAX)       '$.telecom' AS JSON
    ) j

GO

CREATE VIEW fhir.EvidenceVariableReviewer AS
SELECT
    [id],
    [reviewer.JSON],
    [reviewer.id],
    [reviewer.extension],
    [reviewer.name],
    [reviewer.telecom]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [reviewer.JSON]  VARCHAR(MAX) '$.reviewer'
    ) AS rowset
    CROSS APPLY openjson (rowset.[reviewer.JSON]) with (
        [reviewer.id]                  NVARCHAR(4000)      '$.id',
        [reviewer.extension]           NVARCHAR(MAX)       '$.extension',
        [reviewer.name]                NVARCHAR(4000)      '$.name',
        [reviewer.telecom]             NVARCHAR(MAX)       '$.telecom' AS JSON
    ) j

GO

CREATE VIEW fhir.EvidenceVariableEndorser AS
SELECT
    [id],
    [endorser.JSON],
    [endorser.id],
    [endorser.extension],
    [endorser.name],
    [endorser.telecom]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [endorser.JSON]  VARCHAR(MAX) '$.endorser'
    ) AS rowset
    CROSS APPLY openjson (rowset.[endorser.JSON]) with (
        [endorser.id]                  NVARCHAR(4000)      '$.id',
        [endorser.extension]           NVARCHAR(MAX)       '$.extension',
        [endorser.name]                NVARCHAR(4000)      '$.name',
        [endorser.telecom]             NVARCHAR(MAX)       '$.telecom' AS JSON
    ) j

GO

CREATE VIEW fhir.EvidenceVariableRelatedArtifact AS
SELECT
    [id],
    [relatedArtifact.JSON],
    [relatedArtifact.id],
    [relatedArtifact.extension],
    [relatedArtifact.type],
    [relatedArtifact.label],
    [relatedArtifact.display],
    [relatedArtifact.citation],
    [relatedArtifact.url],
    [relatedArtifact.document.id],
    [relatedArtifact.document.extension],
    [relatedArtifact.document.contentType],
    [relatedArtifact.document.language],
    [relatedArtifact.document.data],
    [relatedArtifact.document.url],
    [relatedArtifact.document.size],
    [relatedArtifact.document.hash],
    [relatedArtifact.document.title],
    [relatedArtifact.document.creation],
    [relatedArtifact.resource]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [relatedArtifact.JSON]  VARCHAR(MAX) '$.relatedArtifact'
    ) AS rowset
    CROSS APPLY openjson (rowset.[relatedArtifact.JSON]) with (
        [relatedArtifact.id]           NVARCHAR(4000)      '$.id',
        [relatedArtifact.extension]    NVARCHAR(MAX)       '$.extension',
        [relatedArtifact.type]         NVARCHAR(64)        '$.type',
        [relatedArtifact.label]        NVARCHAR(4000)      '$.label',
        [relatedArtifact.display]      NVARCHAR(4000)      '$.display',
        [relatedArtifact.citation]     NVARCHAR(MAX)       '$.citation',
        [relatedArtifact.url]          VARCHAR(256)        '$.url',
        [relatedArtifact.document.id]  NVARCHAR(4000)      '$.document.id',
        [relatedArtifact.document.extension] NVARCHAR(MAX)       '$.document.extension',
        [relatedArtifact.document.contentType] NVARCHAR(4000)      '$.document.contentType',
        [relatedArtifact.document.language] NVARCHAR(4000)      '$.document.language',
        [relatedArtifact.document.data] NVARCHAR(MAX)       '$.document.data',
        [relatedArtifact.document.url] VARCHAR(256)        '$.document.url',
        [relatedArtifact.document.size] bigint              '$.document.size',
        [relatedArtifact.document.hash] NVARCHAR(MAX)       '$.document.hash',
        [relatedArtifact.document.title] NVARCHAR(4000)      '$.document.title',
        [relatedArtifact.document.creation] VARCHAR(30)         '$.document.creation',
        [relatedArtifact.resource]     VARCHAR(256)        '$.resource'
    ) j

GO

CREATE VIEW fhir.EvidenceVariableCharacteristic AS
SELECT
    [id],
    [characteristic.JSON],
    [characteristic.id],
    [characteristic.extension],
    [characteristic.modifierExtension],
    [characteristic.description],
    [characteristic.usageContext],
    [characteristic.exclude],
    [characteristic.timeFromStart.id],
    [characteristic.timeFromStart.extension],
    [characteristic.timeFromStart.value],
    [characteristic.timeFromStart.comparator],
    [characteristic.timeFromStart.unit],
    [characteristic.timeFromStart.system],
    [characteristic.timeFromStart.code],
    [characteristic.groupMeasure],
    [characteristic.definition.reference.id],
    [characteristic.definition.reference.extension],
    [characteristic.definition.reference.reference],
    [characteristic.definition.reference.type],
    [characteristic.definition.reference.identifier],
    [characteristic.definition.reference.display],
    [characteristic.definition.canonical],
    [characteristic.definition.codeableConcept.id],
    [characteristic.definition.codeableConcept.extension],
    [characteristic.definition.codeableConcept.coding],
    [characteristic.definition.codeableConcept.text],
    [characteristic.definition.expression.id],
    [characteristic.definition.expression.extension],
    [characteristic.definition.expression.description],
    [characteristic.definition.expression.name],
    [characteristic.definition.expression.language],
    [characteristic.definition.expression.expression],
    [characteristic.definition.expression.reference],
    [characteristic.definition.dataRequirement.id],
    [characteristic.definition.dataRequirement.extension],
    [characteristic.definition.dataRequirement.type],
    [characteristic.definition.dataRequirement.profile],
    [characteristic.definition.dataRequirement.mustSupport],
    [characteristic.definition.dataRequirement.codeFilter],
    [characteristic.definition.dataRequirement.dateFilter],
    [characteristic.definition.dataRequirement.limit],
    [characteristic.definition.dataRequirement.sort],
    [characteristic.definition.dataRequirement.subject.codeableConcept],
    [characteristic.definition.dataRequirement.subject.reference],
    [characteristic.definition.triggerDefinition.id],
    [characteristic.definition.triggerDefinition.extension],
    [characteristic.definition.triggerDefinition.type],
    [characteristic.definition.triggerDefinition.name],
    [characteristic.definition.triggerDefinition.data],
    [characteristic.definition.triggerDefinition.condition],
    [characteristic.definition.triggerDefinition.timing.timing],
    [characteristic.definition.triggerDefinition.timing.reference],
    [characteristic.definition.triggerDefinition.timing.date],
    [characteristic.definition.triggerDefinition.timing.dateTime],
    [characteristic.participantEffective.dateTime],
    [characteristic.participantEffective.period.id],
    [characteristic.participantEffective.period.extension],
    [characteristic.participantEffective.period.start],
    [characteristic.participantEffective.period.end],
    [characteristic.participantEffective.duration.id],
    [characteristic.participantEffective.duration.extension],
    [characteristic.participantEffective.duration.value],
    [characteristic.participantEffective.duration.comparator],
    [characteristic.participantEffective.duration.unit],
    [characteristic.participantEffective.duration.system],
    [characteristic.participantEffective.duration.code],
    [characteristic.participantEffective.timing.id],
    [characteristic.participantEffective.timing.extension],
    [characteristic.participantEffective.timing.modifierExtension],
    [characteristic.participantEffective.timing.event],
    [characteristic.participantEffective.timing.repeat],
    [characteristic.participantEffective.timing.code]
FROM openrowset (
        BULK 'EvidenceVariable/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [characteristic.JSON]  VARCHAR(MAX) '$.characteristic'
    ) AS rowset
    CROSS APPLY openjson (rowset.[characteristic.JSON]) with (
        [characteristic.id]            NVARCHAR(4000)      '$.id',
        [characteristic.extension]     NVARCHAR(MAX)       '$.extension',
        [characteristic.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [characteristic.description]   NVARCHAR(4000)      '$.description',
        [characteristic.usageContext]  NVARCHAR(MAX)       '$.usageContext' AS JSON,
        [characteristic.exclude]       bit                 '$.exclude',
        [characteristic.timeFromStart.id] NVARCHAR(4000)      '$.timeFromStart.id',
        [characteristic.timeFromStart.extension] NVARCHAR(MAX)       '$.timeFromStart.extension',
        [characteristic.timeFromStart.value] float               '$.timeFromStart.value',
        [characteristic.timeFromStart.comparator] NVARCHAR(64)        '$.timeFromStart.comparator',
        [characteristic.timeFromStart.unit] NVARCHAR(4000)      '$.timeFromStart.unit',
        [characteristic.timeFromStart.system] VARCHAR(256)        '$.timeFromStart.system',
        [characteristic.timeFromStart.code] NVARCHAR(4000)      '$.timeFromStart.code',
        [characteristic.groupMeasure]  NVARCHAR(64)        '$.groupMeasure',
        [characteristic.definition.reference.id] NVARCHAR(4000)      '$.definition.reference.id',
        [characteristic.definition.reference.extension] NVARCHAR(MAX)       '$.definition.reference.extension',
        [characteristic.definition.reference.reference] NVARCHAR(4000)      '$.definition.reference.reference',
        [characteristic.definition.reference.type] VARCHAR(256)        '$.definition.reference.type',
        [characteristic.definition.reference.identifier] NVARCHAR(MAX)       '$.definition.reference.identifier',
        [characteristic.definition.reference.display] NVARCHAR(4000)      '$.definition.reference.display',
        [characteristic.definition.canonical] VARCHAR(256)        '$.definition.canonical',
        [characteristic.definition.codeableConcept.id] NVARCHAR(4000)      '$.definition.codeableConcept.id',
        [characteristic.definition.codeableConcept.extension] NVARCHAR(MAX)       '$.definition.codeableConcept.extension',
        [characteristic.definition.codeableConcept.coding] NVARCHAR(MAX)       '$.definition.codeableConcept.coding',
        [characteristic.definition.codeableConcept.text] NVARCHAR(4000)      '$.definition.codeableConcept.text',
        [characteristic.definition.expression.id] NVARCHAR(4000)      '$.definition.expression.id',
        [characteristic.definition.expression.extension] NVARCHAR(MAX)       '$.definition.expression.extension',
        [characteristic.definition.expression.description] NVARCHAR(4000)      '$.definition.expression.description',
        [characteristic.definition.expression.name] VARCHAR(64)         '$.definition.expression.name',
        [characteristic.definition.expression.language] NVARCHAR(64)        '$.definition.expression.language',
        [characteristic.definition.expression.expression] NVARCHAR(4000)      '$.definition.expression.expression',
        [characteristic.definition.expression.reference] VARCHAR(256)        '$.definition.expression.reference',
        [characteristic.definition.dataRequirement.id] NVARCHAR(4000)      '$.definition.dataRequirement.id',
        [characteristic.definition.dataRequirement.extension] NVARCHAR(MAX)       '$.definition.dataRequirement.extension',
        [characteristic.definition.dataRequirement.type] NVARCHAR(4000)      '$.definition.dataRequirement.type',
        [characteristic.definition.dataRequirement.profile] NVARCHAR(MAX)       '$.definition.dataRequirement.profile',
        [characteristic.definition.dataRequirement.mustSupport] NVARCHAR(MAX)       '$.definition.dataRequirement.mustSupport',
        [characteristic.definition.dataRequirement.codeFilter] NVARCHAR(MAX)       '$.definition.dataRequirement.codeFilter',
        [characteristic.definition.dataRequirement.dateFilter] NVARCHAR(MAX)       '$.definition.dataRequirement.dateFilter',
        [characteristic.definition.dataRequirement.limit] bigint              '$.definition.dataRequirement.limit',
        [characteristic.definition.dataRequirement.sort] NVARCHAR(MAX)       '$.definition.dataRequirement.sort',
        [characteristic.definition.dataRequirement.subject.codeableConcept] NVARCHAR(MAX)       '$.definition.dataRequirement.subject.codeableConcept',
        [characteristic.definition.dataRequirement.subject.reference] NVARCHAR(MAX)       '$.definition.dataRequirement.subject.reference',
        [characteristic.definition.triggerDefinition.id] NVARCHAR(4000)      '$.definition.triggerDefinition.id',
        [characteristic.definition.triggerDefinition.extension] NVARCHAR(MAX)       '$.definition.triggerDefinition.extension',
        [characteristic.definition.triggerDefinition.type] NVARCHAR(64)        '$.definition.triggerDefinition.type',
        [characteristic.definition.triggerDefinition.name] NVARCHAR(4000)      '$.definition.triggerDefinition.name',
        [characteristic.definition.triggerDefinition.data] NVARCHAR(MAX)       '$.definition.triggerDefinition.data',
        [characteristic.definition.triggerDefinition.condition] NVARCHAR(MAX)       '$.definition.triggerDefinition.condition',
        [characteristic.definition.triggerDefinition.timing.timing] NVARCHAR(MAX)       '$.definition.triggerDefinition.timing.timing',
        [characteristic.definition.triggerDefinition.timing.reference] NVARCHAR(MAX)       '$.definition.triggerDefinition.timing.reference',
        [characteristic.definition.triggerDefinition.timing.date] VARCHAR(10)         '$.definition.triggerDefinition.timing.date',
        [characteristic.definition.triggerDefinition.timing.dateTime] VARCHAR(30)         '$.definition.triggerDefinition.timing.dateTime',
        [characteristic.participantEffective.dateTime] VARCHAR(30)         '$.participantEffective.dateTime',
        [characteristic.participantEffective.period.id] NVARCHAR(4000)      '$.participantEffective.period.id',
        [characteristic.participantEffective.period.extension] NVARCHAR(MAX)       '$.participantEffective.period.extension',
        [characteristic.participantEffective.period.start] VARCHAR(30)         '$.participantEffective.period.start',
        [characteristic.participantEffective.period.end] VARCHAR(30)         '$.participantEffective.period.end',
        [characteristic.participantEffective.duration.id] NVARCHAR(4000)      '$.participantEffective.duration.id',
        [characteristic.participantEffective.duration.extension] NVARCHAR(MAX)       '$.participantEffective.duration.extension',
        [characteristic.participantEffective.duration.value] float               '$.participantEffective.duration.value',
        [characteristic.participantEffective.duration.comparator] NVARCHAR(64)        '$.participantEffective.duration.comparator',
        [characteristic.participantEffective.duration.unit] NVARCHAR(4000)      '$.participantEffective.duration.unit',
        [characteristic.participantEffective.duration.system] VARCHAR(256)        '$.participantEffective.duration.system',
        [characteristic.participantEffective.duration.code] NVARCHAR(4000)      '$.participantEffective.duration.code',
        [characteristic.participantEffective.timing.id] NVARCHAR(4000)      '$.participantEffective.timing.id',
        [characteristic.participantEffective.timing.extension] NVARCHAR(MAX)       '$.participantEffective.timing.extension',
        [characteristic.participantEffective.timing.modifierExtension] NVARCHAR(MAX)       '$.participantEffective.timing.modifierExtension',
        [characteristic.participantEffective.timing.event] NVARCHAR(MAX)       '$.participantEffective.timing.event',
        [characteristic.participantEffective.timing.repeat] NVARCHAR(MAX)       '$.participantEffective.timing.repeat',
        [characteristic.participantEffective.timing.code] NVARCHAR(MAX)       '$.participantEffective.timing.code'
    ) j
