INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-07-01 14:31:12.000000', 420, 2, 3);

SELECT a.*, m.VORGESETZTERID
    FROM Mitarbeiter m
        JOIN Anruf a
ON m.MITARBEITERID = a.MITARBEITERID
WHERE m.VORGESETZTERID = 1;

--pro Mitarbeiter: Anzahl Anrufe, Anzahl Tickets, Abteilung

SELECT m.Vorname, m.Nachname, Count(a.AnrufId), Count(t.TicketId), Abteilung.ABTEILUNGSNAME
From Mitarbeiter m
    Left Join Ticket t ON m.MITARBEITERID = t.MITARBEITERID
    Left Join Anruf a ON m.MITARBEITERID = a.MITARBEITERID
    Left Join Abteilung ON m.ABTEILUNGSID = Abteilung.ABTEILUNGSID
GROUP BY m.Vorname, m.Nachname, Abteilung.ABTEILUNGSNAME;

--alle Abteilungen finden, wo Mitarbeiter mehr als zwei Anrufe
INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-07-01 14:33:12.000000', 420, 2, 2);

SELECT m.Vorname, m.Nachname
From Mitarbeiter m
WHERE 1 < ALL (SELECT Count(AnrufId) From Anruf Where Anruf.MITARBEITERID = m.MITARBEITERID);

--längster und kürzester Anruf
SELECT AnrufId, DAUERSEKUNDEN FROM ANRUF WHERE DAUERSEKUNDEN = (SELECT Min(DAUERSEKUNDEN) FROM Anruf)
UNION
SELECT AnrufId, DAUERSEKUNDEN FROM ANRUF WHERE DAUERSEKUNDEN = (SELECT Max(DAUERSEKUNDEN) FROM Anruf);

--
SELECT m.Vorname, m.Nachname, COUNT(DISTINCT a.AnrufId) AS AnzahlAnrufe, COUNT(DISTINCT t.TicketId) AS AnzahlTickets
FROM Mitarbeiter m
         LEFT JOIN Ticket t ON m.MitarbeiterId = t.MitarbeiterId
         LEFT JOIN Anruf a ON m.MitarbeiterId = a.MitarbeiterId
Having 1 < COUNT(DISTINCT a.AnrufId)
GROUP BY m.Vorname, m.Nachname;

COMMIT;
