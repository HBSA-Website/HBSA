create table BreaksCategories
	(LeagueID int
	,LowHandicap int
	,HighHandicap int
	,ID int identity (1,1)
	)
insert BreaksCategories select 1,-45, -24
insert BreaksCategories select 1,-23, -8
insert BreaksCategories select 1,-7, 8
insert BreaksCategories select 1,9, 24
insert BreaksCategories select 1,25, 45
insert BreaksCategories select 2,-45, 45
insert BreaksCategories select 3,-100,-35
insert BreaksCategories select 3,-34,34
insert BreaksCategories select 3,35,75
insert BreaksCategories select 3,76,130

select * from BreaksCategories
	
	