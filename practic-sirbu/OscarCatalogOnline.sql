CREATE DATABASE CatalogOnlineOscar
GO

USE CatalogOnlineOscar
GO

CREATE TABLE Hala(
	id_hala INT PRIMARY KEY IDENTITY,
	litera VARCHAR(2),
	suprafata REAL
);

CREATE TABLE Taraba(
	id_taraba INT PRIMARY KEY IDENTITY,
	suprafata REAL,
	numar INT,
	id_hala INT FOREIGN KEY REFERENCES Hala(id_hala)
);

CREATE TABLE Categorie(
	id_categorie INT PRIMARY KEY IDENTITY,
	nume NVARCHAR(255)
);

CREATE TABLE TarabaCategorie(
	id_taraba INT FOREIGN KEY REFERENCES Taraba(id_taraba),
	id_categorie INT FOREIGN KEY REFERENCES Categorie(id_categorie),
	CONSTRAINT pk_tarabaCategorie PRIMARY KEY (id_taraba, id_categorie)
);

CREATE TABLE Produs(
	id_produs INT PRIMARY KEY IDENTITY,
	denumire NVARCHAR(255),
	pret REAL,
	id_categorie INT FOREIGN KEY REFERENCES Categorie(id_categorie)
);

INSERT INTO Hala(litera, suprafata) VALUES
('A', 200),
('B', 150),
('C', 350);
SELECT * FROM Hala;

INSERT INTO Taraba(suprafata, numar, id_hala) VALUES
(20, 1, 1),
(25, 1, 2),
(24, 2, 2);
SELECT * FROM Taraba

INSERT INTO Categorie(nume) VALUES
('decoratiuni'),
('tablouri'),
('plante');
INSERT INTO Categorie(nume) VALUES
('vesela');
SELECT * FROM Categorie


INSERT INTO TarabaCategorie(id_taraba, id_categorie) VALUES
(1, 1),
(2, 3),
(3, 2);
INSERT INTO TarabaCategorie(id_taraba, id_categorie) VALUES
(2, 4);
INSERT INTO TarabaCategorie(id_taraba, id_categorie) VALUES
(1, 4);
SELECT * FROM TarabaCategorie


INSERT INTO Produs(denumire, pret, id_categorie) VALUES
('bibelou', 250, 1),
('vernisaj', 1000, 2),
('bonsai', 433, 3);
INSERT INTO Produs(denumire, pret, id_categorie) VALUES
('farfurie portelan', 111, 4);
SELECT * FROM Produs


CREATE OR ALTER PROCEDURE ActualizeazaPret @id_taraba INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM Taraba WHERE id_taraba = @id_taraba)
	BEGIN
		RAISERROR('Nu exista taraba respectiva!', 16, 1);
		RETURN;
	END
	IF NOT EXISTS(SELECT 1 FROM Taraba T INNER JOIN TarabaCategorie TC ON T.id_taraba = TC.id_taraba
										 INNER JOIN Categorie C ON TC.id_categorie = C.id_categorie
										 INNER JOIN Produs P ON P.id_categorie = C.id_categorie
										 WHERE T.id_taraba = @id_taraba)
	BEGIN
		RAISERROR('Nu exista produse pe taraba respectiva', 16, 1)
		RETURN;
	END
	ELSE
	BEGIN
		UPDATE Produs SET pret = pret + 10 WHERE id_categorie IN (SELECT id_categorie FROM TarabaCategorie WHERE id_taraba = @id_taraba) AND pret < 100
		UPDATE Produs SET pret = pret + 50 WHERE id_categorie IN (SELECT id_categorie FROM TarabaCategorie WHERE id_taraba = @id_taraba) AND pret > 200
		UPDATE Produs SET pret = pret + pret * 0.1 WHERE id_categorie IN (SELECT id_categorie FROM TarabaCategorie WHERE id_taraba = @id_taraba) AND pret > 99 AND pret < 201
		PRINT 'Am actualizat pretul!'
	END
END
GO

exec ActualizeazaPret 1

CREATE OR ALTER VIEW AfiseazaProduse
AS
	SELECT P.denumire AS Denumire, P.pret * 0.4 AS Pret 
	FROM TarabaCategorie TC
	INNER JOIN Categorie C ON C.id_categorie = TC.id_categorie
	INNER JOIN Taraba T ON T.id_taraba = TC.id_taraba
	INNER JOIN Hala H ON H.id_hala = T.id_hala
	INNER JOIN Produs P ON C.id_categorie = P.id_categorie
	WHERE (C.nume = 'haine' OR C.nume = 'vesela') AND (H.litera = 'A' OR H.litera = 'F' OR H.litera = 'X')
GO

SELECT * FROM AfiseazaProduse