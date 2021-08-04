select * from FixtureDates where sectionID=10
select * from FixtureGrids where sectionID=10

select M.*, FixtureDate, D.WeekNo
		from FixtureDates D
		left join FixtureGrids M
		  on M.SectionID=10
		 and M.WeekNo=case when D.WeekNo % 18 = 0 then 18 else D.WeekNo % 18 end
	 where D.SectionID=10 
	 order by D.WeekNo
