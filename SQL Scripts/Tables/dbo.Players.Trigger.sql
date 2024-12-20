USE [HBSA]
GO
/****** Object:  Trigger [dbo].[HandicapChange]    Script Date: 10/08/2020 18:07:01 ******/
if exists (select [name] from sysobjects where type = 'TR' and [name] = 'HandicapChange')
	drop trigger [dbo].[HandicapChange]
GO

create trigger [dbo].[HandicapChange]
   ON  [dbo].[Players]
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
		                isnull('; ' + P.email,'')

			from deleted
			cross apply (select Handicap, eMail, ClubID  from inserted where ID = deleted.ID) P
            outer apply (select ContactEMail from ClubsDetails where ID=P.ClubID) C
			outer apply (select ID from teams where ClubID=P.ClubID and SectionID=deleted.SectionID) T

			where P.Handicap <> deleted.Handicap

END

