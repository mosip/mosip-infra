-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.dao_key_store
-- Purpose    	: DAO Key Store: In MOSIP, data related to an individual in stored in encrypted form. This table is to manage all the security keys used for DAO layer encryption.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 29-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: kernel.dao_key_store | type: TABLE --
-- DROP TABLE IF EXISTS kernel.dao_key_store CASCADE;
CREATE TABLE kernel.dao_key_store(
	id character varying(36) NOT NULL,
	key character varying(256) NOT NULL,
	key_gen_dtimes timestamp,
	key_expire_dtimes timestamp,
	is_expired boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_daokeystr_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE kernel.dao_key_store IS 'DAO Key Store: In MOSIP, data related to an individual in stored in encrypted form. This table is to manage all the security keys used for DAO layer encryption. ';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.id IS 'ID: ID is a unique identifier (UUID) used for managing encryption keys';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.key IS 'Key: Security key is used to encrypt / decrypt at DAO layer';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.key_gen_dtimes IS 'Key Generated Date Time: Date and time when the key was generated.';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.key_expire_dtimes IS 'Key Expiry Date Time : Date and time when the key will be expired.';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.is_expired IS 'Is Expired : This is the flag to check whether the security key is expired or not.';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.dao_key_store.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
