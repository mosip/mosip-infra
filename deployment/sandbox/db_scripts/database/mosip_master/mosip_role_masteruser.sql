-- object: masteruser | type: ROLE --
-- DROP ROLE IF EXISTS masteruser;
CREATE ROLE masteruser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --
