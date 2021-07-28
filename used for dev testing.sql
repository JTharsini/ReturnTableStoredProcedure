USE [Test]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[6migrateEntityAfterATimePeriod]
		@p1 = N'2021-07-19'

SELECT	'Return Value' = @return_value

GO
