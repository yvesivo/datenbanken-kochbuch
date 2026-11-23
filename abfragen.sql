-- 1. Welche saisonalen Rezepte kann ich mit meinem vorhandenen Vorrat kochen? 
    SELECT rezept.name AS 'kochbare Rezepte'
    FROM benoetigt
    LEFT JOIN vorrat
        ON vorrat.zutat_id = benoetigt.zutat_id
        AND vorrat.haushalt_id = 1
    JOIN rezept using (rezept_id)
        WHERE rezept.saison = 'Sommer'
    GROUP BY benoetigt.rezept_id
    HAVING COUNT(DISTINCT benoetigt.zutat_id) = COUNT(DISTINCT vorrat.zutat_id);

-- 2. Welche Gerichte eines bestimmten Typs habe ich seit mehr als 90 Tagen nicht mehr gekocht?
    SELECT rezept.name AS 'Rezept seit 90 Tagen nicht gekocht'
    FROM kocht
    JOIN rezept using (rezept_id)
    JOIN mahlzeitentyp using (mahlzeit_id)
    JOIN person using (person_id)
    JOIN haushalt using (haushalt_id)
    WHERE mahlzeitentyp.name = 'Frühstück'
    AND haushalt_id = 1
    GROUP BY rezept_id
    HAVING DATEDIFF(NOW(), MAX(kocht.gekocht_am)) > 90;
    
-- 3. Welche Rezepte verbrauchen die meisten Zutaten, die bald (z.B. in 3 Tagen) ablaufen oder nicht mehr frisch sind?
    SELECT rezept.name AS 'Rezept',
        Count(*) as 'Anzahl fast abgelaufener Zutaten'
    FROM benoetigt
    JOIN zutat using (zutat_id)
    JOIN rezept using (rezept_id)
    JOIN v_vorrat using (zutat_id)
    JOIN haushalt using (haushalt_id)
    WHERE haushalt.haushalt_id = 2
    AND DATEDIFF(MHD, NOW()) BETWEEN 0 AND 3
    GROUP BY rezept_id
    ORDER BY Count(*) DESC;