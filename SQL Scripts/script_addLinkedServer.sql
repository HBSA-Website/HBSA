USE master
GO
/****** Object:  LinkedServer [myGX620]    Script Date: 04/07/2009 22:49:10 ******/
EXEC master.dbo.sp_addlinkedserver
    @server = N'livedb',
    @srvproduct=N'MSSQL',
    @provider=N'SQLNCLI',
    @provstr=N'PROVIDER=SQLOLEDB;SERVER=HBSA.db.11715514.hostedresource.com'
 
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'livedb',
    @useself=N'False',@locallogin=NULL,@rmtuser=N'HBSA',@rmtpassword='Sn00ker%'
GO
