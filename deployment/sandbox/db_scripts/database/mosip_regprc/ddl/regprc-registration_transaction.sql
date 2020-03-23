-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.registration_transaction
-- Purpose    	: Registration Transaction: Registration Processor Transaction table is to store ALL  Registration Processor packet processing/process transaction details for ID issuance.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.registration_transaction | type: TABLE --
-- DROP TABLE IF EXISTS regprc.registration_transaction CASCADE;
CREATE TABLE regprc.registration_transaction(
	id character varying(36) NOT NULL,
	reg_id character varying(39) NOT NULL,
	trn_type_code character varying(64) NOT NULL,
	remarks character varying(256),
	parent_regtrn_id character varying(36),
	ref_id character varying(64),
	ref_id_type character varying(64),
	status_code character varying(36) NOT NULL,
	sub_status_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	status_comment character varying(256),
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_regtrn_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE regprc.registration_transaction IS 'Registration Transaction: Registration Processor Transaction table is to store ALL  Registration Processor packet processing/process transaction details for ID issuance';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.id IS 'ID: Transaction id of the transactions that were recorded in registration module/application';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.reg_id IS 'Registration ID: Registration id for which these transactions are carried out at the registration client application.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.trn_type_code IS 'Transaction Type Code: Type of transaction being processed. Refers to reg.transaction_type.code';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.remarks IS 'Transaction Remarks: Current remarks/comments of the transaction';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.parent_regtrn_id IS 'Parent Registration ID: Parent transaction id that has triggered this transaction (if any). Refers to reg.registration_transaction.id';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.ref_id IS 'Reference ID: Reference id for the transaction if any';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.ref_id_type IS 'reference ID Type: reference ID type of the transaction if any';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.status_code IS 'Status Code: Current status of the transaction. Refers to code field of master.status_list table.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.sub_status_code IS 'Sub Status Code: Current sub status of the registration transaction. Refers to code field of master.status_list table.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.status_comment IS 'Status Comment: Comments provided by the actor during the transaction processing.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.registration_transaction.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
