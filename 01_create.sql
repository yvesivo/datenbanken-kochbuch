-- Schema kochbuechlein. ON DELETE: RESTRICT, CASCADE nur bei abhängigen Daten.
-- Mengen DECIMAL (exakt vergleichbar).
DROP DATABASE IF EXISTS kochbuechlein;
CREATE DATABASE kochbuechlein CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kochbuechlein;

-- Haushalt teilt sich einen Vorrat und Rezepte.
CREATE TABLE haushalt (
    name    VARCHAR(100) NOT NULL,
    adresse VARCHAR(200) NULL,
    PRIMARY KEY (name),
    CHECK (TRIM(name) <> '')
);

-- Nutzer, gehört zu genau einem Haushalt. E-Mail max. 254 Zeichen (RFC).
-- Die Spezialisierung Koch/Rezeptersteller hat keine eigenen Attribute und steckt hier mit drin.
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

-- Lebensmittelgruppe mit Frischedauer nach Kauf; NULL = unbegrenzt haltbar.
CREATE TABLE kategorie (
    name                    VARCHAR(50)       NOT NULL,
    beschreibung            VARCHAR(255)      NULL,
    frischedauer_tage       SMALLINT UNSIGNED NULL,
    empfohlene_aufbewahrung ENUM ('Kühlschrank', 'Gefrierfach', 'Vorratsschrank', 'Keller', 'Obstschale') NOT NULL,
    PRIMARY KEY (name),
    CHECK (frischedauer_tage IS NULL OR frischedauer_tage > 0)
);

-- Zutat-Stammdaten, z. B. Tomate/'' und Tomate/'passiert'. Spezifikation '' = keine Angabe.
-- Einheit fest an der Zutat, damit Rezept- und Vorratsmengen vergleichbar sind.
CREATE TABLE zutat (
    name          VARCHAR(60)             NOT NULL,
    spezifikation VARCHAR(60)             NOT NULL DEFAULT '',
    einheit       ENUM ('g', 'kg', 'ml', 'l', 'Stk', 'EL', 'TL', 'Becher', 'Tasse', 'Prise') NOT NULL,
    kategorie     VARCHAR(50)             NOT NULL,
    PRIMARY KEY (name, spezifikation),
    CHECK (TRIM(name) <> ''),
    FOREIGN KEY (kategorie) REFERENCES kategorie (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Anlass/Mahlzeit, z. B. Frühstück oder Grillabend.
CREATE TABLE mahlzeitentyp (
    name         VARCHAR(50)  NOT NULL,
    beschreibung VARCHAR(255) NULL,
    PRIMARY KEY (name)
);

-- Art des Gerichts, gehört zu einem Mahlzeitentyp (1:N).
CREATE TABLE gerichttyp (
    name          VARCHAR(50)  NOT NULL,
    beschreibung  VARCHAR(255) NULL,
    mahlzeitentyp VARCHAR(50)  NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (mahlzeitentyp) REFERENCES mahlzeitentyp (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Rezeptkopf; die Zutatenmengen gelten für "portionen". bild = Dateipfad oder URL.
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

-- Zubereitungsschritte, schwache Entität: ohne Rezept sinnlos -> CASCADE.
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

-- N:M "kocht": wer welches Rezept gekocht hat, mit eigener Notiz.
-- Person oder Rezept weg -> Notizen dazu auch weg.
CREATE TABLE kocht (
    koch   VARCHAR(254) NOT NULL,
    rezept VARCHAR(100) NOT NULL,
    notiz  TEXT         NULL,
    PRIMARY KEY (koch, rezept),
    FOREIGN KEY (koch)   REFERENCES person (email) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (rezept) REFERENCES rezept (name)  ON UPDATE CASCADE ON DELETE CASCADE
);

-- N:M "benötigt": Menge je Zutat für rezept.portionen.
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

-- N:M "lagert": ein Eintrag je Haushalt und Zutat. mhd NULL = Haltbarkeit über Kategorie.
-- ort = wo die Zutat tatsächlich liegt (gleiche Werte wie kategorie.empfohlene_aufbewahrung).
CREATE TABLE vorrat (
    haushalt            VARCHAR(100)  NOT NULL,
    zutat_name          VARCHAR(60)   NOT NULL,
    zutat_spezifikation VARCHAR(60)   NOT NULL DEFAULT '',
    menge               DECIMAL(8, 2) NOT NULL,
    kaufdatum           DATE          NOT NULL,
    mhd                 DATE          NULL,
    ort                 ENUM ('Kühlschrank', 'Gefrierfach', 'Vorratsschrank', 'Keller', 'Obstschale') NOT NULL,
    PRIMARY KEY (haushalt, zutat_name, zutat_spezifikation),
    CONSTRAINT ck_vorrat_menge CHECK (menge > 0),
    CONSTRAINT ck_vorrat_mhd   CHECK (mhd IS NULL OR mhd >= kaufdatum),
    -- Vorrat hängt am Haushalt
    FOREIGN KEY (haushalt) REFERENCES haushalt (name) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (zutat_name, zutat_spezifikation) REFERENCES zutat (name, spezifikation)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Abgeleitete Attribute als View. haltbar_bis NULL = unbegrenzt.
CREATE VIEW v_vorrat AS
SELECT v.haushalt, v.zutat_name, v.zutat_spezifikation, z.einheit, z.kategorie,
       v.menge, v.kaufdatum, v.mhd, v.ort,
       v.kaufdatum + INTERVAL k.frischedauer_tage DAY                   AS frisch_bis,
       COALESCE(v.mhd, v.kaufdatum + INTERVAL k.frischedauer_tage DAY)  AS haltbar_bis
FROM vorrat v
JOIN zutat z     ON z.name = v.zutat_name AND z.spezifikation = v.zutat_spezifikation
JOIN kategorie k ON k.name = z.kategorie;
