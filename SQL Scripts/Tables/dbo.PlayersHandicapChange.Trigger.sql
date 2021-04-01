use hbsa
go

if exists (select name from sysobjects where name = 'HandicapChange')
	drop trigger HandicapChange
GO

create TRIGGER HandicapChange
   ON  Players
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--log changes to handicaps
	Insert PlayersHandicapChanges
		select getdate(),deleted.ID, deleted.Handicap,P.Handicap

        	  ,eMails = isnull(C.ContactEMail + isnull('; ' + dbo.eMailsForTeamUsers(T.ID),''),'') +
		                isnull('; '+T.eMail,'') +
		                isnull('; '+P.email,'')

			from deleted
			cross apply (select Handicap, eMail, ClubID  from inserted where ID = deleted.ID) P
            outer apply (select ContactEMail from Clubs where ID=P.ClubID) C
			outer apply (select ID, eMail from teams where ClubID=P.ClubID and SectionID=deleted.SectionID) T

			where P.Handicap <> deleted.Handicap

END
GO

select * from PlayersHandicapChanges 

