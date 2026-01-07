cells:
  - kind: 2
    value: "delete from ticket where ticketid in (10,15,20);\r

      \r

      insert into ticket (ticketID, beschreibung, mitarbeiterID, statusID)
      values (10, 'Test1', 1, 1);\r

      insert into ticket (ticketID, beschreibung, mitarbeiterID, statusID)
      values (15, 'Test2', 1, 1);\r

      insert into ticket (ticketID, beschreibung, mitarbeiterID, statusID)
      values (20, 'Test3', 1, 1);\r

      commit;"
    languageId: oracle-sql
