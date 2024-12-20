USE [HBSA]
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='PasswordResets')
	drop table PasswordResets

CREATE TABLE [dbo].PasswordResets(
	eMailAddress varchar(155),
	TeamID int,
	dateRequested datetime
	CONSTRAINT [PK_PasswordResets] PRIMARY KEY CLUSTERED(
		[eMailAddress] ASC,
		[TeamID] ASC
	)
) 

GO
