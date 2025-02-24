CREATE EXTERNAL TABLE [fhir].[TestReport] (
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
    [name] NVARCHAR(4000),
    [status] NVARCHAR(64),
    [testScript.id] NVARCHAR(4000),
    [testScript.extension] NVARCHAR(MAX),
    [testScript.reference] NVARCHAR(4000),
    [testScript.type] VARCHAR(256),
    [testScript.identifier.id] NVARCHAR(4000),
    [testScript.identifier.extension] NVARCHAR(MAX),
    [testScript.identifier.use] NVARCHAR(64),
    [testScript.identifier.type] NVARCHAR(MAX),
    [testScript.identifier.system] VARCHAR(256),
    [testScript.identifier.value] NVARCHAR(4000),
    [testScript.identifier.period] NVARCHAR(MAX),
    [testScript.identifier.assigner] NVARCHAR(MAX),
    [testScript.display] NVARCHAR(4000),
    [result] NVARCHAR(64),
    [score] float,
    [tester] NVARCHAR(4000),
    [issued] VARCHAR(30),
    [participant] VARCHAR(MAX),
    [setup.id] NVARCHAR(4000),
    [setup.extension] NVARCHAR(MAX),
    [setup.modifierExtension] NVARCHAR(MAX),
    [setup.action] VARCHAR(MAX),
    [test] VARCHAR(MAX),
    [teardown.id] NVARCHAR(4000),
    [teardown.extension] NVARCHAR(MAX),
    [teardown.modifierExtension] NVARCHAR(MAX),
    [teardown.action] VARCHAR(MAX),
) WITH (
    LOCATION='/TestReport/**',
    DATA_SOURCE = ParquetSource,
    FILE_FORMAT = ParquetFormat
);

GO

CREATE VIEW fhir.TestReportParticipant AS
SELECT
    [id],
    [participant.JSON],
    [participant.id],
    [participant.extension],
    [participant.modifierExtension],
    [participant.type],
    [participant.uri],
    [participant.display]
FROM openrowset (
        BULK 'TestReport/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [participant.JSON]  VARCHAR(MAX) '$.participant'
    ) AS rowset
    CROSS APPLY openjson (rowset.[participant.JSON]) with (
        [participant.id]               NVARCHAR(4000)      '$.id',
        [participant.extension]        NVARCHAR(MAX)       '$.extension',
        [participant.modifierExtension] NVARCHAR(MAX)       '$.modifierExtension',
        [participant.type]             NVARCHAR(64)        '$.type',
        [participant.uri]              VARCHAR(256)        '$.uri',
        [participant.display]          NVARCHAR(4000)      '$.display'
    ) j

GO

CREATE VIEW fhir.TestReportTest AS
SELECT
    [id],
    [test.JSON],
    [test.id],
    [test.extension],
    [test.modifierExtension],
    [test.name],
    [test.description],
    [test.action]
FROM openrowset (
        BULK 'TestReport/**',
        DATA_SOURCE = 'ParquetSource',
        FORMAT = 'PARQUET'
    ) WITH (
        [id]   VARCHAR(64),
       [test.JSON]  VARCHAR(MAX) '$.test'
    ) AS rowset
    CROSS APPLY openjson (rowset.[test.JSON]) with (
        [test.id]                      NVARCHAR(4000)      '$.id',
        [test.extension]               NVARCHAR(MAX)       '$.extension',
        [test.modifierExtension]       NVARCHAR(MAX)       '$.modifierExtension',
        [test.name]                    NVARCHAR(4000)      '$.name',
        [test.description]             NVARCHAR(4000)      '$.description',
        [test.action]                  NVARCHAR(MAX)       '$.action' AS JSON
    ) j
