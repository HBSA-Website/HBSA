USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Reverse_a_Grid')
	drop procedure Reverse_a_Grid
GO

CREATE procedure Reverse_a_Grid
	@SectionId int
as

set nocount on

declare @SectionSize int
select @SectionSize=COUNT(*) from Teams where SectionID=@SectionId
--simply swap each home and away pair for the given section
update FixtureGrids
	set h1=a1, a1=h1
       ,h2=a2, a2=h2
       ,h3=a3, a3=h3
       ,h4=a4, a4=h4
       ,h5=a5, a5=h5
       ,h6=a6, a6=h6
       ,h7=a7, a7=h7
       ,h8=a8, a8=h8
	    
	where SectionID = @SectionId 				 
	


GO
