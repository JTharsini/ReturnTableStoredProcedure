SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = '4sp_updateWhenOwnerInBothTable' AND [type] = 'P'
)
DROP PROCEDURE [dbo].[4sp_updateWhenOwnerInBothTable]; 
GO

CREATE PROCEDURE [dbo].[4sp_updateWhenOwnerInBothTable]
	@primaryKeyDataOwner PRIMARYKEY_DATAOWNER READONLY, 
	@oldType INT, 
	@ownerAtype INT,
	@ownerBtype INT
AS
BEGIN
	IF OBJECT_ID('tempdb..#PKOwnerInBothTable') IS NOT NULL DROP TABLE #PKOwnerInBothTable
	CREATE TABLE #PKOwnerInBothTable([primaryKey] INT, [dataOwner] INT)
	CREATE CLUSTERED INDEX [IX_PKOwnerInBothTable_owner_temp_01] ON #PKOwnerInBothTable([dataOwner] ASC) WITH (DATA_COMPRESSION =PAGE);

	INSERT INTO #PKOwnerInBothTable
	SELECT [rjiomc].[primaryKey], [rjiomc].[dataOwner]
	FROM [dbo].[TypeBOwner] oso INNER JOIN 
	(SELECT [iomc].[primaryKey], [iomc].[dataOwner]
	FROM @primaryKeyDataOwner iomc INNER JOIN [dbo].[TypeAOwner] rsr 
	ON [iomc].[dataOwner] = [rsr].[id] WHERE [rsr].[latest] = 1 AND [rsr].[active] = 1) AS rjiomc
	ON [rjiomc].[dataOwner] = [oso].[id] WHERE [oso].[latest] = 1 AND [oso].[active] = 1;

	DECLARE @newTypeBOwnerKey BIGINT;
	DECLARE @newTypeAOwnerKey BIGINT;
	DECLARE @deletedOwner PRIMARYKEY_DATAOWNER;

	WHILE EXISTS (SELECT * FROM #PKOwnerInBothTable)
	BEGIN
		DECLARE @primaryKey BIGINT = (SELECT TOP 1 [primaryKey] FROM #PKOwnerInBothTable)
		BEGIN TRANSACTION
			EXEC [dbo].[1sp_updateWithGivenType] @primaryKey = @primaryKey, @newType = @ownerAtype, 
				@newOwnerKey = @newTypeBOwnerKey OUTPUT; 
			EXEC [dbo].[1sp_updateWithGivenType] @primaryKey = @primaryKey, @newType = @ownerBtype, 
				@newOwnerKey = @newTypeAOwnerKey OUTPUT;

			UPDATE [dbo].[SubTableWhichUsesType]
			SET [comments] = 'PATCH-both-type'
			WHERE [primaryKey] IN (@newTypeBOwnerKey, @newTypeAOwnerKey)
		COMMIT

		INSERT INTO [Management].[dbo].[PATCH_Value]
		SELECT @newTypeBOwnerKey

		INSERT INTO [Management].[dbo].[PATCH_Value]
		SELECT @newTypeAOwnerKey

		INSERT INTO @deletedOwner(primaryKey, dataOwner) values (@primaryKey, (SELECT TOP 1 dataOwner FROM #PKOwnerInBothTable));

		DELETE #PKOwnerInBothTable WHERE [primaryKey] = @primaryKey
	END
SELECT * from @deletedOwner;
RETURN
END;