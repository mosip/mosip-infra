-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.misp_license
-- Purpose    : MISP License: License key issued to MISP, using which an individual''s authentication request that is initiated from partners are authenticated.
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: pmp.misp_license | type: TABLE --
-- DROP TABLE IF EXISTS pmp.misp_license CASCADE;
CREATE TABLE pmp.misp_license(
	misp_id character varying(36) NOT NULL,
	license_key character varying(128) NOT NULL,
	valid_from_date timestamp NOT NULL,
	valid_to_date timestamp,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_mlic PRIMARY KEY (misp_id,license_key)

);
-- ddl-end --
COMMENT ON TABLE pmp.misp_license IS 'MISP License: License key issued to MISP, using which an individual''s authentication request that is initiated from partners are authenticated.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.misp_id IS 'MISP ID: MISP ID, refers to pmp.misp .id';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.license_key IS 'License Key: A system generated number assigned to MISP as License key. It will be used by MISP application to be appended to auth request which is received by partners.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.valid_from_date IS 'Valid From Date: Datetime from when the license key is valid.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.valid_to_date IS 'Valid To Date: Datetime when the license key will be expired.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.upd_by IS 'Updated By : ID or name of the user who update the record with new values
';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp_license.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
