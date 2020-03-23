-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.message_list
-- Purpose    	: Message List : List of message texts that will be displayed or sent as alerts / notifications.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.message_list | type: TABLE --
-- DROP TABLE IF EXISTS master.message_list CASCADE;
CREATE TABLE master.message_list(
	code character varying(36) NOT NULL,
	message character varying(256) NOT NULL,
	descr character varying(256),
	msg_type character varying(64),
	msg_grp character varying(64),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_msglst_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.message_list IS 'Message List : List of message texts that will be displayed or sent as alerts / notifications.';
-- ddl-end --
COMMENT ON COLUMN master.message_list.code IS 'Code : unique code for various standard messages used for display , alerts, etc.';
-- ddl-end --
COMMENT ON COLUMN master.message_list.message IS 'Message: Message text that will be displayed or sent as alerts / notifications.';
-- ddl-end --
COMMENT ON COLUMN master.message_list.descr IS 'Description : Message description';
-- ddl-end --
COMMENT ON COLUMN master.message_list.msg_type IS 'Message Type : Message classification type for ex., ERROR, FAILURE, EXCEPTION etc';
-- ddl-end --
COMMENT ON COLUMN master.message_list.msg_grp IS 'Message group : Messages groups based on funcationality/processes , for ex., OTP, ISSUANCE, VALIDATION , SYSTEM, etc';
-- ddl-end --
COMMENT ON COLUMN master.message_list.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.message_list.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.message_list.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.message_list.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.message_list.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.message_list.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.message_list.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.message_list.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
