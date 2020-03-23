DROP DATABASE IF EXISTS mosip_master;
CREATE DATABASE mosip_master
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_master IS 'Database to store all master reference data, look-up data, configuration data, metadata...etc.';
-- ddl-end --

\c mosip_master sysadmin

-- object: master | type: SCHEMA --
DROP SCHEMA IF EXISTS master CASCADE;
CREATE SCHEMA master;
-- ddl-end --
ALTER SCHEMA master OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_master SET search_path TO master,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_master FROM PUBLIC;
-- REVOKEALL ON SCHEMA master FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA master FROM PUBLIC ;
