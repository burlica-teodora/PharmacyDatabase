use Farmacie
GO
CREATE TABLE Clienti_copie
(cod_client INT PRIMARY KEY IDENTITY,
nume_client VARCHAR(100) NOT NULL,
prenume_client VARCHAR(100) NOT NULL
);

CREATE TABLE Produse_copie
(cod_produs INT PRIMARY KEY IDENTITY,
denumire_produs NVARCHAR(100) not null,
pret_produs float,
numar_cutii_stoc int,
cod_categorie int foreign key references Categorii(cod_categorie)
);

CREATE TABLE ContraindicatiiProduse_copie
(cod_contra int,
cod_produs int,
constraint fk_contra0 foreign key (cod_contra) references Contraindicatii(cod_contra),
constraint fk_ContraProduse0 foreign key (cod_produs) references Produse_copie(cod_produs),
constraint pk_ContraindicatiiProduse_copie primary key (cod_contra, cod_produs)
);
drop table Clienti_copie
drop table Produse_copie
drop table ContraindicatiiProduse_copie
GO
CREATE OR ALTER VIEW ViewClient
AS
	SELECT * FROM Clienti_copie
GO
Select* From ViewClient

GO
CREATE OR ALTER VIEW ViewProduse
AS
	SELECT Categorii.denumire_categorie FROM  (Produse_copie INNER JOIN Categorii ON Produse_copie.cod_categorie = Categorii.cod_categorie) 
GO
Select * From ViewProduse

GO
CREATE OR ALTER VIEW ViewContraindicatiiProduse
AS
	SELECT Contraindicatii.nerecomandari FROM (ContraindicatiiProduse_copie INNER JOIN Contraindicatii on Contraindicatii.cod_contra = ContraindicatiiProduse_copie.cod_contra)
	GROUP BY nerecomandari
GO
Select * FROM ViewContraindicatiiProduse

INSERT INTO Tables VALUES ('Clienti_copie'), ('Produse_copie'),('ContraindicatiiProduse_copie')

INSERT INTO Views VALUES ('ViewClient'),('ViewProduse'),('ViewContraindicatiiProduse')

INSERT INTO Tests VALUES ('selectView'),('insertClient'),('deleteClient'),('insertProduse'),('deleteProduse'),('insertContraindicatiiProduse'),('deleteContraindicatiiProduse')

SELECT * FROM Tests
SELECT * FROM Tables
SELECT * FROM Views

INSERT INTO TestViews VALUES (1,1)
INSERT INTO TestViews VALUES (1,2)
INSERT INTO TestViews VALUES (1,3)

SELECT * FROM TestViews

INSERT INTO TestTables VALUES (2,1,100,1),(4,2,100,2),(6,3,100,3)

SELECT * FROM TestTables
GO

CREATE OR ALTER PROC insertClient
AS
	DECLARE @crt INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestID = 2
	PRINT @rows
	WHILE @crt <= @rows
	BEGIN
		INSERT INTO Clienti_copie VALUES (CAST(@crt as varchar(20)),CAST(@crt as varchar(20)))
		SET @crt = @crt + 1
	END
GO
CREATE OR ALTER PROC deleteClient
AS
	DELETE FROM Clienti_copie 
	
GO
CREATE OR ALTER PROC insertProduse
AS
	DECLARE @crt INT = 1
	DECLARE @crt1 FLOAT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestID = 4
	PRINT @rows
	WHILE @crt <= @rows
	BEGIN
		INSERT INTO Produse_copie VALUES (CAST(@crt as nvarchar(20)),@crt1,@crt,@crt%3+1)
		SET @crt = @crt + 1
		SET @crt1 = @crt1 + 1
	END

GO
CREATE OR ALTER PROC deleteProduse
AS
	DELETE FROM Produse_copie 

GO
CREATE OR ALTER PROC insertContraindicatiiProduse
AS
	DECLARE @crt INT = 1
	DECLARE @crt1 INT = 10
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestID = 6
	PRINT @rows
	WHILE @crt <= @rows
	BEGIN
		INSERT INTO ContraindicatiiProduse_copie VALUES (@crt1,@crt)
		SET @crt = @crt + 1
		SET @crt1 = @crt1 +1
	END
GO
CREATE OR ALTER PROC deleteContraindicatiiProduse
AS
	DELETE FROM ContraindicatiiProduse_copie

GO

CREATE OR ALTER PROC TestRunTablesProc
AS 
	DECLARE @start DATETIME;
	DECLARE @start1 DATETIME;
	DECLARE @start2 DATETIME;
	DECLARE @start3 DATETIME;
	DECLARE @end1 DATETIME;
	DECLARE @end2 DATETIME;
	DECLARE @end3 DATETIME;
	DECLARE @end DATETIME;
	DECLARE @description VARCHAR(100);
	SET @description = '';
	SET @start = GETDATE();
	EXEC deleteContraindicatiiProduse;
	SET @description = @description +  'deleteContra ';
	EXEC deleteProduse;
	SET @description = @description +  'deleteProduse ';
	EXEC deleteClient;
	SET @description = @description +  'deleteClient ';
	
	
	SET @start1 = GETDATE();
	EXEC insertClient;
	SET @description = @description +  'insertClient ';
	SET @end1 = GETDATE();


	SET @start2 = GETDATE();
	EXEC insertProduse;
	SET @description = @description +  'insertProduse ';
	SET @end2 = GETDATE();
	
	SET @start3 = GETDATE();
	EXEC insertContraindicatiiProduse;
	SET @description = @description +  'insertContra ';
	SET @end3 = GETDATE();
	
	DECLARE @start1view DATETIME;
	DECLARE @start2view DATETIME;
	DECLARE @start3view DATETIME;
	DECLARE @end1view DATETIME;
	DECLARE @end2view DATETIME;
	DECLARE @end3view DATETIME;
	
	SET @start1view = GETDATE();
	EXEC ('SELECT * FROM ViewClient');
	SET @description = @description +  'viewClient ';
	SET @end1view = GETDATE();

	SET @start2view = GETDATE();
	EXEC ('SELECT * FROM ViewProduse');
	SET @description = @description +  'viewProduse';
	SET @end2view = GETDATE();


	SET @start3view = GETDATE();
	EXEC ('SELECT * FROM ViewContraindicatiiProduse');
	SET @description = @description +  'viewContraindicatii ';
	SET @end3view = GETDATE();

	SET @end = GETDATE();
	
	
	INSERT INTO TestRuns VALUES (@description,@start,@end)
	DECLARE @ID INT = @@IDENTITY
	INSERT INTO TestRunTables VALUES(@ID,1,@start1,@end1);
	INSERT INTO TestRunTables VALUES(@ID,2,@start2,@end2);
	INSERT INTO TestRunTables VALUES(@ID,3,@start3,@end3);
	INSERT INTO TestRunViews VALUES (@ID, 1, @start1view, @end1view);
	INSERT INTO TestRunViews VALUES (@ID, 2, @start2view, @end2view);
	INSERT INTO TestRunViews VALUES (@ID, 3, @start3view, @end3view);
GO 

EXEC TestRunTablesProc;
select * from Contraindicatii

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews

DELETE FROM TestRuns
DELETE FROM TestRunTables
DELETE FROM TestRunViews

