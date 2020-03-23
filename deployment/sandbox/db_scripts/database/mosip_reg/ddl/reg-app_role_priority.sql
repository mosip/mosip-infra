-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.app_role_priority
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: reg.app_role_priority | type: TABLE --
-- DROP TABLE IF EXISTS reg.app_role_priority CASCADE;
CREATE TABLE reg.app_role_priority(
	app_id character varying(36) NOT NULL,
	process_id character varying(36) NOT NULL,
	role_code character varying(36) NOT NULL,
	priority smallint,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_roleprt_id PRIMARY KEY (app_id,process_id,role_code)

);
-- ddl-end --

-- object: uk_roleprt_id | type: INDEX --
-- DROP INDEX IF EXISTS reg.uk_roleprt_id CASCADE;
CREATE UNIQUE INDEX uk_roleprt_id ON reg.app_role_priority
	(
	  app_id,
	  process_id,
	  priority
	)
;
-- ddl-end --

