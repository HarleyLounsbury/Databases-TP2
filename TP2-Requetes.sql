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

SELECT COUNT(*)
FROM Contrats c
GROUP BY idVehicule;

    