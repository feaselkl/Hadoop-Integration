USE [OOTP]
GO
--Query the secondbasemen table in Hive via linked server.
SELECT
	FirstName,
	LastName,
	COUNT(1)
FROM [Hadoop].[HIVE].[default].[secondbasemen]
GROUP BY
	FirstName,
	LastName
HAVING
	COUNT(*) > 1;

--DROP STATISTICS dbo.SecondBasemen.PlayerNames
--CREATE STATISTICS PlayerNames on dbo.SecondBasemen(FirstName, LastName) --Do this after initial table creation to show stat differences.
SELECT
	FirstName,
	LastName,
	COUNT(1)
FROM dbo.SecondBasemen
GROUP BY
	FirstName, 
	LastName
HAVING
	COUNT(*) > 0;