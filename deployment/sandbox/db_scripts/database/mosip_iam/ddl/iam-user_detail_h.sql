-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_iam
-- Table Name 	: iam.user_detail_h
-- Purpose    	: User Detail History : This to track changes to iam record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer iam.user_detail table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: iam.user_detail_h | type: TABLE --
-- DROP TABLE IF EXISTS iam.user_detail_h CASCADE;
CREATE TABLE iam.user_detail_h(
	id character varying(256) NOT NULL,
	eff_dtimes timestamp NOT NULL,
	name character varying(64) NOT NULL,
	email character varying(256),
	mobile character varying(16),
	status_code character varying(36) NOT NULL,
	reg_id character varying(39),
	salt character varying(64),
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
	CONSTRAINT pk_usrdtl_h_id PRIMARY KEY (id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE iam.user_detail_h IS 'User Detail History : This to track changes to iam record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer iam.user_detail table description for details.';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.id IS 'User ID : Unique ID generated / assigned for a user';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.eff_dtimes IS 'Effective Date Timestamp : This to track iam record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time. ';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.name IS 'Name : User name';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.email IS 'Email: Email address of the user';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.mobile IS 'Mobile: Mobile number of the user';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.status_code IS 'Status Code: User status. Refers to master.status_list.code';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.reg_id IS 'Registration ID: RID of the user. Typically this will be used for authentication and validation of users';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.salt IS 'Salt : Salt is the key used while hashing user password for additional security';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.last_login_dtimes IS 'Last Login Datetime: Date and time of the last login by the user';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.last_login_method IS 'Last Login Method: Previous login method in which the user logged into the system';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN iam.user_detail_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
