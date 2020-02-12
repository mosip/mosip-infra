-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_ida
-- Table Name 	: ida.uin_hash_salt
-- Purpose    	: UIN Hash Salt: Stores the salt used to hash uin of an individual in the hashing algorithm.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------


-- object: ida.uin_hash_salt | type: TABLE --
-- DROP TABLE IF EXISTS ida.uin_hash_salt CASCADE;
CREATE TABLE ida.uin_hash_salt(
	id bigint NOT NULL,
	salt character varying(36) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_uinhs PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE ida.uin_hash_salt IS 'UIN Hash Salt: Stores the salt used to hash uin of an individual in the hashing algorithm.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_hash_salt.id IS 'Id: Unique id generated for the salts that is used to hash the uin field.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_hash_salt.salt IS 'Salt: Random generated number used as salt to hash the uin field.';
-- ddl-end --
COMMENT ON COLUMN ida.uin_hash_salt.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN ida.uin_hash_salt.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN ida.uin_hash_salt.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN ida.uin_hash_salt.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
