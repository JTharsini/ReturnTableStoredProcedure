CREATE PROCEDURE [dbo].[sp_handle_SubTypeCAfterADate]
@p1 datetime
AS
BEGIN
DECLARE @scheduleNoteOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeCommon');
DECLARE @scheduleTimeNoteType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'subTypeC');
DECLARE @scheduleNoteType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'entityType');
DECLARE @scheduleNoteResOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeB');
DECLARE @scheduleNoteOfferOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeA');

--2. Time note and note owner id > max(offerId) --> owner is resource type

DECLARE @PKTimeNoteOwner AS PRIMARYKEY_NOTEOWNER;
DECLARE @PKOwnerMoreThanMaxServiceId AS PRIMARYKEY_NOTEOWNER;
DECLARE @maxOfferId BIGINT;

INSERT INTO @PKTimeNoteOwner(owner, noteOwner)
SELECT ptp.primaryKey, SUBSTRING(pte.common, 1, (SELECT CHARINDEX(':', pte.common)) - 1) AS noteOwner FROM dbo.[TypeUsingTableC] ptp INNER 
JOIN dbo.[TypeUsingTableD] pte ON pte.[owner]=ptp.primaryKey WHERE ptp.active=1 AND ptp.[type] = @scheduleNoteType 
AND ptp.active = 1 AND ptp.latest = 1 AND ptp.subtype = @scheduleTimeNoteType AND pte.[type] = @scheduleNoteOwnerType
AND created > CAST(@p1 AS date)
OPTION (FORCE ORDER, LOOP JOIN);

SET @maxOfferId = (SELECT TOP 1 id AS maxOfferId FROM dbo.OwnerTypeAData  WHERE latest = 1 ORDER BY CAST (id AS BIGINT) desc);

INSERT INTO @PKOwnerMoreThanMaxServiceId SELECT * FROM @PKTimeNoteOwner WHERE noteOwner > @maxOfferId;

DECLARE @returned1 AS PRIMARYKEY_NOTEOWNER;
insert @returned1
EXEC [dbo].[sp_handle_PrimaryKeyOwner] @primaryKeyNoteOwner = @PKOwnerMoreThanMaxServiceId, @newType = @scheduleNoteResOwnerType;
DELETE FROM @PKTimeNoteOwner SELECT * FROM @returned1;
DELETE @PKOwnerMoreThanMaxServiceId
DELETE FROM @returned1;

--------------------------------------------------------------------------------------------------------------------------------------------
--3. Time note and note owner id <= max(offerId) and note owner id is not in resource --> owner is service type

DECLARE @PKOwnerNotInResource TABLE (owner BIGINT, noteOwner VARCHAR(50));

INSERT INTO @PKOwnerNotInResource 
SELECT * FROM @PKTimeNoteOwner AS ioltms
WHERE NOT EXISTS (
    SELECT id FROM dbo.OwnerTypeBData rsr WHERE latest = 1 and subclass in (1,2,3) and ioltms.noteOwner = rsr.id
);

insert @returned1
EXEC [dbo].[sp_handle_PrimaryKeyOwner] @primaryKeyNoteOwner = @PKOwnerNotInResource, @newType = @scheduleNoteOfferOwnerType;
DELETE FROM @PKTimeNoteOwner SELECT * FROM @returned1;
DELETE @PKOwnerNotInResource;
DELETE FROM @returned1;

-------------------------------------------------------------------------------------------------------------------------------------
--4. Owner id is in both table
insert @returned1
EXEC [dbo].[sp_updateWhenOwnerInBothTable] @primaryKeyNoteOwner = @PKTimeNoteOwner, @resourceOwnerType = @scheduleNoteResOwnerType, @OfferOwnerType = @scheduleNoteOfferOwnerType;
DELETE FROM @PKTimeNoteOwner SELECT * FROM @returned1;
DELETE FROM @returned1;

-------------------------------------------------------------------------------------------------------------------------------------

--5. Time note and note owner id <= max(offerId) and note owner id might be in resource and not in both table --> owner is resource type
insert @returned1
EXEC [dbo].[sp_handle_PrimaryKeyOwner] @primaryKeyNoteOwner = @PKTimeNoteOwner, @newType = @scheduleNoteResOwnerType;
DELETE @returned1;

-----------------------------------------------------------------------------------------------------------------------------------------
END;
GO