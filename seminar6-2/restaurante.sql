CREATE DATABASE ReviewRestaurante
GO

USE ReviewRestaurante
GO

CREATE TABLE Oras(
	id_oras INT PRIMARY KEY IDENTITY,
	nume VARCHAR(255)
);

CREATE TABLE TipRestaurant(
	id_tip INT PRIMARY KEY IDENTITY,
	nume VARCHAR(255),
	descriere VARCHAR(255)
);

CREATE TABLE Restaurant(
	id_restaurant INT PRIMARY KEY IDENTITY,
	nume VARCHAR(255),
	adresa VARCHAR(255),
	telefon VARCHAR(11) UNIQUE, 
	id_tip INT FOREIGN KEY REFERENCES TipRestaurant(id_tip),
	id_oras INT FOREIGN KEY REFERENCES Oras(id_oras)
);

CREATE TABLE Utilizator(
	id_utilizator INT PRIMARY KEY IDENTITY,
	nume_utilizator VARCHAR(20),
	email VARCHAR(100),
	parola VARCHAR(30)
);

CREATE TABLE Nota(
	id_utilizator INT FOREIGN KEY REFERENCES Utilizator(id_utilizator),
	id_restaurant INT FOREIGN KEY REFERENCES Restaurant(id_restaurant),
	scor REAL
	CONSTRAINT pk_nota PRIMARY KEY (id_utilizator, id_restaurant)
);

INSERT INTO Oras(nume) VALUES
('Bucuresti'),
('Pitesti'),
('Cluj-Napoca');

SELECT * FROM Oras

INSERT INTO TipRestaurant(nume, descriere) VALUES
('Fast Food', 'aripioare pe bune'),
('Classy', 'orice e de bun gust'),
('Karaoke', 'mananci si razi in acelasi timp');

SELECT * FROM TipRestaurant

INSERT INTO Restaurant(nume, adresa, telefon, id_tip, id_oras) VALUES
('KFC', 'Vivo Mall', '0787111222', 1, 2),
('Makeba', 'Centru', '0745010232', 2, 3),
('Sing and eat!', 'Centrul Vechi', '0744104467', 3, 1);

SELECT * FROM Restaurant

INSERT INTO Utilizator(nume_utilizator, email, parola) VALUES
('Maria', 'ivo.pastin@gmail.com', 'ivona2004'),
('David', 'david.gatea@gmail.com', '15031204'),
('Ana', 'ana.pastin@gmail.com', '1601');

SELECT * FROM Utilizator

DROP TABLE Nota

INSERT INTO Nota(id_utilizator, id_restaurant, scor) VALUES
(1, 5, 8.50),
(2, 6, 7),
(3, 4, 10);

SELECT * FROM Nota

CREATE OR ALTER PROCEDURE AdaugaNota @id_restaurant INT, @id_utilizator INT, @scor REAl
AS
BEGIN
	IF EXISTS(SELECT * FROM Nota WHERE id_restaurant = @id_restaurant AND id_utilizator = @id_utilizator)
	BEGIN
		UPDATE Nota
		SET scor = @scor
		WHERE id_restaurant = @id_restaurant AND id_utilizator = @id_utilizator
	END
	ELSE
	BEGIN
		INSERT INTO Nota(id_utilizator, id_restaurant, scor) VALUES
		(@id_utilizator, @id_restaurant, @scor)
	END
END
GO

CREATE FUNCTION Afiseaza(@email VARCHAR(100))
RETURNS TABLE AS
RETURN SELECT 
	T.nume AS Tip, 
	R.nume AS NumeRestaurant, 
	R.telefon AS Telefon, 
	O.nume AS NumeOras, 
	N.scor AS Nota, 
	U.nume_utilizator AS NumeUtilizator, 
	U.email AS EmailUtilizator 
FROM Utilizator U
INNER JOIN Nota N ON U.id_utilizator = N.id_utilizator
INNER JOIN Restaurant R ON N.id_restaurant = R.id_restaurant
INNER JOIN TipRestaurant T ON R.id_tip = T.id_tip
INNER JOIN Oras O ON R.id_oras = O.id_oras
WHERE U.email = @email;

SELECT * FROM dbo.Afiseaza('ivo.pastin@gmail.com');




