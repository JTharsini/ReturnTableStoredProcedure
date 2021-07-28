SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = '2sp_handle_PrimaryKeyOwner' AND [type] = 'P'
)
DROP PROCEDURE dbo.[2sp_handle_PrimaryKeyOwner]; 
GO

CREATE PROCEDURE [dbo].[2sp_handle_PrimaryKeyOwner]
	@primaryKeyDataOwner PRIMARYKEY_DATAOWNER READONLY,
	@newType INT
AS
BEGIN
	DECLARE @PKDataOwner PRIMARYKEY_DATAOWNER;
	DECLARE @deletedOwner PRIMARYKEY_DATAOWNER;

	INSERT INTO @PKDataOwner SELECT * FROM @primaryKeyDataOwner;
	WHILE EXISTS (SELECT * FROM @PKDataOwner)
	BEGIN
		DECLARE @primaryKey BIGINT = (SELECT TOP 1 primaryKey FROM @PKDataOwner)
		BEGIN TRANSACTION
			DECLARE @newOwnerKey BIGINT
			EXEC [dbo].[1sp_updateWithGivenType] @primaryKey = @primaryKey, @newType = @newType,@newOwnerKey = @newOwnerKey OUTPUT;
			UPDATE [dbo].[SubTableWhichUsesType]
			SET [label] = 'PATCH-Id'
			WHERE [primaryKey] = @newOwnerKey
		COMMIT

		INSERT INTO Management.dbo.[PATCH_value] SELECT @primaryKey;

		INSERT INTO @deletedOwner(primaryKey, dataOwner) values (@primaryKey, (SELECT TOP 1 dataOwner FROM @PKDataOwner));

		DELETE @PKDataOwner WHERE primaryKey = @primaryKey;
	END
SELECT * from @deletedOwner;
RETURN
END