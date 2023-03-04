USE Farmacie

CREATE TABLE Versiuni(versiune_curenta INT);
INSERT INTO Versiuni VALUES (0);
SELECT * FROM Versiuni;
GO

CREATE PROCEDURE do_1
AS
BEGIN
	ALTER TABLE Contraindicatii
	ALTER COLUMN nerecomandari nvarchar(200);
	UPDATE Versiuni
	SET versiune_curenta=1;
END;
GO

CREATE PROCEDURE undo_1
AS
BEGIN
	ALTER TABLE Contraindicatii
	ALTER COLUMN nerecomandari nvarchar(100);
	UPDATE Versiuni
	SET versiune_curenta=0;
END;
GO

CREATE PROCEDURE do_2
AS
BEGIN
	ALTER TABLE Produse
	ADD data_expirare DATE;
	UPDATE Versiuni
	SET versiune_curenta=2;
END;
GO

CREATE PROCEDURE undo_2
AS
BEGIN
	ALTER TABLE Produse
	DROP COLUMN data_expirare;
	UPDATE Versiuni
	SET versiune_curenta=1;
END;
GO

CREATE PROCEDURE do_3
AS 
BEGIN
	CREATE TABLE Reteta(
	cod_reteta INT PRIMARY KEY IDENTITY,
	cod_vanzare INT UNIQUE,
	data_valabilitate DATE) 
	UPDATE Versiuni
	SET versiune_curenta=3;
END;
GO

CREATE PROCEDURE undo_3
AS 
BEGIN
	DROP TABLE Reteta;
	UPDATE Versiuni
	SET versiune_curenta=2;
END;
GO

CREATE PROCEDURE do_4
AS
BEGIN
	ALTER TABLE Reteta
	ADD CONSTRAINT df_data_valabilitate DEFAULT GETDATE() FOR data_valabilitate; 
	UPDATE Versiuni
	SET versiune_curenta = 4;
 END;
 GO

CREATE PROCEDURE undo_4
AS
BEGIN
	ALTER TABLE Reteta
	DROP CONSTRAINT df_data_valabilitate; 
	UPDATE Versiuni
	SET versiune_curenta = 3;
 END;
 GO

 CREATE PROCEDURE do_5
 AS
 BEGIN
	ALTER TABLE Reteta
	ADD CONSTRAINT fk_cod_vanzare FOREIGN KEY (cod_vanzare) REFERENCES Vanzari(cod_vanzare);
	UPDATE Versiuni
	SET versiune_curenta=5;
END;
GO

CREATE PROCEDURE undo_5
AS
BEGIN
	ALTER TABLE Reteta
	DROP CONSTRAINT fk_cod_vanzare;
	UPDATE Versiuni
	SET versiune_curenta=4;
END;
GO

 CREATE PROCEDURE run @versiune INT
 AS
 BEGIN
	IF @versiune < 0 OR @versiune > 5
	BEGIN 
		PRINT 'Versiune invalida!'
		RETURN
	END

	DECLARE @versiune_curenta AS INT
	SET @versiune_curenta  = (SELECT versiune_curenta FROM Versiuni)
	IF @versiune = @versiune_curenta
	BEGIN
		PRINT 'Ne aflam deja in versiunea data'
		RETURN
	END
	DECLARE @procedura VARCHAR(20)
	DECLARE @undo_procedura VARCHAR(20)

	WHILE(@versiune_curenta < @versiune )
		BEGIN
			SET @versiune_curenta = @versiune_curenta + 1
			SET @procedura = 'do_' + CAST(@versiune_curenta AS VARCHAR(20))
			PRINT 'Se executa ' + @procedura;
			EXEC @procedura
		END
	WHILE(@versiune_curenta > @versiune)
		BEGIN
			SET @undo_procedura = 'undo_' + CAST(@versiune_curenta AS VARCHAR(20))
			EXEC @undo_procedura
			PRINT 'Se executa ' + @undo_procedura;
			SET @versiune_curenta = @versiune_curenta - 1
		END
END
GO
EXEC run -1;

SELECT* FROM Versiuni
