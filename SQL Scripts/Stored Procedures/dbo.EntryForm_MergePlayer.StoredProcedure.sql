USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_MergePlayer')
	drop procedure EntryForm_MergePlayer
GO

--EntryID	TeamID	SectionID	FixtureNo	ClubID	Team	TelNo	Contact	eMail

CREATE procedure [dbo].[EntryForm_MergePlayer]
	(@PlayerID int      -- <= 0 insert new player
	,@ClubID int
	,@LeagueID int
	,@Team char(1)
	,@Forename varchar(50) 
	,@Inits varchar(4)     
	,@Surname varchar(50)  
	,@Handicap int
	,@eMail varchar(250)
	,@TelNo varchar(20)	
	,@Tagged int
	,@Over70 bit
	,@ReRegister bit
	)
as
set nocount on     
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
set xact_abort on

begin tran

if @PlayerID <= 0
	select @PlayerID=max(PlayerID)+1 from EntryForm_Players

if @ClubID = 0
	update EntryForm_Players 
		set ClubID=0
		where PlayerID=@PlayerID
else
	MERGE EntryForm_Players AS target
    USING (SELECT @PlayerID) AS source (PlayerID)
    
    ON (target.PlayerID  = source.PlayerID )
    
	WHEN MATCHED THEN 
        UPDATE SET
			 ClubID	  = @Clubid
			,LeagueID = @LeagueID	
			,Team	  = @Team
			,Forename = @Forename	
			,Initials = @Inits	
			,Surname  = @Surname	
			,Handicap = @Handicap	
			,email	  = @email	
			,TelNo	  = @TelNo	
			,Tagged	  = @Tagged	
			,Over70	  = @Over70
			,ReRegister = @ReRegister
					
    WHEN NOT MATCHED THEN    
		INSERT	(PlayerID	
				,ClubID	
				,LeagueID	
				,Team	
				,Forename	
				,Initials	
				,Surname	
				,Handicap	
				,email	
				,TelNo	
				,Tagged	
				,Over70	
				,ReRegister
				)
		values	(@PlayerID	
				,@ClubID
				,@LeagueID	
				,@Team	
				,@Forename	
				,@Inits	
				,@Surname	
				,@Handicap	
				,@email	
				,@TelNo	
				,@Tagged	
				,@Over70
				,@ReRegister
				)
		
		OUTPUT $action;

commit tran

GO

exec EntryForm_MergePlayer 268,43,1,'A','Lee','','Quarmby',-36,'lucyandleeq@hotmail.com','',0,0,0


select * from EntryForm_Players where PlayerID=268