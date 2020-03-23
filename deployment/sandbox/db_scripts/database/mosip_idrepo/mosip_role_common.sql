-- object: sysadmin | type: ROLE --
--DROP ROLE IF EXISTS sysadmin;
CREATE ROLE sysadmin WITH 
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	LOGIN
	REPLICATION
	PASSWORD :sysadminpwd;
-- ddl-end --

-- object: dbadmin | type: ROLE --
--DROP ROLE IF EXISTS dbadmin;
CREATE ROLE dbadmin WITH 
	CREATEDB
	CREATEROLE
	INHERIT
	LOGIN
	REPLICATION
	PASSWORD :dbadminpwd;
-- ddl-end --

-- object: appadmin | type: ROLE --
--DROP ROLE IF EXISTS appadmin;
CREATE ROLE appadmin WITH 
	INHERIT
	LOGIN
	PASSWORD :appadminpwd;
-- ddl-end --

