CREATE PROCEDURE [dbo].[sp_handle_PrimaryKeyOwner]
	@primaryKeyNoteOwner PRIMARYKEY_NOTEOWNER READONLY,
	@newType INT
AS
BEGIN
	DECLARE @PKNoteOwner PRIMARYKEY_NOTEOWNER;
	INSERT INTO @PKNoteOwner SELECT * FROM @primaryKeyNoteOwner;
	WHILE EXISTS (SELECT * FROM @primaryKeyNoteOwner)
	BEGIN
		DECLARE @owner BIGINT = (SELECT TOP 1 owner FROM @primaryKeyNoteOwner)
		BEGIN TRANSACTION
			DECLARE @newOwnerKey BIGINT
			EXEC [dbo].[sp_updateWithGivenType] @owner = @owner, @newType = @newType,@newOwnerKey = @newOwnerKey OUTPUT;
			UPDATE [dbo].[TypeUsingTableD]
			SET [label] = 'PATCH-Id'
			WHERE [primaryKey] = @newOwnerKey
		COMMIT

		INSERT INTO Management.dbo.[PATCH-value]
		SELECT @owner

		DELETE @PKNoteOwner WHERE owner = @owner
	END

SELECT * from @PKNoteOwner
RETURN
END