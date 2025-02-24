CREATE EXTERNAL TABLE [fhir].[Bundle] (
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
    [identifier.id] NVARCHAR(4000),
    [identifier.extension] NVARCHAR(MAX),
    [identifier.use] NVARCHAR(64),
    [identifier.type.id] NVARCHAR(4000),
    [identifier.type.extension] NVARCHAR(MAX),
    [identifier.type.coding] NVARCHAR(MAX),
    [identifier.type.text] NVARCHAR(4000),
    [identifier.system] VARCHAR(256),
    [identifier.value] NVARCHAR(4000),
    [identifier.period.id] NVARCHAR(4000),
    [identifier.period.extension] NVARCHAR(MAX),
    [identifier.period.start] VARCHAR(30),
    [identifier.period.end] VARCHAR(30),
    [identifier.assigner.id] NVARCHAR(4000),
    [identifier.assigner.extension] NVARCHAR(MAX),
    [identifier.assigner.reference] NVARCHAR(4000),
    [identifier.assigner.type] VARCHAR(256),
    [identifier.assigner.identifier] NVARCHAR(MAX),
    [identifier.assigner.display] NVARCHAR(4000),
    [type] NVARCHAR(64),
    [timestamp] VARCHAR(30),
    [total] bigint,
    [link] VARCHAR(MAX),
    [entry] VARCHAR(MAX),
    [signature.id] NVARCHAR(4000),
    [signature.extension] NVARCHAR(MAX),
    [signature.type] VARCHAR(MAX),
    [signature.when] VARCHAR(30),
    [signature.who.id] NVARCHAR(4000),
    [signature.who.extension] NVARCHAR(MAX),
    [signature.who.reference] NVARCHAR(4000),
    [signature.who.type] VARCHAR(256),
    [signature.who.identifier] NVARCHAR(MAX),
    [signature.who.display] NVARCHAR(4000),
    [signature.onBehalfOf.id] NVARCHAR(4000),
    [signature.onBehalfOf.extension] NVARCHAR(MAX),
    [signature.onBehalfOf.reference] NVARCHAR(4000),
    [signature.onBehalfOf.type] VARCHAR(256),
    [signature.onBehalfOf.identifier] NVARCHAR(MAX),
    [signature.onBehalfOf.display] NVARCHAR(4000),
    [signature.targetFormat] NVARCHAR(4000),
    [signature.sigFormat] NVARCHAR(4000),
    [signature.data] NVARCHAR(MAX),
) WITH (
    LOCATION='/Bundle/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.BundleLink AS
SELECT
    [id],
    [link.JSON],
    [link.id],
    [link.extension],
    [link.modifierExtension],
    [link.relation],
    [link.url]
FROM openrowset (
        BULK 'Bundle/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [link.JSON]  VARCHAR(MAX) '$.link'
    ) AS rowset
    CROSS APPLY openjson (rowset.[link.JSON]) with (
        [link.id]                      NVARCHAR(4000)      '$.id',
        [link.extension]               NVARCHAR(MAX)       '$.extension',
        [link.modifierExtension]       NVARCHAR(MAX)       '$.modifierExtension',
        [link.relation]                NVARCHAR(4000)      '$.relation',
        [link.url]                     VARCHAR(256)        '$.url'
    ) j

GO

CREATE VIEW fhir.BundleEntry AS
SELECT
    [id],
    [entry.JSON],
    [entry.id],
    [entry.extension],
    [entry.modifierExtension],
    [entry.link],
    [entry.fullUrl],
    [entry.search.id],
    [entry.search.extension],
    [entry.search.modifierExtension],
    [entry.search.mode],
    [entry.search.score],
    [entry.request.id],
    [entry.request.extension],
    [entry.request.modifierExtension],
    [entry.request.method],
    [entry.request.url],
    [entry.request.ifNoneMatch],
    [entry.request.ifModifiedSince],
    [entry.request.ifMatch],
    [entry.request.ifNoneExist],
    [entry.response.id],
    [entry.response.extension],
    [entry.response.modifierExtension],
    [entry.response.status],
    [entry.response.location],
    [entry.response.etag],
    [entry.response.lastModified]
FROM openrowset (
        BULK 'Bundle/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [entry.JSON]  VARCHAR(MAX) '$.entry'
    ) AS rowset
    CROSS APPLY openjson (rowset.[entry.JSON]) with (
        [entry.id]                     NVARCHAR(4000)      '$.id',
        [entry.extension]              NVARCHAR(MAX)       '$.extension',
        [entry.modifierExtension]      NVARCHAR(MAX)       '$.modifierExtension',
        [entry.link]                   NVARCHAR(MAX)       '$.link' AS JSON,
        [entry.fullUrl]                VARCHAR(256)        '$.fullUrl',
        [entry.search.id]              NVARCHAR(4000)      '$.search.id',
        [entry.search.extension]       NVARCHAR(MAX)       '$.search.extension',
        [entry.search.modifierExtension] NVARCHAR(MAX)       '$.search.modifierExtension',
        [entry.search.mode]            NVARCHAR(64)        '$.search.mode',
        [entry.search.score]           float               '$.search.score',
        [entry.request.id]             NVARCHAR(4000)      '$.request.id',
        [entry.request.extension]      NVARCHAR(MAX)       '$.request.extension',
        [entry.request.modifierExtension] NVARCHAR(MAX)       '$.request.modifierExtension',
        [entry.request.method]         NVARCHAR(64)        '$.request.method',
        [entry.request.url]            VARCHAR(256)        '$.request.url',
        [entry.request.ifNoneMatch]    NVARCHAR(4000)      '$.request.ifNoneMatch',
        [entry.request.ifModifiedSince] VARCHAR(30)         '$.request.ifModifiedSince',
        [entry.request.ifMatch]        NVARCHAR(4000)      '$.request.ifMatch',
        [entry.request.ifNoneExist]    NVARCHAR(4000)      '$.request.ifNoneExist',
        [entry.response.id]            NVARCHAR(4000)      '$.response.id',
        [entry.response.extension]     NVARCHAR(MAX)       '$.response.extension',
        [entry.response.modifierExtension] NVARCHAR(MAX)       '$.response.modifierExtension',
        [entry.response.status]        NVARCHAR(4000)      '$.response.status',
        [entry.response.location]      VARCHAR(256)        '$.response.location',
        [entry.response.etag]          NVARCHAR(4000)      '$.response.etag',
        [entry.response.lastModified]  VARCHAR(30)         '$.response.lastModified'
    ) j
