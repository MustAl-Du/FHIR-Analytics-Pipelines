CREATE EXTERNAL TABLE [fhir].[MedicinalProductContraindication] (
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
    [subject] VARCHAR(MAX),
    [disease.id] NVARCHAR(4000),
    [disease.extension] NVARCHAR(MAX),
    [disease.coding] VARCHAR(MAX),
    [disease.text] NVARCHAR(4000),
    [diseaseStatus.id] NVARCHAR(4000),
    [diseaseStatus.extension] NVARCHAR(MAX),
    [diseaseStatus.coding] VARCHAR(MAX),
    [diseaseStatus.text] NVARCHAR(4000),
    [comorbidity] VARCHAR(MAX),
    [therapeuticIndication] VARCHAR(MAX),
    [otherTherapy] VARCHAR(MAX),
    [population] VARCHAR(MAX),
) WITH (
    LOCATION='/MedicinalProductContraindication/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.MedicinalProductContraindicationSubject AS
SELECT
    [id],
    [subject.JSON],
    [subject.id],
    [subject.extension],
    [subject.reference],
    [subject.type],
    [subject.identifier.id],
    [subject.identifier.extension],
    [subject.identifier.use],
    [subject.identifier.type],
    [subject.identifier.system],
    [subject.identifier.value],
    [subject.identifier.period],
    [subject.identifier.assigner],
    [subject.display]
FROM openrowset (
        BULK 'MedicinalProductContraindication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [subject.JSON]  VARCHAR(MAX) '$.subject'
    ) AS rowset
    CROSS APPLY openjson (rowset.[subject.JSON]) with (
        [subject.id]                   NVARCHAR(4000)      '$.id',
        [subject.extension]            NVARCHAR(MAX)       '$.extension',
        [subject.reference]            NVARCHAR(4000)      '$.reference',
        [subject.type]                 VARCHAR(256)        '$.type',
        [subject.identifier.id]        NVARCHAR(4000)      '$.identifier.id',
        [subject.identifier.extension] NVARCHAR(MAX)       '$.identifier.extension',
        [subject.identifier.use]       NVARCHAR(64)        '$.identifier.use',
        [subject.identifier.type]      NVARCHAR(MAX)       '$.identifier.type',
        [subject.identifier.system]    VARCHAR(256)        '$.identifier.system',
        [subject.identifier.value]     NVARCHAR(4000)      '$.identifier.value',
        [subject.identifier.period]    NVARCHAR(MAX)       '$.identifier.period',
        [subject.identifier.assigner]  NVARCHAR(MAX)       '$.identifier.assigner',
        [subject.display]              NVARCHAR(4000)      '$.display'
    ) j

GO

CREATE VIEW fhir.MedicinalProductContraindicationComorbidity AS
SELECT
    [id],
    [comorbidity.JSON],
    [comorbidity.id],
    [comorbidity.extension],
    [comorbidity.coding],
    [comorbidity.text]
FROM openrowset (
        BULK 'MedicinalProductContraindication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [comorbidity.JSON]  VARCHAR(MAX) '$.comorbidity'
    ) AS rowset
    CROSS APPLY openjson (rowset.[comorbidity.JSON]) with (
        [comorbidity.id]               NVARCHAR(4000)      '$.id',
        [comorbidity.extension]        NVARCHAR(MAX)       '$.extension',
        [comorbidity.coding]           NVARCHAR(MAX)       '$.coding' AS JSON,
        [comorbidity.text]             NVARCHAR(4000)      '$.text'
    ) j

GO

CREATE VIEW fhir.MedicinalProductContraindicationTherapeuticIndication AS
SELECT
    [id],
    [therapeuticIndication.JSON],
    [therapeuticIndication.id],
    [therapeuticIndication.extension],
    [therapeuticIndication.reference],
    [therapeuticIndication.type],
    [therapeuticIndication.identifier.id],
    [therapeuticIndication.identifier.extension],
    [therapeuticIndication.identifier.use],
    [therapeuticIndication.identifier.type],
    [therapeuticIndication.identifier.system],
    [therapeuticIndication.identifier.value],
    [therapeuticIndication.identifier.period],
    [therapeuticIndication.identifier.assigner],
    [therapeuticIndication.display]
FROM openrowset (
        BULK 'MedicinalProductContraindication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [therapeuticIndication.JSON]  VARCHAR(MAX) '$.therapeuticIndication'
    ) AS rowset
    CROSS APPLY openjson (rowset.[therapeuticIndication.JSON]) with (
        [therapeuticIndication.id]     NVARCHAR(4000)      '$.id',
        [therapeuticIndication.extension] NVARCHAR(MAX)       '$.extension',
        [therapeuticIndication.reference] NVARCHAR(4000)      '$.reference',
        [therapeuticIndication.type]   VARCHAR(256)        '$.type',
        [therapeuticIndication.identifier.id] NVARCHAR(4000)      '$.identifier.id',
        [therapeuticIndication.identifier.extension] NVARCHAR(MAX)       '$.identifier.extension',
        [therapeuticIndication.identifier.use] NVARCHAR(64)        '$.identifier.use',
        [therapeuticIndication.identifier.type] NVARCHAR(MAX)       '$.identifier.type',
        [therapeuticIndication.identifier.system] VARCHAR(256)        '$.identifier.system',
        [therapeuticIndication.identifier.value] NVARCHAR(4000)      '$.identifier.value',
        [therapeuticIndication.identifier.period] NVARCHAR(MAX)       '$.identifier.period',
        [therapeuticIndication.identifier.assigner] NVARCHAR(MAX)       '$.identifier.assigner',
        [therapeuticIndication.display] NVARCHAR(4000)      '$.display'
    ) j

GO

CREATE VIEW fhir.MedicinalProductContraindicationOtherTherapy AS
SELECT
    [id],
    [otherTherapy.JSON],
    [otherTherapy.id],
    [otherTherapy.extension],
    [otherTherapy.modifierExtension],
    [otherTherapy.therapyRelationshipType.id],
    [otherTherapy.therapyRelationshipType.extension],
    [otherTherapy.therapyRelationshipType.coding],
    [otherTherapy.therapyRelationshipType.text],
    [otherTherapy.medication.codeableConcept.id],
    [otherTherapy.medication.codeableConcept.extension],
    [otherTherapy.medication.codeableConcept.coding],
    [otherTherapy.medication.codeableConcept.text],
    [otherTherapy.medication.reference.id],
    [otherTherapy.medication.reference.extension],
    [otherTherapy.medication.reference.reference],
    [otherTherapy.medication.reference.type],
    [otherTherapy.medication.reference.identifier],
    [otherTherapy.medication.reference.display]
FROM openrowset (
        BULK 'MedicinalProductContraindication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [otherTherapy.JSON]  VARCHAR(MAX) '$.otherTherapy'
    ) AS rowset
    CROSS APPLY openjson (rowset.[otherTherapy.JSON]) with (
        [otherTherapy.id]              NVARCHAR(4000)      '$.id',
        [otherTherapy.extension]       NVARCHAR(MAX)       '$.extension',
        [otherTherapy.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [otherTherapy.therapyRelationshipType.id] NVARCHAR(4000)      '$.therapyRelationshipType.id',
        [otherTherapy.therapyRelationshipType.extension] NVARCHAR(MAX)       '$.therapyRelationshipType.extension',
        [otherTherapy.therapyRelationshipType.coding] NVARCHAR(MAX)       '$.therapyRelationshipType.coding',
        [otherTherapy.therapyRelationshipType.text] NVARCHAR(4000)      '$.therapyRelationshipType.text',
        [otherTherapy.medication.codeableConcept.id] NVARCHAR(4000)      '$.medication.codeableConcept.id',
        [otherTherapy.medication.codeableConcept.extension] NVARCHAR(MAX)       '$.medication.codeableConcept.extension',
        [otherTherapy.medication.codeableConcept.coding] NVARCHAR(MAX)       '$.medication.codeableConcept.coding',
        [otherTherapy.medication.codeableConcept.text] NVARCHAR(4000)      '$.medication.codeableConcept.text',
        [otherTherapy.medication.reference.id] NVARCHAR(4000)      '$.medication.reference.id',
        [otherTherapy.medication.reference.extension] NVARCHAR(MAX)       '$.medication.reference.extension',
        [otherTherapy.medication.reference.reference] NVARCHAR(4000)      '$.medication.reference.reference',
        [otherTherapy.medication.reference.type] VARCHAR(256)        '$.medication.reference.type',
        [otherTherapy.medication.reference.identifier] NVARCHAR(MAX)       '$.medication.reference.identifier',
        [otherTherapy.medication.reference.display] NVARCHAR(4000)      '$.medication.reference.display'
    ) j

GO

CREATE VIEW fhir.MedicinalProductContraindicationPopulation AS
SELECT
    [id],
    [population.JSON],
    [population.id],
    [population.extension],
    [population.modifierExtension],
    [population.gender.id],
    [population.gender.extension],
    [population.gender.coding],
    [population.gender.text],
    [population.race.id],
    [population.race.extension],
    [population.race.coding],
    [population.race.text],
    [population.physiologicalCondition.id],
    [population.physiologicalCondition.extension],
    [population.physiologicalCondition.coding],
    [population.physiologicalCondition.text],
    [population.age.range.id],
    [population.age.range.extension],
    [population.age.range.low],
    [population.age.range.high],
    [population.age.codeableConcept.id],
    [population.age.codeableConcept.extension],
    [population.age.codeableConcept.coding],
    [population.age.codeableConcept.text]
FROM openrowset (
        BULK 'MedicinalProductContraindication/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [population.JSON]  VARCHAR(MAX) '$.population'
    ) AS rowset
    CROSS APPLY openjson (rowset.[population.JSON]) with (
        [population.id]                NVARCHAR(4000)      '$.id',
        [population.extension]         NVARCHAR(MAX)       '$.extension',
        [population.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [population.gender.id]         NVARCHAR(4000)      '$.gender.id',
        [population.gender.extension]  NVARCHAR(MAX)       '$.gender.extension',
        [population.gender.coding]     NVARCHAR(MAX)       '$.gender.coding',
        [population.gender.text]       NVARCHAR(4000)      '$.gender.text',
        [population.race.id]           NVARCHAR(4000)      '$.race.id',
        [population.race.extension]    NVARCHAR(MAX)       '$.race.extension',
        [population.race.coding]       NVARCHAR(MAX)       '$.race.coding',
        [population.race.text]         NVARCHAR(4000)      '$.race.text',
        [population.physiologicalCondition.id] NVARCHAR(4000)      '$.physiologicalCondition.id',
        [population.physiologicalCondition.extension] NVARCHAR(MAX)       '$.physiologicalCondition.extension',
        [population.physiologicalCondition.coding] NVARCHAR(MAX)       '$.physiologicalCondition.coding',
        [population.physiologicalCondition.text] NVARCHAR(4000)      '$.physiologicalCondition.text',
        [population.age.range.id]      NVARCHAR(4000)      '$.age.range.id',
        [population.age.range.extension] NVARCHAR(MAX)       '$.age.range.extension',
        [population.age.range.low]     NVARCHAR(MAX)       '$.age.range.low',
        [population.age.range.high]    NVARCHAR(MAX)       '$.age.range.high',
        [population.age.codeableConcept.id] NVARCHAR(4000)      '$.age.codeableConcept.id',
        [population.age.codeableConcept.extension] NVARCHAR(MAX)       '$.age.codeableConcept.extension',
        [population.age.codeableConcept.coding] NVARCHAR(MAX)       '$.age.codeableConcept.coding',
        [population.age.codeableConcept.text] NVARCHAR(4000)      '$.age.codeableConcept.text'
    ) j
