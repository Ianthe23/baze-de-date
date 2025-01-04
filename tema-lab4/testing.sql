USE "MagazinMercerie"
GO


--Introducem in tabela Tables tabelele pentru test
--Biblioteca - doar cheie primara
--Croseta - are si o cheie straina
--UtilizareCroseta - are 2 chei primare
INSERT INTO Tables(Name) VALUES
('Biblioteca'),
('GhemBumbac'),
('UtilizareCroseta');
GO


--Creeam primul VIEW - contine un SELECT pe o tabela
CREATE OR ALTER VIEW VBiblioteca
AS
SELECT B.NrRafturi
FROM Biblioteca B
GO

--Creeam al doilea VIEW - SELECT pe cel putin 2 tabele
CREATE OR ALTER VIEW VGhemBumbac
AS
SELECT G.Gid, G.Producator, F.Fid, F.Lungime, A.Nume AS AngajatNume
FROM GhemBumbac G
INNER JOIN FirBumbac F ON G.Gid = F.Gid
INNER JOIN Angajat A ON G.AngajatId = A.AngajatId
WHERE F.Lungime > 100
GO

--Creeam al treilea VIEW - SELECT pe cel putin 2 tabele si GROUP BY
CREATE OR ALTER VIEW VUtilizareCroseta
AS
SELECT C.Material, G.Producator 
FROM UtilizareCroseta U
INNER JOIN Croseta C ON U.Cid = C.Cid 
INNER JOIN GhemBumbac G ON U.Gid = G.Gid
GROUP BY C.Material, G.Producator
GO


--Introducem in tabela Views numele view-urilor
INSERT INTO Views VALUES
('VBiblioteca'),
('VGhemBumbac'),
('VUtilizareCroseta');
GO

--Introducem in tabela Tests numele testelor pe care le voi creea
INSERT INTO Tests(Name) Values
('Insert_10'), ---- 1
('Insert_100'), --- 2
('Insert_1000'), -- 3
('Delete_10'), ---- 4
('Delete_100'), --- 5
('Delete_1000'), -- 6
('Select_all'); --- 7
GO

--Introducem in tabela TestTables:
-- * id-ul testului
-- * id-ul tabelei
-- * numarul de randuri afectate de operatia respectiva
-- * pozitia (in ce ordine vor fi considerate operatiile pe teste)
INSERT INTO TestTables VALUES
(1, 1, 10, 1),
(2, 1, 100, 1),
(3, 1, 1000, 1),
(1, 2, 10, 2),
(2, 2, 100, 2),
(3, 2, 1000, 2),
(1, 3, 10, 3),
(2, 3, 100, 3),
(3, 3, 1000, 3),
(4, 1, 10, 3),
(5, 1, 100, 3),
(6, 1, 1000, 3),
(4, 2, 10, 2),
(5, 2, 100, 2),
(6, 2, 1000, 2),
(4, 3, 10, 1),
(5, 3, 100, 1),
(6, 3, 1000, 1);
GO

--Introducem in tabela TestViews:
-- * id-ul testului
-- * id-ul viewului
INSERT INTO TestViews VALUES
(7, 1),
(7, 2),
(7, 3);
GO


--Creeam procedurile de insert, delete si testele
--INSERT in tabela BILBIOTECA
CREATE or ALTER PROCEDURE InsertBiblioteca(@rows int)
AS
BEGIN
	DECLARE @id int
	DECLARE @NrRafturi int
	DECLARE @Culoare VARCHAR(30)
	DECLARE @Inaltime int
	DECLARE @Latime int
	DECLARE @Lungime int
	DECLARE @Capacitate int

	DECLARE @index int
	DECLARE @lastId int

	SET @NrRafturi = 10
	SET @Culoare = 'alb'
	SET @Inaltime = 200
	SET @Latime = 100
	SET @Lungime = 200
	SET @Capacitate = 1000

	SET @index = 1
	SET @id = 3000

	WHILE @index <= @rows
	BEGIN
		SET @id = 3000 + @index
		SELECT TOP 1 @lastId = B.Bid from dbo.Biblioteca B ORDER BY B.Bid DESC
		IF @lastId > 3000
			SET @id = @lastId + 1

	SET IDENTITY_INSERT Biblioteca ON
		INSERT INTO Biblioteca(Bid, NrRafturi, Culoare, Inaltime, Latime, Lungime, Capacitate) VALUES 
		(@id, @NrRafturi, @Culoare, @Inaltime, @Latime, @Lungime, @Capacitate)
		SET IDENTITY_INSERT Biblioteca OFF
	SET @index = @index + 1
	END
END
GO

--DELETE in tabela BIBLIOTECA
CREATE or ALTER PROCEDURE DeleteBiblioteca(@rows int)
AS
BEGIN
	DECLARE @id int
	DECLARE @index int
	DECLARE @lastId int

	SET @id = 3000
	SET @index = @rows

	WHILE @index > 0
	BEGIN
		SET @id = 3000 + @index
		SELECT TOP 1 @lastId = B.Bid FROM dbo.Biblioteca B ORDER BY B.Bid DESC
		IF @lastId > @id	
			SET @id = @lastId

		DELETE FROM Biblioteca WHERE Biblioteca.Bid = @id
		SET @index = @index - 1
	END
END
GO


--INSERT in tabela GHEMBUMBAC
CREATE or ALTER PROCEDURE InsertGhemBumbac(@rows int)
AS
BEGIN
	DECLARE @id int
	DECLARE @NrFire int
	DECLARE @Culoare VARCHAR(30)
	DECLARE @Producator VARCHAR(50)
	DECLARE @Lungime int
	DECLARE @Grosime int
	DECLARE @raft_id int
	DECLARE @angajat_id int

	DECLARE @index int
	DECLARE @lastId int

	SET @NrFire = 6
	SET @Culoare = 'Alb'
	SET @Producator = 'Irika'
	SET @Lungime = 100
	SET @Grosime = 4

	SET @index = 1
	SET @id = 3000

	SELECT @raft_id = R.Rid FROM Raft R WHERE R.Culoare = 'Maro'
	SELECT @angajat_id = A.AngajatId FROM Angajat A WHERE A.nume = 'Andrei'

	WHILE @index <= @rows
	BEGIN
		SET @id = 3000 + @index
		SELECT TOP 1 @lastId = G.Gid FROM dbo.GhemBumbac G ORDER BY G.Gid DESC
		IF @lastId > 3000
			SET @id = @lastId + 1

	INSERT INTO GhemBumbac(Gid, NrFire, Culoare, Producator, Lungime, Grosime, Rid, AngajatId) VALUES
	(@id, @NrFire, @Culoare, @Producator, @Lungime, @Grosime, @raft_id, @angajat_id)

	SET @index = @index + 1
	END
END
GO

--DELETE in tabela GHEMBUMBAC
CREATE or ALTER PROCEDURE DeleteGhemBumbac(@rows int)
AS
BEGIN
	DECLARE @id int
	DECLARE @index int
	DECLARE @lastId int

	SET @id = 3000
	SET @index = @rows

	WHILE @index > 0
	BEGIN	
		SET @id = 3000 + @index
		SELECT TOP 1 @lastId = G.Gid FROM dbo.GhemBumbac G ORDER BY G.Gid DESC
		IF @lastId > @id
			SET @id = @lastId
		DELETE FROM GhemBumbac WHERE GhemBumbac.Gid = @id
		SET @index = @index - 1
	END
END
GO


--INSERT in tabela UTILIZARECROSETA
CREATE or ALTER PROCEDURE InsertUtilizareCroseta (@rows int)
AS
BEGIN
	DECLARE @index int
	DECLARE @croseta_id int
	SET @index = @rows

	SELECT @croseta_id = C.Cid FROM Croseta C WHERE C.Numar = 6

	exec InsertGhemBumbac @rows
	DECLARE @idG int, @NrFire int, @Culoare VARCHAR(30), @Producator VARCHAR(50), @Lungime int, @Grosime int;

	---declaram un cursor
	DECLARE cursorUtilizareCroseta CURSOR SCROLL FOR
	SELECT Gid, NrFire, Culoare, Producator, Lungime, Grosime FROM GhemBumbac;
	OPEN cursorUtilizareCroseta;
	FETCH LAST FROM cursorUtilizareCroseta INTO @idG, @NrFire, @Culoare, @Producator, @Lungime, @Grosime;
	
	WHILE @index > 0 AND @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO UtilizareCroseta VALUES (@croseta_id, @idG)
		FETCH PRIOR FROM cursorUtilizareCroseta INTO @idG, @NrFire, @Culoare, @Producator, @Lungime, @Grosime;
		SET @index = @index - 1;
	END

	CLOSE cursorUtilizareCroseta;
	DEALLOCATE cursorUtilizareCroseta;
END
GO

--DELETE in tabela UTILIZARECROSETA
CREATE or ALTER PROCEDURE DeleteUtilizareCroseta (@rows int)
AS
BEGIN
	DECLARE @idU int
	DECLARE @index int

	DECLARE @idG int

	SET @index = @rows 
	SET @idU = 1

	WHILE @index > 0
	BEGIN
		SELECT TOP 1 @idG = G.Gid FROM dbo.GhemBumbac G ORDER BY G.Gid DESC
		IF @idG > 3000
		BEGIN
			DELETE FROM UtilizareCroseta WHERE UtilizareCroseta.Cid = 101 AND UtilizareCroseta.Gid = @idG
			exec DeleteGhemBumbac 1
			END
		SET @index = @index - 1
	END
END
GO


--Creeam TESTELE
CREATE or ALTER PROCEDURE Insert_10 (@Table VARCHAR(30))
AS
BEGIN
	IF @Table = 'Biblioteca'
		exec InsertBiblioteca 10
	IF @Table = 'GhemBumbac'
		exec InsertGhemBumbac 10
	IF @Table = 'UtilizareCroseta'
		exec InsertUtilizareCroseta 10
END
GO

CREATE or ALTER PROCEDURE Insert_100 (@Table VARCHAR(30))
AS
BEGIN
	IF @Table = 'Biblioteca'
		exec InsertBiblioteca 100
    IF @Table = 'GhemBumbac'
		exec InsertGhemBumbac 100
	IF @Table = 'UtilizareCroseta'
		exec InsertUtilizareCroseta 100
END
GO

CREATE or ALTER PROCEDURE Insert_1000 (@Table VARCHAR(30))
AS
BEGIN
	IF @Table = 'Biblioteca'
		exec InsertBiblioteca 1000
    IF @Table = 'GhemBumbac'
		exec InsertGhemBumbac 1000
	IF @Table = 'UtilizareCroseta'
		exec InsertUtilizareCroseta 1000
END
GO

CREATE or ALTER PROCEDURE Delete_10 (@Table VARCHAR(30))
AS
BEGIN
	IF @Table = 'Biblioteca'
		exec DeleteBiblioteca 10
	IF @Table = 'GhemBumbac'
		exec DeleteGhemBumbac 10
	IF @Table = 'UtilizareCroseta'
		exec DeleteUtilizareCroseta 10
END
GO

CREATE or ALTER PROCEDURE Delete_100 (@Table VARCHAR(30))
AS
BEGIN
	IF @Table = 'Biblioteca'
		exec DeleteBiblioteca 100
	IF @Table = 'GhemBumbac'
		exec DeleteGhemBumbac 100
	IF @Table = 'UtilizareCroseta'
		exec DeleteUtilizareCroseta 100
END
GO

CREATE or ALTER PROCEDURE Delete_1000 (@Table VARCHAR(30))
AS
BEGIN
	IF @Table = 'Biblioteca'
		exec DeleteBiblioteca 1000
	IF @Table = 'GhemBumbac'
		exec DeleteGhemBumbac 1000
	IF @Table = 'UtilizareCroseta'
		exec DeleteUtilizareCroseta 1000
END
GO

CREATE or ALTER PROCEDURE Select_all (@View VARCHAR(30))
AS
BEGIN
	IF @View = 'Biblioteca'
		SELECT * FROM VBiblioteca
	IF @View = 'GhemBumbac'
		SELECT * FROM VGhemBumbac
	IF @View = 'UtilizareCroseta'
		SELECT * FROM VUtilizareCroseta
END
GO


--Procedura main
CREATE or ALTER PROCEDURE Main (@Table VARCHAR(30))
AS
BEGIN
	DECLARE @date1 DATETIME, @date2 DATETIME, @date3 DATETIME
	DECLARE @descriere NVARCHAR(2000)

	DECLARE @testInsert VARCHAR(40)
	DECLARE @testDelete VARCHAR(40)
	DECLARE @nrRows int
	DECLARE @idTest int

	DECLARE @id_table int
	DECLARE @id_view int

	SELECT @id_table = TableID FROM Tables WHERE Name = @Table
	SELECT @id_view = ViewID FROM Views WHERE Name = 'V' + @Table

	SET @nrRows = 1000
	SET @testInsert = 'Insert_' + CONVERT(VARCHAR(5), @nrRows)
	SET @testDelete = 'Delete_' + CONVERT(VARCHAR(5), @nrRows)

	SET @date1 = GETDATE()
	exec @testInsert @Table
	exec @testDelete @Table

	SET @date2 = GETDATE()
	exec Select_all @Table

	SET @date3 = GETDATE()
	SET @descriere = N'Testele: ' + @testInsert + ', ' + @testDelete + ', si view-urile pe' + @Table

	INSERT INTO TestRuns VALUES (@descriere, @date1, @date3)
	SELECT TOP 1 @idTest = T.TestRunID FROM dbo.TestRuns T ORDER BY T.TestRunID DESC
	INSERT INTO TestRunTables VALUES (@idTest, @id_table, @date1, @date2)
	INSERT INTO TestRunViews VALUES (@idTest, @id_view, @date2, @date3)

END
GO

CREATE or ALTER PROCEDURE principala
AS
BEGIN
	DECLARE @index int
	SELECT @index = COUNT(*) FROM Tables
	DECLARE @tableName VARCHAR(20)

	DECLARE cursorTable CURSOR SCROLL FOR
		SELECT name FROM Tables;

	OPEN cursorTable;
		FETCH LAST FROM cursorTable INTO @tableName

	WHILE @index > 0 AND @@FETCH_STATUS = 0
	BEGIN
		EXEC main @tableName
		print @tableName
		FETCH PRIOR FROM cursorTable INTO @tableName;
		SET @index = @index - 1
	END

	CLOSE cursorTable;
	DEALLOCATE cursorTable;
END
GO

EXEC principala

SELECT * FROM TestRuns;
SELECT * FROM TestRunTables;
SELECT * FROM TestRunViews;




DELETE FROM "GhemBumbac" WHERE Gid > 3000
DELETE FROM UtilizareCroseta WHERE Gid > 3000

SELECT * FROM UtilizareCroseta;
SELECT * FROM Biblioteca;
SELECT * FROM Croseta;
SELECT * FROM Angajat;
SELECT * FROM Raft;
SELECT * FROM GhemBumbac;
SELECT * FROM VBiblioteca;
SELECT * FROM VGhemBumbac;
SELECT * FROM VUtilizareCroseta;
SELECT * FROM Views;
SELECT * FROM Tables;
SELECT * FROM Tests;
SELECT * FROM TestTables;
SELECT * FROM TestViews;
SELECT * FROM TestRunTables;
SELECT * FROM TestRunViews;
SELECT * FROM TestRuns;
DELETE FROM Tables;
