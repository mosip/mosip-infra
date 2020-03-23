-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.abis_application
-- Purpose    	: ABIS Application: List of ABIS (Automatic Biometric Identification System) applications with whom MOSIP application interfaces with.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.abis_application | type: TABLE --
-- DROP TABLE IF EXISTS regprc.abis_application CASCADE;
CREATE TABLE regprc.abis_application(
	code character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	descr character varying(256) NOT NULL,
	status_code character varying(36) NOT NULL,
	status_update_dtimes timestamp NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_abisapp PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE regprc.abis_application IS 'ABIS Application: List of ABIS (Automatic Biometric Identification System) applications with whom MOSIP application interfaces with.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.code IS 'Code: Unique code to identify an ABIS application ';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.name IS 'Name: Name of the ABIS application';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.descr IS 'Description : Description of the ABIS application';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.status_code IS 'Status Code : Status code whether the ABIS application is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.status_update_dtimes IS 'Status Update Date Time: Data and Time from when this ABIS application status was updated. This can be used to track from when the ABIS application is active or in active.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_application.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

