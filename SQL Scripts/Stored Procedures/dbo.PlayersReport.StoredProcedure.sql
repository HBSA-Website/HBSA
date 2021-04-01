USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[NonActivePlayers]    Script Date: 04/30/2014 10:22:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NonActivePlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[NonActivePlayers]
GO

USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[NonActivePlayers]    Script Date: 04/30/2014 10:22:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[NonActivePlayers]
	(@SectionID int = 0
	,@ClubID int = 0
	,@Team char(1) = ''
	,@PlayerID int = 0
	,@Tagged bit = 0
	,@Over70 bit = 0
	,@Played bit = null
	)

as

set nocount on	


select P.ID,Section=([League Name] + ' ' + [Section Name])
      ,Team=[Club Name] + ' ' + Team
      ,Name=Forename + case when isnull(Initials,'')='' then ' ' else ' '+Initials+', ' end + Surname 
      ,Handicap
      ,Tagged=case when (convert(tinyint,Tagged))=1 then 'Yes' else '' end
      ,[Over70(80 Vets)]=case when (convert(tinyint,Over70))=1 then 'Yes' else '' end

	from Players P
	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c

	where (@Played is null or @Played=Played)
	  and (@SectionID = 0 or @SectionID = SectionID)
	  and (@Team = ''     or @Team = Team)
	  and (@PlayerID = 0  or @PlayerID = P.ID)
	  and (@Tagged = 0    or @Tagged = Tagged)
	  and (@Over70 = 0    or @Over70 = Over70)
	  and P.ID >=0

	order by SectionID, [Club Name] + ' ' + Team, Name


GO

exec NonActivePlayers @Played=1

