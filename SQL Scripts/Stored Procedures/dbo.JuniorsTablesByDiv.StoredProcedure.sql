USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsTablesByDiv')
	drop procedure JuniorsTablesByDiv
GO

create procedure JuniorsTablesByDiv 
	@div int
as
set nocount on

declare @Head varchar(12), @SQL varchar(4000)
set @Head='[Division ' + convert(varchar,@Div) +']'
set @SQL='
select * from
(select ' + @Head + '=Entrant,Club,Frames=Sum(Frames),PtsFor=sum(PointsFor),PtsAgainst=sum(PointsAgainst), PtsDiff=sum(PointsFor)-sum(PointsAgainst)
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

	where Division=' + convert(varchar,@Div) + '
	  and Entrant <> ''Bye''
	group by Entrant,Club ) V
	order by Frames desc, PtsFor-PtsAgainst desc'

exec (@SQL)
	 
GO

exec JuniorsTablesByDiv 1