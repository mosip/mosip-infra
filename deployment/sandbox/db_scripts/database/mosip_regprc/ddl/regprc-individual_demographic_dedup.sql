-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.individual_demographic_dedup
-- Purpose    	: Individual Demographic Dedupe: Table stores applicant demographic details for deduplication, Only required information for dedupe is stored.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 11-Nov-2019           Sadanandegowda DM   Added columns for lost UIN requirements
-- ------------------------------------------------------------------------------------------

-- object: regprc.individual_demographic_dedup | type: TABLE --
-- DROP TABLE IF EXISTS regprc.individual_demographic_dedup CASCADE;
CREATE TABLE regprc.individual_demographic_dedup(
	reg_id character varying(39) NOT NULL,
	name character varying(128),
	dob character varying(64),
	gender character varying(64),
	mobile_number character varying(64),
	email character varying(512),
	pincode character varying(64),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_idemogd_id PRIMARY KEY (reg_id,lang_code)

);

-- indexes section -------------------------------------------------
create index idx_idemogd_namedob on regprc.individual_demographic_dedup (name, dob);

-- ddl-end --
COMMENT ON TABLE regprc.individual_demographic_dedup IS 'Individual Demographic Dedupe: Table stores applicant demographic details for deduplication, Only required information for dedupe is stored. ';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.reg_id IS 'Registration id of applicant';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.name IS 'Name: Name of an individual, This is combination of fname, mname and lname or full name';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.dob IS 'Date of Birth: DOB of an individual';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.gender IS 'Gender: Gender of an individual';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.mobile_number IS 'Mobile Number :  Contact number of the individulas, Number which is used for registration and any OTP communication';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.email IS 'Email Address :  Email address of the individulas, Address which is used for registration and any communication.';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.pincode IS 'PINCODE : Address pincode of the individuals';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.individual_demographic_dedup.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
