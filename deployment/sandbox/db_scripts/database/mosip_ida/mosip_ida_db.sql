DROP DATABASE IF EXISTS mosip_ida;
CREATE DATABASE mosip_ida
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_ida IS 'ID Authorization related requests, transactions and mapping related data like virtual ids, tokens, etc. will be stored in this database';
-- ddl-end --

\c mosip_ida sysadmin

-- object: ida | type: SCHEMA --
DROP SCHEMA IF EXISTS ida CASCADE;
CREATE SCHEMA ida;
-- ddl-end --
ALTER SCHEMA ida OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_ida SET search_path TO ida,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_ida FROM PUBLIC;
-- REVOKEALL ON SCHEMA ida FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA ida FROM PUBLIC ;
