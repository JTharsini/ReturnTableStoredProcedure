SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = '5sp_handle_SubTypeCAfterADate' AND [type] = 'P'
)
DROP PROCEDURE dbo.[5sp_handle_SubTypeCAfterADate]; 
GO

CREATE PROCEDURE [dbo].[5sp_handle_SubTypeCAfterADate]
@p1 varchar(20)
AS
BEGIN
DECLARE @interestedType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'entityType');
DECLARE @commonOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeCommon');
DECLARE @subTypeCDataType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'subTypeC');
DECLARE @ownerAType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeA');
DECLARE @ownerBType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeB');

--2. SubTypeC and owner id > max(typeAOwner) --> owner is typeB // #typeA owner < #typeB owner

DECLARE @PKSubTypeCDataOwner AS PRIMARYKEY_DATAOWNER;
DECLARE @PKOwnerMoreThanMaxTypeAOwnerId AS PRIMARYKEY_DATAOWNER;
DECLARE @maxTypeAOwnerId BIGINT;

INSERT INTO @PKSubTypeCDataOwner(primaryKey, dataOwner)
SELECT pte.primaryKey, SUBSTRING(pte.common, 1, (SELECT CHARINDEX(':', pte.common)) - 1) AS dataOwner FROM dbo.[MainTableWhichUsesType] ptp INNER 
JOIN dbo.[SubTableWhichUsesType] pte ON pte.[owner]=ptp.primaryKey WHERE ptp.active=1 AND ptp.[type] = @interestedType 
AND ptp.active = 1 AND ptp.latest = 1 AND ptp.subtype = @subTypeCDataType AND pte.[type] = @commonOwnerType
AND created > @p1
OPTION (FORCE ORDER, LOOP JOIN);

SET @maxTypeAOwnerId = (SELECT TOP 1 id AS maxTypeAId FROM dbo.TypeAOwner  WHERE latest = 1 ORDER BY CAST (id AS BIGINT) desc);
INSERT INTO @PKOwnerMoreThanMaxTypeAOwnerId SELECT * FROM @PKSubTypeCDataOwner WHERE dataOwner > @maxTypeAOwnerId;
DECLARE @returned1 AS PRIMARYKEY_DATAOWNER;
INSERT @returned1
EXEC [dbo].[2sp_handle_PrimaryKeyOwner] @primaryKeyDataOwner = @PKOwnerMoreThanMaxTypeAOwnerId, @newType = @ownerBType;

DELETE FROM @PKSubTypeCDataOwner WHERE primaryKey IN (SELECT primaryKey FROM @returned1);
DELETE @PKOwnerMoreThanMaxTypeAOwnerId
DELETE FROM @returned1;

--------------------------------------------------------------------------------------------------------------------------------------------
--3. SubTypeC Data and Data owner id <= max(TypeAOwnerId) and Data owner id is not in TypeBOwner --> owner is TypeAOwner type

DECLARE @PKOwnerNotInTypeBOwner PRIMARYKEY_DATAOWNER;

INSERT INTO @PKOwnerNotInTypeBOwner 
SELECT * FROM @PKSubTypeCDataOwner AS ioltms
WHERE NOT EXISTS (
    SELECT id FROM dbo.TypeBOwner rsr WHERE latest = 1 and subclass in (1,2,3) and ioltms.dataOwner = rsr.id
);

INSERT @returned1
EXEC [dbo].[2sp_handle_PrimaryKeyOwner] @primaryKeyDataOwner = @PKOwnerNotInTypeBOwner, @newType = @ownerAType;
DELETE FROM @PKSubTypeCDataOwner WHERE primaryKey IN (SELECT primaryKey FROM @returned1);
DELETE @PKOwnerNotInTypeBOwner;
DELETE FROM @returned1;

-------------------------------------------------------------------------------------------------------------------------------------
--4. Owner id is in both table
INSERT @returned1
EXEC [dbo].[4sp_updateWhenOwnerInBothTable] @primaryKeyDataOwner = @PKSubTypeCDataOwner, @oldType = @commonOwnerType, @ownerAtype = @ownerAType, @ownerBtype = @ownerBType;
DELETE FROM @PKSubTypeCDataOwner WHERE primaryKey IN (SELECT primaryKey FROM @returned1);
DELETE FROM @returned1;

-------------------------------------------------------------------------------------------------------------------------------------

--5. SubTypeC Data and Data owner id <= max(TypeAOwnerId) and Data owner id might be in TypeBOwner and not in both table --> owner is TypeBOwner type
INSERT @returned1
EXEC [dbo].[2sp_handle_PrimaryKeyOwner] @primaryKeyDataOwner = @PKSubTypeCDataOwner, @newType = @ownerBType;
DELETE @returned1;

-----------------------------------------------------------------------------------------------------------------------------------------
END;
GO