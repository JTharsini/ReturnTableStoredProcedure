CREATE PROCEDURE [dbo].[sp_handle_SubTypeDAfterADate]
@p1 datetime
AS
BEGIN
DECLARE @PKDayNoteOwner AS PRIMARYKEY_NOTEOWNER;
DECLARE @scheduleNoteOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeCommon');
DECLARE @scheduleNoteType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'entityType');
DECLARE @scheduleDayNoteType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'subTypeD');
DECLARE @scheduleNoteResOwnerType int = (SELECT [value] FROM dbo.TypeTable WHERE id = 'ownerTypeB');

--1. Day note and external type is note owner --> owner is resource type

INSERT INTO @PKDayNoteOwner(owner, noteOwner)
SELECT ptp.primaryKey, SUBSTRING(pte.common, 1, (SELECT CHARINDEX(':', pte.common)) - 1)
FROM dbo.[TypeUsingTableC] ptp INNER JOIN dbo.[TypeUsingTableD] pte 
ON pte.[owner]=ptp.primaryKey WHERE ptp.[type] = @scheduleNoteType AND ptp.subtype = @scheduleDayNoteType 
AND pte.[type] = @scheduleNoteOwnerType AND ptp.latest = 1 AND ptp.active = 1
AND created > CAST(@p1 AS date)
OPTION (FORCE ORDER, LOOP JOIN);

EXEC [dbo].[sp_handle_PrimaryKeyOwner] @primaryKeyNoteOwner = @PKDayNoteOwner, @newType = @scheduleNoteResOwnerType;
DELETE @PKDayNoteOwner;

END;
GO