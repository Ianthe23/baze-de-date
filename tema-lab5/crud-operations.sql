USE MagazinMercerie
GO

CREATE or ALTER FUNCTION ValidateStringNotNull (@sir VARCHAR(30))
	RETURNS INT
AS
BEGIN
	IF @sir IS NOT NULL
	BEGIN
		IF @sir = ''
		BEGIN
			RETURN 0
		END
		RETURN 1
	END
	RETURN 0
END
GO


CREATE or ALTER FUNCTION ValidateIntNotNegativeOrZero(@number INT) 
	RETURNS INT
AS
BEGIN
	IF @number <= 0
	BEGIN
		RETURN -1
	END

	RETURN @number
END
GO

CREATE or ALTER FUNCTION ValidateInputNotFloat(@number FLOAT)
	RETURNS INT
AS
BEGIN
    IF @number = FLOOR(@number) AND @number = CEILING(@number)
	BEGIN
        RETURN 1
	END
	RETURN 0
END
GO


CREATE OR ALTER FUNCTION ValidateClientId(@id INT) 
	RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT * FROM Client WHERE ClientId = @id)
	BEGIN
		RETURN 1
	END
	RETURN 0
END
GO

CREATE OR ALTER FUNCTION ValidateAngajatId(@id INT)
	RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT * FROM Angajat WHERE AngajatId = @id)
	BEGIN
		RETURN 1
	END
	RETURN 0
END
GO

CREATE OR ALTER FUNCTION ValidateBibliotecaId(@id INT)
	RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT * FROM Biblioteca WHERE Bid = @id)
	BEGIN
		RETURN 1
	END
	RETURN 0
END
GO

CREATE OR ALTER FUNCTION ValidateAngajatClientLink(@id_client INT, @id_angajat INT)
	RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT * FROM AngajatClient WHERE AngajatClient.ClientId = @id_client AND AngajatClient.AngajatId = @id_angajat)
	BEGIN
		RETURN 0
	END
	RETURN 1
END
GO


CREATE OR ALTER PROCEDURE ValidateClient(
	@nume VARCHAR(30)
)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(MAX) = '';

	IF dbo.ValidateStringNotNull(@nume) = 0
	BEGIN
		SET @ErrorMessage += 'Nume must not be null!';
	END
	
	IF @ErrorMessage <> ''
	BEGIN
		RAISERROR(@ErrorMessage, 16, 1);
		RETURN 0
	END

	RETURN 1
END
GO

CREATE OR ALTER PROCEDURE ValidateAngajat(
	@salariuInput FLOAT,
	@nume VARCHAR(30),
	@salariuOutput INT OUTPUT
)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(MAX) = '';
	
	IF dbo.ValidateInputNotFloat(@salariuInput) = 1
	BEGIN
		SET @SalariuOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@salariuInput));
		IF @SalariuOutput = -1
		BEGIN
			SET @ErrorMessage += 'Salariu must not be negative!' + CHAR(13) + CHAR(10);
		END
		
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Salariu must be int! You introduced a float!' + CHAR(13) + CHAR(10);
	END

	IF dbo.ValidateStringNotNull(@nume) = 0
	BEGIN
		SET @ErrorMessage += 'Nume must not be null!' + CHAR(13) + CHAR(10);
	END

	IF @ErrorMessage <> ''
	BEGIN
		RAISERROR(@ErrorMessage, 16, 1);
		RETURN 0
	END 

	RETURN 1
END
GO


CREATE OR ALTER PROCEDURE ValidateAngajatClient(
	@id_clientInput FLOAT,
	@id_angajatInput FLOAT,
	@id_clientOutput INT OUTPUT,
	@id_angajatOutput INT OUTPUT
)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(MAX) = '';

	IF dbo.ValidateInputNotFloat(@id_clientInput) = 1
	BEGIN
		SET @id_clientOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@id_clientInput))
		IF @id_clientOutput = -1
		BEGIN
			SET @ErrorMessage += 'Client ID must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Client ID must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@id_angajatInput) = 1
	BEGIN
		SET @id_angajatOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@id_angajatInput))
		IF @id_angajatOutput = -1
		BEGIN
			SET @ErrorMessage += 'Client ID must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Client ID must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateClientId(@id_clientOutput) = 0
	BEGIN
		SET @ErrorMessage += 'Client ID does not exist in Client Table!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateAngajatId(@id_angajatOutput) = 0
	BEGIN
		SET @ErrorMessage += 'Angajat ID does not exist in Angajat Table!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateAngajatClientLink(@id_clientOutput, @id_angajatOutput) = 0
	BEGIN
		SET @ErrorMessage += 'Combination already exists!' + CHAR(13) + CHAR(10)
	END

	IF @ErrorMessage <> ''
    BEGIN
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN 0
    END

	RETURN 1
END
GO

CREATE OR ALTER PROCEDURE ValidateBiblioteca(
	@nrRafturiInput FLOAT,
	@culoare VARCHAR(30),
	@inaltimeInput FLOAT,
	@latimeInput FLOAT,
	@lungimeInput FLOAT,
	@capacitateInput FLOAT,

	@nrRafturiOutput INT OUTPUT,
	@inaltimeOutput INT OUTPUT,
	@latimeOutput INT OUTPUT,
	@lungimeOutput INT OUTPUT,
	@capacitateOutput INT OUTPUT
)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(MAX) = ''

	IF dbo.ValidateInputNotFloat(@nrRafturiInput) = 1
	BEGIN
		SET @nrRafturiOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@nrRafturiInput))
		IF @nrRafturiOutput = -1
		BEGIN
			SET @ErrorMessage += 'Nr rafturi must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Nr rafturi must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateStringNotNull(@culoare) = 0
	BEGIN
		SET @ErrorMessage += 'Culoare must not be null!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@inaltimeInput) = 1
	BEGIN
		SET @inaltimeOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@inaltimeInput))
		IF @inaltimeOutput = -1
		BEGIN
			SET @ErrorMessage += 'Inaltime must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Inaltime must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@latimeInput) = 1
	BEGIN
		SET @latimeOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@latimeInput))
		IF @latimeOutput = -1
		BEGIN
			SET @ErrorMessage += 'Latime must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Latime must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@lungimeInput) = 1
	BEGIN
		SET @lungimeOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@lungimeInput))
		IF @lungimeOutput = -1
		BEGIN
			SET @ErrorMessage += 'Lungime must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Lungime must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@capacitateInput) = 1
	BEGIN
		SET @capacitateOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@capacitateInput))
		IF @capacitateOutput = -1
		BEGIN
			SET @ErrorMessage += 'Capacitate must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Capacitate must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF @ErrorMessage <> ''
    BEGIN
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN 0
    END

	RETURN 1
END
GO

CREATE OR ALTER PROCEDURE ValidateRaft(
	@capacitateInput FLOAT,
	@culoare VARCHAR(30),
	@lungimeInput FLOAT,
	@latimeInput FLOAT,
	@grosimeInput FLOAT,
	@id_bibliotecaInput FLOAT,

	@capacitateOutput INT OUTPUT,
	@lungimeOutput INT OUTPUT,
	@latimeOutput INT OUTPUT,
	@grosimeOutput INT OUTPUT,
	@id_bibliotecaOutput INT OUTPUT
)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(MAX) = '';

	IF dbo.ValidateInputNotFloat(@capacitateInput) = 1
	BEGIN
		SET @capacitateOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@capacitateInput))
		IF @capacitateOutput = -1
		BEGIN
			SET @ErrorMessage += 'Capacitate must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Capacitate must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateStringNotNull(@culoare) = 0
	BEGIN
		SET @ErrorMessage += 'Culoare must not be null!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@lungimeInput) = 1
	BEGIN
		SET @lungimeOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@lungimeInput))
		IF @lungimeOutput = -1
		BEGIN
			SET @ErrorMessage += 'Lungime must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Lungime must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@latimeInput) = 1
	BEGIN
		SET @latimeOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@latimeInput))
		IF @latimeOutput = -1
		BEGIN
			SET @ErrorMessage += 'Latime must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Latime must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@grosimeInput) = 1
	BEGIN
		SET @grosimeOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@grosimeInput))
		IF @grosimeOutput = -1
		BEGIN
			SET @ErrorMessage += 'Grosime must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Grosime must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateInputNotFloat(@id_bibliotecaInput) = 1
	BEGIN
		SET @id_bibliotecaOutput = dbo.ValidateIntNotNegativeOrZero(FLOOR (@id_bibliotecaInput))
		IF @id_bibliotecaOutput = -1
		BEGIN
			SET @ErrorMessage += 'Biblioteca ID must not be negative!' + CHAR(13) + CHAR(10)
		END
	END
	ELSE
	BEGIN
		SET @ErrorMessage += 'Biblioteca ID must be int! You introduced a float!' + CHAR(13) + CHAR(10)
	END

	IF dbo.ValidateBibliotecaId(@id_bibliotecaOutput) = 0
	BEGIN
		SET @ErrorMessage += 'Biblioteca ID does not exist in Biblioteca Table!' + CHAR(13) + CHAR(10)
	END

	IF @ErrorMessage <> ''
    BEGIN
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN 0
    END

	RETURN 1
END
GO



CREATE OR ALTER PROCEDURE CRUD_Client
	@nume VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		exec dbo.ValidateClient @nume

		--insert
		INSERT INTO Client(nume) VALUES (@nume)

		--read
		SELECT * FROM Client

		--update
		UPDATE Client
		SET Client.Nume = @nume + '_MODIFIED'
		WHERE Client.Nume = @nume
		SELECT * FROM Client

		--delete
		DELETE FROM Client
		WHERE Client.Nume LIKE @nume + '_MODIFIED'
		SELECT * FROM Client

		PRINT 'CRUD operations were successfully!'
	END TRY

	BEGIN CATCH
		PRINT 'An error or errors occured: ' + ERROR_MESSAGE();
	END CATCH
END
GO


CREATE OR ALTER PROCEDURE CRUD_Angajat
	@salariuInput FLOAT,
	@nume VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @salariu INT
	BEGIN TRY
		exec dbo.ValidateAngajat @salariuInput,
								 @nume,
								 @salariu OUTPUT

		--insert
		INSERT INTO Angajat(Salariu, Nume) VALUES (@salariu, @nume)

		--read
		SELECT * FROM Angajat
		ORDER BY Angajat.Salariu DESC

		--update
		UPDATE Angajat
		SET Angajat.Nume = @nume + '_MODIFIED'
		WHERE Angajat.Nume = @nume
		SELECT * FROM Angajat
		ORDER BY Angajat.Salariu DESC

		--delete
		DELETE FROM Angajat
		WHERE Angajat.Nume LIKE @nume + '_MODIFIED'
		SELECT * FROM Angajat
		ORDER BY Angajat.Salariu DESC

		PRINT 'CRUD operations were successfully!'
	END TRY

	BEGIN CATCH
		PRINT 'An error or errors occured: ' + ERROR_MESSAGE();
	END CATCH

END
GO


CREATE OR ALTER PROCEDURE CRUD_AngajatClient
	@idClientInput FLOAT,
	@idAngajatInput FLOAT,
	@position VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @idClient INT, @idAngajat INT

	BEGIN TRY
		exec dbo.ValidateAngajatClient @idClientInput, @idAngajatInput,
									   @idClient OUTPUT, @idAngajat OUTPUT

		--insert
		INSERT INTO AngajatClient(AngajatId, ClientId) VALUES (@idAngajat, @idClient)
		
		--read
		SELECT * FROM AngajatClient

		--update
		UPDATE AngajatClient
		SET AngajatClient.position = @position + '_MODIFIED'
		WHERE AngajatClient.AngajatId = @idAngajat AND AngajatClient.ClientId = @idClient
		SELECT * FROM AngajatClient

		--delete
		DELETE FROM AngajatClient
		WHERE AngajatClient.position LIKE @position + '_MODIFIED'
		SELECT * FROM AngajatClient

		PRINT 'CRUD operations were successfully!'
	END TRY

	BEGIN CATCH
		PRINT 'An error or errors occurred: ' + ERROR_MESSAGE();
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE CRUD_Biblioteca
	@nrRafturiInput FLOAT,
	@culoare VARCHAR(30),
	@inaltimeInput FLOAT,
	@latimeInput FLOAT,
	@lungimeInput FLOAT,
	@capacitateInput FLOAT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @nrRafturi INT, @inaltime INT, @latime INT, @lungime INT, @capacitate INT
	
	BEGIN TRY
		exec dbo.ValidateBiblioteca @nrRafturiInput, @culoare, @inaltimeInput,
									@latimeInput, @lungimeInput, @capacitateInput,
									@nrRafturi OUTPUT, @inaltime OUTPUT,
									@latime OUTPUT, @lungime OUTPUT, @capacitate OUTPUT
		
		--insert
		INSERT INTO Biblioteca(NrRafturi, Culoare, Inaltime, Latime, Lungime, Capacitate) VALUES
							  (@nrRafturi, @culoare, @inaltime, @latime, @lungime, @capacitate)
		
		--read
		SELECT * FROM Biblioteca
		ORDER BY Biblioteca.NrRafturi DESC

		--update
		UPDATE Biblioteca
		SET Biblioteca.Culoare = @culoare + '_MODIFIED'
		WHERE Biblioteca.Culoare = @culoare
		SELECT * FROM Biblioteca
		ORDER BY Biblioteca.NrRafturi DESC

		--delete
		DELETE FROM Biblioteca
		WHERE Biblioteca.Culoare LIKE @culoare + '_MODIFIED'
		SELECT * FROM Biblioteca
		ORDER BY Biblioteca.NrRafturi DESC

		PRINT 'CRUD operations were successfully!'
	END TRY

	BEGIN CATCH
		PRINT 'An error or errors occurred: ' + ERROR_MESSAGE();
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE CRUD_Raft
	@capacitateInput FLOAT,
	@culoare VARCHAR(30),
	@lungimeInput FLOAT,
	@latimeInput FLOAT,
	@grosimeInput FLOAT,
	@id_bibliotecaInput FLOAT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @capacitate INT, @lungime INT, @latime INT, @grosime INT, @id_biblioteca INT

	BEGIN TRY
		exec dbo.ValidateRaft @capacitateInput, @culoare, @lungimeInput, 
							  @latimeInput, @grosimeInput, @id_bibliotecaInput,
							  @capacitate OUTPUT, @lungime OUTPUT, @latime OUTPUT, @grosime OUTPUT, 
							  @id_biblioteca OUTPUT

	    --insert
		INSERT INTO Raft(Capacitate, Culoare, Lungime, Latime, Grosime, Bid)
		VALUES (@capacitate, @culoare, @lungime, @latime, @grosime, @id_biblioteca)
	 
		--read
		SELECT * FROM Raft
		ORDER BY Raft.Capacitate DESC

		--update
		UPDATE Raft
		SET Culoare = @culoare + '_MODIFIED'
		WHERE Culoare = @culoare
		SELECT * FROM Raft
		ORDER BY Raft.Capacitate DESC

		--delete
		DELETE FROM Raft
		WHERE Culoare LIKE @culoare + '_MODIFIED'
		SELECT * FROM Raft
		ORDER BY Raft.Capacitate DESC

		PRINT 'CRUD operations were successfully!'

	END TRY

	BEGIN CATCH
		PRINT 'An error or errors occured: ' + ERROR_MESSAGE();
	END CATCH
END
GO

CREATE OR ALTER VIEW ViewClient AS
	SELECT Nume FROM Client
	WHERE Nume LIKE 'P%' OR Nume LIKE 'A%'
GO

CREATE OR ALTER VIEW ViewAngajat AS
	SELECT Nume, Salariu FROM Angajat
	WHERE Nume LIKE 'A%'
GO

CREATE OR ALTER VIEW ViewAngajatClient AS
	SELECT
		a.Nume as AngajatNume,
		c.Nume as ClientNume,
		ac.position
		FROM AngajatClient ac
		INNER JOIN Angajat a ON ac.AngajatId = a.AngajatId AND a.Nume LIKE 'An%'
		INNER JOIN Client c ON ac.ClientId = c.ClientId
		WHERE ac.position = 'prima'
GO

CREATE OR ALTER VIEW ViewBiblioteca AS
	SELECT
		NrRafturi,
		Culoare,
		Capacitate
		FROM Biblioteca
		WHERE Culoare LIKE 'a%'
GO

CREATE OR ALTER VIEW ViewRaft AS
	SELECT
		Culoare,
		Capacitate,
		Grosime
		FROM Raft
		WHERE Capacitate < 56
GO

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_AngajatClientPozitie')
DROP INDEX N_idx_AngajatClientPozitie ON AngajatClient
CREATE NONCLUSTERED INDEX N_idx_AngajatClientPozitie ON AngajatClient(position)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_AngajatClient')
DROP INDEX N_idx_AngajatClient ON AngajatClient
CREATE NONCLUSTERED INDEX N_idx_AngajatClient ON AngajatClient(AngajatId, ClientId, position)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_AngajatNume')
DROP INDEX N_idx_AngajatNume ON Angajat
CREATE NONCLUSTERED INDEX N_idx_AngajatNume ON Angajat(Nume)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_AngajatSalariu')
DROP INDEX N_idx_AngajatSalariu ON Angajat
CREATE NONCLUSTERED INDEX N_idx_AngajatSalariu ON Angajat(Salariu)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_Angajat')
DROP INDEX N_idx_Angajat ON Angajat
CREATE NONCLUSTERED INDEX N_idx_Angajat ON Angajat(AngajatId, Nume, Salariu)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_ClientNume')
DROP INDEX N_idx_ClientNume ON Client
CREATE NONCLUSTERED INDEX N_idx_ClientNume ON Client(Nume)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_BibliotecaCuloare')
DROP INDEX N_idx_BibliotecaCuloare ON Biblioteca
CREATE NONCLUSTERED INDEX N_idx_BibliotecaCuloare ON Biblioteca(Culoare)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_Biblioteca')
DROP INDEX N_idx_Biblioteca ON Biblioteca
CREATE NONCLUSTERED INDEX N_idx_Biblioteca ON Biblioteca(Bid, NrRafturi, Culoare, Inaltime, Latime, Lungime, Capacitate)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_RaftGrosime')
DROP INDEX N_idx_RaftGrosime ON Raft
CREATE NONCLUSTERED INDEX N_idx_RaftGrosime ON Raft(Grosime)

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_Raft')
DROP INDEX N_idx_Raft ON Raft
CREATE NONCLUSTERED INDEX N_idx_Raft ON Raft(Rid, Capacitate, Culoare, Lungime, Latime, Grosime, Bid)

SELECT * FROM ViewClient ORDER BY ViewClient.Nume
SELECT * FROM ViewAngajat ORDER BY ViewAngajat.Salariu
SELECT * FROM ViewAngajatClient ORDER BY ViewAngajatClient.position
SELECT * FROM ViewBiblioteca ORDER BY ViewBiblioteca.Culoare
SELECT * FROM ViewRaft ORDER BY ViewRaft.Grosime
SELECT * FROM Angajat
SELECT * FROM Raft

exec CRUD_Client 'Mariposa';
exec CRUD_Client 'Elena Gheorghe';
exec CRUD_Client '';

exec CRUD_Angajat 1000, 'Popovici'
exec CRUD_Angajat 1000.9, 'Popovici'
exec CRUD_Angajat -1000, 'Popovici'
exec CRUD_Angajat -1000, ''

exec CRUD_AngajatClient 1, 2, 'prima'
exec CRUD_AngajatClient 2, 1, 'prima'
exec CRUD_AngajatClient 3, 1, 'prima'
exec CRUD_AngajatClient 2.5, 1, 'ultima'

exec CRUD_Biblioteca 4, 'negru', 100, 100, 100, 500
exec CRUD_Biblioteca 4.5, 'negru', 100, 100, 100.1, 500
exec CRUD_Biblioteca 4, '', 100.1, -100, 100.1, 500.555

exec CRUD_Raft 500, 'negru', 100, 100, 20, 1


--EXEMPLU INDECSI
CREATE TABLE Tea(
Tid INT PRIMARY KEY IDENTITY,
TName VARCHAR(50),
Price INT)
INSERT INTO Tea VALUES ('Mint', 10), ('Ginger', 12), ('Fruits', 9), ('Rose', 8)
SELECT * FROM TeaSELECT * FROM TeaORDER BY Tea.TName