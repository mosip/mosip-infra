DROP DATABASE IF EXISTS mosip_idrepo;
CREATE DATABASE mosip_idrepo
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_idrepo IS 'ID Repo database stores all the data related to an individual for which an UIN is generated';
-- ddl-end --

\c mosip_idrepo sysadmin

-- object: idrepo | type: SCHEMA --
DROP SCHEMA IF EXISTS idrepo CASCADE;
CREATE SCHEMA idrepo;
-- ddl-end --
ALTER SCHEMA idrepo OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_idrepo SET search_path TO idrepo,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_idrepo FROM PUBLIC;
-- REVOKEALL ON SCHEMA idrepo FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA idrepo FROM PUBLIC ;
