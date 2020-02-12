-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.doc_format
-- Purpose    	: Document Format : List of acceptable document formats supported by the system, for ex., pdf, jpeg, etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.doc_format | type: TABLE --
-- DROP TABLE IF EXISTS master.doc_format CASCADE;
CREATE TABLE master.doc_format(
	code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(128),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_docfmt_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.doc_format IS 'Document Format : List of acceptable document formats supported by the system, for ex., pdf, jpeg, etc.';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.code IS 'Code : acceptable format of documents to be uploaded during registration, for ex., pdf, jpeg, etc';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.name IS 'Name : Document format name';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.descr IS 'Description : Document format description';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.doc_format.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
