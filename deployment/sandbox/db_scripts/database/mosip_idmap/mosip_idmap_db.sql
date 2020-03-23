DROP DATABASE IF EXISTS mosip_idmap;
CREATE DATABASE mosip_idmap 
	ENCODING = 'UTF8' 
	LC_COLLATE = 'en_US.UTF-8' 
	LC_CTYPE = 'en_US.UTF-8' 
	TABLESPACE = pg_default 
	OWNER = sysadmin
	TEMPLATE  = template0;

-- ddl-end --
COMMENT ON DATABASE mosip_idmap IS 'idmap related entities and its data is stored in this database';
-- ddl-end --

\c mosip_idmap sysadmin

-- object: idmap | type: SCHEMA --
DROP SCHEMA IF EXISTS idmap CASCADE;
CREATE SCHEMA idmap;
-- ddl-end --
ALTER SCHEMA idmap OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_idmap SET search_path TO idmap,pg_catalog,public;
-- ddl-end --

-- REVOKE CONNECT ON DATABASE mosip_idmap FROM PUBLIC;
-- REVOKE ALL ON SCHEMA idmap FROM PUBLIC;
-- REVOKE ALL ON ALL TABLES IN SCHEMA idmap FROM PUBLIC ;
