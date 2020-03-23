-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.sync_control
-- Purpose    	: Sync Control: Kernel provides services to sync data from one application / module to another like masters data sync to registration client application. This table is used to maintain the control related information about the data that was synched. For eg. it stores information like last sync date time which can be used to sync data incrementally. 
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


-- object: kernel.sync_control | type: TABLE --
-- DROP TABLE IF EXISTS kernel.sync_control CASCADE;
CREATE TABLE kernel.sync_control(
	id character varying(36) NOT NULL,
	syncjob_id character varying(36) NOT NULL,
	machine_id character varying(10),
	regcntr_id character varying(10),
	synctrn_id character varying(36) NOT NULL,
	last_sync_dtimes timestamp NOT NULL,
	lang_code character varying(3),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_synctrl_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE kernel.sync_control IS 'Sync Control: Kernel provides services to sync data from one application / module to another like masters data sync to registration client application. This table is used to maintain the control related information about the data that was synched. For eg. it stores information like last sync date time which can be used to sync data incrementally. ';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.id IS 'ID: Unique Id used as a surrogate key.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.syncjob_id IS 'Sync Job ID: Id of the sync job definition for which the sync controls are set / maintained.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.machine_id IS 'Machine ID: Id of the machine for which sync controls are set / maintained.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.regcntr_id IS 'Registration Center ID: Id of the Registration Center for which sync controls are set / maintained.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.synctrn_id IS 'Sync Transaction ID: Successful transaction id of the sync process';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.last_sync_dtimes IS 'Last Sync Date Time: Date and Time when the sync process was successfully completed. This date and time will be used to perform data sync incrementally.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_control.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
