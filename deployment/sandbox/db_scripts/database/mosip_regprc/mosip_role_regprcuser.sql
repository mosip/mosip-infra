-- object: regprcuser | type: ROLE --
-- DROP ROLE IF EXISTS regprcuser;
CREATE ROLE regprcuser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --
