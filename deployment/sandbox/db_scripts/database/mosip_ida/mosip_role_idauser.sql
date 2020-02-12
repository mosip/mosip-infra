-- object: idauser | type: ROLE --
-- DROP ROLE IF EXISTS idauser;
CREATE ROLE idauser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --

