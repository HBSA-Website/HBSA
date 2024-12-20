USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetSettings]    Script Date: 01/08/2018 15:26:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetSettings]
	(@Category varchar(24) = NULL
	)

as

Select distinct Category 
	from Settings
	where Category = @Category
	   or @Category is NULL
 
Select * 
	from Settings 
	Cross apply (Select [value] from Configuration where [Key]=ConfigKey) C
	where Category = @Category
	   or @Category is NULL
	order by Category, Setting

