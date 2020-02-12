-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.authentication_method
-- Purpose    	: Authentication Method : List of user Authentication methods supported by the system.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.authentication_method | type: TABLE --
-- DROP TABLE IF EXISTS master.authentication_method CASCADE;
CREATE TABLE master.authentication_method(
	code character varying(36) NOT NULL,
	method_seq smallint,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_authm_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.authentication_method IS 'Authentication Method : List of user Authentication methods supported by the system.';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.code IS 'Code :  unique authentication methods supported by the system, for ex., OTP, PASSWORD, BIO etc. ';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.method_seq IS 'Method Sequence: In case of multiple authentication methods supported by an application, then the sequence number is used to serialized the authentication process';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.authentication_method.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

