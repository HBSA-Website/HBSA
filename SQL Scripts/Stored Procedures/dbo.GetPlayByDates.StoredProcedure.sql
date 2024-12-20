USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayByDates]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[GetPlayByDates]
	(@CompetitionID int
	)
as

set nocount on

declare @noRounds int
select @noRounds=NoRounds from Competitions where ID=@CompetitionID

declare @SQL varchar(2000)
set @SQL='
select Seq=1,* from
	(select [Round]=case when RoundNo+1=' + convert(varchar,@NoRounds) + ' then ''Final''
						  when RoundNo+1=' + convert(varchar,@NoRounds-1) + ' then ''Semi-Final'' 
						  else ''Round ''+convert(varchar,RoundNo+1)
				     end
	       ,PlayByDate = convert(varchar(11),PlayByDate,113) 
		from Competitions
		left join Competitions_Rounds on ID=CompetitionID
		where CompetitionID=' + convert(varchar,@CompetitionID) + '
		  and entryID is null) as src
pivot
	(max(PlayBydate) for [Round] in ('

declare @Round int
if @NoRounds = 0
	set @SQL=@SQL+'[0],'
else
	begin
	set @Round=1
	while @Round <= @NoRounds
		begin
		if @Round=@NoRounds 
			set @SQL=@SQL+'[Final],'
		else if @Round=@NoRounds-1
			set @SQL=@SQL+'[Semi-Final],'
		else
			set @SQL=@SQL+'[Round '+convert(varchar,@Round)+'],'
		set @Round=@Round+1
		end 
	end

set @SQL = left(@SQL,len(@SQL)-1) + ')) as p'

--exec (@SQL)

set @SQL=@SQL+' union 
select Seq=2,* from
	(select [Round]=case when RoundNo+1=' + convert(varchar,@NoRounds) + ' then ''Final''
						  when RoundNo+1=' + convert(varchar,@NoRounds-1) + ' then ''Semi-Final'' 
						  else ''Round ''+convert(varchar,RoundNo+1)
				     end
	       ,PlayByDate = Competitions_Rounds.Comment 
		from Competitions
		left join Competitions_Rounds on ID=CompetitionID
		where CompetitionID=' + convert(varchar,@CompetitionID) + '
		  and entryID is null) as src
pivot
	(max(PlayBydate) for [Round] in ('

--declare @Round int
if @NoRounds = 0
	set @SQL=@SQL+'[0],'
else
	begin
	set @Round=1
	while @Round <= @NoRounds
		begin
		if @Round=@NoRounds 
			set @SQL=@SQL+'[Final],'
		else if @Round=@NoRounds-1
			set @SQL=@SQL+'[Semi-Final],'
		else
			set @SQL=@SQL+'[Round '+convert(varchar,@Round)+'],'
		set @Round=@Round+1
		end 
	end

set @SQL = left(@SQL,len(@SQL)-1) + ')) as p 
    order by seq'

exec (@SQL)


GO
exec GetPlayByDates 3