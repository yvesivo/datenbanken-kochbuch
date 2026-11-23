-- Beispieldaten. Datumswerte relativ zu CURDATE().
USE kochbuechlein;
START TRANSACTION;

INSERT INTO haushalt (haushalt_id, name, adresse, ausstattung) VALUES
    (1, 'WG Lindenstraße', 'Lindenstraße 12, 79098 Freiburg', 'Herd,Kühlschrank,Mikrowelle,Wasserkocher'),
    (2, 'Familie Berger',  'Am Mühlbach 3, 79100 Freiburg',   'Herd,Backofen,Kühlschrank,Gefrierschrank,Grill,Mixer');

INSERT INTO person (person_id, email, vorname, nachname, ist_vegetarisch, ist_vegan, haushalt_id) VALUES
    (1, 'anna.k@example.org',  'Anna',  'Keller',   FALSE, FALSE, 1),
    (2, 'ben.s@example.org',   'Ben',   'Schuster', FALSE, FALSE, 1),
    (3, 'carla.b@example.org', 'Carla', 'Berger',   TRUE,  FALSE, 2),
    (4, 'david.b@example.org', 'David', 'Berger',   FALSE, FALSE, 2);

INSERT INTO kategorie (name, beschreibung, frischedauer_tage, empfohlene_aufbewahrung) VALUES
    ('Gemüse',        'Frisches Gemüse, Knollen und Zwiebeln', 7,    'Kühlschrank'),
    ('Obst',          'Frisches Obst',                         10,   'Obstschale'),
    ('Kräuter',       'Frische Kräuter',                       5,    'Kühlschrank'),
    ('Milchprodukte', 'Milch, Käse, Joghurt, Butter',          10,   'Kühlschrank'),
    ('Fleisch',       'Frisches Fleisch und Geflügel',         3,    'Kühlschrank'),
    ('Eier',          'Hühnereier',                            28,   'Kühlschrank'),
    ('Getreide',      'Nudeln, Reis, Flocken',                 NULL, 'Vorratsschrank'),
    ('Backzutaten',   'Mehl, Zucker, Backpulver',              NULL, 'Vorratsschrank'),
    ('Konserven',     'Dosen und Gläser, ungeöffnet',          NULL, 'Vorratsschrank'),
    ('Öle & Gewürze', 'Speiseöle, Salz, Gewürze',              NULL, 'Vorratsschrank');

INSERT INTO zutat (zutat_id, name, spezifikation, einheit, kategorie) VALUES
    (1,  'Tomate',        '',            'Stk', 'Gemüse'),
    (2,  'Tomate',        'passiert',    'ml',  'Konserven'),
    (3,  'Zwiebel',       '',            'Stk', 'Gemüse'),
    (4,  'Knoblauch',     'Zehe',        'Stk', 'Gemüse'),
    (5,  'Karotte',       '',            'Stk', 'Gemüse'),
    (6,  'Kartoffel',     'festkochend', 'g',   'Gemüse'),
    (7,  'Paprika',       'rot',         'Stk', 'Gemüse'),
    (8,  'Gurke',         '',            'Stk', 'Gemüse'),
    (9,  'Apfel',         '',            'Stk', 'Obst'),
    (10, 'Basilikum',     'frisch',      'g',   'Kräuter'),
    (11, 'Milch',         '3,5 %',       'ml',  'Milchprodukte'),
    (12, 'Butter',        '',            'g',   'Milchprodukte'),
    (13, 'Parmesan',      '',            'g',   'Milchprodukte'),
    (14, 'Joghurt',       'natur',       'g',   'Milchprodukte'),
    (15, 'Hackfleisch',   'Rind',        'g',   'Fleisch'),
    (16, 'Hähnchenbrust', '',            'g',   'Fleisch'),
    (17, 'Ei',            'Größe M',     'Stk', 'Eier'),
    (18, 'Spaghetti',     '',            'g',   'Getreide'),
    (19, 'Reis',          'Basmati',     'g',   'Getreide'),
    (20, 'Haferflocken',  'zart',        'g',   'Getreide'),
    (21, 'Mehl',          'Type 405',    'g',   'Backzutaten'),
    (22, 'Zucker',        '',            'g',   'Backzutaten'),
    (23, 'Olivenöl',      'nativ extra', 'ml',  'Öle & Gewürze'),
    (24, 'Salz',          '',            'g',   'Öle & Gewürze');

INSERT INTO mahlzeitentyp (mahlzeit_id, name, beschreibung) VALUES
    (1, 'Frühstück',       'Erste Mahlzeit am Morgen'),
    (2, 'Mittagessen',     'Warme Hauptmahlzeit am Mittag'),
    (3, 'Abendessen',      'Mahlzeit am Abend'),
    (4, 'Grillabend',      'Geselliges Essen im Freien'),
    (5, 'Weihnachtsessen', 'Festessen an den Feiertagen');

INSERT INTO gerichttyp (name, beschreibung, mahlzeitentyp) VALUES
    ('Müsli & Porridge', 'Flocken oder Brei mit Milch',      1),
    ('Süßspeise',        'Süße Gerichte wie Pfannkuchen',    1),
    ('Suppe',            'Flüssige Gerichte, warm serviert', 2),
    ('Pfannengericht',   'In der Pfanne gegart',             2),
    ('Nudelgericht',     'Pasta mit Soße',                   3),
    ('Salat',            'Kalte Gerichte aus Gemüse',        4),
    ('Braten',           'Fleisch im Ofen gegart',           5);

INSERT INTO rezept (rezept_id, name, portionen, saison, region, ist_vegetarisch, ist_vegan, bild, erstellt_von, mahlzeitentyp) VALUES
    (1, 'Spaghetti Bolognese',     4, 'ganzjährig', 'Italien',      FALSE, FALSE, NULL, 1, 3),
    (2, 'Tomatensalat',            2, 'Sommer',     'Mittelmeer',   TRUE,  TRUE,  NULL, 2, 4),
    (3, 'Pfannkuchen',             4, 'ganzjährig', 'Deutschland',  TRUE,  FALSE, NULL, 3, 1),
    (4, 'Apfel-Porridge',          1, 'Herbst',     'Schottland',   TRUE,  FALSE, NULL, 3, 1),
    (5, 'Hähnchen-Reis-Pfanne',    2, 'ganzjährig', 'Asien',        FALSE, FALSE, NULL, 4, 2),
    (6, 'Kartoffelsuppe',          4, 'Winter',     'Deutschland',  TRUE,  FALSE, NULL, 1, 2),
    (7, 'Gurkensalat mit Joghurt', 2, 'Sommer',     'Griechenland', TRUE,  FALSE, NULL, 2, 4);

INSERT INTO benoetigt (rezept_id, zutat_id, menge) VALUES
    (1, 18, 400),
    (1, 15, 400),
    (1, 2,  500),
    (1, 3,  1),
    (1, 4,  2),
    (1, 23, 20),
    (1, 24, 5),
    (1, 13, 40),
    (2, 1,  4),
    (2, 3,  1),
    (2, 10, 10),
    (2, 23, 30),
    (2, 24, 2),
    (3, 21, 250),
    (3, 11, 500),
    (3, 17, 3),
    (3, 22, 30),
    (3, 12, 20),
    (3, 24, 1),
    (4, 20, 50),
    (4, 11, 200),
    (4, 9,  1),
    (4, 22, 5),
    (5, 16, 300),
    (5, 19, 150),
    (5, 7,  2),
    (5, 3,  1),
    (5, 23, 15),
    (5, 24, 3),
    (6, 6,  800),
    (6, 5,  2),
    (6, 3,  1),
    (6, 12, 30),
    (6, 11, 200),
    (6, 24, 5),
    (7, 8,  1),
    (7, 14, 150),
    (7, 4,  1),
    (7, 24, 2);

INSERT INTO schritt (rezept_id, reihenfolge, beschreibung) VALUES
    (1, 1, 'Zwiebel und Knoblauch würfeln, in Olivenöl glasig dünsten.'),
    (1, 2, 'Hackfleisch zugeben und krümelig anbraten.'),
    (1, 3, 'Passierte Tomaten einrühren, salzen, 30 Minuten köcheln.'),
    (1, 4, 'Spaghetti kochen, mit Soße und Parmesan servieren.'),
    (2, 1, 'Tomaten in Scheiben, Zwiebel in Ringe schneiden.'),
    (2, 2, 'Mit Öl und Salz anmachen, Basilikum darüber.'),
    (3, 1, 'Mehl, Milch, Eier, Zucker und Salz glatt rühren.'),
    (3, 2, 'Teig 15 Minuten quellen lassen.'),
    (3, 3, 'In Butter dünne Pfannkuchen ausbacken.'),
    (4, 1, 'Haferflocken in Milch aufkochen, 5 Minuten quellen lassen.'),
    (4, 2, 'Apfel reiben, unterrühren, mit Zucker abschmecken.'),
    (5, 1, 'Reis garen.'),
    (5, 2, 'Hähnchen in Streifen in Olivenöl anbraten.'),
    (5, 3, 'Zwiebel und Paprika mitbraten, Reis unterheben, salzen.'),
    (6, 1, 'Kartoffeln, Karotten und Zwiebel schälen und würfeln.'),
    (6, 2, 'In Butter andünsten, mit Wasser 20 Minuten kochen.'),
    (6, 3, 'Milch zugeben, pürieren, salzen.'),
    (7, 1, 'Gurke hobeln, salzen, abtropfen lassen.'),
    (7, 2, 'Joghurt mit Knoblauch verrühren und unterheben.');

INSERT INTO kocht (person_id, rezept_id, gekocht_am, notiz) VALUES
    (1, 1, CURDATE() - INTERVAL 14 DAY, 'Mit einem Schuss Rotwein noch besser.'),
    (1, 1, CURDATE() - INTERVAL  3 DAY, NULL),
    (2, 1, CURDATE() - INTERVAL 30 DAY, NULL),
    (2, 2, CURDATE() - INTERVAL 60 DAY, 'Basilikum erst kurz vor dem Servieren.'),
    (3, 3, CURDATE() - INTERVAL  7 DAY, 'Teig über Nacht quellen lassen.'),
    (3, 3, CURDATE() - INTERVAL  1 DAY, NULL),
    (4, 3, CURDATE() - INTERVAL 21 DAY, NULL),
    (4, 5, CURDATE() - INTERVAL 10 DAY, 'Etwas Sojasoße dazu.');

-- Kommentar rechts: haltbar_bis relativ zu heute
INSERT INTO vorrat (haushalt_id, zutat_id, menge, kaufdatum, mhd, ort) VALUES
    (1, 1,  5,    CURDATE() - INTERVAL   5 DAY, NULL,                         'Obstschale'),      -- +2
    (1, 2,  500,  CURDATE() - INTERVAL  20 DAY, CURDATE() + INTERVAL   4 DAY, 'Vorratsschrank'),  -- +4
    (1, 3,  3,    CURDATE() - INTERVAL   2 DAY, NULL,                         'Keller'),          -- +5
    (1, 4,  4,    CURDATE() - INTERVAL   4 DAY, NULL,                         'Vorratsschrank'),  -- +3
    (1, 5,  1,    CURDATE() - INTERVAL   2 DAY, NULL,                         'Kühlschrank'),     -- +5
    (1, 6,  2000, CURDATE() - INTERVAL  10 DAY, CURDATE() + INTERVAL  20 DAY, 'Keller'),          -- +20, MHD vor Kategorie
    (1, 7,  2,    CURDATE() - INTERVAL   9 DAY, NULL,                         'Kühlschrank'),     -- -2, abgelaufen
    (1, 8,  1,    CURDATE() - INTERVAL   4 DAY, NULL,                         'Kühlschrank'),     -- +3
    (1, 10, 15,   CURDATE() - INTERVAL   3 DAY, NULL,                         'Kühlschrank'),     -- +2
    (1, 11, 1000, CURDATE() - INTERVAL   2 DAY, CURDATE() + INTERVAL   6 DAY, 'Kühlschrank'),     -- +6
    (1, 12, 250,  CURDATE() - INTERVAL   3 DAY, CURDATE() + INTERVAL  25 DAY, 'Kühlschrank'),     -- +25
    (1, 13, 100,  CURDATE() - INTERVAL  10 DAY, CURDATE() + INTERVAL  40 DAY, 'Kühlschrank'),     -- +40
    (1, 14, 500,  CURDATE() - INTERVAL   5 DAY, CURDATE() + INTERVAL   3 DAY, 'Kühlschrank'),     -- +3
    (1, 15, 250,  CURDATE() - INTERVAL   1 DAY, NULL,                         'Kühlschrank'),     -- +2
    (1, 18, 500,  CURDATE() - INTERVAL  30 DAY, CURDATE() + INTERVAL 200 DAY, 'Vorratsschrank'),  -- +200
    (1, 23, 500,  CURDATE() - INTERVAL  60 DAY, CURDATE() + INTERVAL 300 DAY, 'Vorratsschrank'),  -- +300
    (1, 24, 500,  CURDATE() - INTERVAL 100 DAY, NULL,                         'Vorratsschrank'),  -- unbegrenzt
    (2, 21, 1000, CURDATE() - INTERVAL 40 DAY,  CURDATE() + INTERVAL 150 DAY, 'Vorratsschrank'),  -- +150
    (2, 22, 1000, CURDATE() - INTERVAL 90 DAY,  NULL,                         'Vorratsschrank'),  -- unbegrenzt
    (2, 17, 4,    CURDATE() - INTERVAL  5 DAY,  CURDATE() + INTERVAL   1 DAY, 'Kühlschrank'),     -- +1
    (2, 11, 300,  CURDATE() - INTERVAL  3 DAY,  CURDATE() + INTERVAL   2 DAY, 'Kühlschrank'),     -- +2
    (2, 12, 100,  CURDATE() - INTERVAL 10 DAY,  CURDATE() + INTERVAL  20 DAY, 'Kühlschrank'),     -- +20
    (2, 24, 250,  CURDATE() - INTERVAL 50 DAY,  NULL,                         'Vorratsschrank'),  -- unbegrenzt
    (2, 20, 500,  CURDATE() - INTERVAL 20 DAY,  CURDATE() + INTERVAL 100 DAY, 'Vorratsschrank'),  -- +100
    (2, 9,  4,    CURDATE() - INTERVAL  3 DAY,  NULL,                         'Obstschale'),      -- +7
    (2, 16, 300,  CURDATE() - INTERVAL  1 DAY,  NULL,                         'Kühlschrank'),     -- +2
    (2, 19, 1000, CURDATE() - INTERVAL 15 DAY,  CURDATE() + INTERVAL 300 DAY, 'Vorratsschrank'),  -- +300
    (2, 7,  2,    CURDATE() - INTERVAL  1 DAY,  NULL,                         'Kühlschrank'),     -- +6
    (2, 3,  2,    CURDATE() - INTERVAL  1 DAY,  NULL,                         'Keller'),          -- +6
    (2, 23, 750,  CURDATE() - INTERVAL 30 DAY,  CURDATE() + INTERVAL 200 DAY, 'Vorratsschrank');  -- +200

COMMIT;
