-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.screen_authorization
-- Purpose    	: Screen Authorization : Mapping table to define the access control of application screens to a role.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.screen_authorization | type: TABLE --
-- DROP TABLE IF EXISTS master.screen_authorization CASCADE;
CREATE TABLE master.screen_authorization(
	screen_id character varying(36) NOT NULL,
	role_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_permitted boolean NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_scrauth_screen_id PRIMARY KEY (screen_id,role_code)

);
-- ddl-end --
COMMENT ON TABLE master.screen_authorization IS 'Screen Authorization : Mapping table to define the access control of application screens to a role';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.screen_id IS 'Screen ID : registration center id refers to master.screen_detail.id';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.role_code IS 'Role Code: Screen access control for the specific roles defined. Refers to master.role_list.code';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.is_permitted IS 'Is Permitted: Control flag for allowing / denying screen access';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.screen_authorization.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
