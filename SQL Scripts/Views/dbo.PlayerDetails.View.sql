USE [HBSA]
GO

alter view PlayerDetails

as

select
       Forename, Initials, Surname, Handicap, [Club Name]=isnull([Club Name],'(Deleted)'),Team,Played,Tagged,Over70,email=isnull(email,''),TelNo=isnull(TelNo,'')
      ,[League Name],[Section Name]=isnull([Section Name],'(Deleted)'),LeagueID,SectionID,ClubID, p.ID, dateRegistered 
	from Players p
	cross apply (select [League Name] from Leagues where ID=LeagueID) l
	outer apply (select [Section Name] from Sections where ID=SectionID) s
	outer apply (select [Club Name] from Clubs where ID=ClubID) c
GO
