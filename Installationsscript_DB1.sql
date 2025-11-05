

SET NAMES UTF8;

SET SQL DIALECT 3;


SET AUTODDL ON;

/******************************************************************************/
/****                   Creating generators (sequences)                    ****/
/******************************************************************************/
CREATE SEQUENCE GEN_ABTEILUNG_ID
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE GEN_ANRUF_ID
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE GEN_KUNDE_ID
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE GEN_MITARBEITER_ID
  START WITH 1
  INCREMENT BY 1;


/******************************************************************************/
/****              Creating tables (without computed fields)               ****/
/******************************************************************************/
CREATE TABLE ABTEILUNG (
    ABTEILUNGSID BIGINT NOT NULL,
    ABTEILUNGSNAME VARCHAR(50) /* COLLATE UTF8 - default */,
    FKABTEILUNGSLEITER BIGINT NOT NULL);

CREATE TABLE ANRUF (
    ANRUFID BIGINT NOT NULL,
    DATUM DATE NOT NULL,
    UHRZEIT TIME,
    DAUER VARCHAR(50) /* COLLATE UTF8 - default */,
    KUNDENID BIGINT NOT NULL,
    MITARBEITERID BIGINT NOT NULL,
    TICKETID BIGINT NOT NULL);

CREATE TABLE KUNDE (
    KUNDENID BIGINT NOT NULL,
    NACHNAME VARCHAR(50) /* COLLATE UTF8 - default */,
    VORNAME VARCHAR(50) /* COLLATE UTF8 - default */,
    EMAIL VARCHAR(50) /* COLLATE UTF8 - default */,
    TELEFONNUMMER VARCHAR(50) /* COLLATE UTF8 - default */);

CREATE TABLE MITARBEITER (
    MITARBEITERID BIGINT NOT NULL,
    FKVORGESETZTERID BIGINT NOT NULL,
    FKABTEILUNGSID BIGINT NOT NULL,
    NACHNAME VARCHAR(50) /* COLLATE UTF8 - default */,
    VORNAME VARCHAR(50) /* COLLATE UTF8 - default */,
    IBAN VARCHAR(50) /* COLLATE UTF8 - default */);


/******************************************************************************/
/****                   Creating primary key constraints                   ****/
/******************************************************************************/
RECONNECT;

ALTER TABLE ANRUF ADD CONSTRAINT PK_ANRUF PRIMARY KEY (ANRUFID);

ALTER TABLE KUNDE ADD CONSTRAINT PK_KUNDE PRIMARY KEY (KUNDENID);

ALTER TABLE MITARBEITER ADD CONSTRAINT PK_MITARBEITER PRIMARY KEY (MITARBEITERID);

ALTER TABLE ABTEILUNG ADD CONSTRAINT PK_NEW_TABLE PRIMARY KEY (ABTEILUNGSID);


/******************************************************************************/
/****                          Creating triggers                           ****/
/******************************************************************************/
SET TERM ^ ;

CREATE TRIGGER ABTEILUNG_BI FOR ABTEILUNG
ACTIVE
BEFORE INSERT
POSITION 0 
as
begin
  if (new.abteilungsid is null) then
  begin
    new.abteilungsid = gen_id(gen_abteilung_id, 1);
  end
end
^

CREATE TRIGGER ANRUF_BI FOR ANRUF
ACTIVE
BEFORE INSERT
POSITION 0 
as
begin
  if (new.anrufid is null) then
  begin
    new.anrufid = gen_id (GEN_ANRUF_ID,1);
  end
  if (new.datum is null) then new.datum = current_date;
  if (new.uhrzeit is null) then new.uhrzeit = current_time;
end
^

CREATE TRIGGER KUNDE_BI FOR KUNDE
ACTIVE
BEFORE INSERT
POSITION 0 
as
begin
  if (new.kundenid is null) then
  begin
    new.kundenid = gen_id(gen_kunde_id,1);
  end
end
^

CREATE TRIGGER MITARBEITER_BI FOR MITARBEITER
ACTIVE
BEFORE INSERT
POSITION 0 
as
begin
  if (new.mitarbeiterid is null) then
  begin
    new.mitarbeiterid = gen_id(gen_mitarbeiter_id, 1);
  end
end
^


/******************************************************************************/
/****                       Updating object comments                       ****/
/******************************************************************************/
SET TERM ; ^

DESCRIBE FIELD ABTEILUNGSNAME TABLE ABTEILUNG
'Name der Abteilung';

DESCRIBE FIELD FKABTEILUNGSLEITER TABLE ABTEILUNG
'MitarbeiterID des Abteilungsleiters';


/******************************************************************************/
/****                     Granting missing privileges                      ****/
/******************************************************************************/
GRANT USAGE ON SEQUENCE GEN_ABTEILUNG_ID TO TRIGGER ABTEILUNG_BI;

GRANT USAGE ON SEQUENCE GEN_ANRUF_ID TO TRIGGER ANRUF_BI;

GRANT USAGE ON SEQUENCE GEN_KUNDE_ID TO TRIGGER KUNDE_BI;

GRANT USAGE ON SEQUENCE GEN_MITARBEITER_ID TO TRIGGER MITARBEITER_BI;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON ABTEILUNG TO SYSDBA WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON MITARBEITER TO SYSDBA WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON ANRUF TO SYSDBA WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON KUNDE TO SYSDBA WITH GRANT OPTION;

GRANT USAGE ON SEQUENCE GEN_ABTEILUNG_ID TO SYSDBA WITH GRANT OPTION;

GRANT USAGE ON SEQUENCE GEN_MITARBEITER_ID TO SYSDBA WITH GRANT OPTION;

GRANT USAGE ON SEQUENCE GEN_ANRUF_ID TO SYSDBA WITH GRANT OPTION;

GRANT USAGE ON SEQUENCE GEN_KUNDE_ID TO SYSDBA WITH GRANT OPTION;


