USE [HBSA]
GO
/****** Object:  View [dbo].[MatchResultsDetails3]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create view [dbo].MatchResultsDeletedDetails4

as

SELECT        *
FROM            (SELECT        *
                          FROM            MatchResults_Deleted
                          UNION
                          SELECT        *
                          FROM            Matchresults) M OUTER apply
                             (SELECT        HomePlayer1 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = HomePlayer1ID) h1 OUTER apply
                             (SELECT        HomePlayer2 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = HomePlayer2ID) h2 OUTER apply
                             (SELECT        HomePlayer3 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = HomePlayer3ID) h3 OUTER apply
                             (SELECT        HomePlayer4 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = HomePlayer4ID) h4 OUTER apply
                             (SELECT        AwayPlayer1 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = AwayPlayer1ID) a1 OUTER apply
                             (SELECT        AwayPlayer2 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = AwayPlayer2ID) a2 OUTER apply
                             (SELECT        AwayPlayer3 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = AwayPlayer3ID) a3 OUTER apply
                             (SELECT        AwayPlayer4 = Forename + CASE WHEN Initials <> '' THEN ' ' + Initials + '. ' ELSE ' ' END + Surname
                               FROM            Players
                               WHERE        ID = AwayPlayer4ID) a4 OUTER apply
                             (SELECT        Match = HC.[Club Name] + HT.Team + ' v ' + AC.[Club Name] + AT.Team + ' on ' + CONVERT(varchar(11), MatchDate, 113) + ' in ' + [League Name] + ' ' + S.[Section Name]
                               FROM            (SELECT        *
                                                         FROM            MatchResults_Deleted
                                                         UNION
                                                         SELECT        *
                                                         FROM            Matchresults) M2 JOIN
                                                         Teams HT CROSS apply
                                                             (SELECT        [Club Name]
                                                               FROM            Clubs
                                                               WHERE        ID = HT.ClubID) HC ON HT.ID = HomeTeamID JOIN
                                                         Teams AT CROSS apply
                                                             (SELECT        [Club Name]
                                                               FROM            Clubs
                                                               WHERE        ID = AT.ClubID) AC ON AT.ID = AwayTeamID JOIN
                                                         sections S ON S.ID = HT.SectionID JOIN
                                                         Leagues L ON L.ID = S.LeagueID
                               WHERE        M.ID = M2.ID) H
GO
select * from MatchResultsDeletedDetails4
