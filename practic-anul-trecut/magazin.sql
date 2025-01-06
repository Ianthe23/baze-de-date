CREATE DATABASE Magazine
GO

USE Magazine
GO

CREATE TABLE Locatie(
	id_locatie INT PRIMARY KEY IDENTITY,
	localitate NVARCHAR(255),
	strada NVARCHAR(255),
	numar INT,
	cod_postal VARCHAR(7)
);

CREATE TABLE Magazin(
	id_magazin INT PRIMARY KEY IDENTITY,
	denumire VARCHAR(255),
	an_deschidere INT CHECK (an_deschidere >= 1950 AND an_deschidere <= 2025),
	id_locatie INT FOREIGN KEY REFERENCES Locatie(id_locatie)
);

CREATE TABLE Client(
	id_client INT PRIMARY KEY IDENTITY,
	nume NVARCHAR(255),
	prenume NVARCHAR(255),
	gen VARCHAR(20) CHECK (gen = 'masculin' OR gen = 'feminin'),
	data_nastere DATE
);

CREATE TABLE ProdusFavorit(
	id_produs INT PRIMARY KEY IDENTITY,
	denumire NVARCHAR(255),
	pret REAL,
	reducere DECIMAL(5, 2) CHECK (reducere BETWEEN 0 AND 1),
	id_client INT FOREIGN KEY REFERENCES Client(id_client)
);

CREATE TABLE Cumparaturi(
	id_client INT FOREIGN KEY REFERENCES Client(id_client),
	id_magazin INT FOREIGN KEY REFERENCES Magazin(id_magazin),
	data_cumparaturi DATE,
	pret_achitat REAL,
	CONSTRAINT pk_cumparaturi PRIMARY KEY (id_client, id_magazin)
);


INSERT INTO Locatie(localitate, strada, numar, cod_postal) VALUES
('Stefanesti', 'Primaverii', 13, '117718'),
('Cluj-Napoca', 'Lunii', 12, '400112'),
('Ludus', 'Lunga', 15, '332123');
SELECT * FROM Locatie

INSERT INTO Magazin(denumire, an_deschidere, id_locatie) VALUES
('Profi', 2012, 2),
('Lidl', 2009, 1),
('Plus', 2001, 3);
SELECT * FROM Magazin

INSERT INTO Client(nume, prenume, gen, data_nastere) VALUES
('Pastin', 'Maria', 'feminin', '2004-09-04'),
('Gatea', 'David', 'masculin', '2004-04-21'),
('Pastin', 'Ana', 'feminin', '2004-09-04');
SELECT * FROM Client

INSERT INTO ProdusFavorit(denumire, pret, reducere, id_client) VALUES
('Baked Rolls', 7, 0.15, 1),
('Chips Lays', 10, 0.20, 2),
('Pufuleti Star', 8, 0.30, 3);

INSERT INTO ProdusFavorit(denumire, pret, reducere, id_client) VALUES
('Kinder', 13, 0.05, 1),
('Oreo', 12, 0.12, 1),
('Biscuiti', 10, 0.15, 1)
SELECT * FROM ProdusFavorit

INSERT INTO Cumparaturi(id_client, id_magazin, data_cumparaturi, pret_achitat) VALUES
(1, 1, '2024-12-29', 20),
(2, 3, '2025-01-05', 12),
(3, 2, '2024-12-31', 30);
SELECT * FROM Cumparaturi

CREATE PROCEDURE AdaugaClient @id_client INT, @id_magazin INT, @data_cumparaturi DATE, @pret REAL
AS
BEGIN
	IF EXISTS(SELECT * FROM Cumparaturi WHERE id_magazin = @id_magazin AND id_client = @id_client)
	BEGIN
		UPDATE Cumparaturi
		SET data_cumparaturi = @data_cumparaturi, pret_achitat = @pret
		WHERE id_magazin = @id_magazin AND id_client = @id_client
	END
	ELSE
	BEGIN
		INSERT INTO Cumparaturi (id_client, id_magazin, data_cumparaturi, pret_achitat) VALUES
		(@id_client, @id_magazin, @data_cumparaturi, @pret)
	END
END
GO

CREATE VIEW AfiseazaNumeClient 
AS
SELECT c.nume AS Nume, c.prenume AS Prenume
FROM Client C
INNER JOIN ProdusFavorit pf ON pf.id_client = c.id_client
GROUP BY c.id_client, c.nume, c.prenume
HAVING COUNT(c.id_client) <= 3;
GO

SELECT * FROM AfiseazaNumeClient