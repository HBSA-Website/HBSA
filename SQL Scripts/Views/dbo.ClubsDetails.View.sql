USE [HBSA]
GO

/****** Object:  View [dbo].[ClubsDetails]    Script Date: 05/09/2020 17:07:53 ******/
DROP VIEW [dbo].[ClubsDetails]
GO

/****** Object:  View [dbo].[ClubsDetails]    Script Date: 05/09/2020 17:07:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view	[dbo].[ClubsDetails]

as

select ID, [Club Name], Address1, Address2, PostCode, ContactName, ContacteMail, ContactTelNo,ContactMobNo,MatchTables
	from Clubs
	outer apply (select ContacteMail=eMailAddress 
					from ClubUsers
					where ID=ClubID)X
GO


