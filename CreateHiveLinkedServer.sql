--First install the Microsoft Hive ODBC driver:
--http://www.microsoft.com/en-us/download/details.aspx?id=40886
--Then set up a System DSN.  I called mine "Sandbox" as you can see in @datasrc below.
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver
	@server = N'Hadoop',
	@srvproduct=N'HIVE',
	@provider=N'MSDASQL',
	@datasrc=N'Sandbox',
	@provstr=N'Provider=MSDASQL.1;User ID=admin;PWD=[your password here]';
EXEC master.dbo.sp_addlinkedsrvlogin
	@rmtsrvname=N'Hadoop',
	@useself=N'True',
	@locallogin=NULL,
	@rmtuser=NULL,
	@rmtpassword=NULL;

--Note that table names are case-sensitive, so SecondBasemen is different from secondbasemen!
SELECT * FROM [Hadoop].[HIVE].[default].[secondbasemen];