drop Table FixtureDatesChanges
create Table FixtureDatesChanges
	(dtChanged datetime, SectionID int, SectionSize int, WeekNo int, FixtureDate date, Rec char(1)
	,EventType varchar(30)
	,[Parameters] int 
	,EventInfo varchar(255)
	,LoginName varchar(255)
	,UserName varchar(255)
	)
