-- object: uinuser | type: ROLE --
-- DROP ROLE IF EXISTS uinuser;
CREATE ROLE idrepouser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --
