DROP DATABASE IF EXISTS mosip_prereg;
CREATE DATABASE mosip_prereg
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_prereg IS 'Pre-registration database to store the data that is captured as part of pre-registration process';
-- ddl-end --

\c mosip_prereg sysadmin

-- object: prereg | type: SCHEMA --
DROP SCHEMA IF EXISTS prereg CASCADE;
CREATE SCHEMA prereg;
-- ddl-end --
ALTER SCHEMA prereg OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_prereg SET search_path TO prereg,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_prereg FROM PUBLIC;
-- REVOKEALL ON SCHEMA prereg FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA prereg FROM PUBLIC ;
