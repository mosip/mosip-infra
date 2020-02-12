-- object: idmapuser | type: ROLE --
-- DROP ROLE IF EXISTS idmapuser;
CREATE ROLE idmapuser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --
