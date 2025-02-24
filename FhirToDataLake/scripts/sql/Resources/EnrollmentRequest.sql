CREATE EXTERNAL TABLE [fhir].[EnrollmentRequest] (
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
    [status] NVARCHAR(4000),
    [created] VARCHAR(30),
    [insurer.id] NVARCHAR(4000),
    [insurer.extension] NVARCHAR(MAX),
    [insurer.reference] NVARCHAR(4000),
    [insurer.type] VARCHAR(256),
    [insurer.identifier.id] NVARCHAR(4000),
    [insurer.identifier.extension] NVARCHAR(MAX),
    [insurer.identifier.use] NVARCHAR(64),
    [insurer.identifier.type] NVARCHAR(MAX),
    [insurer.identifier.system] VARCHAR(256),
    [insurer.identifier.value] NVARCHAR(4000),
    [insurer.identifier.period] NVARCHAR(MAX),
    [insurer.identifier.assigner] NVARCHAR(MAX),
    [insurer.display] NVARCHAR(4000),
    [provider.id] NVARCHAR(4000),
    [provider.extension] NVARCHAR(MAX),
    [provider.reference] NVARCHAR(4000),
    [provider.type] VARCHAR(256),
    [provider.identifier.id] NVARCHAR(4000),
    [provider.identifier.extension] NVARCHAR(MAX),
    [provider.identifier.use] NVARCHAR(64),
    [provider.identifier.type] NVARCHAR(MAX),
    [provider.identifier.system] VARCHAR(256),
    [provider.identifier.value] NVARCHAR(4000),
    [provider.identifier.period] NVARCHAR(MAX),
    [provider.identifier.assigner] NVARCHAR(MAX),
    [provider.display] NVARCHAR(4000),
    [candidate.id] NVARCHAR(4000),
    [candidate.extension] NVARCHAR(MAX),
    [candidate.reference] NVARCHAR(4000),
    [candidate.type] VARCHAR(256),
    [candidate.identifier.id] NVARCHAR(4000),
    [candidate.identifier.extension] NVARCHAR(MAX),
    [candidate.identifier.use] NVARCHAR(64),
    [candidate.identifier.type] NVARCHAR(MAX),
    [candidate.identifier.system] VARCHAR(256),
    [candidate.identifier.value] NVARCHAR(4000),
    [candidate.identifier.period] NVARCHAR(MAX),
    [candidate.identifier.assigner] NVARCHAR(MAX),
    [candidate.display] NVARCHAR(4000),
    [coverage.id] NVARCHAR(4000),
    [coverage.extension] NVARCHAR(MAX),
    [coverage.reference] NVARCHAR(4000),
    [coverage.type] VARCHAR(256),
    [coverage.identifier.id] NVARCHAR(4000),
    [coverage.identifier.extension] NVARCHAR(MAX),
    [coverage.identifier.use] NVARCHAR(64),
    [coverage.identifier.type] NVARCHAR(MAX),
    [coverage.identifier.system] VARCHAR(256),
    [coverage.identifier.value] NVARCHAR(4000),
    [coverage.identifier.period] NVARCHAR(MAX),
    [coverage.identifier.assigner] NVARCHAR(MAX),
    [coverage.display] NVARCHAR(4000),
) WITH (
    LOCATION='/EnrollmentRequest/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.EnrollmentRequestIdentifier AS
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
        BULK 'EnrollmentRequest/**',
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
