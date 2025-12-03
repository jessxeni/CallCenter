INSERT INTO ANRUF (DATUMUHRZEIT, DAUERSEKUNDEN, KUNDENID, MITARBEITERID)
VALUES (Timestamp '2025-07-01 14:31:12.000000', 420, 2, 3);

COMMIT;

-- SELECT a.*, m.VORGESETZTERID
--     FROM Mitarbeiter m
--         JOIN Anruf a
-- ON m.MITARBEITERID = a.MITARBEITERID
-- WHERE m.VORGESETZTERID = 1;

--pro Mitarbeiter: Anzahl Anrufe, Anzahl Tickets, Abteilung

SELECT m.Vorname, m.Nachname, Count(a.AnrufId), Count(t.TicketId), Abteilung.ABTEILUNGSNAME
From Mitarbeiter m
    Left Join Ticket t ON m.MITARBEITERID = t.MITARBEITERID
    Left Join Anruf a ON m.MITARBEITERID = a.MITARBEITERID
    Left Join Abteilung ON m.ABTEILUNGSID = Abteilung.ABTEILUNGSID
GROUP BY m.Vorname, m.Nachname, Abteilung.ABTEILUNGSNAME;

--alle Abteilungen finden, wo Mitarbeiter mehr als zwei Anrufe
SELECT m.Vorname, m.Nachname
From Mitarbeiter m
WHERE 1 < ALL (SELECT Count(AnrufId) From Anruf Where Anruf.MITARBEITERID = m.MITARBEITERID);