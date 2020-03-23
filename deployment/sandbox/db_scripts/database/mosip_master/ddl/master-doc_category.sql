-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.doc_category
-- Purpose    	: Document Category : List document categories for registration for ex., POA, POI, etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.doc_category | type: TABLE --
-- DROP TABLE IF EXISTS master.doc_category CASCADE;
CREATE TABLE master.doc_category(
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
	CONSTRAINT pk_doccat_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.doc_category IS 'Document Category : List document categories for registration for ex., POA, POI, etc';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.code IS 'Code : category of documents for registration for ex., POA, POI, etc';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.name IS 'Name : Document category name';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.descr IS 'Description : Document category description';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.doc_category.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

