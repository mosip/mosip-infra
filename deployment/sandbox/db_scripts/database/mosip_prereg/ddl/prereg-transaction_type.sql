-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.transaction_type
-- Purpose    	: Transaction Type: Defines various transaction types that are processd within pre-registration module/application.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.transaction_type | type: TABLE --
-- DROP TABLE IF EXISTS prereg.transaction_type CASCADE;
CREATE TABLE prereg.transaction_type(
	code character varying(36) NOT NULL,
	descr character varying(256) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT ttype_pk PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE prereg.transaction_type IS 'Transaction Type: Defines various transaction types that are processd within pre-registration module/application.';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.code IS 'Code: Code of the transaction types available in pre-registration module/application';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.descr IS 'Desceription: Description of the transaction types of pre-registration module/application';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN prereg.transaction_type.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

