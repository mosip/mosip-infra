-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.foundational_trust_provider
-- Purpose    	: Foundational Trust Provider : To store all foundational trust provider, This provider will issue certificates to the chip/device manufacturer to certify devices.
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 25-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.foundational_trust_provider | type: TABLE --
-- DROP TABLE IF EXISTS reg.foundational_trust_provider CASCADE;
CREATE TABLE reg.foundational_trust_provider(
	id character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	address character varying(512),
	email character varying(512),
	contact_number character varying(16),
	certificate_alias character varying(36),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_ftprd_id PRIMARY KEY (id)

);