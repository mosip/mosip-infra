-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : pmp.misp
-- Purpose    : MISP: MISP, acronym for MOSIP Identity Service Provider, stores the master list of MISPs.
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: pmp.misp | type: TABLE --
-- DROP TABLE IF EXISTS pmp.misp CASCADE;
CREATE TABLE pmp.misp(
	id character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	address character varying(2000),
	contact_no character varying(16),
	email_id character varying(256),
	user_id character varying(256) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_misp PRIMARY KEY (id),
	CONSTRAINT uk_misp UNIQUE (name)

);
-- ddl-end --
COMMENT ON TABLE pmp.misp IS 'MISP: MISP, acronym for MOSIP Identity Service Provider, stores the master list of MISPs.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.id IS 'MISP ID: Unique ID generated / assigned for a MISP.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.name IS 'Name: Name of the MISP orgranization.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.address IS 'Address: Address of the MISP organization.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.contact_no IS 'Contact Number: Contact number of the MISP organization';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.email_id IS 'Email ID: Email ID of the MISP organization / contact person';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.user_id IS 'User ID: Login ID assigned by MOSIP to MISP Admin. It is a general/common id for a MISP that is generated and assigned when the MISP is created.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.is_active IS 'Active Flag: Flag to mark whether the record is Active or In-active
';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN pmp.misp.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
