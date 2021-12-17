USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergePlayer')
	drop procedure MergePlayer
GO

create procedure MergePlayer
	(@ID		int
	,@Forename	varchar(50)
	,@Initials	varchar(4)
	,@Surname	varchar(50)
	,@Handicap	integer	
	,@LeagueID	Smallint
	,@SectionID  int
	,@ClubID	int
	,@Team		char(1)
	,@Tagged	tinyint
	,@Over70	bit
	,@Played	bit
	,@User		varchar(1024) = NULL
	,@eMail		varchar(250) = NULL
	,@TelNo     varchar(20) = NULL
	)
as

set nocount on
set xact_abort on

declare @mergedID int 

begin tran

merge
	Players as target
	using (Select @ID,@Forename,@Initials,@Surname,@Handicap,@LeagueID,@SectionID,@ClubID,@email,@TelNo,@Team,@Tagged,@Over70,@Played) as source
		         ( ID, Forename, Initials, Surname, Handicap, LeagueID, SectionID, ClubID, email, TelNo, Team, Tagged, Over70, Played)
	on target.ID=@ID
	when matched then
		update set Forename		=@Forename
		         , Initials		=@Initials
				 , Surname		=@Surname
				 , Handicap		=@Handicap
				 , LeagueID		=@LeagueID
				 , SectionID	=@SectionID
				 , ClubID		=@ClubID
				 , Team			=@Team
				 , Tagged		=@Tagged
				 , Over70		=@Over70
				 , Played		=@Played
				 , email		=@eMail
				 , TelNo		=@TelNo
				 
	when not matched then
		insert  
			( Forename, Initials, Surname, Handicap, LeagueID, SectionID, ClubID, Team, email, Telno, Tagged, Over70, Played, dateRegistered)
		values
			(@Forename,@Initials,@Surname,@Handicap,@LeagueID,@SectionID,@ClubID,@Team,@email,@Telno,@Tagged,@Over70,@Played, dbo.UKdateTime(getUTCdate()));

if @ID = 0
	select @mergedID= SCOPE_IDENTITY()
else
	select @mergedID = @ID
insert Activitylog values (dbo.UKdateTime(getUTCdate()),'Player merged from Admin',isnull(@mergedID,@ID),isnull(@User,original_login()))

select @mergedID

commit tran


GO
--exec MergePlayer
--     @ID		= 0
--	,@Forename	= 'Gavinyyyxxx'
--	,@Initials	= ''
--	,@Surname	= 'Petts'
--	,@Handicap	= -4
--	,@LeagueID	= 1
--	,@SectionID = 2
--	,@ClubID	= 15
--	,@Team		= ''
--	,@Tagged	= 3
--	,@Over70	= 0
--	,@Played	= 0
--	,@User		= 'Test'
--	,@eMail		= 'who@dom.com'
--	,@TelNo     = '07890032654'
--select top 1 * from Players order by ID desc