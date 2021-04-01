USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_CreateTables')
	DROP procedure EntryForm_CreateTables
GO

create procedure EntryForm_CreateTables

as

set nocount on
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
set xact_abort on

begin tran

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Teams')
	DROP TABLE EntryForm_Teams

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Players')
	DROP TABLE EntryForm_Players

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Clubs')
	DROP TABLE EntryForm_Clubs

CREATE TABLE EntryForm_Clubs(
	ClubID int NOT NULL,
	[Club Name] varchar(50) NOT NULL,
	Address1 varchar(50),
	Address2 varchar(50),
	PostCode char(8),
	ContactName varchar(104),
	ContactTelNo varchar(20),
	ContactMobNo varchar(20),
	MatchTables int,
	WIP int,
	FeePaid bit,
	PrivacyAccepted bit
) 
CREATE TABLE EntryForm_Teams(
	ClubID int NOT NULL, 
	Team char(1) NOT NULL,
	LeagueID int NOT NULL,
	Captain int,
	TeamID int
) 

CREATE TABLE EntryForm_Players(
	PlayerID int NOT NULL,
	ClubID int, 
	LeagueID int,
	Team char(1),
	Forename varchar(50),
	Initials varchar(4),
	Surname varchar(50),
	Handicap int,
	email varchar(250),
	TelNo varchar(20),
	Tagged tinyint,
	Over70 bit,
	ReRegister bit
)

insert EntryForm_Clubs
			select *, 0, 0, 0 from Clubs 
	
insert EntryForm_Teams
			select   ClubID
					,Team
					,LeagueID
					,Captain
					,Teams.ID
				from Teams 
				join Sections on Sections.ID=SectionID
				join Clubs on Clubs.ID=ClubID
				where [Club Name]<>'bye'

insert EntryForm_Players
			select   Players.ID 
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
					,0 --set ReRegister off (until set on at the entry form)
				from Players 
				where ID > 0

if not exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='PaymentsHistory')
	select top 0 * into PaymentsHistory from Payments

insert PaymentsHistory 
	select P.* 
		from Payments P
		left join PaymentsHistory H
		       on P.DateTimePaid = H.DateTimePaid
			  and P.ClubID       = H.ClubID
			  and P.FineID       = H.FineID
			  and P.AmountPaid   = H.AmountPaid 
		where P.PaymentReason = 'League Entry Fee' 
		  and H.DateTimePaid is null

delete Payments
		from Payments P
		join PaymentsHistory H
		       on P.DateTimePaid = H.DateTimePaid
			  and P.ClubID       = H.ClubID
			  and P.FineID       = H.FineID
			  and P.AmountPaid   = H.AmountPaid 
		where P.PaymentReason = 'League Entry Fee' 

exec AllowLeaguesEntryForms

commit tran

GO

