USE HBSA
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('Competitions_EntryForms'))
	DROP TABLE Competitions_EntryForms

create table Competitions_EntryForms
	(ClubID int
	,CompetitionID int
	,EntrantID int
	,Entrant2ID int

	CONSTRAINT PK_Competitions_EntryForms primary key clustered
		(ClubID
		,CompetitionID
		,EntrantID
		)	
	)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('Competitions_EntryFormsClubs'))
	DROP TABLE Competitions_EntryFormsClubs

create table Competitions_EntryFormsClubs
	(ClubID int
	,WIP int
	,FeePaid bit
	,PrivacyAccepted bit
	)

GO
