DROP ROLE IF EXISTS iamuser;
CREATE ROLE iamuser WITH 

	INHERIT

	LOGIN

	PASSWORD :dbuserpwd;

-- ddl-end --
