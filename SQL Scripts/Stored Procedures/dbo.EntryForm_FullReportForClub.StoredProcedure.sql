USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_FullReportForClub')
	DROP procedure EntryForm_FullReportForClub
GO

create procedure EntryForm_FullReportForClub
	(@ClubID int
	)
as

set nocount on

declare @Report table
	(Seq int identity(1,1)
	,Col1 varchar(1000)
	,Col2 varchar(1000)
	,Col3 varchar(1000)
	,Col4 varchar(1000)
	,Col5 varchar(1000)
	,Col6 varchar(1000)
	,Col7 varchar(1000)
	,Col8 varchar(1000)
	)
insert @Report
	select 'Club Name', [Club Name],'Contact',ContactName,'',''
	      ,case when Feepaid= 1 then 'Fee Paid' else 'Fee NOT paid' end
		  , case when PrivacyAccepted=1 then 'Privacy accepted' else 'Privacy NOT accepted' end
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'Address 1', Address1,'eMail',ClubLoginEMail=ContactEMail,'','','',''
		from EntryForm_ClubsDetails TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'Address 2', Address2,'Tel',ContactTelNo,'','','',''
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'Post Code', PostCode,'Mobile',ContactMobNo,'','','',''
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'No Of Tables', MatchTables,'','','','','',''
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID

declare TeamsCursor cursor fast_forward for
	select Team, LeagueID, TelNo, Contact, eMail, [League Name]
		from EntryForm_TeamDetail T
		join Leagues on ID=LeagueID 
		where T.ClubID = @ClubID
		order by LeagueID,Team
declare @LeagueID int
       ,@Team char(1)
	   ,@TelNo varchar(20)
       ,@Contact varchar (104)
	   ,@eMail varchar(255)
	   ,@LeagueName varchar(50)

	   ,@StartSeq int

open TeamsCursor
fetch TeamsCursor into @Team, @LeagueID, @TelNo, @Contact, @eMail,@LeagueName
while @@fetch_status = 0
	begin

	insert @Report values ('','','','','','','','')
	select @StartSeq=max(seq)+2 from @Report
	
	insert @Report
		select 'League',@LeagueName,'Player','Handicap','Tag',case when @LeagueID=2 then 'Over80' else 'Over70' end,'eMail','TelNo'
	insert @Report
		select 'Team',@Team,'','','','','',''
	insert @Report
		select 'Contact',@Contact,'','','','','',''
	insert @Report
		select 'eMail',@eMail,'','','','','',''
	insert @Report
		select 'TelNo',@TelNo,'','','','','',''
	
	declare @player varchar (104)
	       ,@HCap varchar (5)
		   ,@Tag varchar(16)
		   ,@Over70 varchar(1)
		   ,@pEMail varchar(255)
		   ,@pTelNo varchar(20)

		   ,@SeqNo int
	declare PlayerssCursor cursor fast_forward for
		select dbo.FullPlayerName(Forename,Initials,Surname)
		      ,convert(varchar,Handicap)
			  ,dbo.TagDescription(Tagged)
			  ,case when Over70=1 then 'Y' else '' end
			  ,email
			  ,TelNo
			from EntryForm_Players
			where ClubID=@ClubID
			  and LeagueID=@LeagueID
			  and Team=@Team
			  and ReRegister = 1
	open PlayerssCursor
	fetch PlayerssCursor into @Player,@HCap,@tag,@Over70,@eMail,@TelNo
	set @SeqNo=	@StartSeq	  	   
	while @@Fetch_status=0
		begin
		If @SeqNo-@StartSeq < 4
			update @Report
				set col3=@Player,col4=@Hcap,col5=@tag,col6=@Over70,col7=@eMail,col8=@TelNo
				where seq=@SeqNo
		else
			insert @Report
				select '','',@Player,@HCap,@tag,@Over70,@eMail,@TelNo

		fetch PlayerssCursor into @Player,@HCap,@tag,@Over70,@eMail,@TelNo
		set @SeqNo=@SeqNo+1

		end

		close PlayerssCursor
		deallocate PlayerssCursor


	fetch TeamsCursor into @Team, @LeagueID, @TelNo, @Contact, @eMail, @LeagueName

	end

close TeamsCursor
deallocate TeamsCursor

select col1,col2,col3,col4,col5,col6,col7,col8 
	From @Report
	order by seq

GO

--exec EntryForm_FullReportForClub 43