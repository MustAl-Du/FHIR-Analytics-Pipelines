CREATE EXTERNAL TABLE [fhir].[ImmunizationRecommendation] (
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
    [patient.id] NVARCHAR(4000),
    [patient.extension] NVARCHAR(MAX),
    [patient.reference] NVARCHAR(4000),
    [patient.type] VARCHAR(256),
    [patient.identifier.id] NVARCHAR(4000),
    [patient.identifier.extension] NVARCHAR(MAX),
    [patient.identifier.use] NVARCHAR(64),
    [patient.identifier.type] NVARCHAR(MAX),
    [patient.identifier.system] VARCHAR(256),
    [patient.identifier.value] NVARCHAR(4000),
    [patient.identifier.period] NVARCHAR(MAX),
    [patient.identifier.assigner] NVARCHAR(MAX),
    [patient.display] NVARCHAR(4000),
    [date] VARCHAR(30),
    [authority.id] NVARCHAR(4000),
    [authority.extension] NVARCHAR(MAX),
    [authority.reference] NVARCHAR(4000),
    [authority.type] VARCHAR(256),
    [authority.identifier.id] NVARCHAR(4000),
    [authority.identifier.extension] NVARCHAR(MAX),
    [authority.identifier.use] NVARCHAR(64),
    [authority.identifier.type] NVARCHAR(MAX),
    [authority.identifier.system] VARCHAR(256),
    [authority.identifier.value] NVARCHAR(4000),
    [authority.identifier.period] NVARCHAR(MAX),
    [authority.identifier.assigner] NVARCHAR(MAX),
    [authority.display] NVARCHAR(4000),
    [recommendation] VARCHAR(MAX),
) WITH (
    LOCATION='/ImmunizationRecommendation/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.ImmunizationRecommendationIdentifier AS
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
        BULK 'ImmunizationRecommendation/**',
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

CREATE VIEW fhir.ImmunizationRecommendationRecommendation AS
SELECT
    [id],
    [recommendation.JSON],
    [recommendation.id],
    [recommendation.extension],
    [recommendation.modifierExtension],
    [recommendation.vaccineCode],
    [recommendation.targetDisease.id],
    [recommendation.targetDisease.extension],
    [recommendation.targetDisease.coding],
    [recommendation.targetDisease.text],
    [recommendation.contraindicatedVaccineCode],
    [recommendation.forecastStatus.id],
    [recommendation.forecastStatus.extension],
    [recommendation.forecastStatus.coding],
    [recommendation.forecastStatus.text],
    [recommendation.forecastReason],
    [recommendation.dateCriterion],
    [recommendation.description],
    [recommendation.series],
    [recommendation.supportingImmunization],
    [recommendation.supportingPatientInformation],
    [recommendation.doseNumber.positiveInt],
    [recommendation.doseNumber.string],
    [recommendation.seriesDoses.positiveInt],
    [recommendation.seriesDoses.string]
FROM openrowset (
        BULK 'ImmunizationRecommendation/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [recommendation.JSON]  VARCHAR(MAX) '$.recommendation'
    ) AS rowset
    CROSS APPLY openjson (rowset.[recommendation.JSON]) with (
        [recommendation.id]            NVARCHAR(4000)      '$.id',
        [recommendation.extension]     NVARCHAR(MAX)       '$.extension',
        [recommendation.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [recommendation.vaccineCode]   NVARCHAR(MAX)       '$.vaccineCode' AS JSON,
        [recommendation.targetDisease.id] NVARCHAR(4000)      '$.targetDisease.id',
        [recommendation.targetDisease.extension] NVARCHAR(MAX)       '$.targetDisease.extension',
        [recommendation.targetDisease.coding] NVARCHAR(MAX)       '$.targetDisease.coding',
        [recommendation.targetDisease.text] NVARCHAR(4000)      '$.targetDisease.text',
        [recommendation.contraindicatedVaccineCode] NVARCHAR(MAX)       '$.contraindicatedVaccineCode' AS JSON,
        [recommendation.forecastStatus.id] NVARCHAR(4000)      '$.forecastStatus.id',
        [recommendation.forecastStatus.extension] NVARCHAR(MAX)       '$.forecastStatus.extension',
        [recommendation.forecastStatus.coding] NVARCHAR(MAX)       '$.forecastStatus.coding',
        [recommendation.forecastStatus.text] NVARCHAR(4000)      '$.forecastStatus.text',
        [recommendation.forecastReason] NVARCHAR(MAX)       '$.forecastReason' AS JSON,
        [recommendation.dateCriterion] NVARCHAR(MAX)       '$.dateCriterion' AS JSON,
        [recommendation.description]   NVARCHAR(4000)      '$.description',
        [recommendation.series]        NVARCHAR(4000)      '$.series',
        [recommendation.supportingImmunization] NVARCHAR(MAX)       '$.supportingImmunization' AS JSON,
        [recommendation.supportingPatientInformation] NVARCHAR(MAX)       '$.supportingPatientInformation' AS JSON,
        [recommendation.doseNumber.positiveInt] bigint              '$.doseNumber.positiveInt',
        [recommendation.doseNumber.string] NVARCHAR(4000)      '$.doseNumber.string',
        [recommendation.seriesDoses.positiveInt] bigint              '$.seriesDoses.positiveInt',
        [recommendation.seriesDoses.string] NVARCHAR(4000)      '$.seriesDoses.string'
    ) j
