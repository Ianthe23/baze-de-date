CREATE DATABASE Trenuri
GO

USE Trenuri
GO

CREATE TABLE Tip(
	id_tip INT PRIMARY KEY IDENTITY,
	descriere VARCHAR(255)
);

CREATE TABLE Tren(
	id_tren INT PRIMARY KEY IDENTITY,
	nume VARCHAR(255),
	id_tip INT FOREIGN KEY REFERENCES Tip(id_tip)
);

CREATE TABLE Ruta(
	id_ruta INT PRIMARY KEY IDENTITY,
	nume VARCHAR(255),
	id_tren INT FOREIGN KEY REFERENCES Tren(id_tren)
);

CREATE TABLE Statie(
	id_statie INT PRIMARY KEY IDENTITY,
	nume VARCHAR(255)
);

CREATE TABLE StatieRuta(
	id_statie INT FOREIGN KEY REFERENCES Statie(id_statie),
	id_ruta INT FOREIGN KEY REFERENCES Ruta(id_ruta),
	oraPlecarii TIME,
	oraSosirii TIME,
	CONSTRAINT pk_statieRuta PRIMARY KEY (id_statie, id_ruta)
);

INSERT INTO Tip(descriere) VALUES
('Mocanita'),
('Sageata Albastra'),
('Personal');

SELECT * FROM Tip

INSERT INTO Tren(nume, id_tip) VALUES
('Thomas', 2),
('Percy', 1),
('Henry', 3);

SELECT * FROM Tren

INSERT INTO Ruta(nume, id_tren) VALUES
('Cluj-Pitesti', 1),
('Ludus-Cluj', 2),
('Pitesti-Bucuresti', 3);

SELECT * FROM Ruta

INSERT INTO Statie(nume) VALUES
('Cluj-Napoca Est'),
('Bucuresti Nord'),
('Razboieni');

SELECT * FROM Statie

INSERT INTO StatieRuta(id_statie, id_ruta, oraPlecarii, oraSosirii) VALUES
(1, 1, '08:00', '18:00'),
(2, 3, '15:00', '17:00'),
(3, 2, '10:00', '12:00');

INSERT INTO StatieRuta(id_statie, id_ruta, oraPlecarii, oraSosirii) VALUES
(2, 1, '08:00', '18:00'),
(3, 1, '08:00', '18:00');

SELECT * FROM StatieRuta


CREATE OR ALTER PROCEDURE AdaugaStatie @id_ruta INT, @id_statie INT, @oraSosirii TIME, @oraPlecarii TIME
AS
BEGIN
	IF EXISTS(SELECT * FROM StatieRuta WHERE id_statie = @id_statie AND id_statie = @id_statie)
	BEGIN
		UPDATE StatieRuta
		SET oraSosirii = @oraSosirii, oraPlecarii = @oraPlecarii
		WHERE id_statie = @id_statie AND id_ruta = @id_ruta
	END
	ELSE
	BEGIN
		INSERT INTO StatieRuta(id_statie, id_ruta, oraPlecarii, oraSosirii)
		VALUES (@id_statie, @id_ruta, @oraPlecarii, @oraSosirii)
	END
END
GO

--selectez rutele care NU au statii care NU exista in tabela StatieRuta (asa trebuie sa o gandesc)
CREATE VIEW RuteCuToateStatiile
AS
	SELECT r.nume AS nume_ruta
	FROM Ruta r
	WHERE NOT EXISTS(
		SELECT 1
		FROM Statie s
		WHERE NOT EXISTS(
			SELECT 1
			FROM StatieRuta sr
			WHERE sr.id_ruta = r.id_ruta AND sr.id_statie = s.id_statie
		)
	);
GO

SELECT * FROM RuteCuToateStatiile
		
