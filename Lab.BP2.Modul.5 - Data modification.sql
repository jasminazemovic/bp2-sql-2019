--1

--Creating test environment
USE master
GO

CREATE DATABASE TestDB
GO

USE TestDB
GO

CREATE TABLE Osobe 
(
	Prezime nvarchar(50) NULL,
	Ime		nvarchar(50) NULL,
	Telefon nvarchar(50) NULL,
	Email	nvarchar(50) NULL
) 
GO

SELECT *
FROM Osobe
GO

--Inerting data
INSERT INTO Osobe 
(Prezime, Ime, Telefon, Email)
VALUES ('Azemović', 'Jasmin', '061-000-000', 'jasmin@edu.fit.ba')

SELECT *
	FROM Osobe
GO

--2

--Create backup file of AdventureWorks database if dose not exist
USE AdventureWorks2014
GO

SELECT * 
	FROM Person.CountryRegion
WHERE CountryRegionCode = 'BiH'
GO

--Inserting new record into Person.CountryRegion
INSERT INTO Person.CountryRegion
	   VALUES ('BiH', 'Bosna i Hercegovina', GETDATE())

SELECT * 
	FROM Person.CountryRegion
WHERE CountryRegionCode = 'BiH'
GO

--3
SELECT *
FROM Production.ProductReview
GO

--Inserting new record into Person.Production.ProductReview
INSERT INTO Production.ProductReview
	   (ProductID,ReviewerName,ReviewDate, EmailAddress,
	    Rating,Comments,ModifiedDate)
VALUES (937,'Jasmin',GETDATE(),'jasmin@mvp-press.com',4,'This is some cool TSQL book',GETDATE())

SELECT *
	FROM Production.ProductReview
WHERE ProductID = 937
GO

--Inserting new records into Person.Production.ProductReview
INSERT INTO Production.ProductReview
	   (ProductID,ReviewerName,ReviewDate, 
		EmailAddress,Rating,Comments,
		ModifiedDate)
VALUES (937,'Mattias',GETDATE(),'mattias@mvp-press.com',4,'Yeah it is cool',GETDATE()),
	   (937,'Denis',GETDATE(),'denis@mvp-press.com',4,'It is best!',GETDATE())

SELECT *
	FROM Production.ProductReview
WHERE ProductID = 937
GO

--4
USE TestDB
GO

--Inserting records from diffrent database using subquery
INSERT INTO Osobe
	SELECT AP.LastName, AP.FirstName, APP.PhoneNumber, AEA.EmailAddress
		FROM AdventureWorks2014.Person.Person AS AP
	INNER JOIN AdventureWorks2014.Person.PersonPhone AS APP
		ON AP.BusinessEntityID = APP.BusinessEntityID
	INNER JOIN AdventureWorks2014.Person.EmailAddress AS AEA
		ON APP.BusinessEntityID = AEA.BusinessEntityID

SELECT COUNT (*) 
	FROM Osobe
GO

--5
USE TestDB
GO

--Inserting into not existing temp table using subquery
SELECT Title + ','+FirstName + ' ' +LastName AS Customer
  INTO #tempOsobeTitule 
FROM AdventureWorks2014.Person.Person
WHERE Title IS NOT NULL
GO

SELECT *
FROM #tempOsobeTitule

--Inserting into not existing table using subquery
SELECT Title + ','+FirstName + ' ' +LastName AS Customer
  INTO OsobeTitule       
FROM AdventureWorks2014.Person.Person
WHERE Title IS NOT NULL
GO

SELECT *
FROM OsobeTitule

--6
CREATE TABLE Firme
(
	FirmaID int IDENTITY(1,1) NOT NULL,
	Naziv	nvarchar(50) NULL,
	Telefon nvarchar(50) NULL
) 
GO

SELECT * FROM Firme
GO

--Options with partial and default values inserting
INSERT INTO Firme (Naziv)
VALUES ('Pujdo Inc.')

SELECT * FROM Firme
WHERE Naziv = 'Pujdo Inc.'

INSERT INTO Firme (Naziv, Telefon)
VALUES ('New Pujdo Inc.', DEFAULT)

--7

--Skipping IDENTITY numbering sequence
SET IDENTITY_INSERT Firme ON;
GO
INSERT INTO Firme (FirmaID,Naziv) 
VALUES (99, 'Firma sa posebnim ID')

SET IDENTITY_INSERT Firme OFF;
GO

SELECT * FROM Firme

--8
--Deleting record ID 99
DELETE FROM Firme
WHERE FirmaID = 99

SELECT * FROM Firme

--WARNING  - deleting ALL records from the table
DELETE FROM Firme

SELECT * FROM Firme

--9
--Cleanup changes form AdventureWorks2014 database
USE AdventureWorks2014
GO
DELETE FROM Production.ProductReview
WHERE ReviewerName = 'Jasmin'

DELETE FROM Production.ProductReview
WHERE ReviewerName IN (SELECT ReviewerName
					   FROM Production.ProductReview 
					   WHERE ReviewerName ='Denis' 
						OR  ReviewerName = 'Mattias')
SELECT *
FROM Production.ProductReview
GO

--10
SELECT COUNT (*)
FROM Production.TransactionHistoryArchive

--WARNING TRUNCATE table content without logging
TRUNCATE TABLE Production.TransactionHistoryArchive

--11
SELECT *
	FROM Person.Person
WHERE BusinessEntityID = 1

--Change the person LastName and FirstName
UPDATE Person.Person
SET FirstName = 'New Ken', LastName = 'New Sánchez'
WHERE BusinessEntityID = 1

SELECT *
	FROM Person.Person
WHERE BusinessEntityID = 1

--WARNING changing LastName to all persons, always use WHERE!!!
UPDATE Person.Person
SET FirstName = 'New Ken'

SELECT FirstName, LastName
	FROM Person.Person

--12

--Different variants of UPDATE statement
SELECT ListPrice
FROM Production.Product
WHERE ProductID = 713
GO

UPDATE Production.Product
SET ListPrice = ListPrice * 1.1
WHERE ProductID = 713

SELECT ListPrice
FROM Production.Product
WHERE ProductID = 713
GO

--13

--Update records using data from different table as a condition
UPDATE Production.Product
SET ListPrice = ListPrice * 1.1
	FROM Production.ProductCategory AS PC
	INNER JOIN Production.ProductSubcategory AS PS
	ON PC.ProductCategoryID = PS.ProductCategoryID
	INNER JOIN Production.Product AS P
	ON PS.ProductSubcategoryID = P.ProductSubcategoryID
	WHERE PC.Name = 'Bikes'

USE master
GO