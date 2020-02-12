-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.auth_policy_h
-- Purpose    : Authentication Policy History: This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer pmp.auth_policy table description for details.
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


-- object: pmp.auth_policy_h | type: TABLE --
-- DROP TABLE IF EXISTS pmp.auth_policy_h CASCADE;
CREATE TABLE pmp.auth_policy_h(
	id character varying(36) NOT NULL,
	eff_dtimes timestamp NOT NULL,
	policy_group_id character varying(36),
	name character varying(128) NOT NULL,
	descr character varying(256) NOT NULL,
	policy_file_id character varying(500) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_apolh PRIMARY KEY (id,eff_dtimes),
	CONSTRAINT uk_apolh UNIQUE (eff_dtimes,policy_group_id,name)

);
-- ddl-end --
COMMENT ON TABLE pmp.auth_policy_h IS 'Authentication Policy History: This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer pmp.auth_policy table description for details.   
';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.id IS 'ID: A unique identity ';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time. ';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.policy_group_id IS 'Polocy Group ID: Id of the policy group to which this policy belongs.';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.name IS 'Name: Name of the policy';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.descr IS 'Description: Description of the policy';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.policy_file_id IS 'Policy File ID: Policy are defined by Policy / Partner manager are stored in file system or key based storages like CEPH. The policy file details (location / id / key) is stored here.';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.auth_policy_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
