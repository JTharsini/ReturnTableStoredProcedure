---  2021-07-28	
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = 'migrateEntityAfterATimePeriod' AND [type] = 'P'
)
DROP PROCEDURE dbo.[migrateEntityAfterATimePeriod]; 
GO

CREATE PROCEDURE [dbo].migrateEntityAfterATimePeriod
@p1 varchar(20)
AS
BEGIN
SET @p1 = @p1 + ' 00:00:00';
PRINT @p1
---------------------------------------------------------------------------------------------------------------------------------
--1. Day note
EXEC [dbo].[sp_handle_SubTypeDAfterADate] @p1 = @p1;
---------------------------------------------------------------------------------------------------------------------------------
--2. Time note
EXEC [dbo].[sp_handle_SubTypeCAfterADate] @p1 = @p1;
---------------------------------------------------------------------------------------------------------------------------------
END