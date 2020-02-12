-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.status_list
-- Purpose    	: Status List : List of statuses used within each status types are configured in this table.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.status_list | type: TABLE --
-- DROP TABLE IF EXISTS master.status_list CASCADE;
CREATE TABLE master.status_list(
	code character varying(36) NOT NULL,
	descr character varying(256) NOT NULL,
	status_seq smallint,
	sttyp_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_status_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.status_list IS 'Status List : List of statuses used within each status types are configured in this table.';
-- ddl-end --
COMMENT ON COLUMN master.status_list.code IS 'Code : Status codes like STARTED, INPROGRESS, COMPLETED, FAILED etc for each status type with sequence number, with lang_cd for multi language';
-- ddl-end --
COMMENT ON COLUMN master.status_list.descr IS 'Description : Status description';
-- ddl-end --
COMMENT ON COLUMN master.status_list.status_seq IS 'Status Sequence: Sequence in which status list to be displayed';
-- ddl-end --
COMMENT ON COLUMN master.status_list.sttyp_code IS 'Status Type Code: Status Type Code refers to master.status_type.code';
-- ddl-end --
COMMENT ON COLUMN master.status_list.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.status_list.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.status_list.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.status_list.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.status_list.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.status_list.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.status_list.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.status_list.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

