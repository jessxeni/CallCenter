
-- Oracle 12c
CREATE USER C##myUser 
	IDENTIFIED BY oracle
	ACCOUNT UNLOCK  	
	CONTAINER=ALL
  ;
ALTER USER C##myUser quota 100M ON USERS;
  
-- Rechtevergabe an den user myUser
grant connect to C##myUser;               
-- Connect-Berechtigung (erst dann ist ein Connect m�glich)
grant create procedure to C##myUser;      
-- Prozeduren erstellen
grant create trigger to C##myUser;        
-- Trigger erstellen
grant create sequence to C##myUser;       
-- Sequence erstellen
grant create public synonym to C##myUser; 
-- Synonyme erstellen
grant drop public synonym to C##myUser;   
-- Synonyme l�schen
grant create table to C##myUser;
grant create cluster to C##myUser;
grant create type to C##myUser;
grant execute any type to C##myUser;
grant select_catalog_role to C##myUser;
grant select any dictionary to C##myUser;
grant create view to C##myUser;
commit;
