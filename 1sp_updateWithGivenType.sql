SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = '1sp_updateWithGivenType' AND [type] = 'P'
)
DROP PROCEDURE dbo.[1sp_updateWithGivenType]; 
GO

CREATE PROCEDURE [dbo].[1sp_updateWithGivenType]
	@primaryKey BIGINT,
	@newType INT,
	@newOwnerKey BIGINT OUTPUT
AS
BEGIN
	IF EXISTS (SELECT * FROM dbo.SubTableWhichUsesType WHERE primaryKey = @primaryKey)
	BEGIN
	
		SET NOCOUNT ON;

		DECLARE @schema NVARCHAR(MAX) = 'dbo'
		DECLARE @table NVARCHAR(MAX) = 'MainTableWhichUsesType'
		DECLARE @tableSub NVARCHAR(MAX) = 'SubTableWhichUsesType'
		DECLARE @SQL NVARCHAR(MAX)
		DECLARE @SQL2 NVARCHAR(MAX)
		DECLARE @owner BIGINT

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

		DECLARE @columnListSub NVARCHAR(MAX) = (
			SELECT STUFF (
				(
					SELECT ',[' + COLUMN_NAME + ']'
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @tableSub AND COLUMN_NAME != 'primaryKey'
					ORDER BY ORDINAL_POSITION
					FOR XML PATH('')
				),1,1,''
			)
		)

		SET @owner = (SELECT owner FROM dbo.SubTableWhichUsesType WHERE primaryKey = @primaryKey)

		BEGIN TRANSACTION

			SET @SQL = '
			INSERT INTO [' + @schema + '].[' + @tableSub + '] (' + @columnListSub + ') SELECT ' + REPLACE(@columnListSub, '[type]', @newType) + ' FROM [' + @schema + '].[' + @tableSub + '] WHERE [primaryKey] = ' + CAST(@primaryKey AS VARCHAR(MAX));

			EXEC sp_executesql @SQL
			SET @newOwnerKey = @@IDENTITY

			SET @SQL2 = '
			UPDATE [' + @schema + '].[' + @table + '] SET created = ''' + CONVERT(varchar, GETDATE(), 120) + ''' WHERE [primaryKey] = ' + CAST(@owner AS VARCHAR(MAX));

			EXEC sp_executesql @SQL2
	
		COMMIT

	END

	RETURN 

END;

GO