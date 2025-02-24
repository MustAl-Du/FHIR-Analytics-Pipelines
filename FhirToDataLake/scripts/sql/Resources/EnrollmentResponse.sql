CREATE EXTERNAL TABLE [fhir].[EnrollmentResponse] (
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
    [request.id] NVARCHAR(4000),
    [request.extension] NVARCHAR(MAX),
    [request.reference] NVARCHAR(4000),
    [request.type] VARCHAR(256),
    [request.identifier.id] NVARCHAR(4000),
    [request.identifier.extension] NVARCHAR(MAX),
    [request.identifier.use] NVARCHAR(64),
    [request.identifier.type] NVARCHAR(MAX),
    [request.identifier.system] VARCHAR(256),
    [request.identifier.value] NVARCHAR(4000),
    [request.identifier.period] NVARCHAR(MAX),
    [request.identifier.assigner] NVARCHAR(MAX),
    [request.display] NVARCHAR(4000),
    [outcome] NVARCHAR(64),
    [disposition] NVARCHAR(4000),
    [created] VARCHAR(30),
    [organization.id] NVARCHAR(4000),
    [organization.extension] NVARCHAR(MAX),
    [organization.reference] NVARCHAR(4000),
    [organization.type] VARCHAR(256),
    [organization.identifier.id] NVARCHAR(4000),
    [organization.identifier.extension] NVARCHAR(MAX),
    [organization.identifier.use] NVARCHAR(64),
    [organization.identifier.type] NVARCHAR(MAX),
    [organization.identifier.system] VARCHAR(256),
    [organization.identifier.value] NVARCHAR(4000),
    [organization.identifier.period] NVARCHAR(MAX),
    [organization.identifier.assigner] NVARCHAR(MAX),
    [organization.display] NVARCHAR(4000),
    [requestProvider.id] NVARCHAR(4000),
    [requestProvider.extension] NVARCHAR(MAX),
    [requestProvider.reference] NVARCHAR(4000),
    [requestProvider.type] VARCHAR(256),
    [requestProvider.identifier.id] NVARCHAR(4000),
    [requestProvider.identifier.extension] NVARCHAR(MAX),
    [requestProvider.identifier.use] NVARCHAR(64),
    [requestProvider.identifier.type] NVARCHAR(MAX),
    [requestProvider.identifier.system] VARCHAR(256),
    [requestProvider.identifier.value] NVARCHAR(4000),
    [requestProvider.identifier.period] NVARCHAR(MAX),
    [requestProvider.identifier.assigner] NVARCHAR(MAX),
    [requestProvider.display] NVARCHAR(4000),
) WITH (
    LOCATION='/EnrollmentResponse/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.EnrollmentResponseIdentifier AS
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
        BULK 'EnrollmentResponse/**',
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
