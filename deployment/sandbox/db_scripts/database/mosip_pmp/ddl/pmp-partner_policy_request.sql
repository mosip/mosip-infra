-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.partner_policy_request
-- Purpose    : Partner Policy Request: Partner can self register themselves to use the auth services provided by MOSIP. The registeration requests are stored and processed through here. Once the request is approved and processed a partner is created.
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


-- object: pmp.partner_policy_request | type: TABLE --
-- DROP TABLE IF EXISTS pmp.partner_policy_request CASCADE;
CREATE TABLE pmp.partner_policy_request(
	id character varying(36) NOT NULL,
	part_id character varying(36) NOT NULL,
	policy_id character varying(36) NOT NULL,
	request_datetimes timestamp NOT NULL,
	request_detail character varying(4000) NOT NULL,
	status_code character varying(36) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_papr PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE pmp.partner_policy_request IS 'Partner Policy Request: Partner can self register themselves to use the auth services provided by MOSIP. The registeration requests are stored and processed through here. Once the request is approved and processed a partner is created.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.id IS 'Partner Policy Request ID : Unique ID generated / assigned to track the policy creation request for a partner.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.part_id IS 'Partner ID: Partner ID, refers to pmp.partner .id';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.policy_id IS 'Policy ID: Policy ID, refers to pmp.policy .id';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.request_datetimes IS 'Request Datetime: Date and Time when the policy creation request is received by Partner for processing';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.request_detail IS 'Request Detail: Details provided along with the policy creation request by a partner';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.status_code IS 'Status code: Partner policy request status. Refers to master.status_master.code
';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner_policy_request.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
