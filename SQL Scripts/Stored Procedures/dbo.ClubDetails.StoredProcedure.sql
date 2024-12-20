USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ClubDetails')
	drop procedure ClubDetails
GO

create procedure ClubDetails
	(@ID as integer
	,@forMobile bit = 0
	)
as

set nocount on

if (select PrivacyAccepted from EntryForm_Clubs where ClubID=@ID) = 0
	begin	
	select Club	= isnull([Club Name],'')
		  ,Contact= '(Privacy policy not accepted)'
				from Clubs 
				where ID = @ID
	select TOP 0 
	   League=[League Name]
	  ,Team
      ,Section=[Section Name]
	  ,Contact=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')
	from TeamsDetails 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	
	select TOP 0 
	   Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
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

	end
else
	begin
	select Club, Contact
	 from (
			select   Seq=1
					 ,Club	= isnull([Club Name],'')
					,Contact= isnull(ContactName,'')
				from Clubs 
				where ID = @ID
			union
			select   Seq=2
					 ,Club	= isnull(Address1,'')
					,Contact= isnull(ContactEmail,'')
				from ClubsDetails 
				where ID = @ID
			union
			select   Seq=3
					 ,Club	= isnull(Address2,'')
					,Contact= isnull(ContactTelNo,'')
				from Clubs 
				where ID = @ID
			union
			select    Seq=4
					 ,Club	= isnull(PostCode,'')
					,Contact= isnull(ContactMobNo,'')
				from Clubs 
				where ID = @ID
			union
			select    Seq=5
					 ,Club	= 'Available Tables:'
					,Contact= isnull(convert(varchar,MatchTables),'')
				from Clubs 
				where ID = @ID
				) ClubAndContact
	order by Seq
	
	if @forMobile = 0
		select League=[League Name]
			  ,Team
			  ,Section=[Section Name]
			  ,Captain=isnull(Contact,'')
			  ,eMail=isnull(eMail,'')
			  ,TelNo=isnull(TelNo,'')
			from TeamsDetails 
		join Sections on Sections.ID=SectionID
		join Leagues on Leagues.ID=LeagueID
		WHERE ClubID=@ID 
		order by LeagueID,Team
	else
		select TeamsDetails.ID
			  ,League=[League Name]
			  ,Team
			  ,Section=[Section Name]
			  ,Captain=isnull(Contact,'')
			  ,eMail=isnull(eMail,'')
			  ,TelNo=isnull(TelNo,'')
			from TeamsDetails 
		join Sections on Sections.ID=SectionID
		join Leagues on Leagues.ID=LeagueID
		WHERE ClubID=@ID 
		order by LeagueID,Team

	if @forMobile = 0
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
	else
		select Players.ID,Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
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

	end
GO

exec ClubDetails 31,1