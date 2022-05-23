USE HBSA
GO
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DownloadHandicaps')
	drop procedure dbo.DownloadHandicaps
go

create procedure dbo.DownloadHandicaps

as

set nocount on

select PlayerID, Effective=convert(varchar(11), max(Effective), 113)  
	into #RecordSelector
	from HandicapsReportTable
	group by PlayerID

select H.PlayerID
      ,Player
	  --,[Handicap Effective from] = convert(varchar(11), max(H.Effective), 113)
	  ,Handicap
	  ,[Unseasoned Status] = case when Tagged = 0 then 'Seasoned'
                                  when Tagged = 3 then 'Unseasoned'
	                              when Tagged = 2 then '2 Seasons to go'
				                  when Tagged = 1 then '1 Season to go'							 
							  end
	  ,[League Name]
	from HandicapsReportTable H
	join #RecordSelector R 
	  on H.PlayerID=R.PlayerID
     and H.Effective=R.Effective
	cross apply (select Player = dbo.FullPlayerName(Forename, Initials, Surname)
	                 from Players
					 where ID = H.PlayerID) P
	cross apply (Select LeagueID from Sections where ID = H.SectionID) S
	cross apply (Select [League Name] from Leagues where ID=S.LeagueID ) L
--    where H.PlayerID=29
	group by H.PlayerID
		    ,Player
		    ,Handicap
	        ,Tagged
			,[League Name]
	order by max(LeagueID)
           , Player	

GO
exec DownloadHandicaps
