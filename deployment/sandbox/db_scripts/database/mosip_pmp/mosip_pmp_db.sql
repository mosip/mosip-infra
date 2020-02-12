DROP DATABASE IF EXISTS mosip_pmp;
CREATE DATABASE mosip_pmp 
	ENCODING = 'UTF8' 
	LC_COLLATE = 'en_US.UTF-8' 
	LC_CTYPE = 'en_US.UTF-8' 
	TABLESPACE = pg_default 
	OWNER = sysadmin
	TEMPLATE  = template0;

-- ddl-end --
COMMENT ON DATABASE mosip_pmp IS 'PMP related entities and its data is stored in this database';
-- ddl-end --

\c mosip_pmp sysadmin

-- object: pmp | type: SCHEMA --
DROP SCHEMA IF EXISTS pmp CASCADE;
CREATE SCHEMA pmp;
-- ddl-end --
ALTER SCHEMA pmp OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_pmp SET search_path TO pmp,pg_catalog,public;
-- ddl-end --

-- REVOKE CONNECT ON DATABASE mosip_pmp FROM PUBLIC;
-- REVOKE ALL ON SCHEMA pmp FROM PUBLIC;
-- REVOKE ALL ON ALL TABLES IN SCHEMA pmp FROM PUBLIC ;
