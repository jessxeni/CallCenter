/*beim ersten Ausführen die drop tables auskommentieren*/

-- DROP TABLE TicketAnruf;
-- DROP TABLE Ticket;
-- DROP TABLE Anruf;
-- DROP TABLE Mitarbeiter;
-- DROP TABLE Kunde;
-- DROP TABLE Abteilung;
-- DROP TABLE Problemkategorie;
-- DROP TABLE Status;

CREATE TABLE Problemkategorie (
                                  ProblemkategorieId INT PRIMARY KEY,
                                  Bezeichnung VARCHAR(50) NOT NULL,
                                  Beschreibung VARCHAR(255) NOT NULL
);

CREATE TABLE Status (
                        StatusId INT PRIMARY KEY,
                        Bezeichnung VARCHAR(255) NOT NULL UNIQUE
);
--
CREATE TABLE Abteilung(
                          AbteilungsId INT PRIMARY KEY,
                          Abteilungsname VARCHAR(100) NOT NULL,
                          Abteilungsleiter INT
); /*alter table für Mitarbeiter*/

CREATE TABLE Kunde(
    KundenId INT PRIMARY KEY,
    Nachname VARCHAR(50) NOT NULL,
    Vorname VARCHAR(50) NOT NULL,
    Telefonnummer VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Mitarbeiter(
    MitarbeiterId INT PRIMARY KEY,
    VorgesetzterId INT, /*eine Person ist immer der oberste Chef*/
    AbteilungsId INT NOT NULL,
    Nachname VARCHAR(50) NOT NULL,
    Vorname VARCHAR(50) NOT NULL,

    FOREIGN KEY(VorgesetzterId)
                        REFERENCES Mitarbeiter (MitarbeiterId)
                        ON DELETE SET NULL,
    FOREIGN KEY(AbteilungsId)
                        REFERENCES Abteilung (AbteilungsId)
);

CREATE TABLE Anruf(
    AnrufId INT PRIMARY KEY,
    Datum DATE NOT NULL,
    Uhrzeit TIMESTAMP NOT NULL,
    DauerSekunden DECIMAL(5) NOT NULL,
    KundenId INT, /*wenn Kunde nicht mehr Kunde, Anruf noch für Statistik*/
    MitarbeiterId INT, /*genau wie Kunde*/

    FOREIGN KEY (KundenId)
                  REFERENCES Kunde (KundenId)
                  ON DELETE SET NULL,
    FOREIGN KEY (MitarbeiterId)
            REFERENCES Mitarbeiter (MitarbeiterId)
            ON DELETE SET NULL
);

CREATE TABLE Ticket (
                        TicketId INT PRIMARY KEY,
                        ProblemkategorieId INT, /*nicht jeder Anruf ist/hat ein Problem*/
                        MitarbeiterId INT, /*selbe wie bei Anruf Table*/
                        KundenId INT, /*selbe wie bei Anruf Table*/
                        Beschreibung VARCHAR(255) NOT NULL,
                        Problemlösungsschritte VARCHAR(255),
                        StatusId INT NOT NULL,

                        FOREIGN KEY (ProblemkategorieId)
                            REFERENCES Problemkategorie (ProblemkategorieId)
                                ON DELETE SET NULL,
                        FOREIGN KEY (MitarbeiterId)
                            REFERENCES Mitarbeiter (MitarbeiterId)
                                ON DELETE SET NULL,
                        FOREIGN KEY (KundenId)
                            REFERENCES Kunde (KundenId)
                                ON DELETE SET NULL,
                        FOREIGN KEY (StatusId)
                            REFERENCES Status (StatusId)
                                ON DELETE SET NULL
);

CREATE TABLE TicketAnruf(
    TicketAnrufId INT PRIMARY KEY,
    TicketId INT,
    AnrufId INT,

    FOREIGN KEY (TicketId)
                    REFERENCES Ticket (TicketId)
                    ON DELETE SET NULL,
    FOREIGN KEY (AnrufId)
                    REFERENCES Anruf (AnrufId)
                    ON DELETE SET NULL
);

/*---------- ALTERATIONS ----------*/

ALTER TABLE Abteilung
    ADD(
        FOREIGN KEY (Abteilungsleiter)
            REFERENCES Mitarbeiter (MitarbeiterId)
        );

/*---------- INTEGRITÄTSBEDINGUNGEN ----------*/

/*NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY bei CREATE TABLE*/

ALTER TABLE Kunde
ADD (
    CONSTRAINT VornameGroesser0 CHECK ( LENGTH(Vorname) > 0 ),
    CONSTRAINT NachnameGroesser0 CHECK ( LENGTH(Nachname) > 0 )
    );

ALTER TABLE Kunde
    ADD (
        CONSTRAINT EmailWithAt CHECK ( REGEXP_LIKE(Email, '^.*@.*$') )
        );

ALTER TABLE Anruf
ADD (
    CONSTRAINT AnrufDauerGroesser0 CHECK ( DauerSekunden > 0 )
    );

ALTER TABLE Kunde
ADD (
    CONSTRAINT MindestensEineKontaktmoeglichkeitMussGegebenSein CHECK ( Telefonnummer IS NOT NULL OR Email IS NOT NULL )
    );