---  2021-07-28	
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = '6migrateEntityAfterATimePeriod' AND [type] = 'P'
)
DROP PROCEDURE dbo.[6migrateEntityAfterATimePeriod]; 
GO

CREATE PROCEDURE [dbo].[6migrateEntityAfterATimePeriod]
@p1 varchar(20)
AS
BEGIN
SET @p1 = @p1 + ' 00:00:00';
PRINT @p1
---------------------------------------------------------------------------------------------------------------------------------
--1. SubTypeD Data
EXEC [dbo].[3sp_handle_SubTypeDAfterADate] @p1 = @p1;
---------------------------------------------------------------------------------------------------------------------------------
--2. SubTypeC Data
EXEC [dbo].[5sp_handle_SubTypeCAfterADate] @p1 = @p1;
---------------------------------------------------------------------------------------------------------------------------------
END