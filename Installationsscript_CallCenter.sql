--beim ersten Ausführen die drop tables auskommentieren

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
); --alter table für Mitarbeiter

CREATE TABLE Kunde(
    KundenId INT PRIMARY KEY,
    Nachname VARCHAR(50) NOT NULL,
    Vorname VARCHAR(50) NOT NULL,
    Telefonnummer VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Mitarbeiter(
    MitarbeiterId INT PRIMARY KEY,
    VorgesetzterId INT, --eine Person ist immer der oberste Chef
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
    Datum CHAR(10) NOT NULL,
    Uhrzeit TIMESTAMP NOT NULL,
    DauerSekunden DECIMAL(5) NOT NULL,
    KundenId INT, --wenn Kunde nicht mehr Kunde, Anruf noch für Statistik
    MitarbeiterId INT, --genau wie Kunde

    FOREIGN KEY (KundenId)
                  REFERENCES Kunde (KundenId)
                  ON DELETE SET NULL,
    FOREIGN KEY (MitarbeiterId)
            REFERENCES Mitarbeiter (MitarbeiterId)
            ON DELETE SET NULL
);

CREATE TABLE Ticket (
                        TicketId INT PRIMARY KEY,
                        ProblemkategorieId INT, --nicht jeder Anruf ist/hat ein Problem
                        MitarbeiterId INT, --selbe wie bei Anruf Table
                        KundenId INT, --selbe wie bei Anruf Table
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

------------ ALTERATIONS ----------

ALTER TABLE Abteilung
    ADD(
        FOREIGN KEY (Abteilungsleiter)
            REFERENCES Mitarbeiter (MitarbeiterId)
        );

------------ INTEGRITÄTSBEDINGUNGEN ----------

--NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY bei CREATE TABLE

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
--


------------ BEISPIELDATEN ------------

INSERT INTO Status VALUES (1, 'ERSTELLT');
INSERT INTO Status VALUES (2, 'IN BEARBEITUNG');
INSERT INTO Status VALUES (3, 'Erledigt');
INSERT INTO Status VALUES (4, 'Geschlossen');

INSERT INTO Problemkategorie VALUES (1, 'Mängel', 'Falls Mängel festgestellt werden');
INSERT INTO Problemkategorie VALUES (2, 'Bedienung', 'Fragen zur Bedienung');
INSERT INTO Problemkategorie VALUES (3, 'Retouren', 'Infos für Retouren');

INSERT INTO Abteilung VALUES (1, 'Vertrieb', NULL); --2
INSERT INTO Abteilung VALUES (2, 'Marketing', NULL); --1
INSERT INTO Abteilung VALUES (3, 'Produktion', NULL); --3


INSERT INTO Kunde VALUES (1, 'Peter', 'Hans', '0221999985', 'hans.peter@web.de');
INSERt INTO Kunde VALUES (2, 'Frosch', 'Walter', '0221999985-60', 'walter.frosch@zigarette.de');
INSERT INTO Kunde VALUES (3, 'Holland', 'Tom', '01578 1234567', 'tom.holland@spider.man');

INSERT INTO MITARBEITER VALUES (6, NULL, 1, 'HILFSDATEN', 'HILFSDATEN');
INSERT INTO MITARBEITER VALUES (5, NULL, 1, 'HILFSDATEN', 'HILFSDATEN');

INSERT INTO Mitarbeiter VALUES (1, 6, 1, 'Doe', 'Jane');
INSERT INTO Mitarbeiter VALUES (2, 5, 2, 'Doe', 'John');
INSERT INTO Mitarbeiter VALUES (3, 1, 3, 'Mustermann', 'Max');

UPDATE ABTEILUNG SET ABTEILUNGSLEITER = 2 WHERE ABTEILUNGSID = 1;
UPDATE ABTEILUNG SET ABTEILUNGSLEITER = 1 WHERE ABTEILUNGSID = 2;
UPDATE ABTEILUNG SET ABTEILUNGSLEITER = 3 WHERE ABTEILUNGSID = 3;

INSERT INTO Anruf VALUES (1, '2025-08-10', '12:15:00', 312, 1, 2);
INSERT INTO Anruf VALUES (2, '2025-06-01', '14:31:12', 5574, 2, 3);
INSERT INTO Anruf VALUES (3, '2025-10-12', '16:42:52', 2259, 3, 1);

INSERT INTO Ticket VALUES (1, 3, 1, 1, 'Waschmaschine kaputt', '1. Auftrag eingetragen\n2. Auftrag weitergeleitet', 4);
INSERT INTO Ticket VALUES (2, 1, 2, 2, 'Zigarettenautomat kaputt', '1. Auftrag eingetragen\n2. Auftrag weitergeleitet', 2);
INSERT INTO Ticket VALUES (3, 2, 3, 2, 'Wie funktioniert der Spiderman-Anzug', '1. Auftrag eingetragen\n2. Auftrag weitergeleitet', 3);
INSERT INTO Ticket VALUES (4, 2, 1, 3, 'Zigarettenausgabe einstellen', '1. Auf FAQ-Seite verweisen', 4);
INSERT INTO Ticket VALUES (5, 3, 1, 3, 'Rücksendung vom Anzug', '1. Auftrag erstellt und Kunde Etikette ausgedruckt', 2);

INSERT INTO TicketAnruf VALUES (1, 1, 1);
INSERT INTO TicketAnruf VALUES (2, 2, 2);
INSERT INTO TicketAnruf VALUES (3, 3, 2);
