USE [HBSA]
GO
if exists (select TABLE_NAME from INFORMATION_SCHEMA.tables where TABLE_NAME='ClubUsers')
	BEGIN
	DROP INDEX ClubIDUnique ON ClubUsers
	drop table ClubUsers
	END
GO
CREATE TABLE ClubUsers(
	[eMailAddress] [varchar](255) NOT NULL,
	[Password] [varchar](255) NOT NULL,
	[Confirmed] [varchar](10) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Telephone] [varchar](25) NULL,
	[ClubID] [int] NULL,
 CONSTRAINT [PK_ClubUsers] PRIMARY KEY CLUSTERED 
(
	[eMailAddress] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX ClubIDUnique ON ClubUsers
	(ClubID ASC)
GO

insert ClubUsers
    select distinct
	   Clubs.ContactEMail
      ,[Password]
	  ,Confirmed
	  ,FirstName
	  ,Surname
	  ,Telephone
	  ,Clubs.ID
	from Clubs
	cross apply (select top 1
				   [Password]
				  ,Confirmed
				  ,FirstName
				  ,Surname
				  ,Telephone
				from ResultsUsers 
	            where ContactEMail=eMailAddress) U
    where Confirmed = 'Confirmed'
	order by Clubs.ID
GO
--truncate table ClubUsers