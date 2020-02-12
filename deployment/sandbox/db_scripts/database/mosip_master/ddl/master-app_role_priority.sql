-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.app_role_priority
-- Purpose    	: Application Role Priority : Defines role priority for each application and processes for application user.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.app_role_priority | type: TABLE --
-- DROP TABLE IF EXISTS master.app_role_priority CASCADE;
CREATE TABLE master.app_role_priority(
	app_id character varying(36) NOT NULL,
	process_id character varying(36) NOT NULL,
	role_code character varying(36) NOT NULL,
	priority smallint,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_roleprt_id PRIMARY KEY (app_id,process_id,role_code)

);

-- indexes section -------------------------------------------------
create unique index uk_roleprt_id on master.app_role_priority (app_id, process_id, priority) ;

-- ddl-end --
COMMENT ON TABLE master.app_role_priority IS 'Application Role Priority : Defines role priority for each application and processes for application user.';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.app_id IS 'Application ID : of specific application module, for.ex.,  Registration client, Authentication application, Portal App, etc.  refers master.app_detail.id';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.process_id IS 'Process ID : Process id refers to master.process_list.id';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.role_code IS 'Role Code: Role code refers to master.role_list.code';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.priority IS 'Priority: In case of multiple roles assigned to a user, then the role with highest priority will be considered for application process.';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.app_role_priority.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
