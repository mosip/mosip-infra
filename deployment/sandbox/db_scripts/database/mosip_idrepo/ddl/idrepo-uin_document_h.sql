-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_repo
-- Table Name 	: idrepo.uin_document_h
-- Purpose    	: UIN Document History : This to track changes to base table record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer base table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: idrepo.uin_document_h | type: TABLE --
-- DROP TABLE IF EXISTS idrepo.uin_document_h CASCADE;
CREATE TABLE idrepo.uin_document_h(
	uin_ref_id character varying(36) NOT NULL,
	doccat_code character varying(36) NOT NULL,
	doctyp_code character varying(64) NOT NULL,
	eff_dtimes timestamp NOT NULL,
	doc_id character varying(128) NOT NULL,
	doc_name character varying(128) NOT NULL,
	docfmt_code character varying(36) NOT NULL,
	doc_hash character varying(64) NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_uindh PRIMARY KEY (uin_ref_id,doccat_code,eff_dtimes),
	CONSTRAINT uk_uindh UNIQUE (uin_ref_id,doc_id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE idrepo.uin_document_h IS 'UIN Document History : This to track changes to base table record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer base table description for details.   ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.uin_ref_id IS 'UIN Reference ID: System generated id mapped to a UIN used for references in the system. UIN reference ID is also used as folder/bucket in DFS (HDFS/CEPH) to store documents and biometric CBEFF file. refers to idrepo.uin.uin_ref_id';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.doccat_code IS 'Document Category Code:  Category code under which document is uploaded during the registration process for ex., POA, POI, etc. Refers to master.doc_category.code';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.doctyp_code IS 'Document Type Code: Document type under which document is uploaded during the registration process for ex., passport, driving license, etc. Refers to master.doc_type.code.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.eff_dtimes IS 'Effective Datetimestamp : This to track base table record changes whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time  till next change occurs.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.doc_id IS 'Document  ID: ID of the document that is stored in filesystem storage like HDFS/CEPH. If document ID Is not available then name of the file itself can be used as document ID.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.doc_name IS 'Document  Name:  Name of the document that is stored in filesystem storage like HDFS/CEPH.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.docfmt_code IS 'Document Format Code: Document format code of the document that is uploaded during the registration process for ex., PDF, JPG etc. Refers to master.doc_file_format.code';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.doc_hash IS 'Document  Hash:  Hash value of the document which is stored in DFS (HDFS/CEPH) storage. While reading the document, hash value of the document is verified with this hash value to ensure document validity.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
