-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.language
-- Purpose    	: Language : List of Languages supported by system.  These language code are defined as per ISO 639 standard.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.language | type: TABLE --
-- DROP TABLE IF EXISTS master.language CASCADE;
CREATE TABLE master.language(
	code character varying(3) NOT NULL,
	name character varying(64) NOT NULL,
	family character varying(64),
	native_name character varying(64),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_lang_code PRIMARY KEY (code)

);
-- ddl-end --
COMMENT ON TABLE master.language IS 'Language : List of Languages supported by system.  These language code are defined as per ISO 639 standard.';
-- ddl-end --
COMMENT ON COLUMN master.language.code IS 'Code : Unique ISO 639-3 language code as per global standard.';
-- ddl-end --
COMMENT ON COLUMN master.language.name IS 'Name : Language';
-- ddl-end --
COMMENT ON COLUMN master.language.family IS 'Family: Language family for ex., INDO-EUROPEAN';
-- ddl-end --
COMMENT ON COLUMN master.language.native_name IS 'Native Name: Native name of the language';
-- ddl-end --
COMMENT ON COLUMN master.language.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.language.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.language.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.language.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.language.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.language.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.language.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
