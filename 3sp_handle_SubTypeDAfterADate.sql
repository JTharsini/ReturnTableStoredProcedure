SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = '3sp_handle_SubTypeDAfterADate' AND [type] = 'P'
)
DROP PROCEDURE dbo.[3sp_handle_SubTypeDAfterADate]; 
GO

CREATE PROCEDURE [dbo].[3sp_handle_SubTypeDAfterADate]
@p1 varchar(20)
AS
BEGIN
DECLARE @PKSubTypeDDataOwner AS PRIMARYKEY_DATAOWNER;
DECLARE @commonOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeCommon');
DECLARE @interestedType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'entityType');
DECLARE @subTypeDDataType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'subTypeD');
DECLARE @ownerBType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeB');

--1. SubTypeD Data and Sub type is Data owner --> owner is TypeB type

INSERT INTO @PKSubTypeDDataOwner(primaryKey, dataOwner)
SELECT pte.primaryKey, SUBSTRING(pte.common, 1, (SELECT CHARINDEX(':', pte.common)) - 1)
FROM dbo.[MainTableWhichUsesType] ptp INNER JOIN dbo.[SubTableWhichUsesType] pte 
ON pte.[owner]=ptp.primaryKey WHERE ptp.[type] = @interestedType AND ptp.subtype = @subTypeDDataType 
AND pte.[type] = @commonOwnerType AND ptp.latest = 1 AND ptp.active = 1
AND created > @p1
OPTION (FORCE ORDER, LOOP JOIN);

EXEC [dbo].[2sp_handle_PrimaryKeyOwner] @primaryKeyDataOwner = @PKSubTypeDDataOwner, @newType = @ownerBType;
DELETE @PKSubTypeDDataOwner;

END;
GO