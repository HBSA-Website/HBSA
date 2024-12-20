USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Award_Recipient')
	drop function Award_Recipient
GO

CREATE FUNCTION dbo.Award_Recipient 
	(@EntrantID int
	,@Entrant2ID int
	,@RecipientType varchar(15)
	,@AwardType int
	)
RETURNS varchar(255)
AS
BEGIN

declare @Entrant varchar(255)

if @RecipientType = 'Player'
	select
		@Entrant = dbo.FullPlayerName(Forename,Initials,Surname)+case when @AwardType=4 or @AwardType=3 then ' ' + convert(varchar,@Entrant2ID) else isnull('/'+Player2,'') end + isnull(' ('+[Club Name]+')','')
		from Players P
		outer apply (select Player2=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=@Entrant2ID) P2
		outer apply (select [Club Name] from Clubs where ID=P.ClubID) C
		where ID=@EntrantID
else
if @RecipientType = 'Team'
	select
		@Entrant = [Club Name] + ' ' + Team
		from Teams
		outer apply (select [Club Name] from Clubs where ID=ClubID) C
		where ID=@EntrantID


return isnull(@Entrant,'')

END

GO

select dbo.Award_Recipient(1198,4,'Player',2)
select dbo.Award_Recipient(1198,null,'Player',1)
select dbo.Award_Recipient(97,null,'Team')
select dbo.Award_Recipient(97,null,'other',3)
