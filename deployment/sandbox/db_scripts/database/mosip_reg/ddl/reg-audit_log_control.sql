-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.audit_log_control
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


-- object: reg.audit_log_control | type: TABLE --
-- DROP TABLE IF EXISTS reg.audit_log_control CASCADE;
CREATE TABLE reg.audit_log_control(
	reg_id character varying(39) NOT NULL,
	audit_log_from_dtimes timestamp NOT NULL,
	audit_log_to_dtimes timestamp NOT NULL,
	audit_log_sync_dtimes timestamp,
	audit_log_purge_dtimes timestamp,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_algc PRIMARY KEY (reg_id)

);
-- ddl-end --
