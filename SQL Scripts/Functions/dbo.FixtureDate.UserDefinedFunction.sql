USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixtureDate')
	drop function FixtureDate
GO

CREATE FUNCTION dbo.FixtureDate 
	(@HomeTeamID int
	,@AwayTeamID int
	)
RETURNS date --given the HomeTeam and AwayTeam IDs return the fixtureDate
AS
BEGIN

declare @FixtureDate date
       ,@StartYear int
       ,@SectionID int
select @SectionID=SectionID from Teams where ID=@HomeTeamID
select top 1 
	@StartYear=datepart(Year,FixtureDate) 
	from FixtureDates 
	where SectionID=@SectionID
	order by FixtureDate

select @FixtureDate=FixtureDate
	from Teams T
	
	Join FixtureGrids G
	  on G.SectionID=T.SectionID
	  
	join FixtureDates D
		on D.WeekNo=G.WeekNo
	   and D.SectionID = @SectionID
	   
	join Teams A --AwayTeam
	  on A.SectionID=T.SectionID
	 and A.FixtureNo=case when h1=T.FixtureNo then a1   
	                      when h2=T.FixtureNo then a2
	                      when h3=T.FixtureNo then a3
	                      when h4=T.FixtureNo then a4
	                      when h5=T.FixtureNo then a5
	                      when h6=T.FixtureNo then a6
	                      when h7=T.FixtureNo then a7
	                      when h8=T.FixtureNo then a8
	                 end     
   	 join Clubs C
   	   on C.ID=A.ClubID 
   	   
	where T.ID=@HomeTeamID
	  and   ((h1 = T.FixtureNo and a1 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h2 = T.FixtureNo and a2 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h3 = T.FixtureNo and a3 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h4 = T.FixtureNo and a4 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h5 = T.FixtureNo and a5 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h6 = T.FixtureNo and a6 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h7 = T.FixtureNo and a7 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h8 = T.FixtureNo and a8 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) )	         
	 and (@AwayTeamID=0 or A.ID=@AwayTeamID)

return @FixtureDate

END

GO

