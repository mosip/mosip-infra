-- object: kerneluser | type: ROLE --
-- DROP ROLE IF EXISTS kerneluser;
CREATE ROLE kerneluser WITH 
	INHERIT
	LOGIN
	PASSWORD :dbuserpwd;
-- ddl-end --

