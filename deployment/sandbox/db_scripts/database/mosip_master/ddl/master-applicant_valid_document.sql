-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.applicant_valid_document
-- Purpose    	: Applicant Valid Document : This is mapping table that relates applicant type, document category and document type, that is valid document proof for UIN registration process.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.applicant_valid_document | type: TABLE --
-- DROP TABLE IF EXISTS master.applicant_valid_document CASCADE;
CREATE TABLE master.applicant_valid_document(
	apptyp_code character varying(36) NOT NULL,
	doccat_code character varying(36) NOT NULL,
	doctyp_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_avaldoc_code PRIMARY KEY (apptyp_code,doccat_code,doctyp_code)

);
-- ddl-end --
COMMENT ON TABLE master.applicant_valid_document IS 'Applicant Valid Document : This is mapping table that relates applicant type, document category and document type, that is valid document proof for UIN registration process.';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.apptyp_code IS 'Applicant Type Code: Code of the applicant type defined/configured by the country admin';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.doccat_code IS 'Document Category Code: Refers to master.doc_category.code';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.doctyp_code IS 'Document Type Code: Refers to master.doc_type.code';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.applicant_valid_document.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
