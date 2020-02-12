-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.reason_list
-- Purpose    	: Reason List : List of reasons for each category, for ex., photo mismatch, duplicate registration etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.reason_list | type: TABLE --
-- DROP TABLE IF EXISTS master.reason_list CASCADE;
CREATE TABLE master.reason_list(
	code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(256),
	rsncat_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rsnlst_code PRIMARY KEY (code,rsncat_code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.reason_list IS 'Reason List : List of reasons for each category, for ex., photo mismatch, duplicate registration etc.';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.code IS 'Code : list of reasons used related to specific reason categories defined, for ex., photo mismatch, duplicate registration etc.';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.name IS 'Name : Reason short description';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.descr IS 'Description : Reason description';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.rsncat_code IS 'Reason Category Code: Refers to master.reason_category.code';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reason_list.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

