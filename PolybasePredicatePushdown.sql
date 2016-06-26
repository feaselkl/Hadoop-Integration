USE [OOTP]
GO

/* Example 1:  TOP with JOIN */

--Query the secondbasemen table in Hive via linked server.
--Putting secondbasemen into a CTE doesn't help indicate that we only need 50 rows.
WITH players AS
(
	SELECT TOP(50)
		sb.FirstName,
		sb.LastName,
		sb.Age,
		a.AgeDesc,
		sb.Throws,
		sb.Bats
	FROM [Hadoop].HIVE.[default].[secondbasemen] sb
		CROSS APPLY (SELECT CASE WHEN Age > 30 THEN 'Old' ELSE 'Not Old' END AS AgeDesc) a
	ORDER BY
		sb.LastName DESC
)
SELECT
	pl.FirstName,
	pl.LastName,
	pl.Age,
	pl.AgeDesc,
	pl.Throws,
	pl.Bats,
	tsa.TopSalary
FROM players pl
	INNER JOIN dbo.TopSalaryByAge tsa
		ON pl.Age = tsa.Age
ORDER BY
	LastName DESC;

--Predicate pushdown works with the CTE:  we only pull 50 records.
--When querying a huge Hive table, this can make a substantial difference.
WITH players AS
(
	SELECT TOP(50)
		sb.FirstName,
		sb.LastName,
		sb.Age,
		a.AgeDesc,
		sb.Throws,
		sb.Bats
	FROM dbo.SecondBasemen sb
		CROSS APPLY (SELECT CASE WHEN Age > 30 THEN 'Old' ELSE 'Not Old' END AS AgeDesc) a
	ORDER BY
		sb.LastName DESC
)
SELECT
	pl.FirstName,
	pl.LastName,
	pl.Age,
	pl.AgeDesc,
	pl.Throws,
	pl.Bats,
	tsa.TopSalary
FROM players pl
	INNER JOIN dbo.TopSalaryByAge tsa
		ON pl.Age = tsa.Age
ORDER BY
	LastName DESC;


/* Example 2:  Aggregate By Age */
--This example is simple enough that the linked server and Polybase both pushed the grouping
--work down to Hadoop.
SELECT
	sb.Age,
	COUNT(1) AS NumberOfPlayers
FROM [Hadoop].HIVE.[default].[secondbasemen] sb
GROUP BY
	sb.Age
ORDER BY
	sb.Age;

SELECT
	sb.Age,
	COUNT(1) AS NumberOfPlayers
FROM dbo.SecondBasemen sb
GROUP BY
	sb.Age
ORDER BY
	sb.Age;

/* Example 3:  Row Number */
--In this scenario, SQL Server was used for the windowing function work.  Hive has
--windowing functions (ROW_NUMBER, etc.) available, so the linked server could have
--used it, but instead this work was brought back to SQL.
SELECT
	sb.FirstName,
	sb.LastName,
	sb.Age,
	sb.Throws,
	sb.Bats,
	ROW_NUMBER() OVER (PARTITION BY sb.Age ORDER BY LastName, FirstName) AS AgeRowNumber
FROM [Hadoop].HIVE.[default].[secondbasemen] sb
ORDER BY
	sb.LastName DESC;

SELECT
	sb.FirstName,
	sb.LastName,
	sb.Age,
	sb.Throws,
	sb.Bats,
	ROW_NUMBER() OVER (PARTITION BY sb.Age ORDER BY LastName, FirstName) AS AgeRowNumber
FROM dbo.SecondBasemen sb
ORDER BY
	sb.LastName DESC;