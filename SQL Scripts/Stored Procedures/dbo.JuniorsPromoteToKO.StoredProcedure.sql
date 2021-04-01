USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsPromoteToKO')
	drop procedure dbo.JuniorsPromoteToKO
GO

create procedure dbo.JuniorsPromoteToKO
as

set nocount on
set xact_abort on

declare @CompetitionID int
	   ,@EntrantsPerDivision int
set @CompetitionID=10
select @EntrantsPerDivision= 4 / count(distinct Division) from JuniorResults

begin tran

delete Competitions_Entries where CompetitionID=@CompetitionID

declare c cursor fast_forward for

select Division, PlayerID=Players.ID
from
(select Division,Entrant,Club,Frames=Sum(Frames),PointsFor=sum(PointsFor),PointsAgainst=sum(PointsAgainst)
	from JuniorLeagues
	cross apply (select 
					Frames=case when Homeplayer=Entrant then
	      							case when HomeFrame1 is null 
					                     then null
	                                     else case when HomeFrame1>AwayFrame1 then 1 else 0 end +
	                                          case when HomeFrame2>AwayFrame2 then 1 else 0 end +
				                              case when HomeFrame3>AwayFrame3 then 1 else 0 end
                                     end
	                            else
			                        case when AwayFrame1 is null 
	                                     then null
	                                     else case when AwayFrame1>HomeFrame1 then 1 else 0 end +
	                                          case when AwayFrame2>HomeFrame2 then 1 else 0 end +
				                              case when AwayFrame3>HomeFrame3 then 1 else 0 end
                                    end
                           end

				   ,PointsFor=case when Homeplayer=Entrant then HomeFrame1+HomeFrame2+HomeFrame3
				                                           else AwayFrame1+AwayFrame2+AwayFrame3
                              end

				   ,PointsAgainst=case when Awayplayer=Entrant then HomeFrame1+HomeFrame2+HomeFrame3
				                                           else AwayFrame1+AwayFrame2+AwayFrame3
                              end



                    from JuniorResults 
                    where HomePlayer=Entrant 
					   or AwayPlayer=Entrant) R

	group by Division,Entrant,Club ) V

	join Players on dbo.FullPlayerName(Forename, Initials, Surname)=Entrant and LeagueID = 1
	order by Division, Frames desc, PointsFor-PointsAgainst desc

open C
declare @EntrantID int, @Div int, @Pos int, @PrevDiv int
set @PrevDiv=0
set @Pos=0

fetch C into @Div, @EntrantID
while @@FETCH_STATUS=0
	begin
	If @Div <> @PrevDiv
		begin
		set @Pos=1
		set @PrevDiv=@Div
		end
	else
		begin
		set @Pos=@Pos+1
		end

	if @Pos <= @EntrantsPerDivision  --1 div = 4, 2 div = 2, 4 div = 1 
		begin
		insert Competitions_Entries
			select @CompetitionID
			      ,case when @EntrantsPerDivision = 4 and @Div=1 and @pos = 1 then 0
			            when @EntrantsPerDivision = 4 and @Div=1 and @pos = 2 then 2
			            when @EntrantsPerDivision = 4 and @Div=1 and @pos = 3 then 1
			            when @EntrantsPerDivision = 4 and @Div=1 and @pos = 4 then 3
				        when @EntrantsPerDivision = 2 and @Div=1 and @pos = 1 then 0
					    when @EntrantsPerDivision = 2 and @Div=1 and @pos = 2 then 2
				        when @EntrantsPerDivision = 2 and @Div=2 and @pos = 1 then 1
					    when @EntrantsPerDivision = 2 and @Div=2 and @pos = 2 then 3
				        when @EntrantsPerDivision = 2 and @Div=1 and @pos = 1 then 0
					    when @EntrantsPerDivision = 2 and @Div=2 and @pos = 1 then 2
				        when @EntrantsPerDivision = 2 and @Div=3 and @pos = 1 then 1
					    when @EntrantsPerDivision = 2 and @Div=4 and @pos = 1 then 3
		            end
				  ,@Div*10+@pos,0, @EntrantID, NULL
		end

	fetch C into @Div, @EntrantID

	end

close c 
deallocate c

--update the competition with the number of rounds needed
update Competitions
	set NoRounds = (select dbo.integerRoot((select count(*) 
												from Competitions_Entries 
												where CompetitionID=@CompetitionID
												and RoundNo=0),2))
	where ID = @CompetitionID

--Initialise the Competitions_Rounds table
delete Competitions_Rounds
	where CompetitionID = @CompetitionID

insert Competitions_Rounds
	(CompetitionID, RoundNo)
	values
	(@CompetitionID,0)

commit tran

GO

exec JuniorsPromoteToKO

exec GetCompetitionDetails 10 