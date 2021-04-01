USE [HBSA]
GO

/****** Object:  View [dbo].[EntryForm_ClubsDetails]    Script Date: 05/09/2020 17:07:28 ******/
DROP VIEW [dbo].[EntryForm_ClubsDetails]
GO

/****** Object:  View [dbo].[EntryForm_ClubsDetails]    Script Date: 05/09/2020 17:07:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view	[dbo].[EntryForm_ClubsDetails]

as

select ClubID, [Club Name], Address1, Address2, PostCode, ContactName, ContacteMail, ContactTelNo,ContactMobNo,MatchTables, WIP, FeePaid, PrivacyAccepted
	from EntryForm_Clubs
	outer apply (select ContacteMail=eMailAddress 
					from ClubUsers
					where ClubID=EntryForm_Clubs.ClubID)X
GO


