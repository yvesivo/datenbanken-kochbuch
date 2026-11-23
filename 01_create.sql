-- Rezepte-Datenbank "kochbuechlein"
-- Schlüssel: Haushalt, Person, Rezept, und Zutat haben eine künstliche ID (INT, AUTO_INCREMENT) als Primärschlüssel,
-- weil sie oft referenziert werden. Die im ERM unterstrichenen Attribute bleiben als UNIQUE NOT NULL eindeutig.
-- Datentypen:
--   INT UNSIGNED: künstliche IDs, nie negativ, über 4 Mrd. Werte
--   VARCHAR(n): Namen und Beschreibungen unterschiedlicher Länge, n = großzügige Obergrenze
--   DECIMAL(8,2): für Mengen, ermöglicht exakte Vergleiche
--   DATE: Kaufdatum/MHD, um mit Tagen zu rechnen (z. B. DATEDIFF)
--   ENUM: für Einheiten, Saison, Lagerort; vorgegebene Werte zur Vereinfachung
--   SET: wie ENUM, aber mehrere Werte gleichzeitig (Ausstattung des Haushalts)
--   BOOLEAN: Ja/Nein-Merkmale (vegetarisch, vegan)
--   MEDIUMBLOB: Bilder als Binärdaten bis 16 MB
--   TEXT: für Zubereitungsschritte oder Notizen, braucht mehr Platz als 255 Zeichen.
-- Löschen: RESTRICT (verweigern, solange noch verwiesen wird), CASCADE nur bei Daten, die ohne ihren Besitzer sinnlos sind.

DROP DATABASE IF EXISTS kochbuechlein;
CREATE DATABASE kochbuechlein CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kochbuechlein;

-- Entität Haushalt: Ein Haushalt teilt sich einen Vorrat, Küchenausstattung und Rezepte. 
-- Schlüssel: haushalt_id, der Haushaltsname muss auch eindeutig sein.
CREATE TABLE haushalt (
    haushalt_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    adresse     VARCHAR(200) NULL,
    ausstattung SET ('Herd', 'Backofen', 'Mikrowelle', 'Kühlschrank', 'Gefrierschrank', 'Grill', 'Mixer', 'Wasserkocher')
                NOT NULL DEFAULT '',
    PRIMARY KEY (haushalt_id),
    CONSTRAINT uq_haushalt_name UNIQUE (name),
    CHECK (TRIM(name) <> '')
);

-- Entität Person: Haushalte beinhalten Personen/User (1:N). User können Rezepte anlegen, kochen und den Vorrat pflegen.
-- Die Spezialisierung Koch/Rezeptersteller hat keine eigenen Attribute und ergibt sich aus den Beziehungen:
-- Koch ist, wer mindestens einen Eintrag in "kocht" hat, Rezepersteller wer in "rezept.erstellt_von" vorkommt.
-- Schlüssel: person_id. E-Mail ist zwar eindeutig aber kann geändert werden, eine ID ist performanter.
CREATE TABLE person (
    person_id       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    email           VARCHAR(254) NOT NULL,
    vorname         VARCHAR(50)  NOT NULL,
    nachname        VARCHAR(50)  NOT NULL,
    ist_vegetarisch BOOLEAN      NOT NULL DEFAULT FALSE,
    ist_vegan       BOOLEAN      NOT NULL DEFAULT FALSE,
    haushalt_id     INT UNSIGNED NOT NULL,
    PRIMARY KEY (person_id),
    CONSTRAINT uq_person_email UNIQUE (email),
    CONSTRAINT ck_person_email CHECK (email LIKE '_%@_%._%'),
    CHECK (TRIM(vorname) <> ''),
    CHECK (TRIM(nachname) <> ''),
    CONSTRAINT ck_person_vegan CHECK (NOT ist_vegan OR ist_vegetarisch),
    -- Haushalt mit Mitgliedern nicht löschbar
    FOREIGN KEY (haushalt_id) REFERENCES haushalt (haushalt_id) ON DELETE RESTRICT
);

-- Entität Kategorie (Gemüse/Obst,...): eigene Tabelle statt Attribut der Zutat, weil Frischedauer und Aufbewahrung für alle
-- Zutaten einer Lebensmittelkategorie gleich sind und nur einmal gepflegt werden. Frischedauer NULL = unbegrenzt haltbar.
-- Schlüssel: eindeutiger Name
CREATE TABLE kategorie (
    name                    VARCHAR(50)       NOT NULL,
    beschreibung            VARCHAR(255)      NULL,
    frischedauer_tage       SMALLINT UNSIGNED NULL,
    empfohlene_aufbewahrung ENUM ('Kühlschrank', 'Gefrierfach', 'Vorratsschrank', 'Keller', 'Obstschale') NOT NULL,
    PRIMARY KEY (name),
    CHECK (frischedauer_tage IS NULL OR frischedauer_tage > 0)
);

-- Entität Zutat: Eine Zutat gehört zu einer Lebensmittelkategorie (N:1).
-- Zutaten haben eine Einheit zugewiesen, damit Rezeptzutaten und Vorräte vergleichbar sind.
-- Schlüssel: zutat_id. 
CREATE TABLE zutat (
    zutat_id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name          VARCHAR(60)  NOT NULL,
    spezifikation VARCHAR(60)  NOT NULL DEFAULT '',  -- Schlüssel darf nicht NULL sein
    einheit       ENUM ('g', 'ml', 'Stk', 'EL', 'TL', 'Becher', 'Tasse', 'Prise') NOT NULL,
    kategorie     VARCHAR(50)  NOT NULL,
    PRIMARY KEY (zutat_id),
    CONSTRAINT uq_zutat_name UNIQUE (name, spezifikation),
    CHECK (TRIM(name) <> ''),
    FOREIGN KEY (kategorie) REFERENCES kategorie (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Entität Mahlzeitentyp (Frühstück, Grillabend,...): ordnet Rezepte einem Anlass zu.
CREATE TABLE mahlzeitentyp (
    mahlzeit_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name         VARCHAR(50)  NOT NULL,
    beschreibung VARCHAR(255) NULL,
    PRIMARY KEY (mahlzeit_id),
    CONSTRAINT uq_mahlzeit_name UNIQUE (name)
);

-- Entität Gerichttyp (Suppe, Salat,...). Mahlzeitentyp wird spezifiziert von Gerichttyp (1:N).
CREATE TABLE gerichttyp (
    name          VARCHAR(50)  NOT NULL,
    beschreibung  VARCHAR(255) NULL,
    mahlzeit_id   INT UNSIGNED NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (mahlzeit_id)   REFERENCES mahlzeitentyp (mahlzeit_id) ON DELETE RESTRICT
);

-- Entität Rezept: Rezeptersteller erstellt Rezept (1:N), Rezept hat Mahlzeitentyp (N:1).
-- Zutatenmengen beziehen sich auf "Portionen", damit Rezepte Skaliert werden können
-- Schlüssel: rezept_id. Rezeptnamen sind dennoch eindeutig.
CREATE TABLE rezept (
    rezept_id       INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    name            VARCHAR(100)     NOT NULL,
    portionen       TINYINT UNSIGNED NOT NULL,
    saison          ENUM ('Frühling', 'Sommer', 'Herbst', 'Winter', 'ganzjährig') NOT NULL DEFAULT 'ganzjährig',
    region          VARCHAR(50)      NULL,
    ist_vegetarisch BOOLEAN          NOT NULL DEFAULT FALSE,
    ist_vegan       BOOLEAN          NOT NULL DEFAULT FALSE,
    bild            MEDIUMBLOB       NULL,
    erstellt_von    INT UNSIGNED     NOT NULL,
    mahlzeit_id     INT UNSIGNED      NOT NULL,
    PRIMARY KEY (rezept_id),
    CONSTRAINT uq_rezept_name UNIQUE (name),
    CHECK (TRIM(name) <> ''),
    CONSTRAINT ck_rezept_portionen CHECK (portionen > 0),
    CONSTRAINT ck_rezept_vegan CHECK (NOT ist_vegan OR ist_vegetarisch),
    -- Person mit Rezepten nicht löschbar 
    FOREIGN KEY (erstellt_von)  REFERENCES person (person_id)   ON DELETE RESTRICT,
    FOREIGN KEY (mahlzeit_id)   REFERENCES mahlzeitentyp (mahlzeit_id) ON DELETE RESTRICT
);

-- Schwache Entität Schritt: ohne Rezept sinnlos. Rezept beinhaltet Schritt (1:N, mind. 1 Schritt).
-- Schlüssel: Rezept + Reihenfolge, die Nummer ist nur innerhalb eines Rezepts eindeutig.
CREATE TABLE schritt (
    rezept_id    INT UNSIGNED     NOT NULL,
    reihenfolge  TINYINT UNSIGNED NOT NULL,
    beschreibung TEXT             NOT NULL,
    bild         MEDIUMBLOB       NULL,
    PRIMARY KEY (rezept_id, reihenfolge),
    CHECK (reihenfolge > 0),
    CHECK (TRIM(beschreibung) <> ''),
    FOREIGN KEY (rezept_id) REFERENCES rezept (rezept_id) ON DELETE CASCADE
);

-- Beziehung "kocht" (Koch–Rezept, N:M) als eigene Tabelle: Eine Person kocht ein Rezept und kann eine Notiz dazu abspeichern. 
-- Person oder Rezept gelöscht -> Notizen dazu auch.
CREATE TABLE kocht (
    person_id  INT UNSIGNED NOT NULL,
    rezept_id  INT UNSIGNED NOT NULL,
    gekocht_am DATE         NOT NULL,
    notiz      TEXT         NULL,
    PRIMARY KEY (person_id, rezept_id, gekocht_am),
    FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE,
    FOREIGN KEY (rezept_id) REFERENCES rezept (rezept_id) ON DELETE CASCADE
);

-- Beziehung "benötigt": Rezepte benötigen Zutaten (N:M) in vorgegebener Menge.
-- Menge gilt für "rezept.portionen".
CREATE TABLE benoetigt (
    rezept_id INT UNSIGNED  NOT NULL,
    zutat_id  INT UNSIGNED  NOT NULL,
    menge     DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (rezept_id, zutat_id),
    CONSTRAINT ck_benoetigt_menge CHECK (menge > 0),
    FOREIGN KEY (rezept_id) REFERENCES rezept (rezept_id) ON DELETE CASCADE,
    -- verwendete Zutat nicht löschbar
    FOREIGN KEY (zutat_id)  REFERENCES zutat (zutat_id)   ON DELETE RESTRICT
);

-- Beziehung "lagert" (Haushalt–Zutat, N:M) als eigene Tabelle: Menge, Kaufdatum, MHD und Lagerort pro Haushalt und Zutat
-- Schlüssel: haushalt_id, zutat_id und kaufdatum, so können das gleiche Lebensmittel mehrfach gelagert sein mit unterschiedlichen MHDs
CREATE TABLE vorrat (
    haushalt_id INT UNSIGNED  NOT NULL,
    zutat_id    INT UNSIGNED  NOT NULL,
    menge       DECIMAL(8, 2) NOT NULL,
    kaufdatum   DATE          NOT NULL,
    mhd         DATE          NULL,     -- NULL = kein MHD, Haltbarkeit über die Kategorie
    ort         ENUM ('Kühlschrank', 'Gefrierfach', 'Vorratsschrank', 'Keller', 'Obstschale') NOT NULL,
    PRIMARY KEY (haushalt_id, zutat_id, kaufdatum),
    CONSTRAINT ck_vorrat_menge CHECK (menge > 0),
    CONSTRAINT ck_vorrat_mhd   CHECK (mhd IS NULL OR mhd >= kaufdatum),
    -- Vorrat hängt am Haushalt
    FOREIGN KEY (haushalt_id) REFERENCES haushalt (haushalt_id) ON DELETE CASCADE,
    FOREIGN KEY (zutat_id)    REFERENCES zutat (zutat_id)       ON DELETE RESTRICT
);

-- Abgeleitete Attribute aus dem ERM als View, werden nicht gespeichert, sondern berechnet, damit sie nie veralten:
-- frisch_bis = Kaufdatum + Frischedauer der Kategorie, 
-- personenanzahl = Personen pro Haushalt
CREATE VIEW v_vorrat AS
SELECT v.haushalt_id, h.name AS haushalt, v.zutat_id, z.name AS zutat, z.spezifikation, z.einheit, z.kategorie,
       v.menge, v.kaufdatum, v.mhd, v.ort,
       v.kaufdatum + INTERVAL k.frischedauer_tage DAY AS frisch_bis
FROM vorrat v
JOIN haushalt h  ON h.haushalt_id = v.haushalt_id
JOIN zutat z     ON z.zutat_id = v.zutat_id
JOIN kategorie k ON k.name = z.kategorie;

CREATE VIEW v_haushalt AS
SELECT h.haushalt_id, h.name, h.adresse, h.ausstattung, COUNT(p.person_id) AS personenanzahl
FROM haushalt h
LEFT JOIN person p ON p.haushalt_id = h.haushalt_id
GROUP BY h.haushalt_id, h.name, h.adresse, h.ausstattung;
