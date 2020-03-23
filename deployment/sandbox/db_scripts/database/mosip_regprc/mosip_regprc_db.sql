DROP DATABASE IF EXISTS mosip_regprc;
CREATE DATABASE mosip_regprc
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_regprc IS 'The data related to Registration process flows and transaction will be maintained in this database. This database also maintains data that is needed to perform deduplication.';
-- ddl-end --

\c mosip_regprc sysadmin

-- object: regprc | type: SCHEMA --
DROP SCHEMA IF EXISTS regprc CASCADE;
CREATE SCHEMA regprc;
-- ddl-end --
ALTER SCHEMA regprc OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_regprc SET search_path TO regprc,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_regprc FROM PUBLIC;
-- REVOKEALL ON SCHEMA regprc FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA regprc FROM PUBLIC ;
