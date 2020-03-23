DROP DATABASE IF EXISTS mosip_iam;
CREATE DATABASE mosip_iam
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_iam IS 'Database to store all Identity and Access management data, look-up data, configuration data, metadata...etc.';
-- ddl-end --

\c mosip_iam sysadmin

-- object: master | type: SCHEMA --
DROP SCHEMA IF EXISTS iam CASCADE;
CREATE SCHEMA iam;
-- ddl-end --
ALTER SCHEMA iam OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_iam SET search_path TO master,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_master FROM PUBLIC;
-- REVOKEALL ON SCHEMA master FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA master FROM PUBLIC ;
