USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CompetitionEntrant')
	drop function CompetitionEntrant
GO

CREATE FUNCTION [dbo].[CompetitionEntrant] 
	(@EntrantID int
	,@Entrant2ID int
	,@CompType int
	)
RETURNS varchar(110)
AS
BEGIN

declare @Entrant varchar(255)

if @EntrantID is null 
	set @Entrant = 'Bye'
else
if @Comptype=4
	begin
	select
		@Entrant = [Club Name] + ' ' + Team
		from Teams
		outer apply (select [Club Name] from Clubs where ID=ClubID) C
		where ID=@EntrantID
	end
else
if @Comptype=3
	begin
	select
		@Entrant = dbo.FullPlayerName(Forename,Initials,Surname)+'/'+Player2+isnull(' ('+[Club Name]+')','')
		from Players P
		outer apply (select Player2=dbo.FullPlayerName(Forename,Initials,Surname) from Players where ID=@Entrant2ID) P2
		outer apply (select [Club Name] from Clubs where ID=P.ClubID) C
		where ID=@EntrantID
	end
else
if @Comptype=2
	begin
	select
		@Entrant = dbo.FullPlayerName(Forename,Initials,Surname)+isnull(' ('+[Club Name]+')','')
		from Players P
		outer apply (select [Club Name] from Clubs where ID=P.ClubID) C
		where ID=@EntrantID
	end
else
if @Comptype=1
	begin
	select
		@Entrant = dbo.FullPlayerName(Forename,Initials,Surname)+isnull(' ('+[Club Name]+')','')
		from Players P
		outer apply (select [Club Name] from Clubs where ID=P.ClubID) C
		where ID=@EntrantID
	end

return isnull(@Entrant,'')

END


GO

select dbo.CompetitionEntrant(1198,null,2)
select dbo.CompetitionEntrant(97,null,4)
