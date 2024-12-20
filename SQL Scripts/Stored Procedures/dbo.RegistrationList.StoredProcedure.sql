USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[RegistrationList]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[RegistrationList]
as
set nocount on

select [League Name],[Section Name],FixtureNo,[Club Name],Team,
       Name=FirstName + ' ' + surname,eMailAddress,Telephone,
       Confirmed=case when Confirmed='Confirmed' then 'Yes' else 'No' end
		 from ResultsUsers u
         join Teams t on t.ID=u.TeamID
         join Sections s on t.SectionID=s.ID
         join Leagues l on s.LeagueID=l.ID
         join Clubs c on t.ClubID=c.id
order by l.ID,s.ID,FixtureNo

GO
