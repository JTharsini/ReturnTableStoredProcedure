SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = 'sp_handle_PrimaryKeyOwner' AND [type] = 'P'
)
DROP PROCEDURE dbo.[sp_handle_PrimaryKeyOwner]; 
GO

CREATE PROCEDURE [dbo].[sp_handle_PrimaryKeyOwner]
	@primaryKeyNoteOwner PRIMARYKEY_NOTEOWNER READONLY,
	@newType INT
AS
BEGIN
	DECLARE @PKNoteOwner PRIMARYKEY_NOTEOWNER;
	DECLARE @deletedOwner PRIMARYKEY_NOTEOWNER;

	INSERT INTO @PKNoteOwner SELECT * FROM @primaryKeyNoteOwner;
	WHILE EXISTS (SELECT * FROM @PKNoteOwner)
	BEGIN
		DECLARE @owner BIGINT = (SELECT TOP 1 owner FROM @PKNoteOwner)
		BEGIN TRANSACTION
			DECLARE @newOwnerKey BIGINT
			EXEC [dbo].[sp_updateWithGivenType] @owner = @owner, @newType = @newType,@newOwnerKey = @newOwnerKey OUTPUT;
			UPDATE [dbo].[TypeUsingTableD]
			SET [label] = 'PATCH-Id'
			WHERE [primaryKey] = @newOwnerKey
		COMMIT

		INSERT INTO Management.dbo.[PATCH_value] SELECT @owner;

		INSERT INTO @deletedOwner(owner, noteOwner) values (@owner, (SELECT TOP 1 noteOwner FROM @PKNoteOwner));

		DELETE @PKNoteOwner WHERE owner = @owner;
	END
SELECT * from @deletedOwner;
RETURN
END