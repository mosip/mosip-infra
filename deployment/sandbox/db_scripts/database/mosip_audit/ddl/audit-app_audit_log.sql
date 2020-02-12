-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_audit
-- Table Name 	: app_audit_log
-- Purpose    	: Application Audit Log : To track application related audit details for analysing, auditing and reporting purposes
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: audit.app_audit_log | type: TABLE --
-- DROP TABLE IF EXISTS audit.app_audit_log CASCADE;
CREATE TABLE audit.app_audit_log(
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
COMMENT ON TABLE audit.app_audit_log IS 'Application Audit Log : To track application related audit details for analysing, auditing and reporting purposes';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.log_id IS 'Log Id: Unique audit log id for each audit event log entry across the system.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.log_dtimes IS 'Log DateTimestamp: Audit Log Datetimestamp';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.log_desc IS 'Log Description: Detailed description of the audit event';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.event_id IS 'Event Id: Event ID that triggered for which the audit action happend';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.event_type IS 'Event Type: Type of event that triggered the audit log, like, SYSTEM, USER, APPLICATION, BATCH etc.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.event_name IS 'Event Name: Event Name of the Event Id captured';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.action_dtimes IS 'Action DateTimestamp:  Timestamp of an application action happend.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.host_name IS 'Host Name: Host Name of the Host ID captured, if any.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.host_ip IS 'Host Ip: Machine or device host Ip address of audit action event that happend/triggered';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.session_user_id IS 'Session user Id: Active User ID of the person who is logged in to the system and performing any action that triggered the audit log.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.session_user_name IS 'Session user Name: User Name of the Session User ID.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.app_id IS 'Application Id: Application Id of audit action happened and logged.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.app_name IS 'Application Name: Application Name';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.module_id IS 'Module Id: Application Module ID that triggered audit trigger log.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.module_name IS 'Module Name: Application Module Name of the Module ID captured.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.ref_id IS 'Reference Id: Reference ID for any cross reference purpose relevant for audit tracking, user id, app id, app or module id, etc.';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.ref_id_type IS 'Reference Id Type: Type of reference id entered';
-- ddl-end --
COMMENT ON COLUMN audit.app_audit_log.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
