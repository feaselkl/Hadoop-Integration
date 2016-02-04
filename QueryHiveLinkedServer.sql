USE [AdventureWorks2016CTP3]
GO
--Sample queries show you can use most T-SQL constructs with Hive.
--In reality, Person.Person has nothing to do with my secondbasemen table, but they
--	do have overlapping int values so I'm pretending that they're connected keys.
SELECT TOP(50)
	sb.FirstName,
	sb.LastName,
	sb.Age,
	a.AgeDesc,
	sb.Throws,
	sb.Bats,
	p.NameStyle
FROM [Hadoop].HIVE.[default].[secondbasemen] sb
	CROSS APPLY (SELECT CASE WHEN Age > 30 THEN 'Old' ELSE 'Not Old' END AS AgeDesc) a
	INNER JOIN Person.Person_json p
		ON sb.Age = p.PersonID
ORDER BY
	LastName DESC;
				
SELECT * FROM Person.Person_json WHERE PersonID IN
(
	SELECT DISTINCT Age FROM [Hadoop].HIVE.[default].[secondbasemen] sb
);