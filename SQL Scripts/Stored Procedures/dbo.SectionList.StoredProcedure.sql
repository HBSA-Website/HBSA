USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SectionList')
	drop procedure SectionList
GO

CREATE procedure SectionList
	 @SectionID int = NULL
	,@LeagueID int = NULL
	,@IncludeBye bit = 0

as

set nocount on

select top 0 * into #tmp
	from TeamsDetails 
	cross apply (select [Club Name]=convert(varchar(2000),[Club Name]),ContactTelNo, ContactMobNo from Clubs c where ID=ClubID) c

if @sectionID is not null
	insert #tmp 
		select *
			from TeamsDetails 
			cross apply (select [Club Name]=[Club Name]  + ' ' + Team + 
			                                    case when Address1 is null then '' else ', ' + Address1 end + 
												case when Address2 is null then '' else ', ' + Address2 end + 
												case when PostCode is null then '' else ', ' + PostCode end
								,ContactTelNo=replace(ContactTelNo,' ','')
								,ContactMobNo=replace(ContactMobNo,' ','')
							from Clubs c 
							where ID=ClubID) c

		where SectionID = @SectionID
		order by FixtureNo
else
	insert #tmp 
		select *
			from TeamsDetails 
			cross apply (select [Club Name]=[Club Name]  + ' ' + Team +  
			                                    case when Address1 is null then '' else ', ' + Address1 end + 
												case when Address2 is null then '' else ', ' + Address2 end + 
												case when PostCode is null then '' else ', ' + PostCode end
								,ContactTelNo=replace(ContactTelNo,' ','')
								,ContactMobNo=replace(ContactMobNo,' ','')
							from Clubs c 
							where ID=ClubID) c

		where SectionID IN  (select ID from Sections where LeagueID=@LeagueID)
	
		order by SectionID, FixtureNo

alter table #tmp add Players varchar(4000)

--select ID, SectionID, ClubID, Team from #tmp

declare c cursor fast_forward for
select ID, SectionID, ClubID, Team from #tmp
declare @ID int, @SectnID int, @ClubID int, @Team char(1)
declare @PlayerList varchar(2000)

open c
fetch c into @ID, @SectnID, @ClubID, @Team
while @@fetch_status = 0
	begin
	
	declare d cursor fast_forward for
		select Forename + ' ' + case when Initials = '' then '' else Initials + ' ' end + Surname + ' ' +
	  	   convert(varchar,Handicap) + 
	  	   case when Tagged>0 then ' *' else '' end +
	  	   case when over70 =1 then ' F' else '' end
			from Players 
			where SectionID=@SectnID
			  and ClubID=@ClubID 
			  and Team=@team
			  and Surname not like '%Deceased%'
		   order by Forename + ' ' + case when Initials = '' then '' else Initials + ' ' end + Surname
	open d
	fetch d into @PlayerList
	while @@fetch_status=0
		begin
		update #tmp set Players = isnull(Players,'') + @PlayerList + ', '	where ID=@ID

		fetch d into @PlayerList
		end
	close d
	deallocate d
	update #tmp set Players = left(Players,Len(Players)-1) where ID=@ID
	fetch c into @ID, @SectnID, @ClubID, @Team
	end

close c
deallocate c	

if @sectionID is not null
	begin
	if @IncludeBye=1
		select [ ]=FixtureNo, [Club/Team]= replace([Club Name],'  , , ,         ',''),  --get rid of null address in Bye
		       ClubTelNo = isnull(ContactTelNo,''), TeamTelNo = case when isnull(TelNo,'')='' then isnull(ContactMobNo,'') else TelNo end, Players--, T.ID
			from #tmp T
			order by FixtureNo				  
	else
		select [ ]=FixtureNo, [Club/Team]= [Club Name], 
		       ClubTelNo = isnull(ContactTelNo,''), TeamTelNo = case when isnull(TelNo,'')='' then isnull(ContactMobNo,'') else TelNo end, Players--, T.ID
			from #tmp T
			where [Club Name] not like 'Bye%'	
			order by [Club Name]					  
	end
else
	select [ ]=FixtureNo, [Section]=s.[Section Name],[Club/Team]= replace([Club Name],'  , , ,         ','') , --get rid of null address in Bye
	       ClubTelNo = isnull(ContactTelNo,''), TeamTelNo = case when isnull(TelNo,'')='' then isnull(ContactMobNo,'') else TelNo end, Players--, T.ID
		from #tmp T
		outer apply (select [Section Name]
		                from Sections		
		                where ID=T.SectionID) s
		where (@IncludeBye=1 or [Club Name] not like 'Bye%'	)

		order by SectionID, [Club Name]

drop table #tmp


GO

exec SectionList 8

