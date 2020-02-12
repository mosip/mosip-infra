-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.partner_policy
-- Purpose    : Partner Policy: Authentication policies assigned to a partner once the policy creation request is approved. An Policy API Key is generated and provided to the partner that will be used as part of auth requests.
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


-- object: pmp.partner_policy | type: TABLE --
-- DROP TABLE IF EXISTS pmp.partner_policy CASCADE;
CREATE TABLE pmp.partner_policy(
	policy_api_key character varying(128) NOT NULL,
	part_id character varying(36) NOT NULL,
	policy_id character varying(36) NOT NULL,
	valid_from_datetime timestamp NOT NULL,
	valid_to_datetime timestamp,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_ppol PRIMARY KEY (policy_api_key),
	CONSTRAINT uk_ppol UNIQUE (part_id,policy_id,valid_from_datetime)

);
-- ddl-end --
COMMENT ON TABLE pmp.partner_policy IS 'Partner Policy: Authentication policies assigned to a partner once the policy creation request is approved. An Policy API Key is generated and provided to the partner that will be used as part of auth requests.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.policy_api_key IS 'Policy API Key: ';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.part_id IS 'Partner ID: Partner ID, refers to pmp.partner .id';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.policy_id IS 'Policy ID: Policy ID, refers to pmp.auth_policy .id';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.valid_from_datetime IS 'Valid From Datetime: Date and time from when the policy is valid.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.valid_to_datetime IS 'Valid To Datetime: Date and time till when the policy is valid.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
