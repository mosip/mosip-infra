-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.app_detail
-- Purpose    	: Application Details : List of MOSIP Applications.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.app_detail | type: TABLE --
-- DROP TABLE IF EXISTS master.app_detail CASCADE;
CREATE TABLE master.app_detail(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_appdtl_id PRIMARY KEY (id,lang_code)

);

-- indexes section -------------------------------------------------
create unique index idx_appdtl_name on master.app_detail (name)
;

-- ddl-end --
COMMENT ON TABLE master.app_detail IS 'Application Details : List of MOSIP Applications';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.id IS 'Application ID :  Unique ID generated / assigned for an application';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.name IS 'Name : Application name';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.descr IS 'Description :  Application description';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.app_detail.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --



