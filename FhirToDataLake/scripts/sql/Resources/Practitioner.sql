CREATE EXTERNAL TABLE [fhir].[Practitioner] (
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
    [name] VARCHAR(MAX),
    [telecom] VARCHAR(MAX),
    [address] VARCHAR(MAX),
    [gender] NVARCHAR(64),
    [birthDate] VARCHAR(10),
    [photo] VARCHAR(MAX),
    [qualification] VARCHAR(MAX),
    [communication] VARCHAR(MAX),
) WITH (
    LOCATION='/Practitioner/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.PractitionerIdentifier AS
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
        BULK 'Practitioner/**',
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

CREATE VIEW fhir.PractitionerName AS
SELECT
    [id],
    [name.JSON],
    [name.id],
    [name.extension],
    [name.use],
    [name.text],
    [name.family],
    [name.given],
    [name.prefix],
    [name.suffix],
    [name.period.id],
    [name.period.extension],
    [name.period.start],
    [name.period.end]
FROM openrowset (
        BULK 'Practitioner/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [name.JSON]  VARCHAR(MAX) '$.name'
    ) AS rowset
    CROSS APPLY openjson (rowset.[name.JSON]) with (
        [name.id]                      NVARCHAR(4000)      '$.id',
        [name.extension]               NVARCHAR(MAX)       '$.extension',
        [name.use]                     NVARCHAR(64)        '$.use',
        [name.text]                    NVARCHAR(4000)      '$.text',
        [name.family]                  NVARCHAR(4000)      '$.family',
        [name.given]                   NVARCHAR(MAX)       '$.given' AS JSON,
        [name.prefix]                  NVARCHAR(MAX)       '$.prefix' AS JSON,
        [name.suffix]                  NVARCHAR(MAX)       '$.suffix' AS JSON,
        [name.period.id]               NVARCHAR(4000)      '$.period.id',
        [name.period.extension]        NVARCHAR(MAX)       '$.period.extension',
        [name.period.start]            VARCHAR(30)         '$.period.start',
        [name.period.end]              VARCHAR(30)         '$.period.end'
    ) j

GO

CREATE VIEW fhir.PractitionerTelecom AS
SELECT
    [id],
    [telecom.JSON],
    [telecom.id],
    [telecom.extension],
    [telecom.system],
    [telecom.value],
    [telecom.use],
    [telecom.rank],
    [telecom.period.id],
    [telecom.period.extension],
    [telecom.period.start],
    [telecom.period.end]
FROM openrowset (
        BULK 'Practitioner/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [telecom.JSON]  VARCHAR(MAX) '$.telecom'
    ) AS rowset
    CROSS APPLY openjson (rowset.[telecom.JSON]) with (
        [telecom.id]                   NVARCHAR(4000)      '$.id',
        [telecom.extension]            NVARCHAR(MAX)       '$.extension',
        [telecom.system]               NVARCHAR(64)        '$.system',
        [telecom.value]                NVARCHAR(4000)      '$.value',
        [telecom.use]                  NVARCHAR(64)        '$.use',
        [telecom.rank]                 bigint              '$.rank',
        [telecom.period.id]            NVARCHAR(4000)      '$.period.id',
        [telecom.period.extension]     NVARCHAR(MAX)       '$.period.extension',
        [telecom.period.start]         VARCHAR(30)         '$.period.start',
        [telecom.period.end]           VARCHAR(30)         '$.period.end'
    ) j

GO

CREATE VIEW fhir.PractitionerAddress AS
SELECT
    [id],
    [address.JSON],
    [address.id],
    [address.extension],
    [address.use],
    [address.type],
    [address.text],
    [address.line],
    [address.city],
    [address.district],
    [address.state],
    [address.postalCode],
    [address.country],
    [address.period.id],
    [address.period.extension],
    [address.period.start],
    [address.period.end]
FROM openrowset (
        BULK 'Practitioner/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [address.JSON]  VARCHAR(MAX) '$.address'
    ) AS rowset
    CROSS APPLY openjson (rowset.[address.JSON]) with (
        [address.id]                   NVARCHAR(4000)      '$.id',
        [address.extension]            NVARCHAR(MAX)       '$.extension',
        [address.use]                  NVARCHAR(64)        '$.use',
        [address.type]                 NVARCHAR(64)        '$.type',
        [address.text]                 NVARCHAR(4000)      '$.text',
        [address.line]                 NVARCHAR(MAX)       '$.line' AS JSON,
        [address.city]                 NVARCHAR(4000)      '$.city',
        [address.district]             NVARCHAR(4000)      '$.district',
        [address.state]                NVARCHAR(4000)      '$.state',
        [address.postalCode]           NVARCHAR(4000)      '$.postalCode',
        [address.country]              NVARCHAR(4000)      '$.country',
        [address.period.id]            NVARCHAR(4000)      '$.period.id',
        [address.period.extension]     NVARCHAR(MAX)       '$.period.extension',
        [address.period.start]         VARCHAR(30)         '$.period.start',
        [address.period.end]           VARCHAR(30)         '$.period.end'
    ) j

GO

CREATE VIEW fhir.PractitionerPhoto AS
SELECT
    [id],
    [photo.JSON],
    [photo.id],
    [photo.extension],
    [photo.contentType],
    [photo.language],
    [photo.data],
    [photo.url],
    [photo.size],
    [photo.hash],
    [photo.title],
    [photo.creation]
FROM openrowset (
        BULK 'Practitioner/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [photo.JSON]  VARCHAR(MAX) '$.photo'
    ) AS rowset
    CROSS APPLY openjson (rowset.[photo.JSON]) with (
        [photo.id]                     NVARCHAR(4000)      '$.id',
        [photo.extension]              NVARCHAR(MAX)       '$.extension',
        [photo.contentType]            NVARCHAR(4000)      '$.contentType',
        [photo.language]               NVARCHAR(4000)      '$.language',
        [photo.data]                   NVARCHAR(MAX)       '$.data',
        [photo.url]                    VARCHAR(256)        '$.url',
        [photo.size]                   bigint              '$.size',
        [photo.hash]                   NVARCHAR(MAX)       '$.hash',
        [photo.title]                  NVARCHAR(4000)      '$.title',
        [photo.creation]               VARCHAR(30)         '$.creation'
    ) j

GO

CREATE VIEW fhir.PractitionerQualification AS
SELECT
    [id],
    [qualification.JSON],
    [qualification.id],
    [qualification.extension],
    [qualification.modifierExtension],
    [qualification.identifier],
    [qualification.code.id],
    [qualification.code.extension],
    [qualification.code.coding],
    [qualification.code.text],
    [qualification.period.id],
    [qualification.period.extension],
    [qualification.period.start],
    [qualification.period.end],
    [qualification.issuer.id],
    [qualification.issuer.extension],
    [qualification.issuer.reference],
    [qualification.issuer.type],
    [qualification.issuer.identifier],
    [qualification.issuer.display]
FROM openrowset (
        BULK 'Practitioner/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [qualification.JSON]  VARCHAR(MAX) '$.qualification'
    ) AS rowset
    CROSS APPLY openjson (rowset.[qualification.JSON]) with (
        [qualification.id]             NVARCHAR(4000)      '$.id',
        [qualification.extension]      NVARCHAR(MAX)       '$.extension',
        [qualification.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [qualification.identifier]     NVARCHAR(MAX)       '$.identifier' AS JSON,
        [qualification.code.id]        NVARCHAR(4000)      '$.code.id',
        [qualification.code.extension] NVARCHAR(MAX)       '$.code.extension',
        [qualification.code.coding]    NVARCHAR(MAX)       '$.code.coding',
        [qualification.code.text]      NVARCHAR(4000)      '$.code.text',
        [qualification.period.id]      NVARCHAR(4000)      '$.period.id',
        [qualification.period.extension] NVARCHAR(MAX)       '$.period.extension',
        [qualification.period.start]   VARCHAR(30)         '$.period.start',
        [qualification.period.end]     VARCHAR(30)         '$.period.end',
        [qualification.issuer.id]      NVARCHAR(4000)      '$.issuer.id',
        [qualification.issuer.extension] NVARCHAR(MAX)       '$.issuer.extension',
        [qualification.issuer.reference] NVARCHAR(4000)      '$.issuer.reference',
        [qualification.issuer.type]    VARCHAR(256)        '$.issuer.type',
        [qualification.issuer.identifier] NVARCHAR(MAX)       '$.issuer.identifier',
        [qualification.issuer.display] NVARCHAR(4000)      '$.issuer.display'
    ) j

GO

CREATE VIEW fhir.PractitionerCommunication AS
SELECT
    [id],
    [communication.JSON],
    [communication.id],
    [communication.extension],
    [communication.coding],
    [communication.text]
FROM openrowset (
        BULK 'Practitioner/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [communication.JSON]  VARCHAR(MAX) '$.communication'
    ) AS rowset
    CROSS APPLY openjson (rowset.[communication.JSON]) with (
        [communication.id]             NVARCHAR(4000)      '$.id',
        [communication.extension]      NVARCHAR(MAX)       '$.extension',
        [communication.coding]         NVARCHAR(MAX)       '$.coding' AS JSON,
        [communication.text]           NVARCHAR(4000)      '$.text'
    ) j
