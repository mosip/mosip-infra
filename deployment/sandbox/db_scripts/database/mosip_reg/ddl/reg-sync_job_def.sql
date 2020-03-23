-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.sync_job_def
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


-- object: reg.sync_job_def | type: TABLE --
-- DROP TABLE IF EXISTS reg.sync_job_def CASCADE;
CREATE TABLE reg.sync_job_def(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	api_name character varying(64),
	parent_syncjob_id character varying(36),
	sync_freq character varying(36),
	lock_duration character varying(36),
	lang_code character varying(3),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_syncjob_id PRIMARY KEY (id)

);
-- ddl-end --

-- object: idx_syncjob_name | type: INDEX --
-- DROP INDEX IF EXISTS reg.idx_syncjob_name CASCADE;
CREATE UNIQUE INDEX idx_syncjob_name ON reg.sync_job_def
	(
	  name
	)
-- ddl-end --

