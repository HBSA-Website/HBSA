USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Competitions_EntrantsReport')
	drop procedure Competitions_EntrantsReport
GO

CREATE procedure Competitions_EntrantsReport 
	@CompetitionID int

as

set NoCount on

	select   Competition
	        ,[Entry Form Club]=coalesce(Clubs.[Club Name],L.[Club Name],M.[Club Name])
			,[Entrant(s)] = case when CompType = 4 then Clubs.[Club Name] + ' ' + T.Team
					                               else dbo.FullPlayerName(P.Forename,P.Initials,P.Surname) +
														case when CompType=2 then '(' + convert(varchar,P.Handicap) + ')' else '' end +
					                                    case when CompType=3 then '/' + dbo.FullPlayerName(P2.Forename,P2.Initials,P2.Surname) else '' end +
				                                        case when P.ClubID <> Clubs.ID then ' [' + L.[Club Name] + ']' else '' end
															
	                        end 
						
			,TelNo = case when CompType = 4 then T.TelNo
			                                else  coalesce(P.TelNo,Clubs.ContactTelNo + ' (Club TelNo)', clubs.ContactMobNo+' (Club Mobile)')
				     end
			,eMail = case when CompType = 4 then T.eMail
			                                else isnull( P.eMail,Clubs.ContactEMail+' (Club eMail)')
			         end

		From Competitions_EntryForms E
		cross apply (Select Competition = Name 
	                   ,CompType
					from Competitions 
					where ID=E.CompetitionID) C
		left join Players P
		  on P.ID=EntrantID
		left join Players P2
		  on P2.ID=Entrant2ID
	    left join teamsDetails T
		  on T.ID=EntrantID
	    outer apply (select top 1 * from ClubsDetails where ID=E.ClubID) Clubs -- OR ID=P.ClubID OR ID=P2.ClubID OR ID=T.ClubID) Clubs
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'') from Clubs where ID=  P.ClubID) L
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'') from Clubs where ID=  T.ClubID) M

		where CompetitionID=@CompetitionID
		order by  [Entrant(s)]

GO

 exec Competitions_EntrantsReport 1