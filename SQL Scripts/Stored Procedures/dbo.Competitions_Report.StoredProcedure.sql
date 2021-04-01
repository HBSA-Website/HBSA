USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Competitions_Report')
	drop procedure Competitions_Report
GO

CREATE procedure Competitions_Report
	(@ClubID int
	)
as

set nocount on

if @ClubID=0
	begin
	exec Competitions_ReportAll
	return
	end

declare @Report table
	(Competition varchar(256)
	,[Entrant(s)] varchar(256)
	,TelNo varchar(20)
	,eMail varchar(256)
	,EntryFee varchar(10)
	)
create table #Comp 
		(ID int identity(0,1)
		,line varchar(256)
		)

create table #Entrants 
		(ID int identity(0,1)
		,[Entrant(s)] varchar(600)
		,TelNo varchar(20)
		,eMail varchar(256)
		,EntryFee decimal (5,2)
		) 

--insert @Report
--	select 'Entry form for',[Club Name] + ' (' + dbo.EntryForm_State(WIP) + ')','TelNo','eMail','Fee' 
--		from Clubs 
--		cross apply (Select WIP from Competitions_EntryFormsClubs where ClubID=@ClubID) x
--		where ID=@ClubID

declare @CompetitionID int
declare CompetitionIDs_cursor cursor fast_forward for
	select distinct CompetitionID 
		from Competitions_EntryForms
		where ClubID=@ClubID
		order by CompetitionID

open CompetitionIDs_cursor
fetch CompetitionIDs_cursor into @CompetitionID
while @@fetch_status=0
	begin

	insert #Comp 
		select '<b>'+name+'</b>' From Competitions where ID=@CompetitionID
	insert #Comp 
		select 'Entry Fee £' + convert(varchar,EntryFee) From Competitions where ID=@CompetitionID

	declare @Comment varchar(256)
	select @Comment=Comment From Competitions where ID=@CompetitionID
	declare @ix int, @iy int
	set @ix=0
	while @ix < len(@Comment)
		begin
		set @iy = charindex(char(13)+char(10),@Comment,@ix)
		if @iy > 0
			begin
			insert #Comp select substring(@comment,@ix,@iy-@ix)
			set @ix=@iy+2
			end
		else
			begin
			insert #Comp select substring(@comment,@ix,len(@Comment)-@ix+1)
			set @ix=len(@Comment)
			end
	end

	insert #Entrants 
		select NULL,NULL,NULL,NULL
	insert #Entrants
	select   [Entrant(s)] = case when CompType = 4 then Clubs.[Club Name] + ' ' + T.Team
					                               else dbo.FullPlayerName(P.Forename,P.Initials,P.Surname) +
														case when CompType=2 then '(' + convert(varchar,P.Handicap) + ')' else '' end +
					                                    case when CompType=3 then '/' + dbo.FullPlayerName(P2.Forename,P2.Initials,P2.Surname) else '' end +
				                                        case when P.ClubID <> @ClubID then ' [' + L.[Club Name] + ']' else '' end
															
	                        end 
			,TelNo = case when CompType = 4 then T.TelNo
			                                else P.TelNo
				     end
			,eMail = case when CompType = 4 then T.eMail
			                                else P.eMail
			         end

			,EntryFee
		From Competitions_EntryForms E
		cross apply (Select Competition = Name 
	                   ,CompType
					   ,EntryFee
					   ,LeagueID
					from Competitions 
					where ID=E.CompetitionID) C
		left join Players P
		  on P.ID=EntrantID
		left join Players P2
		  on P2.ID=Entrant2ID
	    left join Clubs 
		  on Clubs.ID=E.ClubID
	    left join teamsDetails T
		  on T.ID=EntrantID
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'')
						from Clubs 
						where ID=  P.ClubID) L

		where CompetitionID=@CompetitionID
		  and E.ClubID=@ClubID
		order by CompetitionID
		        ,case when P.LeagueID=C.LeagueID then 0 else P.LeagueID end
				,P.Surname, T.Team

	if (select count(*) from #Comp) > (select count(*) from #Entrants)
		insert @Report
			select CompetitionIDs_cursor.line, E.[Entrant(s)], TelNo,eMail,EntryFee 
				from #Comp CompetitionIDs_cursor 
				left join #Entrants E on CompetitionIDs_cursor.ID=E.ID
	else
		insert @Report
			select CompetitionIDs_cursor.line, E.[Entrant(s)], TelNo,eMail,EntryFee 
				from #Entrants E
				left join #Comp CompetitionIDs_cursor on CompetitionIDs_cursor.ID=E.ID
	truncate table #Entrants
	truncate table #Comp

	fetch CompetitionIDs_cursor into @CompetitionID
	end

close CompetitionIDs_cursor
deallocate CompetitionIDs_cursor

select Competition,[Entrant(s)],TelNo,eMail
		,EntryFee= case when isnumeric(EntryFee)=1 then '£' +  convert(varchar,entryFee) else EntryFee end
	from @Report

drop table #Comp
drop table #Entrants

GO

exec Competitions_Report 43