-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.admin_param
-- Purpose    	: Admin Parameters : Stores admin parameters with values used in application modules.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.admin_param | type: TABLE --
-- DROP TABLE IF EXISTS master.admin_param CASCADE;
CREATE TABLE master.admin_param(
	code character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	val character varying(512),
	typ character varying(128) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_admparm_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.admin_param IS 'Admin Parameters : Stores admin parameters with values used in application modules.';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.code IS 'Code : unique parameter code for different configurations, processes, defaults etc';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.name IS 'Name : Admin parameter name';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.val IS 'Parameter Value : values for admin configuration parameter';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.typ IS 'Type : Admin parameter classification types  for ex., System parameter, business parameters, configuration parameters, security parameter, schedule parameter....etc.';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.admin_param.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
