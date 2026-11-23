-- 1. Welche saisonalen Rezepte kann ich mit meinem vorhandenen Vorrat kochen? 
    SELECT rezept.name 
    FROM rezept_zutat
    LEFT JOIN vorrat
        ON vorrat.zutat_id = rezept_zutat.zutat_id
        AND vorrat.haushalt_id = 1
    JOIN rezept using (rezept_id)
        WHERE rezept.saison = 'Sommer'
    GROUP BY rezept_zutat.rezept_id
    HAVING COUNT(DISTINCT rezept_zutat.zutat_id) = COUNT(DISTINCT vorrat.zutat_id);

-- 2. Welche Gerichte eines bestimmten Typs habe ich seit mehr als drei Monaten nicht mehr gekocht?
    SELECT *
    FROM kocht
    JOIN rezept using (rezept_id)
    JOIN mahlzeitentyp using (mahlzeitentyp_id)
    GROUP BY rezept_id
    HAVING DATEDIFF(NOW(), MAX(kocht.datum)) > 90;
    
-- 3. Welche Rezepte beinhalten die Zutaten die bald ablaufen?
    SELECT rezept.name,
        Count(*) as 'Anzahl fast abgelaufener Zutaten'
    FROM rezept_zutat
    JOIN vorrat using (zutat_id)
    JOIN zutat using (zutat_id)
    JOIN rezept using (rezept_id)
    WHERE DATEDIFF(MHD, NOW()) BETWEEN 0 AND 3
    GROUP BY rezept_id
    ORDER BY Count(*) DESC;