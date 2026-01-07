cells:
  - kind: 2
    value: "create or replace trigger TRG_TICKET_MITARBEITER\r

      before insert or update of MitarbeiterID on Ticket\r

      for each ROW\r

      declare\r

      \    v_abteilungsID NUMBER;\r

      \    v_count NUMBER;\r

      begin\r

      \r

      \    -- Abteilung des neuen Mitarbeiters ermitteln\r

      \    select abteilungsID \r

      \        into v_abteilungsID\r

      \        from Mitarbeiter\r

      \        where MitarbeiterID = :NEW.MitarbeiterID;\r

      \r

      \    -- Anzahl aktiver Tickets für diese Abteilung zählen\r

      \    select count(ticketID)\r

      \        into v_count\r

      \        from Ticket\r

      \        where mitarbeiterID in (\r

      \            select mitarbeiterid \r

      \                from mitarbeiter\r

      \                where abteilungsID = v_abteilungsID\r

      \        )\r

      \        and statusid <= 3\r

      \        and ticketID != :NEW.ticketID;  -- Aktuelles Ticket
      ausschließen\r

      \r

      \    if v_count >= 3 then\r

      \        raise_application_error(-20001, 'Die Abteilung hat bereits 3
      Tickets zugewiesen');\r

      \    end if;\r

      \r

      exception\r

      \    when NO_DATA_FOUND then\r

      \        raise_application_error(-20002, 'MitarbeiterID existiert
      nicht');\r

      end TRG_TICKET_MITARBEITER;\r

      \r

      /\r

      \r

      commit;\r

      \r\n"
    languageId: oracle-sql
