update a
	set a.Fixturedate=b.fixturedate 

from  Fixturedates a
join fixturedates b on b.sectionID=1 and b.weekno=a.weekno
where a.SectionID between 2 and 6

update a
	set a.StartDate=b.Startdate 
	   ,a.EndDate=b.EndDate 
from  FixtureDatesCurfew a
join FixtureDatesCurfew b on b.sectionID=1 
where a.SectionID between 2 and 6

update a
	set a.Fixturedate=b.fixturedate 

from  Fixturedates a
join fixturedates b on b.sectionID=7 and b.weekno=a.weekno
where a.SectionID between 7 and 9

update a
	set a.StartDate=b.Startdate 
	   ,a.EndDate=b.EndDate 
from  FixtureDatesCurfew a
join FixtureDatesCurfew b on b.sectionID=7 
where a.SectionID between 7 and 9



