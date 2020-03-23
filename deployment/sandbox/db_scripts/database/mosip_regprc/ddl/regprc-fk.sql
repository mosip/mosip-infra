-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: All tables at mosip_regprc Database
-- Purpose    	: To establish FOREIGN Constrations required for entity relationship
--       
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- Foreign Key Constraints Same DB/Schema tables.
-- FOREIGN KEY CONSTRAINTS : mosip_regprc database/schema.

-- object: fk_regtrn_reg | type: CONSTRAINT --
-- ALTER TABLE regprc.registration_transaction DROP CONSTRAINT IF EXISTS fk_regtrn_reg CASCADE;
ALTER TABLE regprc.registration_transaction ADD CONSTRAINT fk_regtrn_reg FOREIGN KEY (reg_id)
REFERENCES regprc.registration (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regtrn_trntyp | type: CONSTRAINT --
-- ALTER TABLE regprc.registration_transaction DROP CONSTRAINT IF EXISTS fk_regtrn_trntyp CASCADE;
ALTER TABLE regprc.registration_transaction ADD CONSTRAINT fk_regtrn_trntyp FOREIGN KEY (trn_type_code,lang_code)
REFERENCES regprc.transaction_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_idemogd_reg | type: CONSTRAINT --
-- ALTER TABLE regprc.individual_demographic_dedup DROP CONSTRAINT IF EXISTS fk_idemogd_reg CASCADE;
ALTER TABLE regprc.individual_demographic_dedup ADD CONSTRAINT fk_idemogd_reg FOREIGN KEY (reg_id)
REFERENCES regprc.registration (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_rmnlver_reg | type: CONSTRAINT --
-- ALTER TABLE regprc.reg_manual_verification DROP CONSTRAINT IF EXISTS fk_rmnlver_reg CASCADE;
ALTER TABLE regprc.reg_manual_verification ADD CONSTRAINT fk_rmnlver_reg FOREIGN KEY (reg_id)
REFERENCES regprc.registration (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_rmnlver_trntyp | type: CONSTRAINT --
-- ALTER TABLE regprc.reg_manual_verification DROP CONSTRAINT IF EXISTS fk_rmnlver_trntyp CASCADE;
ALTER TABLE regprc.reg_manual_verification ADD CONSTRAINT fk_rmnlver_trntyp FOREIGN KEY (trntyp_code,lang_code)
REFERENCES regprc.transaction_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_regded_regtrn | type: CONSTRAINT --
-- ALTER TABLE regprc.reg_demo_dedupe_list DROP CONSTRAINT IF EXISTS fk_regded_regtrn CASCADE;
ALTER TABLE regprc.reg_demo_dedupe_list ADD CONSTRAINT fk_regded_regtrn FOREIGN KEY (regtrn_id)
REFERENCES regprc.registration_transaction (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_regref_reg | type: CONSTRAINT --
-- ALTER TABLE regprc.reg_bio_ref DROP CONSTRAINT IF EXISTS fk_regref_reg CASCADE;
ALTER TABLE regprc.reg_bio_ref ADD CONSTRAINT fk_regbrf_reg FOREIGN KEY (reg_id)
REFERENCES regprc.registration (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_abisresp_abisreq | type: CONSTRAINT --
-- ALTER TABLE regprc.abis_response DROP CONSTRAINT IF EXISTS fk_abisresp_abisreq CASCADE;
ALTER TABLE regprc.abis_response ADD CONSTRAINT fk_abisresp_abisreq FOREIGN KEY (abis_req_id)
REFERENCES regprc.abis_request (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_abisresp_resp_id | type: CONSTRAINT --
-- ALTER TABLE regprc.abis_response_det DROP CONSTRAINT IF EXISTS fk_abisresp_resp_id CASCADE;
ALTER TABLE regprc.abis_response_det ADD CONSTRAINT fk_abisresp_resp_id FOREIGN KEY (abis_resp_id)
REFERENCES regprc.abis_response (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_rlostd_reg | type: CONSTRAINT --
-- ALTER TABLE regprc.reg_lost_uin_det DROP CONSTRAINT IF EXISTS fk_rlostd_reg CASCADE;
ALTER TABLE regprc.reg_lost_uin_det ADD CONSTRAINT fk_rlostd_reg FOREIGN KEY (reg_id)
REFERENCES regprc.registration (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

