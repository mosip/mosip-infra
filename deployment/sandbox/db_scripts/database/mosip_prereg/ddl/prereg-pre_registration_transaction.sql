-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.pre_registration_transaction
-- Purpose    	: Pre-Registration Transaction: Stores various transactions that are processd within pre-registration module/application.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.pre_registration_transaction | type: TABLE --
-- DROP TABLE IF EXISTS prereg.pre_registration_transaction CASCADE;
CREATE TABLE prereg.pre_registration_transaction(
	id character varying(36) NOT NULL,
	trn_type_code character varying(36) NOT NULL,
	parent_prereg_trn_id character varying(36),
	status_code character varying(36) NOT NULL,
	status_comments character varying(1024),
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT preg_trn_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE prereg.pre_registration_transaction IS 'Pre-Registration Transaction: Stores various transactions that are processd within pre-registration module/application.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.id IS 'Transaction id of the transactions that were recorded in pre-registration module/application';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.trn_type_code IS 'Transaction type code: Type of transaction being processed.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.parent_prereg_trn_id IS 'Parent Pre-Registration Transaction Id: Parent transaction id that has triggered this transaction (if any)';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.status_code IS 'Status Code: Current status of the transaction. Refers to code field of master.status_list table.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.status_comments IS 'Status Comments: Comments provided by the actor during the transaction processing.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN prereg.pre_registration_transaction.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
