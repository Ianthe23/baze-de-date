CREATE Database MagazinMercerie
go

USE MagazinMercerie
go

--Creeam Angajat-Client (m-n)
CREATE TABLE Angajat
(AngajatId INT PRIMARY KEY IDENTITY, 
Salariu int,
Nume varchar(30)
)

CREATE TABLE Client
(ClientId INT PRIMARY KEY IDENTITY,
Nume varchar(30)
)

CREATE TABLE AngajatClient
(AngajatId INT FOREIGN KEY REFERENCES Angajat(AngajatId),
ClientId INT FOREIGN KEY REFERENCES Client(ClientId),
CONSTRAINT pk_AngajatClient PRIMARY KEY (AngajatId, ClientId)
)

--Creeam biblioteca si raftul (1-n)
CREATE TABLE Biblioteca
(Bid INT PRIMARY KEY IDENTITY,
NrRafturi int,
Culoare varchar(30),
Inaltime int,
Latime int,
Lungime int,
Capacitate int
)

CREATE TABLE Raft
(Rid INT PRIMARY KEY IDENTITY,
Capacitate int,
Culoare varchar(30),
Lungime int,
Latime int,
Grosime int,
Bid int FOREIGN KEY REFERENCES Biblioteca(Bid)
)

--Creeam CarteTutorial-TutorialJucariePlus
CREATE TABLE TutorialJucariePlus
(Tid INT PRIMARY KEY,
TipJucarie varchar(40),
Instructiuni varchar(100)
)

CREATE TABLE CarteTutoriale
(CTid INT PRIMARY KEY,
NrPagini int,
Editura varchar(40),
Titlu varchar(50),
Rid int FOREIGN KEY REFERENCES Raft(Rid),
AngajatId int FOREIGN KEY REFERENCES Angajat(AngajatId)
)

CREATE TABLE Continut
(CTid INT FOREIGN KEY REFERENCES CarteTutoriale(CTid),
Tid INT FOREIGN KEY REFERENCES TutorialJucariePlus(Tid),
CONSTRAINT pk_Continut PRIMARY KEY (CTid, Tid)
)

--Creeam Croseta-GhemBumbac (m-n)
CREATE TABLE Croseta
(Cid int PRIMARY KEY,
Numar int,
Material varchar(30),
Marime varchar(10),
AngajatId INT FOREIGN KEY REFERENCES Angajat(AngajatId)
)

CREATE TABLE GhemBumbac
(Gid int PRIMARY KEY,
NrFire int CHECK (NrFire>=1 AND NrFire<=10 ),
Culoare varchar(30) DEFAULT 'Alb',
Producator varchar(50),
Lungime int,
Grosime int,
Rid INT FOREIGN KEY REFERENCES Raft(Rid),
AngajatId INT FOREIGN KEY REFERENCES Angajat(AngajatId)
)

CREATE TABLE UtilizareCroseta
(Cid INT FOREIGN KEY REFERENCES Croseta(Cid),
Gid INT FOREIGN KEY REFERENCES GhemBumbac(Gid),
CONSTRAINT pk_UtilizareCroseta PRIMARY KEY (Cid, Gid)
)

--Creeam Ac-GhemBumbac (m-n)
CREATE TABLE Ac
(Aid int PRIMARY KEY,
Marime varchar(30),
Material varchar(40) Default 'Otel',
MarimeGaura int,
AngajatId INT FOREIGN KEY REFERENCES Angajat(AngajatId)
)

CREATE TABLE UtilizareAc
(Aid INT FOREIGN KEY REFERENCES Ac(Aid),
Gid INT FOREIGN KEY REFERENCES GhemBumbac(Gid),
CONSTRAINT pk_UtilizareAc PRIMARY KEY (Aid, Gid)
)

--Creeam FirBumbac (n-1) cu GhemBumbac
CREATE TABLE FirBumbac
(Fid int PRIMARY KEY,
Culoare varchar(40) DEFAULT 'Alb',
Lungime int,
Grosime int,
Gid INT FOREIGN KEY REFERENCES GhemBumbac(Gid)
)

