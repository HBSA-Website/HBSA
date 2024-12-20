USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDates]    Script Date: 12/12/2014 17:46:00 ******/
If exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetFixtureDates')
	drop procedure dbo.GetFixtureDates
GO

CREATE procedure [dbo].[GetFixtureDates] 
	 @TeamID int
as

set nocount on

declare @StartYear int
       ,@SectionID int
select @SectionID=SectionID from Teams where ID=@TeamID
select top 1 
	@StartYear=datepart(Year,FixtureDate) 
	from FixtureDates 
	where SectionID=@SectionID
	order by FixtureDate

declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=@SectionID

select D.WeekNo, [Date]=convert(varchar(11),FixtureDate,113)
      ,AwayTeamID=A.ID, AwayTeam=C.[Club Name] + ' ' + A.Team
	  ,HalfWay=convert(bit,case when FixtureDate > (select Fixturedate from FixtureDates where SectionID=@SectionID and weekNo = SectionSize-1) then 1 else 0 end)
	from Teams T
	
	Join FixtureGrids G
	  on G.SectionID=T.SectionID
	  
	join FixtureDates D
		on D.SectionID = @SectionID
	   and case when D.WeekNo % @MatrixSize = 0 then @MatrixSize else D.WeekNo % @MatrixSize end=G.WeekNo  
	   
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
   	   
	where T.ID=@TeamID
	  and   ((h1 = T.FixtureNo and a1 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h2 = T.FixtureNo and a2 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h3 = T.FixtureNo and a3 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h4 = T.FixtureNo and a4 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h5 = T.FixtureNo and a5 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h6 = T.FixtureNo and a6 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h7 = T.FixtureNo and a7 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h8 = T.FixtureNo and a8 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) )	         

	order by D.WeekNo

GO

exec getfixturedates 1339
