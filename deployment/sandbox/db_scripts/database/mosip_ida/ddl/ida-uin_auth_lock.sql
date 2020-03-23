-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_ida
-- Table Name : ida.uin_auth_lock
-- Purpose    : UIN Authentication Lock: An individual is provided an option to lock or unlock any of the authentication types that are provided by the system. When an individual locks a particular type of authentication, any requests received by the system will be rejected. The details of the locked authentication types are stored in this table.
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: ida.uin_auth_lock | type: TABLE --
-- DROP TABLE IF EXISTS ida.uin_auth_lock CASCADE;
CREATE TABLE ida.uin_auth_lock(
	uin character varying(500) NOT NULL,
	uin_hash character varying(128) NOT NULL,
	auth_type_code character varying(36) NOT NULL,
	lock_request_datetime timestamp NOT NULL,
	lock_start_datetime timestamp NOT NULL,
	lock_end_datetime timestamp,
	status_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_uinal PRIMARY KEY (uin,auth_type_code,lock_request_datetime),
	CONSTRAINT uk_uinal UNIQUE (uin_hash,auth_type_code,lock_request_datetime)

);
-- ddl-end --
COMMENT ON TABLE ida.uin_auth_lock IS 'UIN Authentication Lock: An individual is provided an option to lock or unlock any of the authentication types that are provided by the system. When an individual locks a particular type of authentication, any requests received by the system will be rejected. The details of the locked authentication types are stored in this table. ';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.uin IS 'Unique Identification Number: Unique Identification Number of an individual for which an authentication type is locked.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.uin_hash IS 'Unique Identification Number Hash: Unique Identification Number Hash value of an individual for which an authentication type is locked.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.auth_type_code IS 'Authentication Type Code: Unique code of an authentication type that is being locked by an individual';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.lock_request_datetime IS 'Lock Request Datetime: Data and time when the lock was requested.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.lock_start_datetime IS 'Lock Start Datetime: Start Date and time when the UIN authentication was locked.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.lock_end_datetime IS 'Lock End Datetime: End date and time when the UIN Authentication lock was released.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.status_code IS 'Status Code : Current Status code of the auth lock, whether it is still active or in active.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_auth_lock.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
