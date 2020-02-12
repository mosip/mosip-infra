-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.abis_response_det
-- Purpose    	: ABIS Response Detail: Stores details of all the ABIS responses received from ABIS system. Response details will mainly have scores, which is applicable only for identify request type.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.abis_response_det | type: TABLE --
-- DROP TABLE IF EXISTS regprc.abis_response_det CASCADE;
CREATE TABLE regprc.abis_response_det(
	abis_resp_id character varying(36) NOT NULL,
	matched_bio_ref_id character varying(36) NOT NULL,
	score numeric(6,3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_abisrdt PRIMARY KEY (matched_bio_ref_id,abis_resp_id)

);
-- ddl-end --
COMMENT ON TABLE regprc.abis_response_det IS 'ABIS Response Detail: Stores details of all the ABIS responses received from ABIS system. Response details will mainly have scores, which is applicable only for identify request type.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.abis_resp_id IS 'ABIS Response ID: Response id of the ABIS transaction for which ABIS response details are received. This response id refers to regprc.abis_response.id';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.matched_bio_ref_id IS 'Matched BIO Reference ID: Bio Reference IDs that are potential matches with the host reference id as rececived by an ABIS application.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.score IS 'Score : Mached score of biometric deduplication which is received from ABIS applications';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_response_det.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

