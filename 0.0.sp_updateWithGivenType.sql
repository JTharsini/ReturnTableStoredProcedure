SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = 'sp_updateWithGivenType' AND [type] = 'P'
)
DROP PROCEDURE dbo.[sp_updateWithGivenType]; 
GO

CREATE PROCEDURE [dbo].[sp_updateWithGivenType]
	@owner BIGINT,
	@newType INT,
	@newOwnerKey BIGINT OUTPUT
AS
BEGIN

	IF EXISTS (SELECT * FROM dbo.TypeUsingTableC WHERE primaryKey = @owner)
	BEGIN
	
		SET NOCOUNT ON;

		DECLARE @schema NVARCHAR(MAX) = 'dbo'
		DECLARE @table NVARCHAR(MAX) = 'TypeUsingTableC'
		DECLARE @tableExternal NVARCHAR(MAX) = 'TypeUsingTableD'
		DECLARE @SQL NVARCHAR(MAX)
		DECLARE @SQL2 NVARCHAR(MAX)

		DECLARE @columnList NVARCHAR(MAX) = (
			SELECT STUFF (
				(
					SELECT ',[' + COLUMN_NAME + ']'
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @table AND COLUMN_NAME != 'primaryKey'
					ORDER BY ORDINAL_POSITION
					FOR XML PATH('')
				),1,1,''
			)
		)

		DECLARE @columnListExternal NVARCHAR(MAX) = (
			SELECT STUFF (
				(
					SELECT ',[' + COLUMN_NAME + ']'
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @tableExternal AND COLUMN_NAME != 'primaryKey'
					ORDER BY ORDINAL_POSITION
					FOR XML PATH('')
				),1,1,''
			)
		)

		BEGIN TRANSACTION

			SET @SQL = '
			INSERT INTO [' + @schema + '].[' + @tableExternal + '] (' + @columnListExternal + ') SELECT ' + REPLACE(@columnListExternal, '[type]', @newType) + ' FROM [' + @schema + '].[' + @tableExternal + '] WHERE [owner] = ' + CAST(@owner AS VARCHAR(MAX))

			EXEC sp_executesql @SQL
			SET @newOwnerKey = @@IDENTITY

			SET @SQL2 = '
			UPDATE [' + @schema + '].[' + @table + '] SET created = ' + CONVERT(varchar, GETDATE(), 120) + ' WHERE [primaryKey] = ' + @owner;

			EXEC sp_executesql @SQL2
	
		COMMIT

	END

	RETURN 

END;

GO