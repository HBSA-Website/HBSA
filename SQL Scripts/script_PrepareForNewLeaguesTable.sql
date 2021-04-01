alter table Leagues
	add MaxHandicap int
	   ,MinHandicap int
/* Do the table alter first, then the tran below
*/
set xact_abort on

begin tran

update Leagues
		set Leagues.MaxHandicap = HandicapLimits.MaxHandicap 
	       ,Leagues.MinHandicap = HandicapLimits.MinHandicap
	from Leagues
	join HandicapLimits on LeagueID = ID 

drop table HandicapLimits

commit tran
SELECT * FROM Leagues

-- Then do these
USE [HBSA]
GO

/****** Object:  UserDefinedFunction [dbo].[Awards_TemplateCompetition]    Script Date: 24/06/2019 13:45:17 ******/
DROP FUNCTION [dbo].[Awards_TemplateCompetition]
GO

/****** Object:  UserDefinedFunction [dbo].[MinimumInteger]    Script Date: 24/06/2019 13:45:17 ******/
DROP FUNCTION [dbo].[MinimumInteger]
GO

/****** Object:  UserDefinedFunction [dbo].[newTaggedHandicap]    Script Date: 24/06/2019 13:45:17 ******/
DROP FUNCTION [dbo].[newTaggedHandicap]
GO

/****** Object:  UserDefinedFunction [dbo].[newHandicap]    Script Date: 24/06/2019 13:45:17 ******/
DROP FUNCTION [dbo].[newHandicap]
GO

/****** Object:  UserDefinedFunction [dbo].[newHandicap]    Script Date: 24/06/2019 13:45:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[newHandicap] 
	(@Handicap int
	,@Played int
	,@Won int
	,@LeagueID int --3 = Billiards, otherwise Snooker
	,@Tagged int
	,@Over70 bit
)
RETURNS int
AS
BEGIN

declare @NewHandicap int
       ,@Delta int
       ,@Max int
       ,@Min int

--calculate the difference between won and lost (may well be negative)
set @Delta=@Won-(@Played-@Won)       

if @LeagueID = 3 
	--calculate the new billiards handicap as a change to the old handicap
	--if the difference is less than 3 there is no change
	--otherwise the difference is 2.5 points per difference, rounded down
	--   i.e. when the difference is negative the change is 2.5 more than the difference
	--        when the fifference is positive the change is 2.5 less than the difference
	--            hence the use of the celing function.
	set @NewHandicap = case when abs(@Delta) < 3 then @Handicap
	                                             else @Handicap - (ceiling(convert(decimal,@Delta)/2)) * 5
	                   end
else
	--calculate the new snooker handicap as a change to the old handicap
	--if the difference is greater than 8 the change is the difference
	--if the difference is less than 3 there is no change
	--otherwise the difference is half a point per difference, rounded down
	--   i.e. when the difference is negative the change is 0.5 more than the difference
	--        when the fifference is positive the change is 0.5 less than the difference
	--            hence the use of the celing function.
	set @NewHandicap = case when abs(@Delta) > 8 then @Handicap - @Delta
		                    when abs(@Delta) < 3 then @Handicap
			                                     else case when @Tagged <> 0 then @Handicap - @Delta 
																			else @Handicap - ceiling(convert(decimal,@Delta)/2)
                                                      end
				       end

--Over 70 cannot go down
if @Over70 = 1 and @Delta > 0 
	set @NewHandicap = @Handicap

--ensure the change does not exceed the handicap limits for it's league
select @Max=[MaxHandicap] 
	  ,@Min=[MinHandicap] 
	from Leagues
	where ID=@LeagueID   
	
if @NewHandicap > @Max 
	set @NewHandicap=@Max 
else 
if @NewHandicap < @Min 
		set @NewHandicap=@Min      
	
RETURN @NewHandicap

END



GO

/****** Object:  UserDefinedFunction [dbo].[newTaggedHandicap]    Script Date: 24/06/2019 13:45:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[newTaggedHandicap] 
	(@Played int
	,@Won int
	,@Handicap int
	,@LeagueID int --3 = Billiards, otherwise Snooker
)
RETURNS int
AS
BEGIN

declare @newHandicap int
       ,@Delta int
	   ,@Max int
       ,@Min int

--calculate the change required 

if @Played <> 6 
	set @Delta = NULL
else
if @LeagueID = 3 
	--calculate the billiards handicap change
	--if won 6 out of 6, reduce the handicap by 15 
	--if won 5 out of 6, reduce the handicap by 10
	--if lost 6 out of 6, raise the handicap by 15 
	--if lost 5 out of 6, raise the handicap by 10
	set @Delta = case when @Played-@Won = 1 then -10
                      when @Played-@Won = 0 then -15
					  when @Played-@Won = 5 then 10
					  when @Played-@Won = 6 then 15
					                  else null
	                   end
else
	--calculate the snooker handicap change
	--if won 6 out of 6, reduce the handicap by 9
	--if won 5 out of 6, reduce the handicap by 5
	--if lost 6 out of 6, raise the handicap by 9 
	--if lost 5 out of 6, raise the handicap by 5
	set @Delta = case when @Played-@Won = 1 then -5
                      when @Played-@Won = 0 then -9
					  when @Played-@Won = 5 then 5
					  when @Played-@Won = 6 then 9
					                  else null
	                   end

--ensure the change does not exceed the handicap limits for it's league
set @NewHandicap = @Handicap + @Delta
select @Max=[MaxHandicap] 
	  ,@Min=[MinHandicap] 
	from Leagues 
	where ID=@LeagueID   
	
if @NewHandicap > @Max 
	set @NewHandicap=@Max 
else 
if @NewHandicap < @Min 
		set @NewHandicap=@Min      

--return the adjusted handicap
RETURN @NewHandicap 

END

GO

/****** Object:  UserDefinedFunction [dbo].[MinimumInteger]    Script Date: 24/06/2019 13:45:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[MinimumInteger] 
	()
 RETURNS int
AS
BEGIN

return -2147483648

END

GO

/****** Object:  UserDefinedFunction [dbo].[MaximumInteger]    Script Date: 24/06/2019 13:45:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[MaximumInteger] 
	()
 RETURNS int
AS
BEGIN

return 2147483647

END

GO

/****** Object:  UserDefinedFunction [dbo].[Awards_TemplateCompetition]    Script Date: 24/06/2019 13:45:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[Awards_TemplateCompetition]
	(@AwardType int
	,@AwardID int = NULL
	,@SubId int = NULL
	,@LeagueID int = NULL
	)
returns varchar(255)

as

begin

declare @Competition varchar(255)
select @Competition = replace (replace (replace (replace (replace (replace
							(AT.[Name],'[League]',isnull([League Name],'[League]'))
							          ,'[Competition]',isnull(C.Name,'[Competition]')) 
							          ,'[Section]',isnull([Section Name],'[Section]'))
									  ,'[Position]', case when isnull(@SubID,0)=0 then '[Position]'
									                      when @SubID=1 then 'Winner' 
									                      when @SubID=2 then 'Runner up' 
														  else 'Semi Finalist' 
													  end )
									  ,'[LowHandicap]', case when LowHandicap is null then '[LowHandicap]'
									                         when LowHandicap = dbo.MinimumInteger() then 'No limit'
															 else convert(varchar,LowHandicap)
                                                         end )
									  ,'[HighHandicap]', case when HighHandicap is null then '[HighHandicap]'
									                          when HighHandicap = dbo.MaximumInteger() then 'No limit'
									                          else convert(varchar, HighHandicap)
                                                         end ) 																									                                                                                                                                 
	  
	from Awards_Types AT
	Outer apply (select [League Name] from Leagues where ID=@LeagueID) L
	outer apply (select [Section Name] from sections where ID=@AwardID) S
	outer apply (select Name from Competitions where ID=@AwardID) C
	outer apply (select * from BreaksCategories where LeagueID=@LeagueID and ID=@AwardID) B
	
	where AwardType=@AwardType

return @Competition

end

GO




USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeLeague]    Script Date: 24/06/2019 13:45:59 ******/
DROP PROCEDURE [dbo].[MergeLeague]
GO

/****** Object:  StoredProcedure [dbo].[LeagueDetails]    Script Date: 24/06/2019 13:45:59 ******/
DROP PROCEDURE [dbo].[LeagueDetails]
GO

/****** Object:  StoredProcedure [dbo].[GetLeaguesWithHandicapLimits]    Script Date: 24/06/2019 13:45:59 *****
DROP PROCEDURE [dbo].[GetLeaguesWithHandicapLimits]
GO*/

/****** Object:  StoredProcedure [dbo].[BreaksReport]    Script Date: 24/06/2019 13:45:59 ******/
DROP PROCEDURE [dbo].[BreaksReport]
GO

/****** Object:  StoredProcedure [dbo].[BreaksReport]    Script Date: 24/06/2019 13:45:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[BreaksReport]
	(@LeagueID int
	)
as	

set nocount on

select	 PlayerID,Name= Forename + case when Initials = '' then ' ' else ' ' + Initials + '. ' end + Surname
		,PlayerDetails.LeagueID, Leagues.[League Name]
		,Handicap = 
		 case when PlayerID=HomePlayer1ID then HomeHandicap1
		      when PlayerID=HomePlayer2ID then HomeHandicap2
		      when PlayerID=HomePlayer3ID then HomeHandicap3
		      when PlayerID=HomePlayer4ID then HomeHandicap4
		      when PlayerID=AwayPlayer1ID then AwayHandicap1
		      when PlayerID=AwayPlayer2ID then AwayHandicap2
		      when PlayerID=AwayPlayer3ID then AwayHandicap3
		      when PlayerID=AwayPlayer4ID then AwayHandicap4
		      --else matchresultid
		 end     
		,[Break], Category=BreaksCategories.ID
		--,*
	into #tempBreaks	
	from Breaks
         join PlayerDetails on PlayerDetails.ID=PlayerID
         join MatchResults on MatchResults.ID=MatchResultID
         join Leagues on Leagues.ID = LeagueID
         join BreaksCategories on BreaksCategories.[LeagueID]=PlayerDetails.LeagueID and Handicap between LowHandicap and HighHandicap
         
    where PlayerDetails.LeagueID=@LeagueID

select *, [Type]='Std'	
	into #tempBreaks2
	from #tempBreaks    

declare HighestBreaks cursor fast_forward for
	select tb.Name,tb.[Break],tb.Category, tb.LeagueID,tb.[League Name]
		from #tempBreaks tb
		join (select [Break]=MAX([Break]),Category
				from #tempBreaks
				group by Category) MB
		  on tb.[Break] = MB.[Break]		
		 and tb.Category=MB.Category 
		 order by Category desc, name
declare @hbName varchar(250),@hbBreak int, @hbCategory int, @hbLeagueID int, @hbLeagueName varchar(50)
declare @prevBreak int, @prevCategory int, @prevPlayer varchar(250)
set @prevBreak = -1 set @prevCategory = -1
open HighestBreaks
fetch HighestBreaks into @hbName, @hbBreak, @hbCategory, @hbLeagueID, @hbLeagueName
while @@FETCH_STATUS=0
	begin
	if @prevCategory=@hbCategory and @prevBreak=@hbBreak
		set @prevPlayer=@prevPlayer + ', ' + @hbName
	else
		begin
		if @prevPlayer is not null
			insert #tempBreaks2
				select 	0, 'Highest break (' + @prevPlayer + ')', @hbLeagueID, @hbLeagueName, 0, @prevBreak, @prevCategory, 'Top'	
		select @prevPlayer=@hbName, @prevCategory=@hbCategory, @prevBreak=@hbBreak
		end	
	fetch HighestBreaks into @hbName, @hbBreak, @hbCategory, @hbLeagueID, @hbLeagueName
	end

if @prevPlayer is not null
	insert #tempBreaks2
		select 	0, 'Highest break (' + @prevPlayer + ')', @hbLeagueID, @hbLeagueName, 0, @prevBreak, @prevCategory, 'Top'

close HighestBreaks
deallocate HighestBreaks

create table #BreaksReport
	(ID int identity (1,1)
	)

declare CategoriesCursor cursor fast_forward for
	select ID, Category=convert(varchar,LowHandicap) + ' to ' + convert(varchar,HighHandicap)
	 from BreaksCategories where LeagueID=@LeagueID 

declare @CategoryID int, @Category	varchar(50)
declare @SQL varchar (2000)
declare @selectSQL varchar(2000)
set @selectSQL='select '

open CategoriesCursor
fetch CategoriesCursor into @CategoryID,@Category
while @@FETCH_STATUS=0
	begin
	set @SQL = 
		'alter table #BreaksReport
			add [Player ' + @Category +  '] varchar(120), [Breaks ' + @Category + '] varchar(2000)'
	exec (@SQL)	
	--print @SQL

	set @selectSQL = @selectSQL + 
		'[' + case when left(@category,len(convert(varchar(15),dbo.MinimumInteger()))) = convert(varchar(15),dbo.MinimumInteger())
				       then right (@Category, len(@Category) - len(convert(varchar(15),dbo.MinimumInteger())) - 4) + ' down'
				   when right(@category,len(convert(varchar(15),dbo.MaximumInteger()))) = convert(varchar(15),dbo.MaximumInteger())
				       then left (@Category, len(@Category) - len(convert(varchar(15),dbo.MaximumInteger())) - 4) + ' up'
				else @Category
	           end
		 + '] = [Player ' + @Category +  '], Breaks = [Breaks ' + @Category + '],' 

	declare BreaksCursor cursor fast_forward for
	select PlayerID, Name, [Break]
		from #tempBreaks2
		where Category=@CategoryID
		order by Category,[Type] Desc,Name,playerid

	declare @prevPlayerID int
		   ,@prevName varchar(120)
	       ,@PlayerID int
		   ,@Name varchar(120)
		   ,@Break int
	       ,@Breaks varchar(2000)
	       ,@RecID int
       
	open BreaksCursor
	select @prevPlayerID=-1,@prevName=''

	fetch BreaksCursor into @PlayerID,@name,@Break
	set @RecID=1
	while @@fetch_status=0
		begin
		if @PlayerID <> @prevPlayerID
			begin
			if @prevPlayerID <> -1
				begin
				if (select ID from #BreaksReport where ID=@RecID) is not null
					set @SQL = 
						'update #BreaksReport 
							set [Player ' +  + @Category +  ']=''' + replace(@prevName,'''','''''') + ''' 
							   ,[Breaks ' + @Category + ']=''' + left(@Breaks,len(@Breaks)-1) + '''
							where ID=' + CONVERT(varchar,@RecID)
				else 
					set @SQL = 
						'insert #BreaksReport
							([Player ' +  + @Category +  ']
			                ,[Breaks ' + @Category + ']) 
				         VALUES
							(''' + replace(@prevName,'''','''''') + ''',''' + left(@Breaks,len(@Breaks)-1) + ''')'  

				exec (@SQL)
				
				set @RecID = @RecID + 1
				end
			select @prevPlayerID=@PlayerID,@prevName=@Name, @Breaks=convert(varchar,@Break)+', '
			end
		else
			select @Breaks = @Breaks+convert(varchar,@Break)+', '
	
		fetch BreaksCursor into @PlayerID,@name,@Break
		end

		if (select ID from #BreaksReport where ID=@RecID) is not null
			set @SQL = 
				'update #BreaksReport 
					set [Player ' +  + @Category +  ']=''' + replace(@prevName,'''','''''') + ''' 
					   ,[Breaks ' + @Category + ']=''' + left(@Breaks,len(@Breaks)-1) + '''
					where ID=' + CONVERT(varchar,@RecID)
		else 
			set @SQL = 
				'insert #BreaksReport
					([Player ' +  + @Category +  ']
		            ,[Breaks ' + @Category + ']) 
		         VALUES
					(''' + replace(@prevName,'''','''''') + ''',''' + left(@Breaks,len(@Breaks)-1) + ''')'  

		exec (@SQL)
		--print @SQL
	close BreaksCursor
	deallocate BreaksCursor

	fetch CategoriesCursor into @CategoryID,@Category

	end

close CategoriesCursor
deallocate CategoriesCursor

set @selectSQL = left(@selectSQL,len(@selectSQL)-1) + '
	from #BreaksReport'
--print(@selectSQL)	
exec(@selectSQL)	
--select * from #BreaksReport
drop table #tempBreaks	
drop table #tempBreaks2
drop table #BreaksReport


GO

/****** Object:  StoredProcedure [dbo].[GetLeaguesWithHandicapLimits]    Script Date: 24/06/2019 13:45:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[GetLeaguesWithHandicapLimits]

as

set nocount on

select 
	 ID	= isnull(ID,'')
	,[League Name]	= isnull([League Name],'')
	,MaxHandicap=case when MaxHandicap=dbo.MaximumInteger() then 'No Limit' else convert(varchar,MaxHandicap) end
	,MinHandicap=case when MinHandicap=dbo.MinimumInteger() then 'No Limit' else convert(varchar,MinHandicap) end

	from Leagues 
	ORDER BY ID

GO

/****** Object:  StoredProcedure [dbo].[LeagueDetails]    Script Date: 24/06/2019 13:45:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[LeagueDetails]
	(@ID as integer
	)
as

set nocount on

select 
	 ID
	,[League Name]	= isnull([League Name],'')
	,MaxHandicap
	,MinHandicap
	from Leagues 

	where ID = @ID

select * 
	From Sections 
	where LeagueID=@ID

select Team,[League Name],[Section Name], [Club Name]
	from Teams 
	join Clubs on Clubs.ID=Clubid
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE LeagueID=@ID 
	order by sectionid
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
	from Players 
	where LeagueID=@ID
	order by Team, Forename,surname



GO

/****** Object:  StoredProcedure [dbo].[MergeLeague]    Script Date: 24/06/2019 13:45:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[MergeLeague]
	(@LeagueID int           --if = -1 insert new record
	,@LeagueName varchar(50) --if empty delete record with this ID
	,@MaxHandicap int
	,@MinHandicap int
	)

as
set nocount on
set xact_abort on

begin tran

MERGE Leagues AS target
    USING (SELECT @LeagueID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @LeagueName='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
             [League Name]		= @LeagueName
			,MaxHandicap		= @MaxHandicap
			,MinHandicap		= @MinHandicap

					
    WHEN NOT MATCHED AND @LeagueName <> '' AND @LeagueID=-1 THEN    
		INSERT ( [League Name]
				,MaxHandicap
				,MinHandicap
				)
			values(	 @LeagueName
					,@MaxHandicap
					,@MinHandicap
			      )
		
		OUTPUT $action;
	
--resequence the table and it's IDs
select * into #tmpLeagues from Leagues
truncate table Leagues
insert Leagues
	select [League Name], MaxHandicap, MinHandicap 
		from #tmpLeagues
		order by ID
drop table #tmpLeagues	

commit tran

GO

USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetBreaksCategories2')
	drop procedure GetBreaksCategories2
GO

create procedure dbo.GetBreaksCategories2

as	

set nocount on

select [League Name]
      ,LeagueID
	  ,LowHandicap = case when LowHandicap = dbo.MinimumInteger() 
	                      then 'No limit'
						  else convert(varchar,LowHandicap)
                     end
	  ,HighHandicap = case when HighHandicap = dbo.MaximumInteger() 
	                      then 'No limit'
						  else convert(varchar,HighHandicap)
                     end
	  ,ID 
	from BreaksCategories 
	cross apply (select [League Name] from Leagues where ID=LeagueID) L

GO

use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_TypeUpdate')
	drop procedure dbo.Awards_TypeUpdate
GO

create procedure dbo.Awards_TypeUpdate
	(@AwardType int
	,@Name varchar(255)
	,@description varchar(63)
	,@StoredProcedureName varchar(255)
	)
as

set nocount on

update Awards_Types
	set Name				= @Name
	   ,[Description]		= @description
	   ,StoredProcedureName	= @StoredProcedureName
	where @AwardType = AwardType

GO

exec Awards_TypeUpdate 4,'Highest Break in [League]', 'Highest Break in a league', 'Awards_HighestBreaksByLeague'


update BreaksCategories
	set LowHandicap=dbo.MinimumInteger() where ID in (1,6,7)
update BreaksCategories
	set HighHandicap=90
	where id=5

select * from BreaksCategories


