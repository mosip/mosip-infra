-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.licensekey_list
-- Purpose    	: License Key : Holds list of license keys which will be used by TSPs.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.licensekey_list | type: TABLE --
-- DROP TABLE IF EXISTS master.licensekey_list CASCADE;
CREATE TABLE master.licensekey_list(
	license_key character varying(255) NOT NULL,
	created_dtime timestamp,
	expiry_dtime timestamp,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_lkeylst PRIMARY KEY (license_key)

);
-- ddl-end --
COMMENT ON TABLE master.licensekey_list IS 'License Key : Holds list of license keys which will be used by TSPs';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.license_key IS 'License Key : License key which is created to map partners, license key will have information related to authentication type access.';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.created_dtime IS 'Created Date and Time : Licence key created date and time';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.expiry_dtime IS 'Expiry Date and Time: Expiry date and time of license key';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.licensekey_list.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

