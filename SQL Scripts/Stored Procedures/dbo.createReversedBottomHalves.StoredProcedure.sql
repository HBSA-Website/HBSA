USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[createReversedBottomHalves]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[createReversedBottomHalves]
as
delete  FixtureGrids 
	where SectionID <= 6
	  and WeekNo > 15

insert FixtureGrids  
	select SectionID, SectionSize, WeekNo+15
		  ,a1,h1,a2,h2,a3,h3,a4,h4,a5,h5,a6,h6,a7,h7,a8,h8 
	from FixtureGrids 
	where SectionID <= 6
	  and WeekNo < 16
  

GO
