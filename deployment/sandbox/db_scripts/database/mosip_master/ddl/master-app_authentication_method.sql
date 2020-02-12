-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.app_authentication_method
-- Purpose    	: App Authentication Method : Store List of application, process, role and their user authentication methods mapped with sequence.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.app_authentication_method | type: TABLE --
-- DROP TABLE IF EXISTS master.app_authentication_method CASCADE;
CREATE TABLE master.app_authentication_method(
	app_id character varying(36) NOT NULL,
	process_id character varying(36) NOT NULL,
	role_code character varying(36) NOT NULL,
	auth_method_code character varying(36) NOT NULL,
	method_seq smallint,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_appauthm_id PRIMARY KEY (app_id,process_id,role_code,auth_method_code)

);

 -- indexes section -------------------------------------------------
create unique index uk_appauthm_id on master.app_authentication_method (app_id, process_id, role_code, method_seq) ;

-- ddl-end --
COMMENT ON TABLE master.app_authentication_method IS 'App Authentication Method : Store List of application, process, role and their user authentication methods mapped with sequence.';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.app_id IS 'Application ID : of specific application module, for.ex.,  Registration client, Authentication application, Portal App, etc.  refers master.app_detail.id';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.process_id IS 'Process ID : Process id refers to master.process_list.id';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.role_code IS 'Role Code: Role code refers to master.role_list.code';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.auth_method_code IS 'Authentication Method Code :  unique authentication methods supported by the system, for ex., OTP, PASSWORD, BIO etc.  Refers to master.authentication_method.code  ';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.method_seq IS 'Method Sequence: In case of multiple authentication methods supported by an application, then the sequence number is used to serialized the authentication process';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.app_authentication_method.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
