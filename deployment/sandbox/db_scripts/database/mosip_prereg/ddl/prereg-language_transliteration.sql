
-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.language_transliteration
-- Purpose    	: Language Transliteration: Mapping table to store mapping between the language id, (defined by the utility) to support transliteration from one language to another.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.language_transliteration | type: TABLE --
-- DROP TABLE IF EXISTS prereg.language_transliteration CASCADE;
CREATE TABLE prereg.language_transliteration(
	lang_from_code character varying(3) NOT NULL,
	lang_to_code character varying(3) NOT NULL,
	lang_id character varying(30) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_ltrnln PRIMARY KEY (lang_from_code,lang_to_code)

);
-- ddl-end --
COMMENT ON TABLE prereg.language_transliteration IS 'Language Transliteration: Mapping table to store mapping between the language id, (defined by the utility) to support transliteration from one language to another. ';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.lang_from_code IS 'Language From Code: Host language code from which the transliteration to be done ';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.lang_to_code IS 'Language To Code: Target language code to which the transliteration to be done ';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.lang_id IS 'Language Id: Unique language id which is used to transliterate from one language to other. This id should be part of the language ids supported by the transliterate utility.';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.language_transliteration.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --

