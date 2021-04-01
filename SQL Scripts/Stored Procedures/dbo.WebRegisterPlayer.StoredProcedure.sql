USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[WebRegisterPlayer]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



alter procedure [dbo].[WebRegisterPlayer]
	(@TeamID	int
	,@Forename	varchar(50)
	,@Initials	varchar(4)
	,@Surname	varchar(50)
	,@Handicap	integer	
	,@User		varchar(1024) = NULL
	,@eMail     varchar(1024) = NULL
	,@TelNo     varchar(20) = NULL)
as

set nocount on
set xact_abort on

declare
	 @LeagueID	Smallint
	,@SectionID  int
	,@ClubID	int
	,@Team		char(1)
	,@Tagged	tinyint
	,@Over70	bit

	,@ID int
	
begin tran

select  
		 @SectionID = SectionID
		,@ClubID	= ClubID
		,@Team		= Team
		,@Tagged	= 3
		,@Over70	= 0
	from Teams 
	where ID=@TeamID
select 
		 @LeagueID=LeagueID
	from Sections 
	where ID=@SectionID

insert Players 
		( Forename, Initials, Surname, Handicap, LeagueID, SectionID, ClubID, Team, Tagged, Over70, email, TelNo, Played, dateRegistered)
	values
		(@Forename,@Initials,@Surname,@Handicap,@LeagueID,@SectionID,@ClubID,@Team,@Tagged,@Over70,@eMail,@TelNo, 1,dbo.UKdateTime(getUTCdate()))

select @ID= SCOPE_IDENTITY()

insert ActivityLog values
	(dbo.UKdateTime(getUTCdate()),'Player registered from Web',@ID, isnull(@User,original_login()))

commit tran	

select @ID



GO
