USE Farmacie

GO
CREATE FUNCTION validareVanzareProduse(@idVanzare INT,@idProdus INT, @numar_cutii INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @error VARCHAR(100)
	SET @error = ''

	IF (NOT(EXISTS(SELECT cod_vanzare FROM Vanzari WHERE cod_vanzare = @idVanzare)))
		SET @error = @error + 'Vanzarea cu codul ' + CONVERT(VARCHAR,@idVanzare) + ' nu exista.'

	IF (NOT(EXISTS(SELECT cod_produs FROM Produse WHERE cod_produs = @idProdus)))
		SET @error = @error + 'Produsul cu codul ' + CONVERT(VARCHAR,@idProdus) + ' nu exista.'

	IF (EXISTS(SELECT cod_vanzare, cod_produs FROM VanzareProduse WHERE cod_produs = @idProdus AND cod_vanzare = @idVanzare))
		SET @error = @error + 'Datele exista deja in tabel.'
	IF (@numar_cutii<0)
		SET @error = @error + 'numarul de cutii nu poate fi negativ.'
	RETURN @error
END
--PRINT dbo.validareVanzareProduse(1,2,-1);

GO
CREATE  OR ALTER PROCEDURE adaugaVanzProd(@idVanzare INT,@idProdus INT, @numar_cutii INT)
AS
BEGIN

	DECLARE @errorMessage VARCHAR(200)
	SET @errorMessage = dbo.validareVanzareProduse(@idVanzare, @idProdus, @numar_cutii)

	IF (@errorMessage != '')
	BEGIN
		PRINT 'ERROR: ' + @errorMessage
		RETURN
	END
	INSERT INTO VanzareProduse(cod_vanzare, cod_produs, numar_cutii_vandute) VALUES (@idVanzare, @idProdus, @numar_cutii)
END

GO
CREATE  OR ALTER PROCEDURE readVanzProd(@idVanzare INT, @idProdus INT, @numar_cutii INT)
AS
BEGIN
	-- READ
	SELECT * FROM VanzareProduse WHERE cod_vanzare = @idVanzare AND cod_produs = @idProdus
END

GO

CREATE  OR ALTER PROCEDURE updateVanzProd(@idVanzare INT, @idProdus INT, @numar_cutii INT)
AS
BEGIN

	DECLARE @errorMessage VARCHAR(200)
	SET @errorMessage = dbo.validareVanzareProduse(@idVanzare, @idProdus, @numar_cutii)
    UPDATE VanzareProduse SET numar_cutii_vandute = @numar_cutii WHERE cod_vanzare = @idVanzare and cod_produs = @idProdus

END

GO
CREATE  OR ALTER PROCEDURE deleteVanzProd(@idVanzare INT, @idProdus INT, @numar_cutii INT)
AS
BEGIN

	DECLARE @errorMessage VARCHAR(200)
	SET @errorMessage = dbo.validareVanzareProduse(@idVanzare, @idProdus, @numar_cutii)

	DELETE FROM VanzareProduse WHERE cod_vanzare = @idVanzare AND cod_produs = @idProdus
END

SELECT * FROM VanzareProduse
EXEC readVanzProd 11, 5, 3
EXEC adaugaVanzProd 11, 5, 3
EXEC readVanzProd 11, 5, 3
EXEC updateVanzProd 11, 5, 5
EXEC deleteVanzProd 11, 5, 5


GO
-- Validare Tabel Furnizor
CREATE OR ALTER FUNCTION validareFurnizor(@nume VARCHAR(100), @prenume VARCHAR(100),@telefon NVARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @error VARCHAR(100)
	SET @error = ''
	IF (EXISTS(SELECT nume_furnizor,prenume_furnizor FROM Furnizori WHERE nume_furnizor = @nume AND prenume_furnizor = @prenume))
		SET @error = @error + 'Furnizorul e deja inregistrat.'
	IF (@nume = '' OR @prenume = '' OR @telefon = '')
		SET @error = @error + 'Datele nu pot fii nule.'
	IF len(@telefon) != 10
		SET @error = @error + 'Numar de telefon invalid. '
	RETURN @error
END
--PRINT dbo.validareFurnizor('craciun','','0763351272')
GO
CREATE OR ALTER PROCEDURE adaugaFurnizor(@nume VARCHAR(100), @prenume VARCHAR(100),@telefon NVARCHAR(100))
AS
BEGIN
	DECLARE @error VARCHAR (100)
	SET @error = dbo.validareFurnizor(@nume,@prenume,@telefon)
	IF (@error != '')
	BEGIN
		PRINT ' ERROR: ' + @error
		RETURN 
	END
	INSERT INTO Furnizori(nume_furnizor,prenume_furnizor,numar_de_telefon) VALUES (@nume,@prenume,@telefon)
END
GO
CREATE OR ALTER PROCEDURE readFurnizor(@nume NVARCHAR(100))
AS
BEGIN
	SELECT * FROM Furnizori WHERE nume_furnizor = @nume
END

GO
CREATE OR ALTER PROCEDURE updateFurnizor(@nume VARCHAR(100), @prenume VARCHAR(100),@telefon NVARCHAR(100))
AS
BEGIN
	DECLARE @error VARCHAR (100)
	SET @error = dbo.validareFurnizor(@nume,@prenume,@telefon)
	IF (@error != 'Furnizorul e deja inregistrat.')
	BEGIN
		PRINT ' ERROR: ' + @error
		RETURN 
	END
	UPDATE Furnizori SET numar_de_telefon = @telefon WHERE nume_furnizor = @nume AND prenume_furnizor = @prenume
END
GO
CREATE OR ALTER PROCEDURE deleteFurnizor(@nume VARCHAR(100), @prenume VARCHAR(100),@telefon NVARCHAR(100))
AS
BEGIN
	DECLARE @error VARCHAR (100)
	SET @error = dbo.validareFurnizor(@nume,@prenume,@telefon)
	IF (@error = 'Furnizorul e deja inregistrat.')
	BEGIN
		DELETE FROM Furnizori WHERE nume_furnizor = @nume AND prenume_furnizor = @prenume AND numar_de_telefon = @telefon
	END
	ELSE 
	BEGIN 
		PRINT 'Furnizorul nu exista.'
	END
	
END
GO
SELECT * FROM Furnizori
EXEC readFurnizor 'Cazacu'
EXEC adaugaFurnizor 'Cazacu','paul','0799999999'
EXEC adaugaFurnizor 'Duta','sorin','0753157940'
EXEC readFurnizor 'Duta'
EXEC deleteFurnizor 'Duta','sorin','0753157940'
EXEC updateFurnizor 'Cazacu','paul','0788888888'
EXEC readFurnizor 'Cazacu'

-- Validare Tabel Clienti
GO
CREATE OR ALTER FUNCTION validareClient(@nume VARCHAR(100), @prenume VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @error VARCHAR(100)
	SET @error = ''
	IF (EXISTS(SELECT nume_client,prenume_client FROM Clienti WHERE nume_client = @nume AND prenume_client = @prenume))
		SET @error = @error + 'Clientul e deja inregistrat.'
	IF (@nume = '' OR @prenume = '')
		SET @error = @error + 'Datele nu pot fii nule.'
	RETURN @error
END
--PRINT dbo.validareClient('craciun','')
GO
CREATE OR ALTER PROCEDURE adaugaClient(@nume VARCHAR(100), @prenume VARCHAR(100))
AS
BEGIN
	DECLARE @error VARCHAR (100)
	SET @error = dbo.validareClient(@nume,@prenume)
	IF (@error != '')
	BEGIN
		PRINT ' ERROR: ' + @error
		RETURN 
	END
	INSERT INTO Clienti(nume_client,prenume_client) VALUES (@nume,@prenume)
END
GO
CREATE OR ALTER PROCEDURE readClient(@nume VARCHAR(100))
AS
BEGIN
	SELECT * FROM Clienti WHERE nume_client = @nume
END

GO
CREATE OR ALTER PROCEDURE updateClient(@nume VARCHAR(100), @prenume VARCHAR(100))
AS
BEGIN
	DECLARE @error VARCHAR (100)
	SET @error = dbo.validareClient(@nume,@prenume)
	IF (@error = 'Clientul e deja inregistrat.')
	BEGIN
		PRINT ' ERROR: ' + @error
		RETURN 
	END
	UPDATE Clienti SET nume_client = @nume WHERE prenume_client = @prenume
END
GO
CREATE OR ALTER PROCEDURE deleteClient(@nume VARCHAR(100), @prenume VARCHAR(100))
AS
BEGIN
	DECLARE @error VARCHAR (100)
	SET @error = dbo.validareClient(@nume,@prenume)
	IF (@error = 'Clientul e deja inregistrat.')
	BEGIN
		DELETE FROM Clienti WHERE nume_client = @nume AND prenume_client = @prenume
	END
	ELSE 
	BEGIN 
		PRINT 'Clientul nu exista.'
	END
	
END
GO
SELECT * FROM Clienti
EXEC readClient 'Cazacu'
EXEC adaugaClient 'Cazacu','paula'
EXEC readClient 'Cazacu'
EXEC readClient 'Duta'
EXEC deleteClient 'Duta','sorina'
EXEC deleteClient 'Duta','sorina'
EXEC updateClient 'Marian','paula'
EXEC readClient 'Marian'
EXEC deleteClient 'Marian','paula'
GO
CREATE OR ALTER VIEW viewClient
AS
	SELECT nume_client,prenume_client FROM Clienti
GO

CREATE OR ALTER VIEW viewFurnizor
AS
	SELECT nume_furnizor,prenume_furnizor,numar_de_telefon FROM Furnizori
GO

SELECT * FROM viewClient
SELECT * FROM viewFurnizor

CREATE INDEX Client_nume_prenume ON Clienti (nume_client ASC, prenume_client ASC);

CREATE INDEX Furnizori_nume_prenume_telefon ON Furnizori (nume_furnizor ASC,prenume_furnizor ASC, numar_de_telefon ASC); 

SELECT nume_client,prenume_client FROM viewClient
SELECT nume_furnizor, prenume_furnizor, numar_de_telefon FROM viewFurnizor