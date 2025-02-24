CREATE EXTERNAL TABLE [fhir].[Schedule] (
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
    [identifier] VARCHAR(MAX),
    [active] bit,
    [serviceCategory] VARCHAR(MAX),
    [serviceType] VARCHAR(MAX),
    [specialty] VARCHAR(MAX),
    [actor] VARCHAR(MAX),
    [planningHorizon.id] NVARCHAR(4000),
    [planningHorizon.extension] NVARCHAR(MAX),
    [planningHorizon.start] VARCHAR(30),
    [planningHorizon.end] VARCHAR(30),
    [comment] NVARCHAR(4000),
) WITH (
    LOCATION='/Schedule/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.ScheduleIdentifier AS
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
        BULK 'Schedule/**',
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

CREATE VIEW fhir.ScheduleServiceCategory AS
SELECT
    [id],
    [serviceCategory.JSON],
    [serviceCategory.id],
    [serviceCategory.extension],
    [serviceCategory.coding],
    [serviceCategory.text]
FROM openrowset (
        BULK 'Schedule/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [serviceCategory.JSON]  VARCHAR(MAX) '$.serviceCategory'
    ) AS rowset
    CROSS APPLY openjson (rowset.[serviceCategory.JSON]) with (
        [serviceCategory.id]           NVARCHAR(4000)      '$.id',
        [serviceCategory.extension]    NVARCHAR(MAX)       '$.extension',
        [serviceCategory.coding]       NVARCHAR(MAX)       '$.coding' AS JSON,
        [serviceCategory.text]         NVARCHAR(4000)      '$.text'
    ) j

GO

CREATE VIEW fhir.ScheduleServiceType AS
SELECT
    [id],
    [serviceType.JSON],
    [serviceType.id],
    [serviceType.extension],
    [serviceType.coding],
    [serviceType.text]
FROM openrowset (
        BULK 'Schedule/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [serviceType.JSON]  VARCHAR(MAX) '$.serviceType'
    ) AS rowset
    CROSS APPLY openjson (rowset.[serviceType.JSON]) with (
        [serviceType.id]               NVARCHAR(4000)      '$.id',
        [serviceType.extension]        NVARCHAR(MAX)       '$.extension',
        [serviceType.coding]           NVARCHAR(MAX)       '$.coding' AS JSON,
        [serviceType.text]             NVARCHAR(4000)      '$.text'
    ) j

GO

CREATE VIEW fhir.ScheduleSpecialty AS
SELECT
    [id],
    [specialty.JSON],
    [specialty.id],
    [specialty.extension],
    [specialty.coding],
    [specialty.text]
FROM openrowset (
        BULK 'Schedule/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [specialty.JSON]  VARCHAR(MAX) '$.specialty'
    ) AS rowset
    CROSS APPLY openjson (rowset.[specialty.JSON]) with (
        [specialty.id]                 NVARCHAR(4000)      '$.id',
        [specialty.extension]          NVARCHAR(MAX)       '$.extension',
        [specialty.coding]             NVARCHAR(MAX)       '$.coding' AS JSON,
        [specialty.text]               NVARCHAR(4000)      '$.text'
    ) j

GO

CREATE VIEW fhir.ScheduleActor AS
SELECT
    [id],
    [actor.JSON],
    [actor.id],
    [actor.extension],
    [actor.reference],
    [actor.type],
    [actor.identifier.id],
    [actor.identifier.extension],
    [actor.identifier.use],
    [actor.identifier.type],
    [actor.identifier.system],
    [actor.identifier.value],
    [actor.identifier.period],
    [actor.identifier.assigner],
    [actor.display]
FROM openrowset (
        BULK 'Schedule/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [actor.JSON]  VARCHAR(MAX) '$.actor'
    ) AS rowset
    CROSS APPLY openjson (rowset.[actor.JSON]) with (
        [actor.id]                     NVARCHAR(4000)      '$.id',
        [actor.extension]              NVARCHAR(MAX)       '$.extension',
        [actor.reference]              NVARCHAR(4000)      '$.reference',
        [actor.type]                   VARCHAR(256)        '$.type',
        [actor.identifier.id]          NVARCHAR(4000)      '$.identifier.id',
        [actor.identifier.extension]   NVARCHAR(MAX)       '$.identifier.extension',
        [actor.identifier.use]         NVARCHAR(64)        '$.identifier.use',
        [actor.identifier.type]        NVARCHAR(MAX)       '$.identifier.type',
        [actor.identifier.system]      VARCHAR(256)        '$.identifier.system',
        [actor.identifier.value]       NVARCHAR(4000)      '$.identifier.value',
        [actor.identifier.period]      NVARCHAR(MAX)       '$.identifier.period',
        [actor.identifier.assigner]    NVARCHAR(MAX)       '$.identifier.assigner',
        [actor.display]                NVARCHAR(4000)      '$.display'
    ) j
