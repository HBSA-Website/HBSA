if exists (select value from configuration where [key]='UnderMaintenance')
	update configuration set value=1 where [key]='UnderMaintenance'
else
	insert Configuration select 'UnderMaintenance',1
