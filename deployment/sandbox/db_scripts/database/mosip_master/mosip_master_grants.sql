\c mosip_master sysadmin


-- object: grant_b0ae4f0dce | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE mosip_master
   TO sysadmin;
-- ddl-end --

-- object: grant_99dd1cb062 | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE mosip_master
   TO appadmin;
-- ddl-end --

-- object: grant_18180691b7 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE mosip_master
   TO masteruser;
-- ddl-end --

-- object: grant_3543fb6cf7 | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA master
   TO sysadmin;
-- ddl-end --

-- object: grant_8e1a2559ed | type: PERMISSION --
GRANT USAGE
   ON SCHEMA master
   TO masteruser;
-- ddl-end --

-- object: grant_8e1a2559ed | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES
   ON ALL TABLES IN SCHEMA master
   TO masteruser;
-- ddl-end --

ALTER DEFAULT PRIVILEGES IN SCHEMA master 
	GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON TABLES TO masteruser;


-- object: grant_78ed2da4ee | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES
   ON ALL TABLES IN SCHEMA master
   TO appadmin;
-- ddl-end --
