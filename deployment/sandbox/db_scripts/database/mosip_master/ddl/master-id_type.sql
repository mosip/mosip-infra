-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.id_type
-- Purpose    	: Id Type :  List of ID types of various IDs generated , used or refered, for ex., PRID, RID, VID, etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.id_type | type: TABLE --
-- DROP TABLE IF EXISTS master.id_type CASCADE;
CREATE TABLE master.id_type(
	code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(128),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_idtyp_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.id_type IS 'Id Type :  List of ID types of various IDs generated , used or refered, for ex., PRID, RID, VID, etc';
-- ddl-end --
COMMENT ON COLUMN master.id_type.code IS 'Code : Types of various IDs used or refered or generated for ex., PRID, RID, VID, etc';
-- ddl-end --
COMMENT ON COLUMN master.id_type.name IS 'Name : Id type name';
-- ddl-end --
COMMENT ON COLUMN master.id_type.descr IS 'Description : ID Type description';
-- ddl-end --
COMMENT ON COLUMN master.id_type.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.id_type.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.id_type.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.id_type.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.id_type.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.id_type.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.id_type.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.id_type.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

