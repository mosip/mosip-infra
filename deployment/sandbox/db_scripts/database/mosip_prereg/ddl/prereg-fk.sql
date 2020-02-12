-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: All tables at mosip_prereg Database
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

-- FOREIGN KEY CONSTRAINTS : mosip_prereg database/schema.

-- object: fk_appldoc_appldem | type: CONSTRAINT --
-- ALTER TABLE prereg.applicant_document DROP CONSTRAINT IF EXISTS fk_appldoc_appldem CASCADE;
ALTER TABLE prereg.applicant_document ADD CONSTRAINT fk_appldoc_appldem FOREIGN KEY (prereg_id)
REFERENCES prereg.applicant_demographic (prereg_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_appldocc_appldem | type: CONSTRAINT --
-- ALTER TABLE prereg.applicant_document_consumed DROP CONSTRAINT IF EXISTS fk_appldocc_appldem CASCADE;
ALTER TABLE prereg.applicant_document_consumed ADD CONSTRAINT fk_appldocc_appldem FOREIGN KEY (prereg_id)
REFERENCES prereg.applicant_demographic_consumed (prereg_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_rappmnt_id | type: CONSTRAINT --
-- ALTER TABLE prereg.reg_appointment DROP CONSTRAINT IF EXISTS fk_rappmnt_id CASCADE;
ALTER TABLE prereg.reg_appointment ADD CONSTRAINT fk_rappmnt_id FOREIGN KEY (prereg_id)
REFERENCES prereg.applicant_demographic (prereg_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_rappmntc_id | type: CONSTRAINT --
-- ALTER TABLE prereg.reg_appointment_consumed DROP CONSTRAINT IF EXISTS fk_rappmntc_id CASCADE;
ALTER TABLE prereg.reg_appointment_consumed ADD CONSTRAINT fk_rappmntc_id FOREIGN KEY (prereg_id)
REFERENCES prereg.applicant_demographic_consumed (prereg_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: pprlst_pregtrn_fk | type: CONSTRAINT --
-- ALTER TABLE prereg.processed_prereg_list DROP CONSTRAINT IF EXISTS pprlst_pregtrn_fk CASCADE;
ALTER TABLE prereg.processed_prereg_list ADD CONSTRAINT pprlst_pregtrn_fk FOREIGN KEY (prereg_trn_id)
REFERENCES prereg.pre_registration_transaction (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --