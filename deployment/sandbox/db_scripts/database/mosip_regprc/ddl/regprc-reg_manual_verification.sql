-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.reg_manual_verification
-- Purpose    	: Manual Verification: Stores all the registration request which goes through manual verification process, registration can be assinged to single/multiple manual verifier as part of the verification process.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.reg_manual_verification | type: TABLE --
-- DROP TABLE IF EXISTS regprc.reg_manual_verification CASCADE;
CREATE TABLE regprc.reg_manual_verification(
	reg_id character varying(39) NOT NULL,
	matched_ref_id character varying(39) NOT NULL,
	matched_ref_type character varying(36) NOT NULL,
	mv_usr_id character varying(256),
	matched_score numeric(6,3),
	status_code character varying(36),
	reason_code character varying(36),
	status_comment character varying(256),
	trntyp_code character varying(36),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rmnlver_id PRIMARY KEY (reg_id,matched_ref_id,matched_ref_type)

);
-- ddl-end --
COMMENT ON TABLE regprc.reg_manual_verification IS 'Manual Verification: Stores all the registration request which goes through manual verification process, registration can be assinged to single/multiple manual verifier as part of the verification process';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.reg_id IS 'Registration ID: ID of the registration request';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.matched_ref_id IS 'Mached Reference ID: Reference ID of the mached registrations, This id can be RID';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.matched_ref_type IS 'Mached reference ID Type: Type of the Reference ID';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.mv_usr_id IS 'Manual Verifier ID: User ID of the manual verifier';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.matched_score IS 'Mached Score: Mached score as part deduplication process, This will be the combined score of multiple ABISapplications';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.status_code IS 'Status Code : Status of the manual verification';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.reason_code IS 'Reason Code : Reason code provided by the manual verifier on reason for approve or reject the registration request as part of the verification process';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.status_comment IS 'Status Comment: Comments captured as part of manual verification process';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.trntyp_code IS 'Transaction Type Code : Code of the transaction type';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_manual_verification.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

