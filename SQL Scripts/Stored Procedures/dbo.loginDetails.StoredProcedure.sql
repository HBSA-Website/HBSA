USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='loginDetails')
	drop procedure loginDetails
GO

CREATE procedure loginDetails
	(@eMailAddress varchar(255) = NULL
	,@TeamID       int = NULL
	,@ID           int = NULL
	)
as

set noCount on	

select eMailAddress
      ,[Password]
      ,Club=C.[Club Name]
      ,Team = T.Team
      ,Section = S.[Section Name]
      ,Confirmed=Confirmed
      ,League=L.[League Name]
      ,FirstName = ISNULL(Firstname,'')
      ,Surname=  ISNULL(Surname,'')
      ,Telephone = ISNULL(Telephone,'')
	  ,U.ID
	from Resultsusers U
	join Teams T on U.TeamID=T.ID
	join Clubs C on C.ID=T.ClubID
	join Sections S on S.ID=T.SectionID
	join Leagues L on L.ID=S.LeagueID
	
	where (eMailAddress=@eMailAddress and TeamID = @TeamID)
	   or U.ID=@ID
	order by case when Confirmed <> 'Confirmed' then Confirmed else '' end

GO
exec loginDetails 'gilbertp@outlook.com',27
exec loginDetails @ID=73
