-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.key_alias
-- Purpose    	: Key Alias: To maintain a system generated key as alias for the encryption key that will be stored in key-store devices like HSM.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: kernel.key_alias | type: TABLE --
-- DROP TABLE IF EXISTS kernel.key_alias CASCADE;
CREATE TABLE kernel.key_alias(
	id character varying(36) NOT NULL,
	app_id character varying(36) NOT NULL,
	ref_id character varying(128),
	key_gen_dtimes timestamp,
	key_expire_dtimes timestamp,
	status_code character varying(36),
	lang_code character varying(3),
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_keymals_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE kernel.key_alias IS 'Key Alias: To maintain a system generated key as alias for the encryption key that will be stored in key-store devices like HSM.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.id IS 'ID: Key alias id is a unique identifier (UUID) used as an alias of the encryption key stored in keystore like HSM (hardware security module).';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.app_id IS 'Application ID: Application id for which the encryption key is generated';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.ref_id IS 'Reference ID: Reference ID is a reference inforamtion received from key requester which can be machine id, TSP id, etc.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.key_gen_dtimes IS 'Key Generated Date Time: Date and time when the key was generated.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.key_expire_dtimes IS 'Key Expiry Date Time: Date and time when the key will be expired. This will be derived based on the configuration / policy defined in Key policy definition.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.status_code IS 'Status Code: Status of the key, whether it is active or expired.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_alias.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
