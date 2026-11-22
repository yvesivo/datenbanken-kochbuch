-- Rezepte-Datenbank "kochbuechlein" 
-- Datentypen:
--   VARCHAR(n): Namen und Beschreibungen unterschiedlicher Länge, n = großzügige Obergrenze
--   DECIMAL(8,2): für Mengen, ermöglicht exakte Vergleiche
--   DATE: Kaufdatum/MHD, um mit Tagen zu rechnen (z.b. DATEDIFF)
--   ENUM: für Einheiten, Saison, Lagerort; vorgegebene Werte zur Vereinfachung
--   TEXT: für Zubereitungsschritte oder Notizen, braucht mehr Platz als 255 Zeichen.
DROP DATABASE IF EXISTS kochbuechlein;
CREATE DATABASE kochbuechlein CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kochbuechlein;

-- Entität Haushalt: teilt sich einen Vorrat und Rezepte. 
-- Schlüssel: Name, Haushaltsname muss eindeutig sein.
CREATE TABLE haushalt (
    name    VARCHAR(100) NOT NULL,
    adresse VARCHAR(200) NULL,          
    PRIMARY KEY (name),
    CHECK (TRIM(name) <> '')
);

-- Entität Person: Haushalte beinhalten Personen/User (1:N). User können Rezepte anlegen, kochen und den Vorrat pflegen.
-- Die Spezialisierung Koch/Rezeptersteller hat keine eigenen Attribute und ergibt sich aus den Beziehungen:
-- Koch ist, wer mindestens einen Eintrag in "kocht" hat, Rezepersteller wer in "rezept.erstellt_von" vorkommt.
-- Schlüssel: E-Mail (max. 254 Zeichen)
CREATE TABLE person (
    email       VARCHAR(254) NOT NULL,
    vorname     VARCHAR(50)  NOT NULL,
    nachname    VARCHAR(50)  NOT NULL,
    haushalt    VARCHAR(100) NOT NULL,
    PRIMARY KEY (email),
    CONSTRAINT ck_person_email CHECK (email LIKE '_%@_%._%'),
    CHECK (TRIM(vorname) <> ''),
    CHECK (TRIM(nachname) <> ''),
    -- Haushalt mit Mitgliedern nicht löschbar
    FOREIGN KEY (haushalt) REFERENCES haushalt (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Entität Kategorie: eigene Tabelle statt Attribut der Zutat, weil Frischedauer und Aufbewahrung für alle
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
-- Schlüssel: Name + Spezifikation, damit z. B. Tomate und Tomate/passiert verschiedene Zutaten sind
CREATE TABLE zutat (
    name          VARCHAR(60)             NOT NULL,
    spezifikation VARCHAR(60)             NOT NULL DEFAULT '',  -- Schlüssel darf nicht NULL sein
    einheit       ENUM ('g', 'ml', 'Stk', 'EL', 'TL', 'Becher', 'Tasse', 'Prise') NOT NULL,
    kategorie     VARCHAR(50)             NOT NULL,
    PRIMARY KEY (name, spezifikation),
    CHECK (TRIM(name) <> ''),
    FOREIGN KEY (kategorie) REFERENCES kategorie (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Entität Mahlzeitentyp (Frühstück, Grillabend,...): ordnet Rezepte einem Anlass zu.
CREATE TABLE mahlzeitentyp (
    name         VARCHAR(50)  NOT NULL,
    beschreibung VARCHAR(255) NULL,
    PRIMARY KEY (name)
);

-- Entität Gerichttyp (Suppe, Salat …) verfeinert den Mahlzeitentyp.
-- Mahlzeitentyp wird spezifiziert von Gerichttyp (1:N).
CREATE TABLE gerichttyp (
    name          VARCHAR(50)  NOT NULL,
    beschreibung  VARCHAR(255) NULL,
    mahlzeitentyp VARCHAR(50)  NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (mahlzeitentyp) REFERENCES mahlzeitentyp (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Entität Rezept: Rezeptersteller erstellt Rezept (1:N), Rezept hat Mahlzeitentyp (N:1).
-- Zutatenmengen beziehen sich auf "Portionen", damit Rezepte Skaliert werden können
-- Schlüssel: Name, Rezeptnamen sind datenbankweit eindeutig.
CREATE TABLE rezept (
    name          VARCHAR(100)     NOT NULL,
    portionen     TINYINT UNSIGNED NOT NULL,
    saison        ENUM ('Frühling', 'Sommer', 'Herbst', 'Winter', 'ganzjährig') NOT NULL DEFAULT 'ganzjährig',
    region        VARCHAR(50)      NULL,
    bild          VARCHAR(255)     NULL,
    erstellt_von  VARCHAR(254)     NOT NULL,
    mahlzeitentyp VARCHAR(50)      NOT NULL,
    PRIMARY KEY (name),
    CHECK (TRIM(name) <> ''),
    CONSTRAINT ck_rezept_portionen CHECK (portionen > 0),
    -- Person mit Rezepten nicht löschbar (Alternative: SET NULL)
    FOREIGN KEY (erstellt_von)  REFERENCES person (email)        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (mahlzeitentyp) REFERENCES mahlzeitentyp (name)  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Schwache Entität Schritt: ohne Rezept sinnlos. Rezept beinhaltet Schritt (1:N, mind. 1 Schritt).
-- Schlüssel: Rezept + Reihenfolge, die Nummer ist nur innerhalb eines Rezepts eindeutig.
CREATE TABLE schritt (
    rezept       VARCHAR(100)     NOT NULL,
    reihenfolge  TINYINT UNSIGNED NOT NULL,
    beschreibung TEXT             NOT NULL,
    bild         VARCHAR(255)     NULL,
    PRIMARY KEY (rezept, reihenfolge),
    CHECK (reihenfolge > 0),
    CHECK (TRIM(beschreibung) <> ''),
    FOREIGN KEY (rezept) REFERENCES rezept (name) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Beziehung "kocht" (Koch–Rezept, N:M) als eigene Tabelle: Eine Person kocht ein Rezept und kann eine Notiz dazu abspeichern. 
-- Person oder Rezept gelöscht -> Notizen dazu auch.
CREATE TABLE kocht (
    koch   VARCHAR(254) NOT NULL,
    rezept VARCHAR(100) NOT NULL,
    notiz  TEXT         NULL,
    PRIMARY KEY (koch, rezept),
    FOREIGN KEY (koch)   REFERENCES person (email) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (rezept) REFERENCES rezept (name)  ON UPDATE CASCADE ON DELETE CASCADE
);

-- Beziehung "benötigt" (Rezept–Zutat, N:M): Menge gilt für rezept.portionen.
CREATE TABLE rezept_zutat (
    rezept              VARCHAR(100)  NOT NULL,
    zutat_name          VARCHAR(60)   NOT NULL,
    zutat_spezifikation VARCHAR(60)   NOT NULL DEFAULT '',
    menge               DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (rezept, zutat_name, zutat_spezifikation),
    CONSTRAINT ck_rezept_zutat_menge CHECK (menge > 0),
    FOREIGN KEY (rezept) REFERENCES rezept (name) ON UPDATE CASCADE ON DELETE CASCADE,
    -- verwendete Zutat nicht löschbar
    FOREIGN KEY (zutat_name, zutat_spezifikation) REFERENCES zutat (name, spezifikation)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Beziehung "lagert" (Haushalt–Zutat, N:M) als eigene Tabelle: Menge, Kaufdatum, MHD und Lagerort pro Haushalt und Zutat
CREATE TABLE vorrat (
    haushalt            VARCHAR(100)  NOT NULL,
    zutat_name          VARCHAR(60)   NOT NULL,
    zutat_spezifikation VARCHAR(60)   NOT NULL DEFAULT '',
    menge               DECIMAL(8, 2) NOT NULL,
    kaufdatum           DATE          NOT NULL,
    mhd                 DATE          NULL,     -- NULL = kein MHD, Haltbarkeit über die Kategorie
    ort                 ENUM ('Kühlschrank', 'Gefrierfach', 'Vorratsschrank', 'Keller', 'Obstschale') NOT NULL,
    PRIMARY KEY (haushalt, zutat_name, zutat_spezifikation),
    CONSTRAINT ck_vorrat_menge CHECK (menge > 0),
    CONSTRAINT ck_vorrat_mhd   CHECK (mhd IS NULL OR mhd >= kaufdatum),
    -- Vorrat hängt am Haushalt
    FOREIGN KEY (haushalt) REFERENCES haushalt (name) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (zutat_name, zutat_spezifikation) REFERENCES zutat (name, spezifikation)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Abgeleitete Attribute aus dem ERM als View, werden nicht gespeichert, sondern berechnet, damit sie nie veralten:
-- frisch_bis = Kaufdatum + Frischedauer der Kategorie, 
-- haltbar_bis = MHD, sonst frisch_bis (NULL = unbegrenzt).
CREATE VIEW v_vorrat AS
SELECT v.haushalt, v.zutat_name, v.zutat_spezifikation, z.einheit, z.kategorie,
       v.menge, v.kaufdatum, v.mhd, v.ort,
       v.kaufdatum + INTERVAL k.frischedauer_tage DAY                   AS frisch_bis,
       COALESCE(v.mhd, v.kaufdatum + INTERVAL k.frischedauer_tage DAY)  AS haltbar_bis
FROM vorrat v
JOIN zutat z     ON z.name = v.zutat_name AND z.spezifikation = v.zutat_spezifikation
JOIN kategorie k ON k.name = z.kategorie;
