-- object: pmpuser | type: ROLE --
-- DROP ROLE IF EXISTS pmpuser;
CREATE ROLE pmpuser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --
