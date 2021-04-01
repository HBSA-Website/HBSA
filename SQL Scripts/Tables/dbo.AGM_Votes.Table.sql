USE [HBSA]
go

if exists (select table_name from  information_schema.tables where table_name = 'AGM_Votes_Resolutions')
	drop table dbo.AGM_Votes_Resolutions
go

create table dbo.AGM_Votes_Resolutions
	(ID int identity (1,1)
	,ResolutionType varchar(60)
	,Resolution varchar(1000) not null
	constraint PK_AGM_Votes_Resolutions primary key clustered
		(ID asc)
	)
GO
insert AGM_Votes_Resolutions select 'Ordinary Resolutions','1. Acceptance of minutes of 2018/2019 AGM'
insert AGM_Votes_Resolutions select 'Ordinary Resolutions','2. Approve the Annual Report and Accounts '
insert AGM_Votes_Resolutions select 'Special Resolutions','<b>1. New qualifying criteria for entering competitions.</b><br />A minimum of 3 games in the current season OR 5 games in the current and last season combined. This does NOT apply to junior snooker competitions. With immediate effect.'
insert AGM_Votes_Resolutions select 'Special Resolutions','<b>2. The handbook. A smaller handbook is proposed, reducing down to around 40 pages.</b><br />To include last season’s league tables and results. 200 copies to be produced: 1 per team and 1 per premises.'
insert AGM_Votes_Resolutions select 'Special Resolutions','<b>3. AGM attendance.</b><br />Non-attendance at the AGM will incur a 4-point deduction, starting in 2021.'
insert AGM_Votes_Resolutions select 'Special Resolutions','<b>4. Late Payments.</b><br />League Entry Fees not received by the November meeting will incur a 4-point deduction. Teams not paying competition entry fees by this date will be scratched. Teams not paying fines by the March meeting will incur a 4-point deduction. With immediate effect.'
insert AGM_Votes_Resolutions select 'Ordinary Resolutions','<b>5. Venues for the 2020/2021 Finals fortnight.</b><br />Please tick a box indicating your preferred venue:  All at Levels, Mix of Crosland Moor Con and Marsh Lib, or a mix of Levels, Crosland Moor Con and Marsh Lib '
insert AGM_Votes_Resolutions select 'Election or re-Election of Officers','1. Secretary – B Keenan'
insert AGM_Votes_Resolutions select 'Election or re-Election of Officers','2. League Secretary – J Bastow'
insert AGM_Votes_Resolutions select 'Election or re-Election of Officers','3. Competition Secretary – P Schofield'
insert AGM_Votes_Resolutions select 'Election or re-Election of Officers','4. Treasurer – D Poutney'
insert AGM_Votes_Resolutions select 'Election or re-Election of Officers','5. Auditors – B Keenan / R Taylor'




if exists (select table_name from  information_schema.tables where table_name = 'AGM_Votes_Cast')
	drop table dbo.AGM_Votes_Cast
go

create table dbo.AGM_Votes_Cast
	(ClubID int not null
	,ResolutionID int not null
	,[For] bit not null
	,Against bit not null
	,Withheld bit not null
	constraint PK_AGM_Votes_Cast primary key clustered
		(ClubID, ResolutionID asc)
	)
GO

select distinct ResolutionType from AGM_Votes_Resolutions 
select * from AGM_Votes_Resolutions