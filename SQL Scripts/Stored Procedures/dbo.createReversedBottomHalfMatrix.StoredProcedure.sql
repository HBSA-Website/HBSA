USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[createReversedBottomHalfMatrix]    Script Date: 08/09/2014 15:06:31 ******/
DROP PROCEDURE [dbo].[createReversedBottomHalfMatrix]
GO

/****** Object:  StoredProcedure [dbo].[createReversedBottomHalfMatrix]    Script Date: 08/09/2014 15:06:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[createReversedBottomHalfMatrix]
	@SectionSize int
as

delete  FixtureMatrices 
	where SectionSize = @SectionSize
	  and WeekNo > @SectionSize-1  --The no of weeks in ½ season 

insert FixtureMatrices  
	select SectionSize, WeekNo+@SectionSize-1 
		  ,a1,h1,a2,h2,a3,h3,a4,h4,a5,h5,a6,h6,a7,h7,a8,h8 
	from FixtureMatrices 
	where SectionSize = @SectionSize
	  and WeekNo <= @SectionSize-1 

GO  

exec [createReversedBottomHalfMatrix] 16