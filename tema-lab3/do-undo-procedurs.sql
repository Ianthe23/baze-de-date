USE MagazinMercerie
go

--DO
--Procedure do_proc1
CREATE PROCEDURE do_proc1 AS
ALTER TABLE Raft
ALTER COLUMN Culoare varchar(50)
PRINT 'Am modificat coloana -Culoare- din tabelul -Raft-'
GO

--UNDO
--Procedure undo_proc1
CREATE PROCEDURE undo_proc1 AS
ALTER TABLE Raft
ALTER COLUMN Culoare varchar(30)
PRINT 'Am revenit la vechea coloana -Culoare- din tabelul -Raft-'
GO


--DO
--Procedure do_proc2
CREATE PROCEDURE do_proc2 AS
ALTER TABLE Biblioteca
ADD CONSTRAINT nr_rafturi_min DEFAULT 5 FOR NrRafturi
PRINT 'Am adaugat constrangere pentru coloana -NrRafturi- din tabelul -Biblioteca-'
GO

--UNDO
--Procedure undo_proc2
CREATE PROCEDURE undo_proc2 AS
ALTER TABLE Biblioteca
DROP CONSTRAINT nr_rafturi_min
PRINT 'Am eliminat constrangerea pentru coloana -NrRafturi- din tabelul -Biblioteca-'
GO


--DO
--Procedure do_proc3
CREATE PROCEDURE do_proc3 AS
CREATE TABLE Bold(
Boldid int NOT NULL PRIMARY KEY,
Material varchar(30)
)
PRINT 'Am creat tabela -Bold-'
GO

--UNDO
--Procedure undo_proc3
CREATE PROCEDURE undo_proc3 AS
DROP TABLE Bold
PRINT 'Am sters tabela -Bold-'
GO


--DO
--DROP Procedure do_proc4
CREATE PROCEDURE do_proc4 AS
ALTER TABLE Bold
ADD Gid int
PRINT 'Am adaugat un camp nou in tabela -Bold-'
GO

--UNDO
--DROP Procedure undo_proc4
CREATE PROCEDURE undo_proc4 AS
ALTER TABLE Bold
DROP COLUMN Gid
PRINT 'Am sters coloana -Pret- din tabela -Bold-'
GO


--DO
--DROP Procedure do_proc5
CREATE PROCEDURE do_proc5 AS
ALTER TABLE Bold
ADD CONSTRAINT BFid FOREIGN KEY(Gid) REFERENCES GhemBumbac(Gid)
PRINT 'Am adaugat cheie straina'
GO

--UNDO
--DROP Procedure undo_proc5
CREATE PROCEDURE undo_proc5 AS
ALTER TABLE Bold
DROP CONSTRAINT BFid
PRINT 'Am sters cheia straina'
GO

--creez tabela de versiune
DROP TABLE IF EXISTS Versiune
CREATE TABLE Versiune (
	numarVersiune int --retin versiunea tabelei
);

--pun versiunea initiala a tabelei, 0
INSERT INTO Versiune VALUES(0)

SELECT * FROM Versiune
GO

--DROP PROCEDURE main
CREATE OR ALTER PROCEDURE main @versiune INT
AS
BEGIN
	IF @versiune < 0 OR @versiune > 5
	BEGIN
		PRINT 'Versiune invalida!'
		RETURN
	END

	DECLARE @versiune_curenta AS INT
	--imi iau versiunea curenta din tabela
	SET @versiune_curenta = (SELECT numarVersiune FROM Versiune)

	IF @versiune = @versiune_curenta
	BEGIN
		PRINT 'Versiunea este deja cea curenta!'
		RETURN
	END

	DECLARE @proc varchar(20)
	DECLARE @proc_undo varchar(20)

	DECLARE @gata AS INT
	SET @gata = 0

	DELETE FROM Versiune
	INSERT INTO Versiune(numarVersiune) VALUES (@versiune)

	WHILE(@versiune_curenta < @versiune)
	BEGIN
		SET @gata = @gata + 1
		SET @versiune_curenta = @versiune_curenta + 1
		SET @proc = 'do_proc' + CAST(@versiune_curenta AS VARCHAR(10))
		PRINT 'Se executa ' + @proc
		EXEC @proc
	END

	IF(@gata > 0)
	BEGIN
		RETURN
	END

	WHILE(@versiune_curenta > @versiune)
	BEGIN
		SET @proc_undo = 'undo_proc' + CAST(@versiune_curenta AS VARCHAR(10))
		SET @versiune_curenta = @versiune_curenta - 1
		PRINT 'Se executa ' + @proc_undo
		EXEC @proc_undo
	END
END
GO


exec main 0
exec main 1
exec main 2
exec main 3
exec main 4
exec main 5
exec main 50

exec do_proc5
exec undo_proc5
exec undo_proc4
exec undo_proc3
exec undo_proc2
exec undo_proc1










