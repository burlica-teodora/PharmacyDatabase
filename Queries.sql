USE Farmacie

--5 where 
--3 group by
--2 distinct
--2 having
--7 ce extrag info din mai mult de 2 tabele
--2 m-m

SELECT DISTINCT pret_total FROM Vanzari WHERE pret_total>130;
--preturile mai mari de 130

SELECT DISTINCT Produse.cod_categorie, Categorii.denumire_categorie FROM Produse JOIN Categorii on Produse.cod_categorie=Categorii.cod_categorie;
--categoriile din care am produse in stoc

SELECT Produse.denumire_produs, SUM(VanzareProduse.numar_cutii_vandute) as total_vandute FROM 
((Produse INNER JOIN VanzareProduse ON Produse.cod_produs=VanzareProduse.cod_produs) 
INNER JOIN Vanzari ON VanzareProduse.cod_vanzare=Vanzari.cod_vanzare) 
WHERE Vanzari.cod_farmacist=1 
GROUP BY 
denumire_produs HAVING SUM(VanzareProduse.numar_cutii_vandute)>2;
--produsele si totalul cutiilor vandute de farmacistul cu cod 1

SELECT Furnizori.nume_furnizor, Furnizori.prenume_furnizor, COUNT(FurnizoriProduse.cod_furnizor) as numar_produse FROM
((Furnizori INNER JOIN FurnizoriProduse ON Furnizori.cod_furnizor=FurnizoriProduse.cod_furnizor)
INNER JOIN Produse ON FurnizoriProduse.cod_produs=Produse.cod_produs)
WHERE Produse.pret_produs>15
GROUP BY nume_furnizor, prenume_furnizor HAVING COUNT(FurnizoriProduse.cod_furnizor)!=0;
--numele si prenumele furnizorilor ce au furnizat un produs mai scump de 15

SELECT Categorii.denumire_categorie, COUNT(Produse.cod_categorie) as popularitate_categorii
FROM (Categorii INNER JOIN Produse ON Categorii.cod_categorie=Produse.cod_categorie)
GROUP BY denumire_categorie ORDER BY COUNT(Produse.cod_categorie) DESC;
--categoriile si numarul de produse in ordine descr la fiecare categorie

SELECT Clienti.nume_client, Clienti.prenume_client, Vanzari.pret_total FROM (Vanzari JOIN Clienti ON Clienti.cod_client=Vanzari.cod_client)
WHERE pret_total between 130 and 150;
--numele si prenumele clientilor care au cumparat produse cu valoarea situata in intervalul [130,150]

SELECT Clienti.nume_client, Clienti.prenume_client FROM (Card_Farmacie JOIN Clienti ON Clienti.cod_client=Card_Farmacie.cod_client)
WHERE numar_puncte>35;
--numele si prenumele clientilor care au numarul de puncte pe card mai mare de 35

SELECT* FROM Farmacisti WHERE EXISTS(SELECT * FROM Vanzari WHERE Farmacisti.cod_farmacist=Vanzari.cod_farmacist);
--numele si prenumele farmacistilor care au efectuat vanzari

SELECT* FROM Clienti WHERE NOT EXISTS(SELECT * FROM Vanzari WHERE Clienti.cod_client=Vanzari.cod_client);
--numele si prenumele clientilor care nu au efectuat vanzari

SELECT Clienti.nume_client, Clienti.prenume_client FROM Clienti INNER JOIN Vanzari ON Clienti.cod_client=Vanzari.cod_client
WHERE data_si_ora_efectuarii LIKE '%2022%';
--numele si prenumele clientilor care au cumparat produse in 2022