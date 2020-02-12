-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.app_audit_log
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.app_audit_log | type: TABLE --
-- DROP TABLE IF EXISTS reg.app_audit_log CASCADE;
CREATE TABLE reg.app_audit_log(
	log_id character varying(64) NOT NULL,
	log_dtimes timestamp NOT NULL,
	log_desc character varying(2048),
	event_id character varying(64) NOT NULL,
	event_type character varying(64) NOT NULL,
	event_name character varying(128) NOT NULL,
	action_dtimes timestamp NOT NULL,
	host_name character varying(128) NOT NULL,
	host_ip character varying(16) NOT NULL,
	session_user_id character varying(256) NOT NULL,
	session_user_name character varying(128),
	app_id character varying(64) NOT NULL,
	app_name character varying(128) NOT NULL,
	module_id character varying(64),
	module_name character varying(128),
	ref_id character varying(64),
	ref_id_type character varying(64),
	cr_by character varying(256) NOT NULL,
	CONSTRAINT pk_audlog_log_id PRIMARY KEY (log_id)

);
-- ddl-end --
