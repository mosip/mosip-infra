-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.registration_center
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: reg.registration_center | type: TABLE --
-- DROP TABLE IF EXISTS reg.registration_center CASCADE;
CREATE TABLE reg.registration_center(
	id character varying(10) NOT NULL,
	name character varying(128) NOT NULL,
	cntrtyp_code character varying(36),
	addr_line1 character varying(256),
	addr_line2 character varying(256),
	addr_line3 character varying(256),
	latitude character varying(32),
	longitude character varying(32),
	location_code character varying(36) NOT NULL,
	contact_phone character varying(16),
	contact_person character varying(128),
	number_of_kiosks smallint,
	working_hours character varying(32),
	per_kiosk_process_time time,
	center_start_time time,
	center_end_time time,
	lunch_start_time time,
	lunch_end_time time,
	time_zone character varying(64),
	holiday_loc_code character varying(36),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_regcntr_code PRIMARY KEY (id,lang_code)

);
-- ddl-end --
