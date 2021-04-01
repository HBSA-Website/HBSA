USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GenerateFixtureMatrix')
	drop procedure GenerateFixtureMatrix
GO
create procedure GenerateFixtureMatrix
	(@SectionSize int
	)

AS

/* 
 * This code owes an enormous debt to 
 * http://www.barrychessclub.org.uk/berger2001.htm 
 * and also
 * http://http://bluebones.net/2005/05/generating-fixture-lists/
 */

set nocount on

        Declare @teams int
               ,@ByeNeeded  Bit
		select @teams=@SectionSize
		      ,@ByeNeeded=0

        --if odd number of teams we need a bye
        If @teams % 2 = 1
            Select @teams = @teams+ 1
                  ,@ByeNeeded = 1

        declare @totalRounds int
		       ,@matchesPerRound int
        select @totalRounds = @teams - 1
		       ,@matchesPerRound = @teams / 2
			   

        create table #rounds(RoundNo int
		                     ,h1 int, a1 int
		                     ,h2 int, a2 int
		                     ,h3 int, a3 int
		                     ,h4 int, a4 int
		                     ,h5 int, a5 int
		                     ,h6 int, a6 int
		                     ,h7 int, a7 int
		                     ,h8 int, a8 int
							 )
		
		declare @round int
		       ,@match int

		declare @SQL varchar(4000)
		
		--initialise the rounds table
		set @round=0
		while @round < @totalrounds
			begin
			insert #rounds (RoundNo) values (@round)
			set @round = @round + 1
			end

        --Generate fixtures using the "cyclic algorithm"
		set @round=0
		while @round < @totalrounds
			begin
			set @match = 0
			while @match < @matchesPerRound
				begin
				declare @home int, @away int
				select @home = (@round + @match) % (@teams - 1)
				      ,@away = (@teams - 1 - @match + @round) % (@teams - 1)
				--last team stays in the same place while other rotate around it
				if @match = 0
					set @away = @teams - 1
				
				set @SQL = 'update #rounds set h' + convert(varchar,@match+1) + ' = ' + convert(varchar,@home+1) + 
				                             ',a' + convert(varchar,@match+1) + ' = ' + convert(varchar,@away+1) + 
								' where RoundNo=' + convert(varchar,@round) 
				exec (@SQL)

				set @match = @match + 1
				end

			set @round = @round + 1
			end

        --interleave so that home and away games are reasonably dispersed
        declare @interleave table(RoundNo int
		                     ,h1 int, a1 int
		                     ,h2 int, a2 int
		                     ,h3 int, a3 int
		                     ,h4 int, a4 int
		                     ,h5 int, a5 int
		                     ,h6 int, a6 int
		                     ,h7 int, a7 int
		                     ,h8 int, a8 int
							 )
		
		declare @evn int
               ,@odd int
               ,@i int
		select  @evn = 0
               ,@odd = @teams / 2
			   ,@i   = 0
		while @i < @totalRounds
			begin
			if @i % 2 = 0
				begin
				insert @interleave 
					select @i, h1,a1,h2,a2,h3,a3,h4,a4,h5,a5,h6,a6,h7,a7,h8,a8 
						from #rounds
						where RoundNo = @evn
				set @evn = @evn + 1
				end
			else
				begin
				insert @interleave 
					select @i, h1,a1,h2,a2,h3,a3,h4,a4,h5,a5,h6,a6,h7,a7,h8,a8 
						from #rounds
						where RoundNo = @odd
				set @odd = @odd + 1
				end

			set @i=@i+1
			end

        --the last team can't be away for every game so flip them to home on odd rounds
        set @round=0
		while @round < @totalrounds
			begin
			If @round % 2 = 1
                update @interleave
					set a1=h1, h1=a1
					where roundNo=@round

			set @round=@round+1

			end

        --display the fixtures
		declare @Matrix table
			(WeekNo int
			,h1 int, a1 int
			,h2 int, a2 int
			,h3 int, a3 int
			,h4 int, a4 int
			,h5 int, a5 int
			,h6 int, a6 int
			,h7 int, a7 int
			,h8 int, a8 int
			)

		insert @Matrix
			select 
				WeekNo=RoundNo+1
		       ,h1,a1,h2,a2,h3,a3,h4,a4,h5,a5,h6,a6,h7,a7,h8,a8 
			from @interleave
		insert @Matrix
			select 
				   WeekNo=RoundNo+@teams
			      ,a1,h1,a2,h2,a3,h3,a4,h4,a5,h5,a6,h6,a7,h7,a8,h8 
			from @interleave

		select * from @Matrix order by WeekNo
GO

exec GenerateFixtureMatrix 14