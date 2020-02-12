-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.template
-- Purpose    	: Template : Templates are defined to standardize the communication process within the system. For ex., notications, alerts, etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.template | type: TABLE --
-- DROP TABLE IF EXISTS master.template CASCADE;
CREATE TABLE master.template(
	id character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	descr character varying(256),
	file_format_code character varying(36) NOT NULL,
	model character varying(128),
	file_txt character varying(4086),
	module_id character varying(36),
	module_name character varying(128),
	template_typ_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_tmplt_id PRIMARY KEY (id,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.template IS 'Template : Templates are defined to standardize the communication process within the system. For ex., notications, alerts, etc.';
-- ddl-end --
COMMENT ON COLUMN master.template.id IS 'Template ID : Unique ID generated / assigned for a template';
-- ddl-end --
COMMENT ON COLUMN master.template.name IS 'Name : Template name / title';
-- ddl-end --
COMMENT ON COLUMN master.template.descr IS 'Description : Template description';
-- ddl-end --
COMMENT ON COLUMN master.template.file_format_code IS 'Temple File Format Code : Template formats like xml, html, xslt...etc.';
-- ddl-end --
COMMENT ON COLUMN master.template.model IS 'Template Model : velocity, free maker, jasper report....etc';
-- ddl-end --
COMMENT ON COLUMN master.template.file_txt IS 'File Text: Contents of the template';
-- ddl-end --
COMMENT ON COLUMN master.template.module_id IS 'Module ID : Module id refers to master.module_list.id';
-- ddl-end --
COMMENT ON COLUMN master.template.module_name IS 'Module Name: Name of the module where the template is being used.';
-- ddl-end --
COMMENT ON COLUMN master.template.template_typ_code IS 'Template Type Code: Template type code refers to master.template_type.code';
-- ddl-end --
COMMENT ON COLUMN master.template.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.template.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.template.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.template.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.template.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.template.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.template.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.template.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

