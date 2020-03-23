
-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.applicant_demographic_consumed
-- Purpose    	: Applicant Demographic Consumed: Stores demographic details of an applicant that was comsumed.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.applicant_demographic_consumed | type: TABLE --
-- DROP TABLE IF EXISTS prereg.applicant_demographic_consumed CASCADE;
CREATE TABLE prereg.applicant_demographic_consumed(
	prereg_id character varying(36) NOT NULL,
	demog_detail bytea NOT NULL,
	demog_detail_hash character varying(64) NOT NULL,
	encrypted_dtimes timestamp NOT NULL,
	status_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_appuser_id character varying(256) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_appldemc_prereg_id PRIMARY KEY (prereg_id)

);
-- ddl-end --
COMMENT ON TABLE prereg.applicant_demographic_consumed IS 'Applicant Demographic Consumed: Stores demographic details of an applicant that was comsumed.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.prereg_id IS 'Pre Registration ID: Unique Id generated for an individual during the pre-registration process which will be referenced during registration process at a registration center.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.demog_detail IS 'Demographic Detail: Demographic details of an individual, stored in json format.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.demog_detail_hash IS 'Demographic Detail Hash: Hash value of the demographic details stored in json format in a separate column. This will be used to make sure that nobody has tampered the data.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.encrypted_dtimes IS 'Encrypted Data Time: Date and time when the data was encrypted. This will also be used  get the key for decrypting the data.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.status_code IS 'Status Code: Status of the pre-registration application. The application can be in draft / pending state or submitted state';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.cr_appuser_id IS 'Applciation Created User Id: User ID of the individual who is submitting the pre-registration application. It can be for self or for others like family members.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_demographic_consumed.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --

