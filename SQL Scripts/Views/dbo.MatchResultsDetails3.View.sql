USE [HBSA]
GO
/****** Object:  View [dbo].[MatchResultsDetails3]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[MatchResultsDetails3]

as

select * 
		,HomePoints=case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
					case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
					case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
			        case when HomePlayer4Score is null then 0 else case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end end
		,AwayPoints=case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
					case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
					case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
			        case when HomePlayer4ID =0 then 0 else case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end end

from Matchresults
GO
select * from MatchResultsDetails3
