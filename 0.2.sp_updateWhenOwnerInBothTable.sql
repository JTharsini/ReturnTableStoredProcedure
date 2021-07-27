CREATE PROCEDURE [dbo].[sp_updateWhenOwnerInBothTable]
	@primaryKeyNoteOwner PRIMARYKEY_NOTEOWNER READONLY,
	@resourceOwnerType INT,
	@OfferOwnerType INT
AS
BEGIN
	DECLARE @PKOwnerInBothTable PRIMARYKEY_NOTEOWNER;
	DECLARE @PKNoteOwner PRIMARYKEY_NOTEOWNER;
	INSERT INTO @PKNoteOwner SELECT * FROM @primaryKeyNoteOwner;

	INSERT INTO @PKOwnerInBothTable 
	SELECT rjiomc.owner, rjiomc.noteOwner
	FROM dbo.OwnerTypeAData oso INNER JOIN 
	(SELECT iomc.[owner], iomc.noteOwner
	FROM @primaryKeyNoteOwner iomc INNER JOIN dbo.OwnerTypeBData rsr 
	ON iomc.noteOwner = rsr.id WHERE rsr.latest = 1) AS rjiomc
	ON rjiomc.noteOwner = oso.id WHERE oso.latest = 1;

	DECLARE @newResourceOwnerKey BIGINT;
	DECLARE @newOfferOwnerKey BIGINT;

	WHILE EXISTS (SELECT * FROM @PKOwnerInBothTable)
	BEGIN
		DECLARE @owner BIGINT = (SELECT TOP 1 owner FROM @PKOwnerInBothTable)
		BEGIN TRANSACTION
			DECLARE @newOwnerKey BIGINT
			EXEC [dbo].[sp_updateWithGivenType] @owner = @owner, @newType = @resourceOwnerType,@newOwnerKey = @newResourceOwnerKey OUTPUT; 
			EXEC [dbo].[sp_updateWithGivenType] @owner = @owner, @newType = @OfferOwnerType,@newOwnerKey = @newOfferOwnerKey OUTPUT;
			UPDATE [dbo].[TypeUsingTableD]
			SET [label] = 'PATCH-value'
			WHERE [primaryKey] = @newOwnerKey
		COMMIT

		INSERT INTO Management.dbo.[PATCH-value]
		SELECT @newResourceOwnerKey

		INSERT INTO Management.dbo.[PATCH-value]
		SELECT @newOfferOwnerKey

		DELETE @PKNoteOwner WHERE owner = @owner
	END
DELETE @PKOwnerInBothTable;
SELECT * from @PKNoteOwner;
END;