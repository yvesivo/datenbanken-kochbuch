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

-- 2. Welche Gerichte eines bestimmten Typs habe ich seit mehr als drei Monaten nicht mehr gekocht?
    SELECT *
    FROM kocht
    JOIN rezept using (rezept_id)
    JOIN mahlzeitentyp using (mahlzeitentyp_id)
    WHERE haushalt_id = 1
    AND person_id = 1
    GROUP BY rezept_id
    HAVING DATEDIFF(NOW(), MAX(kocht.gekocht_am)) > 90;
    
-- 3. Welche Rezepte beinhalten die Zutaten die bald ablaufen?
    SELECT rezept.name AS 'Rezept',
        Count(*) as 'Anzahl fast abgelaufener Zutaten'
    FROM benoetigt
    JOIN vorrat using (zutat_id)
    JOIN zutat using (zutat_id)
    JOIN rezept using (rezept_id)
    WHERE haushalt_id = 2
    AND DATEDIFF(MHD, NOW()) BETWEEN 0 AND 3
    GROUP BY rezept_id
    ORDER BY Count(*) DESC;