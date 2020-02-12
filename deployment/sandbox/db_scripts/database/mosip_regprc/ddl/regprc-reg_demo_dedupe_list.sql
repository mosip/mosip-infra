-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.reg_demo_dedupe_list
-- Purpose    	: Registration Demographic Deduplication List: List of matched UIN / RIDs, as part of demographic data.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.reg_demo_dedupe_list | type: TABLE --
-- DROP TABLE IF EXISTS regprc.reg_demo_dedupe_list CASCADE;
CREATE TABLE regprc.reg_demo_dedupe_list(
	regtrn_id character varying(36) NOT NULL,
	matched_reg_id character varying(39) NOT NULL,
	reg_id character varying(39) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_regded PRIMARY KEY (matched_reg_id,regtrn_id)

);
-- ddl-end --
COMMENT ON TABLE regprc.reg_demo_dedupe_list IS 'Registration Demographic Deduplication List: List of matched UIN / RIDs, as part of demographic data.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.regtrn_id IS 'Registration Transaction ID: ID of the demo dedupe transaction, Refers to regprc.registration_transaction.id';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.matched_reg_id IS 'Matched Registration ID: Registration ID of the individual matching with the host registration id. It can be RID or any other id related to an individual.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.reg_id IS 'Registration ID: Registration ID for which the matches are found as part of the demographic dedupe process.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_demo_dedupe_list.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
