USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[ClubRecord]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ClubRecord')
	drop procedure [dbo].ClubRecord
GO

create procedure [dbo].ClubRecord
	(@ID as integer
	)
as

set nocount on

select ID
      ,[Club Name]=isnull([Club Name],'')
	  ,Address1=isnull(Address1,'')
	  ,Address2=isnull(Address2,'')
	  ,PostCode=isnull(PostCode,'')
	  ,ContactName=isnull(ContactName,'')
	  ,ClubLoginEMail=isnull(ContactEMail,'')
	  ,ContactTelNo=isnull(ContactTelNo,'')
	  ,ContactMobNo=isnull(ContactMobNo,'')
	  ,Matchtables

	 from ClubsDetails
	 
	 where ID=@ID

	 select Team,League=[League Name],Section=[Section Name]
	from Teams 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	order by LeagueID,Team
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
      ,handicap
	  ,League=[League Name],Section=[Section Name]
      ,Tagged=case when Tagged=3 then 'Unseasoned'
	               when Tagged=2 then '2 Seasons to go'
				   when Tagged=1 then '1 Season to go'
				                 else ''
			  end 
	  ,[Over70(80 Vets)]=Over70,[Played this season]=Played, eMail=isnull(eMail,''), TelNo=isnull(TelNo,'')
	from Players 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=Players.LeagueID
	where ClubID=@ID
	order by Players.LeagueID,Team, Forename,surname

Select * from Teams where ClubID=@ID
	
Select * from Players where ClubID=@ID


GO
