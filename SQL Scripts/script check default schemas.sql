use hbsa_test
go

SELECT DB_NAME() AS [database] ,*--[name] ,[type],[type_desc] ,[default_schema_name] 
	FROM [sys]. [database_principals] 

