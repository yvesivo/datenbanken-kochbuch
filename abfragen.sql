-- 1. Welche Rezepte kann ich mit meinem vorhandenen Vorrat kochen? 

    SELECT rezept_id 
    FROM benoetigt
    LEFT JOIN vorratseintrag
        ON vorratseintrag.zutat_id = benoetigt.zutat_id
        AND vorratseintrag.haushalt_id = 1
    GROUP BY benoetigt.rezept_id
    HAVING COUNT(DISTINCT benoetigt.zutat_id) = COUNT(DISTINCT vorratseintrag.zutat_id);

-- 2. Welche Gerichte eines bestimmten Typs habe ich seit mehr als drei Monaten nicht mehr gekocht?
select * from kochvorgang join rezept using (rezept_id) join rezeptkategorie using (rezeptkategorie_id) GROUP BY rezept_id HAVING DATEDIFF(NOW(), MAX(kochvorgang.datum)) > 90;

-- 3. Welche Rezepte beinhalten die Zutaten die bald ablaufen?
select rezept.name, Count(*) as 'Anzahl fast abgelaufener Zutaten' from benoetigt join vorratseintrag using (zutat_id) join zutat using (zutat_id) join rezept using (rezept_id) WHERE DATEDIFF(MHD, NOW()) BETWEEN 0 AND 3 GROUP BY rezept_id ORDER BY Count(*) DESC;