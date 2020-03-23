-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_repo
-- Table Name 	: idrepo.uin_encrypt_salt
-- Purpose    	: UIN Encript Salt: Stores the salt used to encrypt an uin of an individual in the encryption algorithm.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: idrepo.uin_encrypt_salt | type: TABLE --
-- DROP TABLE IF EXISTS idrepo.uin_encrypt_salt CASCADE;
CREATE TABLE idrepo.uin_encrypt_salt(
	id bigint NOT NULL,
	salt character varying(36) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_uines PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE idrepo.uin_encrypt_salt IS 'UIN Encript Salt: Stores the salt used to encrypt an uin of an individual in the encryption algorithm.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_encrypt_salt.id IS 'Id: Unique id generated for the salts that is used to encrypt the uin field.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_encrypt_salt.salt IS 'Salt: Random generated number used as salt to encrypt the uin field.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_encrypt_salt.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_encrypt_salt.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_encrypt_salt.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_encrypt_salt.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
