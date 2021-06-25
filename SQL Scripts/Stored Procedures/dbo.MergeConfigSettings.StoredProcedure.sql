use HBSA
GO

if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='MergeConfigSettings')
	drop procedure dbo.MergeConfigSettings
GO

Create procedure dbo.MergeConfigSettings
	(@Category varchar(24)
	,@Setting varchar(128)
	,@ControlType varchar(16)
	,@ConfigKey varchar(150)
	,@SettingValue varchar(1000)
	)
as

set nocount on
set xact_abort on

begin tran

if exists (select [key] from Configuration where [key] = @ConfigKey)
	update Configuration 
		set [value] = @SettingValue
		where [key] = @ConfigKey
else
	insert Configuration
		select @ConfigKey
		      ,@SettingValue

if exists (select ConfigKey from Settings where ConfigKey = @ConfigKey)
		update Settings
		set Category = @Category
		   ,Setting = @Setting
		   ,ControlType = @ControlType
		where ConfigKey = @Configkey   
else
	insert Settings
		select @Category
		      ,@Setting
			  ,@ControlType
			  ,@ConfigKey

commit tran
GO