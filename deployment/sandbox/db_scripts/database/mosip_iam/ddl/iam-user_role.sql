-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_iam
-- Table Name 	: iam.user_role
-- Purpose    	: User Role : List of user roles as per the security and access rights, that will be assigned to specific users.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------


-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: iam.user_role | type: TABLE --
-- DROP TABLE IF EXISTS iam.user_role CASCADE;
CREATE TABLE iam.user_role(
	usr_id character varying(256) NOT NULL,
	role_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_usrrol_usr_id PRIMARY KEY (usr_id,role_code)

);
-- ddl-end --
COMMENT ON TABLE iam.user_role IS 'User Role : List of user roles as per the security and access rights, that will be assigned to specific users.';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.usr_id IS 'User ID : registration center id refers to iam.user_detail.id';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.role_code IS 'Role Code: Role assigned to the user for access control. Refers to iam.role_list.code';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN iam.user_role.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
