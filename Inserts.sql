use Farmacie

INSERT INTO Clienti(nume_client,prenume_client) VALUES
('Pop','Andrei'),
('Rus','Matei'),
('Popescu','Bianca'),
('Ivan','Mircea'),
('Stoica','Catalin'),
('Toader','Ioana'),
('Andrei','Marian'),
('Costache','Bogdan'),
('Oltean','Cristian')
;
INSERT INTO Clienti(nume_client,prenume_client) VALUES ('Mocanu','Dani'),('Velcu','Andrei'),('Biju','Costel');
SELECT * FROM Clienti;

INSERT INTO Card_Farmacie(cod_card,numar_puncte,cod_client) VALUES (1,33,3),(2,43,1),(3,12,7),(4,15,8),(5,14,9),(6,3,5),(7,50,2),(8,16,4),(9,76,6);
SELECT * FROM Card_Farmacie;

INSERT INTO Farmacisti(nume_farmacist,prenume_farmacist) VALUES
('Costin','Eugenia'),('Marian','Stefania'),('Achim','Dorin');
INSERT INTO Farmacisti(nume_farmacist,prenume_farmacist) VALUES ('Dobrescu','Alina'),('Encean','Stefan');
SELECT * FROM Farmacisti;

INSERT INTO Vanzari(pret_total,data_si_ora_efectuarii,cod_client,cod_farmacist) VALUES
(150,'2022-10-10 10:01:05',1,2),(120,'2022-09-11 12:01:05',5,1),(130,'2021-03-02 10:01:05',2,1),(145,'2022-01-02 14:01:05',3,2),(150,'2022-02-02 14:01:05',6,2),(145,'2022-05-02 18:03:05',4,3),
(165,'2022-01-02 16:09:09',8,1),(120,'2020-01-02 16:09:09',9,3),(145,'2021-01-02 10:02:05',7,3);
SELECT * FROM Vanzari;

INSERT INTO Categorii(denumire_categorie) VALUES ('Parafarmaceutice'),('Suplimente alimentare'),('Medicamente');
SELECT * FROM Categorii;

INSERT INTO Produse(denumire_produs,pret_produs,numar_cutii_stoc,cod_categorie) VALUES
('Nurofen Express Forte',15,1500,3),('Nurofen raceala si gripa',30,2000,3),('Magnosun',20,1700,2),('Heliocare',10,550,1);
SELECT * FROM Produse;

INSERT INTO Furnizori(nume_furnizor,prenume_furnizor,numar_de_telefon) VALUES
('Dan','Denis','0733171568'), ('Mircea','Aurelian','0726544161');
SELECT * FROM Furnizori;

INSERT INTO Contraindicatii(nerecomandari) VALUES 
(N'Nu utilizati Nurofen Forte dacă sunteţi alergic la ibuprofen.'),
(N'Nu utilizati dacă suferiți de ASTM.'), (N'Interzisa administrarea copiilor sub 12 ani.');
SELECT * FROM Contraindicatii;

INSERT INTO FurnizoriProduse(cod_furnizor, cod_produs) Values
(1,5),(1,6),(2,7),(2,8),(2,5),(1,8);
SELECT * FROM FurnizoriProduse;

INSERT INTO ContraindicatiiProduse(cod_contra,cod_produs) values
(3,5),(4,5),(4,6),(8,5);
SELECT * FROM ContraindicatiiProduse;

INSERT INTO VanzareProduse(cod_vanzare,cod_produs,numar_cutii_vandute) values
(10,5,10),(11,6,4),(12,7,6),(13,5,9),(14,8,15),(15,5,9),(16,5,11),(17,7,6),(18,5,9);
SELECT * FROM VanzareProduse;





