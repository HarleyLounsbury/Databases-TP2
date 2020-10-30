###############################################################
# Question 1.
###############################################################
SELECT COUNT(*) AS nbCientsBlainville
FROM Contrats c
	INNER JOIN Locataires l ON c.idLocataire = l.idLocataire
WHERE l.adresse LIKE "%Blainville";

###############################################################
# Question 2.
###############################################################
SELECT MAX(ROUND((kilometrageFin - kilometrageDebut), 1)) AS PlusGrandKilometrage
FROM Contrats;

###############################################################
# Question 3.
###############################################################
SELECT CONCAT(ROUND((SELECT COUNT(*)
		FROM Locataires
        WHERE idEntreprise IS NOT NULL)
        /
        (SELECT COUNT(*)
        FROM Locataires) * 100), '%') AS PourcentageEntreprises;
        
###############################################################
# Question 4.
###############################################################
SELECT (TIMESTAMPDIFF(YEAR, CONCAT('19', SUBSTR(noPermisConduire, 11, 2), '-'
								   , SUBSTR(noPermisConduire, 9, 2), '-'
								   , SUBSTR(noPermisConduire, 7, 2), ' 00:00:00'), NOW())) AS Age
	 , nom
	 , prenom
FROM Locataires
ORDER BY Age;

###############################################################
# Question 5.
###############################################################
SELECT m.nom AS Modele
	 , f.nom AS Fabricant
	 , v.immatriculation AS Immatriculation
     , MAX(kilometrageFin) AS Odomètre
     , COUNT(c.idVehicule) AS nbrLocations
FROM Vehicules v
	INNER JOIN Modeles m ON v.idModele = m.idModele
    INNER JOIN Fabricants f ON m.idFabricant = f.idFabricant
    INNER JOIN Contrats c ON v.idVehicule = c.idVehicule
GROUP BY immatriculation
ORDER BY Odomètre DESC;

###############################################################
# Question 6.
###############################################################
SELECT CONCAT(l.prenom, ' ', l.nom) AS LocataireNumImpaire
FROM Telephones t
	INNER JOIN Locataires l ON t.idLocataire = l.idLocataire
WHERE (CAST(SUBSTR(numero, 1, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 2, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 3, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 4, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 5, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 6, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 7, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 8, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 9, 1) AS SIGNED INT) 
	+ CAST(SUBSTR(numero, 10, 1) AS SIGNED INT) ) % 2 = 1
GROUP BY t.idLocataire;

###############################################################
# Question 7.
###############################################################
SELECT COUNT(*) AS nbrLocations
	 , m.nom AS Modele
     , v.immatriculation
FROM Contrats c
	INNER JOIN Vehicules v ON c.idVehicule = v.idVehicule
    INNER JOIN Modeles m ON v.idModele = m.idModele
GROUP BY c.idVehicule
HAVING nbrLocations > 6
ORDER BY nbrLocations DESC;

###############################################################
# Question 8.
###############################################################
SELECT SUM(DATEDIFF(c.dateFin, c.dateDebut))
FROM Contrats c
	INNER JOIN Vehicules v ON c.idVehicule = v.idVehicule 
WHERE v.immatriculation = 'XYV655';
    
###############################################################
# Question 9.
###############################################################
# Je dois souligner une possible contradiction dans les données entre contrat 26 et 27.
# Il semble que la vehicule avec le idVehicule = 4 RECULE son odomètre sur un period de
# 13 jours entre deux locations. 
# Ceci fait pour 2 possible réponses à la question. 
# La deuxième fonctionnement est en commentaire pour observer la différence.
# Question 14 n'a pas cette nuance vue que "pendant les locations" a été spécifié. 
# idVehicule = 1 recule aussi son odomètre entre contrat 16 et 17, mais ce n'est pas un enjeux pour les réponses suivants.

SELECT ROUND(SUM(c.kilometrageFin - c.kilometrageDebut), 1) AS Totale
#SELECT ROUND(MAX(c.kilometrageFin) - MIN(c.kilometrageDebut), 1) AS Totale
	 , v.immatriculation
FROM Contrats c
	INNER JOIN Vehicules v ON c.idVehicule = v.idVehicule
WHERE MONTH(c.dateDebut) >= 9
  AND MONTH(c.dateFin) <= 10
GROUP BY c.idVehicule
ORDER BY Totale DESC
LIMIT 2;
    
###############################################################
# Question 10.
###############################################################    
SELECT l.prenom AS prenom
	 , l.nom AS nom 
	 , CONCAT('(', SUBSTR(t.numero, 1, 3), ') '
				 , SUBSTR(t.numero, 4, 3), '-'
                 , SUBSTR(t.numero, 7, 4) )AS numéro
FROM Locataires l
	INNER JOIN Telephones t ON l.idLocataire = t.idLocataire
ORDER BY nom DESC, prenom DESC;

###############################################################
# Question 11.
###############################################################    
SELECT l.prenom
	 , l.nom
	 , SUM(DATEDIFF(c.dateFin, c.dateDebut)) as nbrJours
FROM Contrats c
	INNER JOIN Vehicules v ON c.idVehicule = v.idVehicule
    INNER JOIN Locataires l ON c.idLocataire = l.idLocataire
WHERE v.idModele = 2
GROUP BY c.idLocataire
HAVING nbrJours > 7;

###############################################################
# Question 12.
############################################################### 
SELECT c.nom AS Couleur
     , f.nom AS Fabricant
	 , m.nom AS Modele
FROM Couleurs c
	INNER JOIN Vehicules v ON v.idCouleur = v.idCouleur
    INNER JOIN Modeles m ON v.idModele = m.idModele
    INNER JOIN Fabricants f ON m.idFabricant = f.idFabricant
ORDER BY c.nom DESC;

###############################################################
# Question 13.
############################################################### 
SELECT CONCAT('$', ROUND(SUM(c.prix), 2)) AS Montant
FROM Contrats c
	INNER JOIN Locataires l ON c.idLocataire = l.idLocataire
WHERE l.prenom = 'Kathy'
  AND l.nom = 'Leblanc'
  AND DAY(c.dateFin) <= 15;

###############################################################
# Question 14.
############################################################### 
SELECT v.immatriculation
     , ROUND(SUM(c.kilometrageFin - c.kilometrageDebut), 1) as kmParcouru
FROM Vehicules v
	INNER JOIN Contrats c ON v.idVehicule = c.idVehicule
GROUP BY c.idVehicule
ORDER BY kmParcouru DESC;

    
    