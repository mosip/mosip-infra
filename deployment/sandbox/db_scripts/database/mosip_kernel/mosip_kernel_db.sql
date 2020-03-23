DROP DATABASE IF EXISTS mosip_kernel;
CREATE DATABASE mosip_kernel
	ENCODING = 'UTF8'
	LC_COLLATE = 'en_US.UTF-8'
	LC_CTYPE = 'en_US.UTF-8'
	TABLESPACE = pg_default
	OWNER = sysadmin
	TEMPLATE  = template0;
-- ddl-end --
COMMENT ON DATABASE mosip_kernel IS 'Kernel database maintains common / system configurations, data related to kernel services like sync process, OTP, etc.';
-- ddl-end --

\c mosip_kernel sysadmin

-- object: kernel | type: SCHEMA --
DROP SCHEMA IF EXISTS kernel CASCADE;
CREATE SCHEMA kernel;
-- ddl-end --
ALTER SCHEMA kernel OWNER TO sysadmin;
-- ddl-end --

ALTER DATABASE mosip_kernel SET search_path TO kernel,pg_catalog,public;
-- ddl-end --

-- REVOKECONNECT ON DATABASE mosip_kernel FROM PUBLIC;
-- REVOKEALL ON SCHEMA kernel FROM PUBLIC;
-- REVOKEALL ON ALL TABLES IN SCHEMA kernel FROM PUBLIC ;
