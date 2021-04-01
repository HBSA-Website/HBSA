drop table JuniorLeagues
drop table JuniorResults
go
Create table JuniorLeagues
	(Division int
	,Entrant varchar(250)
	,Club varchar(250)
	,Points int)
Create table JuniorResults
	(ID int identity(1,1)
	,Division int
	,HomePlayer varchar(250)
	,AwayPlayer varchar(250)
	,HomeFrame1 int
	,AwayFrame1 int
	,HomeFrame2 int
	,AwayFrame2 int
	,HomeFrame3 int
	,AwayFrame3 int
	)
go
insert JuniorLeagues select 1, 'Connor Kelly	','Deighton WMC',	3
insert JuniorLeagues select 1, 'Cameron Stansfield	','Lindley BC',	0
insert JuniorLeagues select 1, 'David Dunne	','Deighton WMC',	0
insert JuniorLeagues select 1, 'Jake Read	','Lindley WMC',	0
insert JuniorLeagues select 2, 'James Moss	','Slaithwaite Con',	0
insert JuniorLeagues select 2, 'Levi Hardy	','Deighton WMC',	0
insert JuniorLeagues select 2, 'Kian Collins	','Bradley & Colne WMC',	0
insert JuniorLeagues select 2, 'Rhys Kelly	','Deighton WMC',	0
insert JuniorLeagues select 3, 'Oliver Read	','Lindley WMC',	0
insert JuniorLeagues select 3, 'Ciaran Gledhill	','Deighton WMC',	0
insert JuniorLeagues select 3, 'Callum Weir	','Bradley& Colne WMC',	0
insert JuniorLeagues select 3, 'Nathan Haigh	','Meltham Lib',	0
insert JuniorLeagues select 4, 'Josh Dyson	','Canalside',	0
insert JuniorLeagues select 4, 'Jordan Glover	','Deighton WMC',	1
insert JuniorLeagues select 4, 'Jordan Williams	','Meltham Lib',	2
insert JuniorLeagues select 4, 'Luke Jones	','Meltham Lib',	0
go
insert JuniorResults select 1,'Connor Kelly','Cameron Stansfield',null,null,null,null,null,null						
insert JuniorResults select 1,'David Dunne','Connor Kelly',	86,	65,	60,	21,	79,	22
insert JuniorResults select 1,'Jake Read','Connor Kelly',null,null,null,null,null,null						
insert JuniorResults select 1,'Cameron Stansfield','David Dunne',null,null,null,null,null,null						
insert JuniorResults select 1,'Cameron Stansfield','Jake Read',null,null,null,null,null,null						
insert JuniorResults select 1,'Jake Read','David Dunne',null,null,null,null,null,null	

insert JuniorResults select 2,'James Moss','Levi Hardy',null,null,null,null,null,null						
insert JuniorResults select 2,'Kian Collins','James Moss',null,null,null,null,null,null						
insert JuniorResults select 2,'Rhys Kelly','James Moss',null,null,null,null,null,null						
insert JuniorResults select 2,'Levi Hardy','Kian Collins',null,null,null,null,null,null						
insert JuniorResults select 2,'Levi Hardy','Rhys Kelly',null,null,null,null,null,null						
insert JuniorResults select 2,'Rhys Kelly','Kian Collins',null,null,null,null,null,null		

insert JuniorResults select 3,'Oliver Read','Ciaran Gledhill',null,null,null,null,null,null						
insert JuniorResults select 3,'Callum Weir','Oliver Read',null,null,null,null,null,null						
insert JuniorResults select 3,'Nathan Haigh','Oliver Read',null,null,null,null,null,null						
insert JuniorResults select 3,'Ciaran Gledhill','Callum Weir',null,null,null,null,null,null						
insert JuniorResults select 3,'Ciaran Gledhill','Nathan Haigh',null,null,null,null,null,null						
insert JuniorResults select 3,'Nathan Haigh','Callum Weir',null,null,null,null,null,null

insert JuniorResults select 4,'Josh Dyson','Jordan Glover',null,null,null,null,null,null						
insert JuniorResults select 4,'Jordan Williams','Josh Dyson',null,null,null,null,null,null						
insert JuniorResults select 4,'Luke Jones','Josh Dyson',null,null,null,null,null,null						
insert JuniorResults select 4,'Jordan Glover','Jordan Williams'	,33,	65,	23,	35,	61,	29
insert JuniorResults select 4,'Jordan Glover','Luke Jones',null,null,null,null,null,null						
insert JuniorResults select 4,'Luke Jones','Jordan Williams',null,null,null,null,null,null	
GO

update JuniorLeagues set Entrant=replace(Entrant,'	',''),Club=replace(Club,'	','')
update JuniorResults 
	set HomePlayer=replace(HomePlayer,'	','')
	   ,AwayPlayer=replace(AwayPlayer,'	','')
GO
select Division, HomePlayer, AwayPlayer,HomeFrame1,AwayFrame1,HomeFrame2,AwayFrame2,HomeFrame3,AwayFrame3 
	   ,HomePoints=case when HomeFrame1 is null 
	                    then null
	                    else case when HomeFrame1>AwayFrame1 then 1 else 0 end +
	                         case when HomeFrame2>AwayFrame2 then 1 else 0 end +
				             case when HomeFrame3>AwayFrame3 then 1 else 0 end
                  end
	   ,AwayPoints=case when AwayFrame1 is null 
	                    then null
	                    else case when AwayFrame1>HomeFrame1 then 1 else 0 end +
	                         case when AwayFrame2>HomeFrame2 then 1 else 0 end +
				             case when AwayFrame3>HomeFrame3 then 1 else 0 end
                  end
from JuniorResults 