USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_CreateTables')
	DROP procedure EntryForm_CreateTables
GO

create procedure EntryForm_CreateTables

as

set nocount on

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Teams')
	DROP TABLE EntryForm_Teams

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Players')
	DROP TABLE EntryForm_Players

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Clubs')
	DROP TABLE EntryForm_Clubs

CREATE TABLE EntryForm_Clubs(
	ClubID int,
	[Club Name] varchar(50),
	Address1 varchar(50),
	Address2 varchar(50),
	PostCode char(8),
	ContactName varchar(104),
	ContactEMail varchar(250),
	ContactTelNo varchar(20),
	ContactMobNo varchar(20),
	MatchTables int,
	FeePaid bit,
	PrivacyAccepted bit
) 
CREATE TABLE EntryForm_Teams(
	ClubID int, 
	Team char(1),
	LeagueID int,
	Captain int
) 

CREATE TABLE EntryForm_Players(
	ClubID int, 
	PlayerID int,
	Forename varchar(50),
	Initials varchar(4),
	Surname varchar(50),
	Handicap int,
	LeagueID int,
	Team char(1),
	email varchar(250),
	TelNo varchar(20),
	Tagged tinyint,
	Over70 bit
)

GO

exec EntryForm_CreateTables