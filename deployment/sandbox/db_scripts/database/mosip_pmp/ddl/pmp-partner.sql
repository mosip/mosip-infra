-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.partner
-- Purpose    : Partner: Registered external partners use the authentication services provided by MOSIP. The auth services are channeled through MISPs. This table stores the master list of partners who can self register themselves and use auth services.
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: pmp.partner | type: TABLE --
-- DROP TABLE IF EXISTS pmp.partner CASCADE;
CREATE TABLE pmp.partner(
	id character varying(36) NOT NULL,
	policy_group_id character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	address character varying(2000),
	contact_no character varying(16),
	email_id character varying(254),
	public_key character varying(128),
	user_id character varying(256) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_part PRIMARY KEY (id),
	CONSTRAINT uk_part UNIQUE (policy_group_id,name)

);
-- ddl-end --
COMMENT ON TABLE pmp.partner IS 'Partner: Registered external partners use the authentication services provided by MOSIP. The auth services are channeled through MISPs. This table stores the master list of partners who can self register themselves and use auth services.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.id IS 'Partner ID : Unique ID generated / assigned for partner';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.policy_group_id IS 'Policy Group ID: Policy group to which the partner registers for to avail the auth services.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.name IS 'Name: Name of the Partner.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.address IS 'Address: Address of the partner organization';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.contact_no IS 'Contact Number: Contact number of the partner organization or the contact person';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.email_id IS 'Email ID: Email ID of the MISP organization''s contact person';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.public_key IS 'Public Key: Public key provided by the partner to MOSIP to use its auth request data.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.user_id IS 'Partner Admin: When a partner registers themselves to avail auth services, a user id is created for them to login to partner management portal to perform few operational activities. Currently only one user is created per partner.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.partner.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
