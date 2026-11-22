-- Beispieldaten. Datumswerte relativ zu CURDATE().
USE kochbuechlein;
START TRANSACTION;

INSERT INTO haushalt (name, adresse) VALUES
    ('WG Lindenstraße', 'Lindenstraße 12, 79098 Freiburg'),
    ('Familie Berger',  'Am Mühlbach 3, 79100 Freiburg');

INSERT INTO person (email, vorname, nachname, haushalt) VALUES
    ('anna.k@example.org',  'Anna',  'Keller',   'WG Lindenstraße'),
    ('ben.s@example.org',   'Ben',   'Schuster', 'WG Lindenstraße'),
    ('carla.b@example.org', 'Carla', 'Berger',   'Familie Berger'),
    ('david.b@example.org', 'David', 'Berger',   'Familie Berger');

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

INSERT INTO zutat (name, spezifikation, einheit, kategorie) VALUES
    ('Tomate',        '',            'Stk', 'Gemüse'),
    ('Tomate',        'passiert',    'ml',  'Konserven'),
    ('Zwiebel',       '',            'Stk', 'Gemüse'),
    ('Knoblauch',     'Zehe',        'Stk', 'Gemüse'),
    ('Karotte',       '',            'Stk', 'Gemüse'),
    ('Kartoffel',     'festkochend', 'g',   'Gemüse'),
    ('Paprika',       'rot',         'Stk', 'Gemüse'),
    ('Gurke',         '',            'Stk', 'Gemüse'),
    ('Apfel',         '',            'Stk', 'Obst'),
    ('Basilikum',     'frisch',      'g',   'Kräuter'),
    ('Milch',         '3,5 %',       'ml',  'Milchprodukte'),
    ('Butter',        '',            'g',   'Milchprodukte'),
    ('Parmesan',      '',            'g',   'Milchprodukte'),
    ('Joghurt',       'natur',       'g',   'Milchprodukte'),
    ('Hackfleisch',   'Rind',        'g',   'Fleisch'),
    ('Hähnchenbrust', '',            'g',   'Fleisch'),
    ('Ei',            'Größe M',     'Stk', 'Eier'),
    ('Spaghetti',     '',            'g',   'Getreide'),
    ('Reis',          'Basmati',     'g',   'Getreide'),
    ('Haferflocken',  'zart',        'g',   'Getreide'),
    ('Mehl',          'Type 405',    'g',   'Backzutaten'),
    ('Zucker',        '',            'g',   'Backzutaten'),
    ('Olivenöl',      'nativ extra', 'ml',  'Öle & Gewürze'),
    ('Salz',          '',            'g',   'Öle & Gewürze');

INSERT INTO mahlzeitentyp (name, beschreibung) VALUES
    ('Frühstück',       'Erste Mahlzeit am Morgen'),
    ('Mittagessen',     'Warme Hauptmahlzeit am Mittag'),
    ('Abendessen',      'Mahlzeit am Abend'),
    ('Grillabend',      'Geselliges Essen im Freien'),
    ('Weihnachtsessen', 'Festessen an den Feiertagen');

INSERT INTO gerichttyp (name, beschreibung, mahlzeitentyp) VALUES
    ('Müsli & Porridge', 'Flocken oder Brei mit Milch',      'Frühstück'),
    ('Süßspeise',        'Süße Gerichte wie Pfannkuchen',    'Frühstück'),
    ('Suppe',            'Flüssige Gerichte, warm serviert', 'Mittagessen'),
    ('Pfannengericht',   'In der Pfanne gegart',             'Mittagessen'),
    ('Nudelgericht',     'Pasta mit Soße',                   'Abendessen'),
    ('Salat',            'Kalte Gerichte aus Gemüse',        'Grillabend'),
    ('Braten',           'Fleisch im Ofen gegart',           'Weihnachtsessen');

INSERT INTO rezept (name, portionen, saison, region, bild, erstellt_von, mahlzeitentyp) VALUES
    ('Spaghetti Bolognese',     4, 'ganzjährig', 'Italien',      'bilder/bolognese.jpg',   'anna.k@example.org',  'Abendessen'),
    ('Tomatensalat',            2, 'Sommer',     'Mittelmeer',   NULL,                     'ben.s@example.org',   'Grillabend'),
    ('Pfannkuchen',             4, 'ganzjährig', 'Deutschland',  'bilder/pfannkuchen.jpg', 'carla.b@example.org', 'Frühstück'),
    ('Apfel-Porridge',          1, 'Herbst',     'Schottland',   NULL,                     'carla.b@example.org', 'Frühstück'),
    ('Hähnchen-Reis-Pfanne',    2, 'ganzjährig', 'Asien',        NULL,                     'david.b@example.org', 'Mittagessen'),
    ('Kartoffelsuppe',          4, 'Winter',     'Deutschland',  NULL,                     'anna.k@example.org',  'Mittagessen'),
    ('Gurkensalat mit Joghurt', 2, 'Sommer',     'Griechenland', NULL,                     'ben.s@example.org',   'Grillabend');

INSERT INTO rezept_zutat (rezept, zutat_name, zutat_spezifikation, menge) VALUES
    ('Spaghetti Bolognese',   'Spaghetti',    '',            400),
    ('Spaghetti Bolognese',   'Hackfleisch',  'Rind',        400),
    ('Spaghetti Bolognese',   'Tomate',       'passiert',    500),
    ('Spaghetti Bolognese',   'Zwiebel',      '',            1),
    ('Spaghetti Bolognese',   'Knoblauch',    'Zehe',        2),
    ('Spaghetti Bolognese',   'Olivenöl',     'nativ extra', 20),
    ('Spaghetti Bolognese',   'Salz',         '',            5),
    ('Spaghetti Bolognese',   'Parmesan',     '',            40),

    ('Tomatensalat',          'Tomate',       '',            4),
    ('Tomatensalat',          'Zwiebel',      '',            1),
    ('Tomatensalat',          'Basilikum',    'frisch',      10),
    ('Tomatensalat',          'Olivenöl',     'nativ extra', 30),
    ('Tomatensalat',          'Salz',         '',            2),

    ('Pfannkuchen',           'Mehl',         'Type 405',    250),
    ('Pfannkuchen',           'Milch',        '3,5 %',       500),
    ('Pfannkuchen',           'Ei',           'Größe M',     3),
    ('Pfannkuchen',           'Zucker',       '',            30),
    ('Pfannkuchen',           'Butter',       '',            20),
    ('Pfannkuchen',           'Salz',         '',            1),

    ('Apfel-Porridge',        'Haferflocken', 'zart',        50),
    ('Apfel-Porridge',        'Milch',        '3,5 %',       200),
    ('Apfel-Porridge',        'Apfel',        '',            1),
    ('Apfel-Porridge',        'Zucker',       '',            5),

    ('Hähnchen-Reis-Pfanne',  'Hähnchenbrust','',           300),
    ('Hähnchen-Reis-Pfanne',  'Reis',         'Basmati',     150),
    ('Hähnchen-Reis-Pfanne',  'Paprika',      'rot',         2),
    ('Hähnchen-Reis-Pfanne',  'Zwiebel',      '',            1),
    ('Hähnchen-Reis-Pfanne',  'Olivenöl',     'nativ extra', 15),
    ('Hähnchen-Reis-Pfanne',  'Salz',         '',            3),

    ('Kartoffelsuppe',        'Kartoffel',    'festkochend', 800),
    ('Kartoffelsuppe',        'Karotte',      '',            2),
    ('Kartoffelsuppe',        'Zwiebel',      '',            1),
    ('Kartoffelsuppe',        'Butter',       '',            30),
    ('Kartoffelsuppe',        'Milch',        '3,5 %',       200),
    ('Kartoffelsuppe',        'Salz',         '',            5),

    ('Gurkensalat mit Joghurt','Gurke',        '',           1),
    ('Gurkensalat mit Joghurt','Joghurt',      'natur',      150),
    ('Gurkensalat mit Joghurt','Knoblauch',    'Zehe',       1),
    ('Gurkensalat mit Joghurt','Salz',         '',           2);

INSERT INTO schritt (rezept, reihenfolge, beschreibung) VALUES
    ('Spaghetti Bolognese', 1, 'Zwiebel und Knoblauch würfeln, in Olivenöl glasig dünsten.'),
    ('Spaghetti Bolognese', 2, 'Hackfleisch zugeben und krümelig anbraten.'),
    ('Spaghetti Bolognese', 3, 'Passierte Tomaten einrühren, salzen, 30 Minuten köcheln.'),
    ('Spaghetti Bolognese', 4, 'Spaghetti kochen, mit Soße und Parmesan servieren.'),
    ('Tomatensalat', 1, 'Tomaten in Scheiben, Zwiebel in Ringe schneiden.'),
    ('Tomatensalat', 2, 'Mit Öl und Salz anmachen, Basilikum darüber.'),
    ('Pfannkuchen', 1, 'Mehl, Milch, Eier, Zucker und Salz glatt rühren.'),
    ('Pfannkuchen', 2, 'Teig 15 Minuten quellen lassen.'),
    ('Pfannkuchen', 3, 'In Butter dünne Pfannkuchen ausbacken.'),
    ('Apfel-Porridge', 1, 'Haferflocken in Milch aufkochen, 5 Minuten quellen lassen.'),
    ('Apfel-Porridge', 2, 'Apfel reiben, unterrühren, mit Zucker abschmecken.'),
    ('Hähnchen-Reis-Pfanne', 1, 'Reis garen.'),
    ('Hähnchen-Reis-Pfanne', 2, 'Hähnchen in Streifen in Olivenöl anbraten.'),
    ('Hähnchen-Reis-Pfanne', 3, 'Zwiebel und Paprika mitbraten, Reis unterheben, salzen.'),
    ('Kartoffelsuppe', 1, 'Kartoffeln, Karotten und Zwiebel schälen und würfeln.'),
    ('Kartoffelsuppe', 2, 'In Butter andünsten, mit Wasser 20 Minuten kochen.'),
    ('Kartoffelsuppe', 3, 'Milch zugeben, pürieren, salzen.'),
    ('Gurkensalat mit Joghurt', 1, 'Gurke hobeln, salzen, abtropfen lassen.'),
    ('Gurkensalat mit Joghurt', 2, 'Joghurt mit Knoblauch verrühren und unterheben.');

INSERT INTO kocht (koch, rezept, notiz) VALUES
    ('anna.k@example.org',  'Spaghetti Bolognese',  'Mit einem Schuss Rotwein noch besser.'),
    ('ben.s@example.org',   'Spaghetti Bolognese',  NULL),
    ('ben.s@example.org',   'Tomatensalat',         'Basilikum erst kurz vor dem Servieren.'),
    ('carla.b@example.org', 'Pfannkuchen',          'Teig über Nacht quellen lassen.'),
    ('david.b@example.org', 'Pfannkuchen',          NULL),
    ('david.b@example.org', 'Hähnchen-Reis-Pfanne', 'Etwas Sojasoße dazu.');

-- Kommentar rechts: haltbar_bis relativ zu heute
INSERT INTO vorrat (haushalt, zutat_name, zutat_spezifikation, menge, kaufdatum, mhd, ort) VALUES
    ('WG Lindenstraße', 'Tomate',      '',            5,    CURDATE() - INTERVAL   5 DAY, NULL, 'Obstschale'),                          -- +2
    ('WG Lindenstraße', 'Tomate',      'passiert',    500,  CURDATE() - INTERVAL  20 DAY, CURDATE() + INTERVAL   4 DAY, 'Vorratsschrank'),  -- +4
    ('WG Lindenstraße', 'Zwiebel',     '',            3,    CURDATE() - INTERVAL   2 DAY, NULL, 'Keller'),                          -- +5
    ('WG Lindenstraße', 'Knoblauch',   'Zehe',        4,    CURDATE() - INTERVAL   4 DAY, NULL, 'Vorratsschrank'),                          -- +3
    ('WG Lindenstraße', 'Karotte',     '',            1,    CURDATE() - INTERVAL   2 DAY, NULL, 'Kühlschrank'),                          -- +5
    ('WG Lindenstraße', 'Kartoffel',   'festkochend', 2000, CURDATE() - INTERVAL  10 DAY, CURDATE() + INTERVAL  20 DAY, 'Keller'),  -- +20, MHD vor Kategorie
    ('WG Lindenstraße', 'Paprika',     'rot',         2,    CURDATE() - INTERVAL   9 DAY, NULL, 'Kühlschrank'),                          -- -2, abgelaufen
    ('WG Lindenstraße', 'Gurke',       '',            1,    CURDATE() - INTERVAL   4 DAY, NULL, 'Kühlschrank'),                          -- +3
    ('WG Lindenstraße', 'Basilikum',   'frisch',      15,   CURDATE() - INTERVAL   3 DAY, NULL, 'Kühlschrank'),                          -- +2
    ('WG Lindenstraße', 'Milch',       '3,5 %',       1000, CURDATE() - INTERVAL   2 DAY, CURDATE() + INTERVAL   6 DAY, 'Kühlschrank'),  -- +6
    ('WG Lindenstraße', 'Butter',      '',            250,  CURDATE() - INTERVAL   3 DAY, CURDATE() + INTERVAL  25 DAY, 'Kühlschrank'),  -- +25
    ('WG Lindenstraße', 'Parmesan',    '',            100,  CURDATE() - INTERVAL  10 DAY, CURDATE() + INTERVAL  40 DAY, 'Kühlschrank'),  -- +40
    ('WG Lindenstraße', 'Joghurt',     'natur',       500,  CURDATE() - INTERVAL   5 DAY, CURDATE() + INTERVAL   3 DAY, 'Kühlschrank'),  -- +3
    ('WG Lindenstraße', 'Hackfleisch', 'Rind',        250,  CURDATE() - INTERVAL   1 DAY, NULL, 'Kühlschrank'),                          -- +2
    ('WG Lindenstraße', 'Spaghetti',   '',            500,  CURDATE() - INTERVAL  30 DAY, CURDATE() + INTERVAL 200 DAY, 'Vorratsschrank'),  -- +200
    ('WG Lindenstraße', 'Olivenöl',    'nativ extra', 500,  CURDATE() - INTERVAL  60 DAY, CURDATE() + INTERVAL 300 DAY, 'Vorratsschrank'),  -- +300
    ('WG Lindenstraße', 'Salz',        '',            500,  CURDATE() - INTERVAL 100 DAY, NULL, 'Vorratsschrank'),                          -- unbegrenzt
    ('Familie Berger', 'Mehl',          'Type 405',    1000, CURDATE() - INTERVAL 40 DAY, CURDATE() + INTERVAL 150 DAY, 'Vorratsschrank'), -- +150
    ('Familie Berger', 'Zucker',        '',            1000, CURDATE() - INTERVAL 90 DAY, NULL, 'Vorratsschrank'),                         -- unbegrenzt
    ('Familie Berger', 'Ei',            'Größe M',     4,    CURDATE() - INTERVAL  5 DAY, CURDATE() + INTERVAL   1 DAY, 'Kühlschrank'), -- +1
    ('Familie Berger', 'Milch',         '3,5 %',       300,  CURDATE() - INTERVAL  3 DAY, CURDATE() + INTERVAL   2 DAY, 'Kühlschrank'), -- +2
    ('Familie Berger', 'Butter',        '',            100,  CURDATE() - INTERVAL 10 DAY, CURDATE() + INTERVAL  20 DAY, 'Kühlschrank'), -- +20
    ('Familie Berger', 'Salz',          '',            250,  CURDATE() - INTERVAL 50 DAY, NULL, 'Vorratsschrank'),                         -- unbegrenzt
    ('Familie Berger', 'Haferflocken',  'zart',        500,  CURDATE() - INTERVAL 20 DAY, CURDATE() + INTERVAL 100 DAY, 'Vorratsschrank'), -- +100
    ('Familie Berger', 'Apfel',         '',            4,    CURDATE() - INTERVAL  3 DAY, NULL, 'Obstschale'),                         -- +7
    ('Familie Berger', 'Hähnchenbrust', '',            300,  CURDATE() - INTERVAL  1 DAY, NULL, 'Kühlschrank'),                         -- +2
    ('Familie Berger', 'Reis',          'Basmati',     1000, CURDATE() - INTERVAL 15 DAY, CURDATE() + INTERVAL 300 DAY, 'Vorratsschrank'), -- +300
    ('Familie Berger', 'Paprika',       'rot',         2,    CURDATE() - INTERVAL  1 DAY, NULL, 'Kühlschrank'),                         -- +6
    ('Familie Berger', 'Zwiebel',       '',            2,    CURDATE() - INTERVAL  1 DAY, NULL, 'Keller'),                         -- +6
    ('Familie Berger', 'Olivenöl',      'nativ extra', 750,  CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 200 DAY, 'Vorratsschrank'); -- +200

COMMIT;
