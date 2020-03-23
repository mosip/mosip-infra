-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.app_detail
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


-- object: reg.app_detail | type: TABLE --
-- DROP TABLE IF EXISTS reg.app_detail CASCADE;
CREATE TABLE reg.app_detail(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_appdtl_id PRIMARY KEY (id,lang_code)

);
-- ddl-end --

-- object: idx_appdtl_name | type: INDEX --
-- DROP INDEX IF EXISTS reg.idx_appdtl_name CASCADE;
CREATE UNIQUE INDEX idx_appdtl_name ON reg.app_detail
	(
	  name
	);
-- ddl-end --

