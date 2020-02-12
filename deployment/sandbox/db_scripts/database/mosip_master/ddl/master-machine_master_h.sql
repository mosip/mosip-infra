-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.machine_master_h
-- Purpose    	: Machine Master History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer master.machine_master table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.machine_master_h | type: TABLE --
-- DROP TABLE IF EXISTS master.machine_master_h CASCADE;
CREATE TABLE master.machine_master_h(
	id character varying(10) NOT NULL,
	name character varying(64) NOT NULL,
	mac_address character varying(64) NOT NULL,
	serial_num character varying(64) NOT NULL,
	ip_address character varying(17),
	validity_end_dtimes timestamp,
	mspec_id character varying(36) NOT NULL,
	public_key bytea,
	key_index character varying(128),
	zone_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	eff_dtimes timestamp NOT NULL,
	CONSTRAINT pk_machm_h_id PRIMARY KEY (id,lang_code,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE master.machine_master_h IS 'Machine Master History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer master.machine_master table description for details.   ';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.id IS 'Machine ID : Unique ID generated / assigned for machine';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.name IS 'Name : Machine name';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.mac_address IS 'Mac Address: Mac address of the machine';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.serial_num IS 'Serial Number: Serial number of the machine';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.ip_address IS 'IP Address: IP address of the machine';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.validity_end_dtimes IS 'Validity End Datetime: Machine validity expiry date';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.mspec_id IS 'Machine Specification ID : Machince specification id refers to master.machine_spec.id';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.public_key IS 'Public Key: Public key of the machine,  This will be Machine Identification TPM Endorsement key';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.key_index IS 'Key Index: Fingerprint[Unique Hash ]  for the TPM public key';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.zone_code IS 'Zone Code : Unique zone code generated or entered by admin while creating zones, It is referred to master.zone.code. ';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
COMMENT ON COLUMN master.machine_master_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time. ';
-- ddl-end --

