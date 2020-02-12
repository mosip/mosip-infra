-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.user_detail
-- Purpose    	: User Detail : List of applicatgion users in the system, who can perform UIN registration functions as per roles assigned.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.user_detail | type: TABLE --
-- DROP TABLE IF EXISTS master.user_detail CASCADE;
CREATE TABLE master.user_detail(
	id character varying(256) NOT NULL,
	uin character varying(28),
	name character varying(64) NOT NULL,
	email character varying(256),
	mobile character varying(16),
	status_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	last_login_dtimes timestamp,
	last_login_method character varying(64),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_usrdtl_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE master.user_detail IS 'User Detail : List of applicatgion users in the system, who can perform UIN registration functions as per roles assigned.';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.id IS 'User ID : Unique ID generated / assigned for a user';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.uin IS 'UIN: UIN of the user. Typically this will be used for bio authentication';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.name IS 'Name : User name';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.email IS 'Email: Email address of the user';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.mobile IS 'Mobile: Mobile number of the user';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.status_code IS 'Status Code: User status. Refers to master.status_master.code';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.last_login_dtimes IS 'Last Login Datetime: Date and time of the last login by the user';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.last_login_method IS 'Last Login Method: Previous login method in which the user logged into the system';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.user_detail.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

