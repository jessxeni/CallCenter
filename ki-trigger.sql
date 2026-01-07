CREATE OR REPLACE TRIGGER trg_check_ticket_limit
    BEFORE INSERT OR UPDATE OF MitarbeiterId ON Ticket
    FOR EACH ROW
DECLARE
    v_offene_tickets INTEGER;
    v_abteilung_id INTEGER;
    max_tickets_limit CONSTANT INTEGER := 3;
    e_limit_erreicht EXCEPTION;
BEGIN
    -- 1. Abteilung des zugewiesenen Mitarbeiters ermitteln (Tabelle: Mitarbeiter)
    SELECT AbteilungsId INTO v_abteilung_id
    FROM Mitarbeiter
    WHERE MitarbeiterId = :NEW.MitarbeiterId;

    -- 2. Anzahl der offenen Tickets dieser Abteilung zählen (Tabelle: Ticket)
    -- Ein Ticket gilt als offen, wenn der Status nicht 'Abgeschlossen' (StatusId != 3) ist.
    -- Hinweis: Im Kontext eines BEFORE-Triggers bei einem INSERT wird der neue Datensatz
    -- noch nicht mitgezählt, daher ist der Vergleich auf ">= max_tickets_limit" korrekt.
    SELECT COUNT(*) INTO v_offene_tickets
    FROM Ticket t
             JOIN Mitarbeiter m ON t.MitarbeiterId = m.MitarbeiterId
    WHERE m.AbteilungsId = v_abteilung_id
      AND t.StatusId != 3; -- StatusId 3 entspricht 'Abgeschlossen' laut Skript-Logik

    -- 3. Integritätsprüfung
    IF v_offene_tickets >= max_tickets_limit THEN
        RAISE e_limit_erreicht;
    END IF;

EXCEPTION
    WHEN e_limit_erreicht THEN
        raise_application_error(-20001, 'Zuweisung abgelehnt: Die Abteilung des Mitarbeiters hat bereits '
            || max_tickets_limit || ' offene Tickets.');
END;
/

INSERT INTO Ticket (MitarbeiterId, StatusId, BESCHREIBUNG) VALUES (1, 1, 'Beispielticket');