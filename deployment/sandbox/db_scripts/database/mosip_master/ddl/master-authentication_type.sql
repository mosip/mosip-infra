-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.authentication_type
-- Purpose    	: Authentication Type : List of Authentication types supported by the system.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.authentication_type | type: TABLE --
-- DROP TABLE IF EXISTS master.authentication_type CASCADE;
CREATE TABLE master.authentication_type(
	code character varying(36) NOT NULL,
	descr character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_authtyp_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.authentication_type IS 'Authentication Type : List of Authentication types supported by the system.';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.code IS 'Code :  unique authentication types supported by the authentication system, for ex., OTP, BIO, DEMOGRAPHIC, eKYC etc. ';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.descr IS 'Description :  Description of authentication types supported by the authentication system';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.authentication_type.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
