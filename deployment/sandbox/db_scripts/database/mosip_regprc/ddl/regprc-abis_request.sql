-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.abis_request
-- Purpose    	: ABIS Request: Stores all the requests that were sent to ABIS systems.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.abis_request | type: TABLE --
-- DROP TABLE IF EXISTS regprc.abis_request CASCADE;
CREATE TABLE regprc.abis_request(
	id character varying(36) NOT NULL,
	req_batch_id character varying(36) NOT NULL,
	abis_app_code character varying(36) NOT NULL,
	request_type character varying(64) NOT NULL,
	request_dtimes timestamp NOT NULL,
	bio_ref_id character varying(36),
	ref_regtrn_id character varying(36),
	req_text bytea,
	status_code character varying(36) NOT NULL,
	status_comment character varying(256),
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_abisreq PRIMARY KEY (id),
	CONSTRAINT uk_abisreq_ref UNIQUE (req_batch_id,abis_app_code)

);
-- ddl-end --
COMMENT ON TABLE regprc.abis_request IS 'ABIS Request: Stores all the requests that were sent to ABIS systems';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.id IS 'Request ID: System generated id, used to track all the ABIS request sent to ABIS applications.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.req_batch_id IS 'Request Batch ID: ABIS Request Batch ID to track all the requests that was sent to different ABIS systems. This will also be used to track the responses received for the ABIS systems to manage futher flows.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.abis_app_code IS 'ABIS Application Code: Code of the ABIS application to which the transaction request is being done.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.request_type IS 'Request Type: Type of request that was sent to ABIS application. Eg. INSERT, IDENTIFY, etc.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.request_dtimes IS 'Request Data Time: Date and time when the ABIS request was created.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.bio_ref_id IS 'Biometric Reference ID: Biometric Reference ID of the host registration id for which requests are being sent to ABIS application.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.ref_regtrn_id IS 'Reference Transaction ID: ID of the reference registration transaction for which the ABIS transaction request is being initiated.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.req_text IS 'Requesst Text: Information that was passed to the ABIS system as part of this request.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.status_code IS 'Status Code:  Current Status code of the ABIS request transaction. Refers to master.status_list.code';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.status_comment IS 'Status Comment: Comments captured as part of packet processing (if any). This can be used in case someone wants to abort the transaction, comments can be provided as additional information.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.lang_code IS 'Language Code: Code of the language used while creating this ABIS transaction.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.abis_request.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
