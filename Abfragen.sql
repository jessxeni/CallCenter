/* Call Center von Tom Joost, Leon Walger, Jess Schäfer*/

INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-07-01 14:31:12.000000', 420, 2, 3);

SELECT a.*, m.VORGESETZTERID
    FROM Mitarbeiter m
        JOIN Anruf a
ON m.MITARBEITERID = a.MITARBEITERID
WHERE m.VORGESETZTERID = 1;

--pro Mitarbeiter: Anzahl Anrufe, Anzahl Tickets, Abteilung

INSERT INTO MITARBEITER (VORGESETZTERID, ABTEILUNGSID, NACHNAME, VORNAME)
VALUES (1, 3, 'Test', 'Test');
INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-07-01 14:33:12.000000', 20, 2, 3);

SELECT m.Vorname, m.Nachname, Count(DISTINCT a.AnrufId), Count(DISTINCT t.TicketId), Abteilung.ABTEILUNGSNAME
From Mitarbeiter m
    Left Join Ticket t ON m.MITARBEITERID = t.MITARBEITERID
    Left Join Anruf a ON m.MITARBEITERID = a.MITARBEITERID
    Left Join Abteilung ON m.ABTEILUNGSID = Abteilung.ABTEILUNGSID
GROUP BY m.Vorname, m.Nachname, Abteilung.ABTEILUNGSNAME;

--alle Abteilungen finden, wo Mitarbeiter mehr als zwei Anrufe
INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-07-01 14:33:12.000000', 420, 2, 2);

SELECT m.Vorname, m.Nachname,
       (SELECT COUNT(*)
           FROM Anruf a
           WHERE a.MITARBEITERID = m.MITARBEITERID
       ) AS AnrufCount
From Mitarbeiter m
WHERE 1 < ALL (SELECT Count(AnrufId) From Anruf Where Anruf.MITARBEITERID = m.MITARBEITERID);

--längster und kürzester Anruf
SELECT AnrufId, DAUERSEKUNDEN FROM ANRUF WHERE DAUERSEKUNDEN = (SELECT Min(DAUERSEKUNDEN) FROM Anruf)
UNION
SELECT AnrufId, DAUERSEKUNDEN FROM ANRUF WHERE DAUERSEKUNDEN = (SELECT Max(DAUERSEKUNDEN) FROM Anruf);

INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-12-12 14:53:12.000000', 6000, 2, 3);

-- Mitarbeiter, die mehr als einen Anruf haben und von denen Anzahl Anrufe und Anzahl Tickets
SELECT m.Vorname, m.Nachname, COUNT(DISTINCT a.AnrufId) AS AnzahlAnrufe, COUNT(DISTINCT t.TicketId) AS AnzahlTickets
FROM Mitarbeiter m
         LEFT JOIN Ticket t ON m.MitarbeiterId = t.MitarbeiterId
         LEFT JOIN Anruf a ON m.MitarbeiterId = a.MitarbeiterId
Having 1 < COUNT(DISTINCT a.AnrufId)
GROUP BY m.Vorname, m.Nachname;

INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-10-12 14:53:00.000000', 300, 2, 1);


COMMIT;

UPDATE Mitarbeiter SET VORGESETZTERID = 3 Where MITARBEITERID = 5;
INSERT INTO Mitarbeiter (VORGESETZTERID, ABTEILUNGSID, NACHNAME, VORNAME) VALUES (1, 1, '3.Ebene', '3.Ebene');
INSERT INTO Mitarbeiter (VORGESETZTERID, ABTEILUNGSID, NACHNAME, VORNAME) VALUES (4, 1, '2.Ebene', '2.Ebene');
INSERT INTO Mitarbeiter (VORGESETZTERID, ABTEILUNGSID, NACHNAME, VORNAME) VALUES (7, 1, '3.Ebene', '3.Ebene');
INSERT INTO Mitarbeiter (VORGESETZTERID, ABTEILUNGSID, NACHNAME, VORNAME) VALUES (7, 1, '3.Ebene', '3.Ebene');

COMMIT;

--Tiefensuche
SELECT * FROM MITARBEITER
START WITH VORGESETZTERID = 4
CONNECT BY PRIOR MITARBEITERID = VORGESETZTERID;

--Breitensuche
WITH Tabelle (MitarbeiterId, VorgesetzterId) AS (
SELECT MITARBEITERID, VORGESETZTERID
    FROM MITARBEITER
    WHERE MITARBEITERID = 4
UNION ALL
SELECT m.MITARBEITERID, m.VORGESETZTERID
FROM MITARBEITER m
         JOIN Tabelle t ON m.VORGESETZTERID = t.MitarbeiterId
)
SEARCH BREADTH FIRST BY MitarbeiterId SET order1
    SELECT * FROM Tabelle;

create or replace function Tiefensuche (i_MitarbeiterId in integer)
    RETURN varchar2
    AS
    Ergebnis varchar2(4000);
    CURSOR MitarbeiterCursor IS
        SELECT * FROM MITARBEITER
        START WITH VORGESETZTERID = i_MitarbeiterId
        CONNECT BY PRIOR MITARBEITERID = VORGESETZTERID;
BEGIN
    Ergebnis := '';
    FOR m in MitarbeiterCursor LOOP
        Ergebnis := Ergebnis || m.MITARBEITERID || '; ';
        END LOOP;
    RETURN Ergebnis;
END Tiefensuche;

create or replace function Breitensuche (i_MitarbeiterId in integer)
    RETURN varchar2
AS
    Ergebnis varchar2(4000);
    CURSOR MitarbeiterCursor IS
        WITH Tabelle (MitarbeiterId, VorgesetzterId) AS (
            SELECT MITARBEITERID, VORGESETZTERID
            FROM MITARBEITER
            WHERE MITARBEITERID = 4
            UNION ALL
            SELECT m.MITARBEITERID, m.VORGESETZTERID
            FROM MITARBEITER m
                     JOIN Tabelle t ON m.VORGESETZTERID = t.MitarbeiterId
        )
        SEARCH BREADTH FIRST BY MitarbeiterId SET order1
        SELECT * FROM Tabelle;
BEGIN
    Ergebnis := '';
    FOR m in MitarbeiterCursor LOOP
            Ergebnis := Ergebnis || m.MITARBEITERID || '; ';
        END LOOP;
    RETURN Ergebnis;
END Breitensuche;

COMMIT;

SELECT Tiefensuche(4) FROM dual;
SELECT Breitensuche(4) FROM dual;

INSERT INTO Mitarbeiter (VORGESETZTERID, ABTEILUNGSID, NACHNAME, VORNAME) VALUES (8, 1, '3.Ebene', '3.Ebene');
