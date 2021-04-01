create table #tBreaks
	(MatchResultID int
	,Breaks varchar(2000)
	,Forename1 varchar(50)
	,Surname1 varchar(50)
	,PlayerID1 int
	,Forename2 varchar(50)
	,Surname2 varchar(50)
	,PlayerID2 int
	,Forename3 varchar(50)
	,Surname3 varchar(50)
	,PlayerID3 int
	,Forename4 varchar(50)
	,Surname4 varchar(50)
	,PlayerID4 int
	)

insert #tBreaks
	select 
	  MB.MatchResultID, Homebreaks
     ,p1.Forename,p1.Surname,p1.id
     ,p2.Forename,p2.Surname,p2.id
     ,p3.Forename,p3.Surname,p3.id
     ,p4.Forename,p4.Surname,p4.id
	                                
	from matchBreaks MB
	join MatchResults MR
		on MatchResultID=MR.ID
	join PlayerDetails P1
		on HomePlayer1ID = P1.ID 
	join PlayerDetails P2
		on HomePlayer2ID = P2.ID 
	join PlayerDetails P3
		on HomePlayer3ID = P3.ID 
	left join PlayerDetails P4
		on HomePlayer4ID = P4.ID
	where HomeBreaks <> ''
insert #tBreaks
	select 
	  MB.MatchResultID, Awaybreaks
     ,p1.Forename,p1.Surname,p1.id
     ,p2.Forename,p2.Surname,p2.id
     ,p3.Forename,p3.Surname,p3.id
     ,p4.Forename,p4.Surname,p4.id
	                                
	from matchBreaks MB
	left join MatchResults MR
		on MatchResultID=MR.ID
	join PlayerDetails P1
		on AwayPlayer1ID = P1.ID 
	join PlayerDetails P2
		on AwayPlayer2ID = P2.ID 
	join PlayerDetails P3
		on AwayPlayer3ID = P3.ID 
	left join PlayerDetails P4
		on AwayPlayer4ID = P4.ID
	where AwayBreaks <> ''	
truncate table Breaks
insert breaks
select MatchResultID
		,case when Breaks like '%' + Surname1 + '%' and Breaks like '%' + LEFT(Forename1,1) + '%' then PlayerID1
		      when Breaks like '%' + Surname2 + '%' and Breaks like '%' + LEFT(Forename2,1) + '%' then PlayerID2
		      when Breaks like '%' + Surname3 + '%' and Breaks like '%' + LEFT(Forename3,1) + '%' then PlayerID3
		      when Breaks like '%' + Surname4 + '%' and Breaks like '%' + LEFT(Forename4,1) + '%' then PlayerID4 end
		,dbo.extract1stNumber(Breaks)
		
	from #tBreaks
drop table #tBreaks
select * from Breaks