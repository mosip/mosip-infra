-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.tsp_licensekey_map
-- Purpose    	: TSP License keys : TSP and License key mapping.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.tsp_licensekey_map | type: TABLE --
-- DROP TABLE IF EXISTS master.tsp_licensekey_map CASCADE;
CREATE TABLE master.tsp_licensekey_map(
	tsp_id character varying(36) NOT NULL,
	license_key character varying(255) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_tsplkeym PRIMARY KEY (tsp_id,license_key)

);
-- ddl-end --
COMMENT ON TABLE master.tsp_licensekey_map IS 'TSP License keys : TSP and License key mapping ';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.tsp_id IS 'TSP ID: ID of the thirdparty service provider';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.license_key IS 'License Key : License key which is mapped to TSP, This will refer to master.licensekey_list.license_key';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.tsp_licensekey_map.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

