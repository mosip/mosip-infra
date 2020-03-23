DROP DATABASE IF EXISTS mosip_audit;
CREATE DATABASE mosip_audit 
	ENCODING = 'UTF8' 
	LC_COLLATE = 'en_US.UTF-8' 
	LC_CTYPE = 'en_US.UTF-8' 
	TABLESPACE = pg_default 
	OWNER = sysadmin
	TEMPLATE  = template0;

-- ddl-end --
COMMENT ON DATABASE mosip_audit IS 'Audit related logs and the data is stored in this database';
-- ddl-end --

\c mosip_audit sysadmin

-- object: audit | type: SCHEMA --
DROP SCHEMA IF EXISTS audit CASCADE;
CREATE SCHEMA audit;
-- ddl-end --
ALTER SCHEMA audit OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_audit SET search_path TO audit,pg_catalog,public;
-- ddl-end --

-- REVOKE CONNECT ON DATABASE mosip_audit FROM PUBLIC;
-- REVOKE ALL ON SCHEMA audit FROM PUBLIC;
-- REVOKE ALL ON ALL TABLES IN SCHEMA audit FROM PUBLIC ;
