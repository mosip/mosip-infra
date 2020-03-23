-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_pmp
-- Table Name : 
-- Purpose    : All the FKs are created separately, not part of create table scripts to ease the deployment process
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: fk_mispl_misp | type: CONSTRAINT --
-- ALTER TABLE pmp.misp_license DROP CONSTRAINT IF EXISTS fk_mispl_misp CASCADE;
ALTER TABLE pmp.misp_license ADD CONSTRAINT fk_mispl_misp FOREIGN KEY (misp_id)
REFERENCES pmp.misp (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_apol_polg | type: CONSTRAINT --
-- ALTER TABLE pmp.auth_policy DROP CONSTRAINT IF EXISTS fk_apol_polg CASCADE;
ALTER TABLE pmp.auth_policy ADD CONSTRAINT fk_apol_polg FOREIGN KEY (policy_group_id)
REFERENCES pmp.policy_group (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_apolh_polg_cp | type: CONSTRAINT --
-- ALTER TABLE pmp.auth_policy_h DROP CONSTRAINT IF EXISTS fk_apolh_polg_cp CASCADE;
ALTER TABLE pmp.auth_policy_h ADD CONSTRAINT fk_apolh_polg_cp FOREIGN KEY (policy_group_id)
REFERENCES pmp.policy_group (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_papr_part | type: CONSTRAINT --
-- ALTER TABLE pmp.partner_policy_request DROP CONSTRAINT IF EXISTS fk_papr_part CASCADE;
ALTER TABLE pmp.partner_policy_request ADD CONSTRAINT fk_papr_part FOREIGN KEY (part_id)
REFERENCES pmp.partner (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_ppol_part | type: CONSTRAINT --
-- ALTER TABLE pmp.partner_policy DROP CONSTRAINT IF EXISTS fk_ppol_part CASCADE;
ALTER TABLE pmp.partner_policy ADD CONSTRAINT fk_ppol_part FOREIGN KEY (part_id)
REFERENCES pmp.partner (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_ppol_apol | type: CONSTRAINT --
-- ALTER TABLE pmp.partner_policy DROP CONSTRAINT IF EXISTS fk_ppol_apol CASCADE;
ALTER TABLE pmp.partner_policy ADD CONSTRAINT fk_ppol_apol FOREIGN KEY (policy_id)
REFERENCES pmp.auth_policy (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

