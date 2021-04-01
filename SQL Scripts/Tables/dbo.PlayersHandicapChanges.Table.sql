USE HBSA
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('PlayersHandicapChanges'))
	DROP TABLE PlayersHandicapChanges

create table PlayersHandicapChanges
	(dateChanged datetime
	,PlayerID int
    ,Handicap int
    ,NewHandicap int
	,eMails varchar(3000)
	)
GO
