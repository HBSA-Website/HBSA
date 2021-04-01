if exists (select value from configuration where [key]='UnderMaintenance')
	update configuration set value=0 where [key]='UnderMaintenance'
else
	insert Configuration select 'UnderMaintenance',0

select * from Configuration
