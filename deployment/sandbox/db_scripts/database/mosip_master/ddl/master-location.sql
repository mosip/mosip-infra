-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.location
-- Purpose    	: Location :  List of all location and  hierarchies defined for various location requirements.  An example is provided for understanding the data to be populated.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.location | type: TABLE --
-- DROP TABLE IF EXISTS master.location CASCADE;
CREATE TABLE master.location(
	code character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	hierarchy_level smallint NOT NULL,
	hierarchy_level_name character varying(64) NOT NULL,
	parent_loc_code character varying(36),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_loc_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.location IS 'Location :  List of all location and  hierarchies defined for various location requirements.  An example is provided for understanding the data to be populated.';
-- ddl-end --
COMMENT ON COLUMN master.location.code IS 'Code : Unique location code. ';
-- ddl-end --
COMMENT ON COLUMN master.location.name IS 'Name : Location';
-- ddl-end --
COMMENT ON COLUMN master.location.hierarchy_level IS 'Hierarchy Level: Number of hierarchy levels defined by each country. Typically it starts with 0 for the topmost hierarchy level.';
-- ddl-end --
COMMENT ON COLUMN master.location.hierarchy_level_name IS 'Hierarchy Level Name: Hierarchy level name defined by each country. for ex., COUNTRY->STATE->CITY->PINCODE.';
-- ddl-end --
COMMENT ON COLUMN master.location.parent_loc_code IS 'Parent Location Code: Location code to refers to location code as per hierarchy defined by each country';
-- ddl-end --
COMMENT ON COLUMN master.location.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.location.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.location.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.location.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.location.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.location.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.location.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.location.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

--------------------------------------------------------------------------------------------	
	--  Below is sample data for understanding the hierarchy_level and data to be populated.
	--  code(unique,pkey)	name  			level	levelname	parent code 	

	--  IND				INDIA			0		COUNTRY		NULL	

	-- 	KAR				KARNATAKA		1		STATE		IND	
	--  TN				TAMILNADU		1		STATE		IND
	--  KL				KERALA			1		STATE		IND

	-- 	BLR				BANGALURU		2		CITY		KAR	
	-- 	MLR	 			MANGALORE		2		CITY		KAR	
	-- 	MSR				MYSURU			2		CITY		KAR	
	-- 	KLR				KOLAR			2		CITY		KAR

	-- 	CHNN			CHENNAI 		2		CITY		TN
	-- 	CBE				COIMBATORE		2		CITY		TN			

	--  RRN				RRNAGAR			3		AREA		BLR
	--  560029			560029			4		ZIPCODE		RRN	
	-- 								(  for pin/zip, both code and name can be same)
			
	--  600001			600001			3		ZIPCODE		CHN		
--------------------------------------------------------------------------------------------

