DROP TABLE Ticket_Anruf;
DROP TABLE Ticket;
DROP TABLE Anruf;
DROP TABLE Mitarbeiter;
DROP TABLE Kunden;
DROP TABLE Abteilung;
DROP TABLE Problemkategorie;
DROP TABLE Status;

CREATE TABLE Kunde(
    MitarbeiterId INT PRIMARY KEY,
    Nachname VARCHAR(50),
    Vorname VARCHAR(50),
    Telefonnummer VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Abteilung(
    AbteilungsId INT PRIMARY KEY,
    Abteilungsname VARCHAR(100),
    Abteilungsleiter INT
); /*alter table für mitarbeiter*/

CREATE TABLE Mitarbeiter(
    MitarbeiterId INT PRIMARY KEY,
    VorgesetzterId INT,
    AbteilungsId INT,
    Nachname VARCHAR(50),
    Vorname VARCHAR(50),

    FOREIGN KEY(VorgesetzterId)
                        REFERENCES Mitarbeiter (MitarbeiterId)
                        ON DELETE SET NULL,
    FOREIGN KEY(AbteilungsId)
                        REFERENCES Abteilung (AbteilungsId)
);

CREATE TABLE Anruf(
    AnrufId INT PRIMARY KEY,
    Datum DATE,
    Uhrzeit TIMESTAMP,
    DauerSekunden DECIMAL(12),

)

/*---------- ALTERATIONS ----------*/
ALTER TABLE Abteilung ADD (
    FOREIGN KEY(Abteilungsleiter)
        REFERENCES Mitarbeiter (MitarbeiterId)
            ON DELETE SET NULL
    );

