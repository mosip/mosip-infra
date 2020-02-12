-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.policy_group
-- Purpose    : Policy Group: Authentication policies are categorized into different groups/domains. These policy groups are defined and maintained in this table.
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: pmp.policy_group | type: TABLE --
-- DROP TABLE IF EXISTS pmp.policy_group CASCADE;
CREATE TABLE pmp.policy_group(
	id character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	descr character varying(256) NOT NULL,
	user_id character varying(256) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_polg PRIMARY KEY (id),
	CONSTRAINT uk_polg UNIQUE (name)

);
-- ddl-end --
COMMENT ON TABLE pmp.policy_group IS 'Policy Group: Authentication policies are categorized into different groups/domains. These policy groups are defined and maintained in this table.';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.id IS 'ID: A unique id generated / assigned for a policy group.';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.name IS 'Name: Name of the policy group';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.descr IS 'Description: Description of the policy group.';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.user_id IS 'User ID: Login ID assigned by MOSIP to Partner Manager. It is a general/common id for a policy group that is generated and assigned when the policy group is created.';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.policy_group.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
