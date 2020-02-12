-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.sync_transaction
-- Purpose    	: Sync Transaction: Sync instance table to track all the sync process that were executed.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: kernel.sync_transaction | type: TABLE --
-- DROP TABLE IF EXISTS kernel.sync_transaction CASCADE;
CREATE TABLE kernel.sync_transaction(
	id character varying(36) NOT NULL,
	syncjob_id character varying(36) NOT NULL,
	sync_dtimes timestamp NOT NULL,
	status_code character varying(36) NOT NULL,
	status_comment character varying(256),
	trigger_point character varying(32),
	sync_from character varying(32),
	sync_to character varying(32),
	machine_id character varying(10),
	regcntr_id character varying(10),
	ref_id_type character varying(64),
	ref_id character varying(64),
	sync_param character varying(2048),
	lang_code character varying(3),
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_synctrn_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE kernel.sync_transaction IS 'Sync Transaction: Sync instance table to track all the sync process that were executed. ';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.id IS 'ID: Unique id generated for each sync transaction.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.syncjob_id IS 'Sync Job ID: Id of the sync job definition for which the sync transaction is executed. Sync Job id refers to kernel.sync_job_def.id';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.sync_dtimes IS 'Sync transaction Date Time: Date and time when this sync transaction happened.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.status_code IS 'Status Code: Status of the sync transaction.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.status_comment IS 'Status Comment: Comments captured as part of sync transaction (if any). This can be used in case someone wants to abort the transaction, comments can be provided as additional information.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.trigger_point IS 'Trigger Point: Module / stage from where this sync transaction is triggered.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.sync_from IS 'Sync From: Host application of the sync process';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.sync_to IS 'Sync To: Target application of the sync process';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.machine_id IS 'Machine ID: Id of the machine which is used in this sync process. Machine_id refers to master.machine_list.id';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.regcntr_id IS 'Registration Center ID: Id of the Registration Center which is part of the sync process. Regcntr_id refers to master.registration_center.id';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.ref_id_type IS 'Reference Id Type: Type of information in Reference ID field, used to reference the sync process by the host / target application.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.ref_id IS 'Reference Id: Reference ID is the reference information received by the sync process triggered application / module for tracking purpose.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.sync_param IS 'Sync Parameters: Parameters that are used to trigger the Sync process. This might contain from date, to date which can be used to get the incremental data. It can hold other parameters too.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_transaction.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
