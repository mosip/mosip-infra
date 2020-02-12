-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_iam
-- Table Name : iam table relation
-- Purpose    : All the FKs are created separately, not part of create table scripts to ease the deployment process
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: fk_usrrol_rolelst | type: CONSTRAINT --
-- ALTER TABLE iam.user_role DROP CONSTRAINT IF EXISTS fk_usrrol_rolelst CASCADE;
ALTER TABLE iam.user_role ADD CONSTRAINT fk_usrrol_rolelst FOREIGN KEY (role_code,lang_code)
REFERENCES iam.role_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usrrol_usrdtl | type: CONSTRAINT --
-- ALTER TABLE iam.user_role DROP CONSTRAINT IF EXISTS fk_usrrol_usrdtl CASCADE;
ALTER TABLE iam.user_role ADD CONSTRAINT fk_usrrol_usrdtl FOREIGN KEY (usr_id)
REFERENCES iam.user_detail (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_usrpwd_usrdtl | type: CONSTRAINT --
-- ALTER TABLE iam.user_pwd DROP CONSTRAINT IF EXISTS fk_usrpwd_usrdtl CASCADE;
ALTER TABLE iam.user_pwd ADD CONSTRAINT fk_usrpwd_usrdtl FOREIGN KEY (usr_id)
REFERENCES iam.user_detail (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
