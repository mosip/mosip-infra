-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
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

-- object: fk_synctrl_syncjob | type: CONSTRAINT --
-- ALTER TABLE kernel.sync_control DROP CONSTRAINT IF EXISTS fk_synctrl_syncjob CASCADE;
ALTER TABLE kernel.sync_control ADD CONSTRAINT fk_synctrl_syncjob FOREIGN KEY (syncjob_id)
REFERENCES kernel.sync_job_def (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_synctrl_synctrn | type: CONSTRAINT --
-- ALTER TABLE kernel.sync_control DROP CONSTRAINT IF EXISTS fk_synctrl_synctrn CASCADE;
ALTER TABLE kernel.sync_control ADD CONSTRAINT fk_synctrl_synctrn FOREIGN KEY (synctrn_id)
REFERENCES kernel.sync_transaction (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_synctrn_syncjob | type: CONSTRAINT --
-- ALTER TABLE kernel.sync_transaction DROP CONSTRAINT IF EXISTS fk_synctrn_syncjob CASCADE;
ALTER TABLE kernel.sync_transaction ADD CONSTRAINT fk_synctrn_syncjob FOREIGN KEY (syncjob_id)
REFERENCES kernel.sync_job_def (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
