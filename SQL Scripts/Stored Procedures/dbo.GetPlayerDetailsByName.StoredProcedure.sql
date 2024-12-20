USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetailsByName')
	drop procedure GetPlayerDetailsByName
GO

create procedure [dbo].[GetPlayerDetailsByName]
	(@SurnameOperator int
	,@Surname varchar(50)
	,@ForenameOperator int
	,@Forename varchar(50)
	,@LeagueID int = 0
	)

as 

set nocount on

declare @SurnameExpression varchar(52)
declare @ForenameExpression varchar(52)

if @Surname=''
	set @SurnameExpression='%%'
else 
	set @SurnameExpression= case when @SurnameOperator=0 then '%' + @Surname + '%'
                                 when @SurnameOperator=1 then @Surname + '%'
                                 when @SurnameOperator=2 then '%' + @Surname
                                 when @ForenameOperator=3 then @Surname
                            end     
if @Forename=''
	set @ForenameExpression='%%'
else 
	set @ForenameExpression= case when @ForenameOperator=0 then '%' + @Forename + '%'
                                 when @ForenameOperator=1 then @Forename + '%'
                                 when @ForenameOperator=2 then '%' + @Forename
                                 when @ForenameOperator=3 then @Forename
                            end     

--select  Forename, Initials, Surname, Handicap, [Club Name],Team,Played,Tagged,[Over70(80 Vets)]=Over70,email,TelNo
--      ,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID 
select  Forename,Initials,Surname,Handicap,[Club Name],Team,Played,Tagged,Over70,email,TelNo,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID
       ,dateRegistered,TeamEmail=isnull(TeamEmail,''),TeamID=isnull(TeamID,0),ClubEmail
	   ,fullName=dbo.FullPlayerName(Forename,Initials,Surname)
	from PlayerDetails P
	outer apply (select TeamEmail=eMail, TeamID=ID from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
	outer apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from clubsDetails where ID=P.ClubID)c  
	where Surname like @SurnameExpression
	  and Forename like @ForenameExpression  
	  and (@leagueID=0 or LeagueID=@LeagueID)
	
	order by LeagueID,SectionID,ClubID, Team


GO

