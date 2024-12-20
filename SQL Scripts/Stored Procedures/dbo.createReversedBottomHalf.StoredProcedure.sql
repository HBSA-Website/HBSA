USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[createReversedBottomHalf]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[createReversedBottomHalf]
	@SectionId int
as

declare @SectionSize int

select @SectionSize=COUNT(*) from Teams where ID=@SectionId

delete  FixtureGrids 
	where SectionID = @SectionId
	  and WeekNo > (@SectionSize/2)-1  --The no of weeks in ½ season is the number of teams / 2 less 1
                                       --i.e. one team plays all the others
insert FixtureGrids  
	select SectionID, SectionSize, WeekNo+(@SectionSize/2)-1
		  ,a1,h1,a2,h2,a3,h3,a4,h4,a5,h5,a6,h6,a7,h7,a8,h8 
	from FixtureGrids 
	where SectionID <= 6
	  and WeekNo < (@SectionSize/2)
  

GO
