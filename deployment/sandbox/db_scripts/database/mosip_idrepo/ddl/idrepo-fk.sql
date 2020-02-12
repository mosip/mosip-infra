-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_idmap
-- Table Name : IDMAP Table relations
-- Purpose    : All the FKs are created separately, not part of create table scripts to ease the deployment process
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: fk_uind_uin | type: CONSTRAINT --
-- ALTER TABLE idrepo.uin_document DROP CONSTRAINT IF EXISTS fk_uind_uin CASCADE;
ALTER TABLE idrepo.uin_document ADD CONSTRAINT fk_uind_uin FOREIGN KEY (uin_ref_id)
REFERENCES idrepo.uin (uin_ref_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



-- object: fk_uinb_uin | type: CONSTRAINT --
-- ALTER TABLE idrepo.uin_biometric DROP CONSTRAINT IF EXISTS fk_uinb_uin CASCADE;
ALTER TABLE idrepo.uin_biometric ADD CONSTRAINT fk_uinb_uin FOREIGN KEY (uin_ref_id)
REFERENCES idrepo.uin (uin_ref_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
