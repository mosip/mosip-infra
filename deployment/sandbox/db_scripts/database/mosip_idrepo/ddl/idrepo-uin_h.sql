-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_repo
-- Table Name 	: idrepo.uin_h
-- Purpose    	: UIN History : This to track changes to base table record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer base table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: idrepo.uin_h | type: TABLE --
-- DROP TABLE IF EXISTS idrepo.uin_h CASCADE;
CREATE TABLE idrepo.uin_h(
	uin_ref_id character varying(36) NOT NULL,
	eff_dtimes timestamp NOT NULL,
	uin character varying(500) NOT NULL,
	uin_hash character varying(128) NOT NULL,
	uin_data bytea NOT NULL,
	uin_data_hash character varying(64) NOT NULL,
	reg_id character varying(39) NOT NULL,
	bio_ref_id character varying(128),
	status_code character varying(32) NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_uinh PRIMARY KEY (uin_ref_id,eff_dtimes),
	CONSTRAINT uk_uinh UNIQUE (uin,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE idrepo.uin_h IS 'UIN History : This to track changes to base table record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer base table description for details.   ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.uin_ref_id IS 'UIN Reference ID: System generated id mapped to a UIN used for references in the system. UIN reference ID is also used as folder/bucket in DFS (HDFS/CEPH) to store documents and biometric CBEFF file.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.eff_dtimes IS 'Effective Datetimestamp : This to track base table record changes whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time  till next change occurs.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.uin IS 'Unique Identification Number : Unique identification number assigned to individual.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.uin_hash IS 'Unique Identification Number Hash: Hash value of Unique identification number assigned to individual.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.uin_data IS 'UIN Data: Information of an individual stored in JSON file as per ID definition defined by the country in the system';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.uin_data_hash IS 'UIN Data Hash:  Hash value of the UIN data which is stored in uin_data field. While reading the JSON file, hash value of the file is verified with this hash value to ensure file validity.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.reg_id IS 'Registration ID: Latest registration ID through which individual information got processed and registered';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.bio_ref_id IS 'Biometric Reference Id: Biometric reference id generated which will be used as a reference id in ABIS systems';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.status_code IS 'Status Code:  Current Status code of the UIN. Refers to master.status_list.code';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
