-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.sync_job_def
-- Purpose    	: Sync Job Definition: Stores Sync jobs definition that MOSIP supports. This jobs are used to sync data from one application / module to another based on the sync frequency and other setup.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: kernel.sync_job_def | type: TABLE --
-- DROP TABLE IF EXISTS kernel.sync_job_def CASCADE;
CREATE TABLE kernel.sync_job_def(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	api_name character varying(64),
	parent_syncjob_id character varying(36),
	sync_freq character varying(36),
	lock_duration character varying(36),
	lang_code character varying(3),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_syncjob_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE kernel.sync_job_def IS 'Sync Job Definition: Stores Sync jobs definition that MOSIP supports. This jobs are used to sync data from one application / module to another based on the sync frequency and other setup.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.id IS 'ID: Sync job id, a unique id generated for sync jobs configured.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.name IS 'Name: Name of the sync job being defined';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.api_name IS 'API Name: Name of the API used for sync process.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.parent_syncjob_id IS 'Parent Sync Job ID: Parent sync job id can be used to link one job to another based on the job dependencies.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.sync_freq IS 'Sync Frequency: Frequency of the sync process for this job is defined in this field. It can be Daily, Monthly, hourly, etc. as defined by administrator.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.lock_duration IS 'Lock Duration: Duration within which sync process has to be executed. If not done, the application can be locked.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.sync_job_def.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
