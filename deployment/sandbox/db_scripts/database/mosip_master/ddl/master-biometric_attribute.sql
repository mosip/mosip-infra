-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.biometric_attribute
-- Purpose    	: Biometric Attribute : List of all biometric attributes to be captured for each biometric type during UIN registration.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------------------------

-- object: master.biometric_attribute | type: TABLE --
-- DROP TABLE IF EXISTS master.biometric_attribute CASCADE;
CREATE TABLE master.biometric_attribute(
	code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(128),
	bmtyp_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_bmattr_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.biometric_attribute IS 'Biometric Attribute : List of all biometric attributes to be captured for each biometric type during UIN registration';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.code IS 'Code : Biometic attribute names,  Right Thumb, Left Thumb, Right Eye, Left Eye, etc.';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.name IS 'Name : Biometric attribute name';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.descr IS 'Description : Description of Biometic attribute names,  Right Thumb, Left Thumb, Right Eye, Left Eye, etc.';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.bmtyp_code IS 'Bio-metric Type code : types of biometrics for ex.,  Finger prints, facial, Iris etc.  Refers master.biometric_type.code';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.biometric_attribute.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

