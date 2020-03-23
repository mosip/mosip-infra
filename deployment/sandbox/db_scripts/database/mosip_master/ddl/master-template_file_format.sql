-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.template_file_format
-- Purpose    	: Template File Format : Format of the template files that are used for notifications. For ex.,  xml, html, xslt, etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.template_file_format | type: TABLE --
-- DROP TABLE IF EXISTS master.template_file_format CASCADE;
CREATE TABLE master.template_file_format(
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
	CONSTRAINT pk_tffmt_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.template_file_format IS 'Template File Format : Format of the template files that are used for notifications. For ex.,  xml, html, xslt, etc.';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.code IS 'Code : format code of template documents, for ex., html, text, etc';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.descr IS 'Description : Template file format description';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.template_file_format.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

