
select r1.id,r2.ID,r1.eMailAddress,r1.TeamID,t1.Team,r2.TeamID,t2.Team,t1.clubID,c1.[Club Name],t2.clubid,c2.[Club Name] 
	from ResultsUsers r1
	join ResultsUsers r2
	  on r1.eMailAddress = r2.eMailAddress
	 and r1.TeamID<>r2.TeamID 
	join Teams t1
	  on t1.ID=r1.TeamID
	join Teams t2
	  on t2.ID=r2.TeamID  
	join Clubs c1
	  on c1.ID=t1.ClubID
	join Clubs c2
	  on c2.ID=t2.ClubID
	where t1.SectionID between 1 and 6
	  and t2.SectionID between 1 and 6  
	  and c1.[Club Name] <> 'Bye'
	  and c2.[Club Name]<>'Bye'
	  and c1.ID<>c2.ID
	      
