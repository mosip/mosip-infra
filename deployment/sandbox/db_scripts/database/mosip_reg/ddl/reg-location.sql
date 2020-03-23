-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.location
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.location | type: TABLE --
-- DROP TABLE IF EXISTS reg.location CASCADE;
CREATE TABLE reg.location(
	code character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	hierarchy_level smallint NOT NULL,
	hierarchy_level_name character varying(64) NOT NULL,
	parent_loc_code character varying(32),
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




