IF NOT EXISTS
(
	SELECT 1
	FROM sys.databases
	WHERE
		name = N'OOTP'
)
BEGIN
	CREATE DATABASE OOTP;
END
GO
USE OOTP
GO
IF NOT EXISTS
(
	SELECT 1
	FROM sys.schemas
	WHERE
		name = N'Player'
)
BEGIN
	EXEC(N'CREATE SCHEMA [Player];');
END
GO
IF (OBJECT_ID('dbo.TopSalaryByAge') IS NULL)
BEGIN
	--Salaries for second basemen in the major leagues by age.
	CREATE TABLE dbo.TopSalaryByAge
	(
		Age INT NOT NULL,
		TopSalary MONEY NOT NULL
	);
	ALTER TABLE dbo.TopSalaryByAge ADD CONSTRAINT [PK_TopSalaryByAge] PRIMARY KEY CLUSTERED(Age);

	INSERT INTO dbo.TopSalaryByAge(Age, TopSalary) VALUES
	(16, 0),
	(17, 0),
	(18, 0),
	(19, 0),
	(20, 0),
	(21, 507500),
	(22, 509500),
	(23, 507500),
	(24, 2687500),
	(25, 507500),
	(26, 2500000),
	(27, 1800000),
	(28, 6500000),
	(29, 8000000),
	(30, 12625000),
	(31, 9850000),
	(32, 24000000),
	(33, 7500000),
	(34, 3000000),
	(35, 13000000),
	(36, 15000000),
	(37, 3000000);
END
GO
DROP TABLE IF EXISTS Player.SecondBasemen;
CREATE TABLE Player.SecondBasemen
(
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Age INT,
	Bats VARCHAR(5),
	Throws VARCHAR(5)
);
GO
