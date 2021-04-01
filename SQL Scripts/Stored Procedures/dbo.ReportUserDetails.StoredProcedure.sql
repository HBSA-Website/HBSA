use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ReportUserDetails')
	drop procedure ReportUserDetails
GO

create procedure ReportUserDetails
	 (@ClubID int = 0
	 ,@Team char(1) = ''
	 ,@LeagueID int = 0
	 ,@UserType varchar(4) = 'Team'
	 ,@Confirmed varchar(16) = 'Both'
	 )
as

set nocount on

if @UserType='Team'
	select eMailAddress,[Password],Confirmed=convert(tinyint,case when Confirmed='Confirmed' then 1 else 0 end)
	      ,FirstName,[Surname],Telephone,TeamID,ID,[Club Name],Team,[League Name] 
		from ResultsUsers R
		cross apply (select ClubID, Team, SectionID from Teams where R.TeamID=ID) T
		cross apply (select [Club Name] from Clubs where T.ClubID=ID)C
		cross apply (select LeagueID from Sections where SectionID=ID) S
		cross apply (select [League Name] from Leagues where LeagueID=ID) L
	    where (@ClubID=0 or T.clubID=@ClubID)
		  and (@Team='' or Team=case when @Team='x' then '' else @Team end)
		  and (@LeagueID=0 or @LeagueID=LeagueID)
		  and Confirmed = case when @Confirmed = 'Both'      then Confirmed
		                       when @Confirmed = 'Confirmed' then 'Confirmed'
							                                 else case when Confirmed = 'Confirmed'  then '' else Confirmed end
                          end
		order by LeagueID, [Club Name], Team
else	   
	select eMailAddress,[Password],Confirmed=convert(tinyint,case when Confirmed='Confirmed' then 1 else 0 end)
	      ,FirstName,[Surname],Telephone,Clubid,ID=ClubID,[Club Name],Team='',[League Name]='' 
		from ClubUsers R
		cross apply (select [Club Name] from Clubs where R.ClubID=ID)C
	    where (@ClubID=0 or R.clubID=@ClubID)
		  and Confirmed = case when @Confirmed = 'Both'      then Confirmed
		                       when @Confirmed = 'Confirmed' then 'Confirmed'
							                                 else case when Confirmed = 'Confirmed'  then '' else Confirmed end
                          end
		order by [Club Name]

GO

exec ReportUserDetails 0,'',3,'club','Both'