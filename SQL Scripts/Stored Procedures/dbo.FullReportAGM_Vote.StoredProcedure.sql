USE [HBSA]
GO
if exists (select routine_Name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='FullReportAGM_Vote')
	drop procedure dbo.FullReportAGM_Vote
GO

CREATE procedure dbo.FullReportAGM_Vote
	(@ClubID int = 0
	,@Type int = 0 --0 = all votes, 1 = Votes Against, 2 = Votes For, 3 = Votes Witheld 
	)
as

set nocount on

create table #tmp
	(col1 varchar(1000)
	,col2 varchar(1000)
	,col3 varchar(1000)
	,col4 varchar(1000)
	,col5 varchar(1000)
	)
declare @ID int
       ,@ClubName varchar(50)
       ,@ContactDetails varchar(1000)

declare c cursor fast_forward for
	select distinct 
	    C.ID,
		[Club Name] ,
        ContactEMail + ', ' + case when ContactEMail <> eMailAddress then eMailAddress + ', ' else '' end +
		ContactMobNo + ', ' + ContactTelNo + 
		case when U.Telephone <> ContactMobNo and U.Telephone <> ContactTelNo then  + ', ' + U.Telephone else '' end
	from ClubsDetails C
	join AGM_Votes_Cast V on V.ClubID=ID
	cross apply (select top 1 * from Clubusers where ClubID=ID) U
	where (@ClubID = 0 or @ClubID = ID)
      and (@Type = 0 or (case when @Type = 1 then Against
                              when @Type = 2 then [For]
 		      			                     else Withheld
                         end) = 1)
open c
fetch c into @ID, @ClubName, @ContactDetails
while @@FETCH_STATUS=0
	begin
	insert #tmp select @ClubName, @ContactDetails,'','',''
	insert #tmp select '','<b>Resolution</b>','<b>For</b>','<b>Against</b>','<b>Withheld</b>'
	insert #tmp
	select  '', 
		Resolution, 
		[For] = case when [For]=1 then 'Y' else '' end, 
		Against = case when Against=1 then 'Y' else '' end, 
		Withheld = case when Withheld=1 then 'Y' else '' end

		from AGM_Votes_Cast V
		left join AGM_Votes_Resolutions R on R.ID = ResolutionID
		cross apply (select * from Clubs where ID=ClubID) C
		cross apply (select * from Clubusers where ClubID=V.ClubID) U
		where (@ID = V.ClubID)
  	      and (@Type = 0 or (case when @Type = 1 then Against
	                              when @Type = 2 then [For]
				      			                  else Withheld
                             end) = 1)

	insert #tmp select '','','','','' 	

	fetch c into @ID, @ClubName, @ContactDetails

	end
close c
deallocate c


select * from #tmp
drop table #tmp

GO
exec FullReportAGM_Vote 0, 3