CREATE DATABASE Farmacie;
GO
USE Farmacie;
--creare tabele
CREATE TABLE Clienti
(cod_client INT PRIMARY KEY IDENTITY,
nume_client VARCHAR(100) NOT NULL,
prenume_client VARCHAR(100) NOT NULL
);

CREATE TABLE Card_Farmacie
(cod_card int primary key,
numar_puncte int,
cod_client INT UNIQUE FOREIGN KEY REFERENCES Clienti(cod_client)
);

CREATE TABLE Farmacisti
(cod_farmacist INT PRIMARY KEY IDENTITY,
nume_farmacist VARCHAR(100) NOT NULL,
prenume_farmacist VARCHAR(100) NOT NULL
);

CREATE TABLE Vanzari
(cod_vanzare INT PRIMARY KEY IDENTITY,
pret_total float,
data_si_ora_efectuarii DATETIME,
cod_client INT FOREIGN KEY REFERENCES Clienti(cod_client),
cod_farmacist INT FOREIGN KEY REFERENCES Farmacisti(cod_farmacist)
);

CREATE TABLE Categorii
(cod_categorie INT PRIMARY KEY IDENTITY,
denumire_categorie varchar(100) not null
);

CREATE TABLE Produse
(cod_produs INT PRIMARY KEY IDENTITY,
denumire_produs NVARCHAR(100) not null,
pret_produs float,
numar_cutii_stoc int,
cod_categorie int foreign key references Categorii(cod_categorie)
);

CREATE TABLE VanzareProduse
(cod_vanzare INT,
cod_produs INT,
numar_cutii_vandute int,
CONSTRAINT fk_Vanzare FOREIGN KEY (cod_vanzare) REFERENCES Vanzari(cod_vanzare),
CONSTRAINT fk_Produse FOREIGN KEY (cod_produs) REFERENCES Produse(cod_produs),
CONSTRAINT pk_VanzareProduse PRIMARY KEY (cod_vanzare, cod_produs)
);

CREATE TABLE Furnizori
(cod_furnizor INT PRIMARY KEY IDENTITY,
nume_furnizor varchar(100) not null,
prenume_furnizor varchar(100) not null,
numar_de_telefon nvarchar(100)
);

CREATE TABLE FurnizoriProduse
(cod_furnizor int,
cod_produs int,
CONSTRAINT fk_furnizor FOREIGN KEY (cod_furnizor) references Furnizori(cod_furnizor),
CONSTRAINT fk_FurnizorProdus FOREIGN KEY (cod_produs) references Produse(cod_produs),
CONSTRAINT pk_FurnizoriProduse primary key (cod_furnizor, cod_produs)
);

CREATE TABLE Contraindicatii
(cod_contra int primary key identity,
nerecomandari nvarchar(100)
);

CREATE TABLE ContraindicatiiProduse
(cod_contra int,
cod_produs int,
constraint fk_contra foreign key (cod_contra) references Contraindicatii(cod_contra),
constraint fk_ContraProduse foreign key (cod_produs) references Produse(cod_produs),
constraint pk_ContraindicatiiProduse primary key (cod_contra, cod_produs)
);