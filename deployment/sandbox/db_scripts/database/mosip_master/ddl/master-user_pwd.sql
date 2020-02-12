-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.user_pwd
-- Purpose    	: User Password : Stores encripted password of users in master.user_details table.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.user_pwd | type: TABLE --
-- DROP TABLE IF EXISTS master.user_pwd CASCADE;
CREATE TABLE master.user_pwd(
	usr_id character varying(256) NOT NULL,
	pwd character varying(512) NOT NULL,
	pwd_expiry_dtimes timestamp,
	status_code character varying(64) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_usrpwd_usr_id PRIMARY KEY (usr_id)

);
-- ddl-end --
COMMENT ON TABLE master.user_pwd IS 'User Password : Stores encripted password of users in master.user_details table.   ';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.usr_id IS 'User ID : registration center id refers to master.user_detail.id';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.pwd IS 'Password: User password in encrypted form';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.pwd_expiry_dtimes IS 'Password Expiry Datetime: User password expiry date and time based on password policy';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.status_code IS 'Status Code: User password status. Refers to master.status_master.code';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.user_pwd.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

