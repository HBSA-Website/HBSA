USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateNews')
	drop procedure UpdateNews
GO

create procedure UpdateNews
	(@ID int
	,@Title varchar(50)
	,@Article varchar(max)
	,@Date Date
	 )
as 

set nocount on
set xact_abort on

if @ID = 0 
	begin
		begin tran
		declare @newID int
		select @NewID=max(ID)+1 from news
		insert News values
			(isnull(@newID,1), @Title, @Article, @Date)
		commit tran	
	end
else
	update News
		set Title=@Title
		   ,Article=@Article
		   ,Date=@Date
		where ID=@ID   	 


GO
