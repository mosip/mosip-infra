-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.zone
-- Purpose    	: Zone :  List of all zones and hierarchies defined for various zone requirements.  An example is provided for understanding the data to be populated.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.zone | type: TABLE --
-- DROP TABLE IF EXISTS master.zone CASCADE;
CREATE TABLE master.zone(
	code character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	hierarchy_level smallint NOT NULL,
	hierarchy_level_name character varying(64) NOT NULL,
	hierarchy_path character varying(1024),
	parent_zone_code character varying(36),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_zone_code PRIMARY KEY (code,lang_code),
	CONSTRAINT uk_hierpath UNIQUE (hierarchy_path,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.zone IS 'Zone :  List of all zones and hierarchies defined for various zone requirements.  An example is provided for understanding the data to be populated.';
-- ddl-end --
COMMENT ON COLUMN master.zone.code IS 'Code : Unique zone code generated or entered by admin while creating zones. ';
-- ddl-end --
COMMENT ON COLUMN master.zone.name IS 'Name : Name of the zone';
-- ddl-end --
COMMENT ON COLUMN master.zone.hierarchy_level IS 'Hierarchy Level: Number of hierarchy levels defined by each zone in the country. Typically it starts with 0 for the topmost hierarchy level.';
-- ddl-end --
COMMENT ON COLUMN master.zone.hierarchy_level_name IS 'Hierarchy Level Name: Hierarchy level name defined by each country. for ex., ROOT ZONE->ZONELEVEL1->ZONELEVEL2-LEAFZONE.';
-- ddl-end --
COMMENT ON COLUMN master.zone.hierarchy_path IS 'Hierarchy Path : Path of the zone hierarchy. Hierarchy Path will have zone code of all the level from root to leaf and these codes will be saparated by saparators like / or ,....etc.';
-- ddl-end --
COMMENT ON COLUMN master.zone.parent_zone_code IS 'Parent Zone Code: Parent zone code to refers to zone code as per hierarchy defined by each country';
-- ddl-end --
COMMENT ON COLUMN master.zone.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.zone.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.zone.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.zone.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.zone.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.zone.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.zone.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.zone.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

