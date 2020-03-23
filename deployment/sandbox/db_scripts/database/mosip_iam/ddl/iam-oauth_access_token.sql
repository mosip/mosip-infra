-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_iam
-- Table Name 	: iam.oauth_access_token
-- Purpose    	: Authentication Access Token : This table is used to store the auth token, refresh token and expiration time for JWT token based validation.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: iam.oauth_access_token | type: TABLE --
-- DROP TABLE IF EXISTS iam.oauth_access_token CASCADE;
CREATE TABLE iam.oauth_access_token(
	auth_token character varying(1024),
	user_id character varying(256) NOT NULL,
	refresh_token character varying(1024),
	expiration_time timestamp,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_authat_id PRIMARY KEY (user_id)

);
-- ddl-end --
COMMENT ON TABLE iam.oauth_access_token IS 'Authentication Access Token : This table is used to store the auth token, refresh token and expiration time for JWT token based validation.';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.auth_token IS 'Authentication Token : JWT Token for user logged in';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.user_id IS 'User ID: User Id of the user logged in';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.refresh_token IS 'Refresh Token : JWT Refresh token when auth token expires';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.expiration_time IS 'Expiration Time : Expiration time of Auth Token';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN iam.oauth_access_token.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
