USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayersByClubAndTeam]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetPlayersByClubAndTeam]
	 @SectionID int = 0
	,@ClubId int = 0
	,@Team char(1) = ''

as

set nocount on

select distinct
		 PlayerID=P.ID
		,T.SectionID
		,Player=rtrim(ltrim(Forename)) + case when isnull(rtrim(ltrim(Initials)),'')='' then ' ' else ' ' + rtrim(ltrim(Initials))+'. ' end + rtrim(ltrim(Surname))
			+ case when @SectionID=0 then ' (' + [League Name]+' '+ rtrim([Section Name])+')' else '' end
	from teams T
	cross apply (Select ID,Forename,Initials,Surname,Team from Players P where  P.ClubID=T.ClubID and P.SectionID=T.SectionID ) p
	cross apply (Select [Section Name],LeagueID from Sections where ID=T.SectionID) s  
	cross apply (select [League name] from Leagues where ID=S.LeagueID) l
	where (T.SectionID=@SectionID or @SectionID=0)
	  and (T.ClubID=@ClubId or @ClubId=0)
	  and (P.Team=@Team or @Team='')
	order by SectionID, Player

GO
