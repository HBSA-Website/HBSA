USE [HBSA]
GO

if exists(select ROUTINE_NAME from information_schema.routines where ROUTINE_NAME='ClubEMailAddresses')
	drop procedure [dbo].[ClubEMailAddresses]
GO

create procedure [dbo].[ClubEMailAddresses]
	(@LeagueID  int = 0 
	,@SectionID int =  0
	)
as

set nocount on

declare @email varchar (255)
       ,@Club varchar(256)
       ,@emailList varchar(max)
	   ,@ClubList varchar(max)
set @emailList=''
set @ClubList=''
declare emailsCursor cursor fast_forward for
	select distinct [Club Name], ContactEMail 
		from ClubsDetails Clubs
		outer apply (select sectionID from Teams where ClubID = Clubs.ID) c
		cross apply (select LeagueID from Sections where Sections.ID=c.SectionID) l
		where isnull(ContactEmail,'') <> ''
		  and (@SectionID=0 or @SectionID=SectionID)
		  and (@leagueID=0 or @leagueID=leagueID)

open emailsCursor
fetch emailsCursor into @Club, @email
while @@fetch_status = 0
	begin
	set @emailList=@emailList +  @email + ';'
	set @ClubList=@ClubList + @Club + ', '
	fetch emailsCursor into  @Club, @email
	end
set @emailList=left(@emailList,len(@emailList)-1)
close emailsCursor
deallocate emailsCursor
select eMailList=@emailList, ClubsList=@ClubList

GO

exec [ClubEMailAddresses] 0.1

