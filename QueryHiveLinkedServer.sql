USE [OOTP]
GO
--Sample queries show you can use most T-SQL constructs with Hive.
SELECT TOP(50)
	sb.FirstName,
	sb.LastName,
	sb.Age,
	a.AgeDesc,
	sb.Throws,
	sb.Bats,
	tsa.TopSalary
FROM [Hadoop].HIVE.[default].[secondbasemen] sb
	CROSS APPLY (SELECT CASE WHEN Age > 30 THEN 'Old' ELSE 'Not Old' END AS AgeDesc) a
	INNER JOIN dbo.TopSalaryByAge tsa
		ON sb.Age = tsa.Age
ORDER BY
	LastName DESC;

SELECT * FROM dbo.TopSalaryByAge WHERE Age IN
(
	SELECT DISTINCT Age FROM [Hadoop].HIVE.[default].[secondbasemen] sb
);
