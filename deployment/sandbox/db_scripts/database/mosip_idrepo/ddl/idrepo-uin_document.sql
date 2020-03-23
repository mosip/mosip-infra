-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_repo
-- Table Name 	: idrepo.uin_document
-- Purpose   	: UIN Document: The documents uploaded / provided by an individual as part of registration / UIN generation process.  The documents are stored in separate storage like HDFS/CEPH store, only the reference to the document files is maintained in this table. Along with the reference, a hash value of the document file is also maintained as an added security measure to prevent data tampering.
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


-- object: idrepo.uin_document | type: TABLE --
-- DROP TABLE IF EXISTS idrepo.uin_document CASCADE;
CREATE TABLE idrepo.uin_document(
	uin_ref_id character varying(36) NOT NULL,
	doccat_code character varying(36) NOT NULL,
	doctyp_code character varying(64) NOT NULL,
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
	CONSTRAINT pk_uind PRIMARY KEY (uin_ref_id,doccat_code),
	CONSTRAINT uk_uind UNIQUE (uin_ref_id,doc_id)

);
-- ddl-end --
COMMENT ON TABLE idrepo.uin_document IS 'UIN Document: The documents uploaded / provided by an individual as part of registration / UIN generation process.  The documents are stored in separate storage like HDFS/CEPH store, only the reference to the document files is maintained in this table. Along with the reference, a hash value of the document file is also maintained as an added security measure to prevent data tampering.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.uin_ref_id IS 'UIN Reference ID: System generated id mapped to a UIN used for references in the system. UIN reference ID is also used as folder/bucket in DFS (HDFS/CEPH) to store documents and biometric CBEFF file. refers to idrepo.uin.uin_ref_id';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.doccat_code IS 'Document Category Code:  Category code under which document is uploaded during the registration process for ex., POA, POI, etc. Refers to master.doc_category.code';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.doctyp_code IS 'Document Type Code: Document type under which document is uploaded during the registration process for ex., passport, driving license, etc. Refers to master.doc_type.code.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.doc_id IS 'Document  ID: ID of the document that is stored in filesystem storage like HDFS/CEPH. If document ID Is not available then name of the file itself can be used as document ID.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.doc_name IS 'Document  Name:  Name of the document that is stored in filesystem storage like HDFS/CEPH.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.docfmt_code IS 'Document Format Code: Document format code of the document that is uploaded during the registration process for ex., PDF, JPG etc. Refers to master.doc_file_format.code';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.doc_hash IS 'Document  Hash:  Hash value of the document which is stored in DFS (HDFS/CEPH) storage. While reading the document, hash value of the document is verified with this hash value to ensure document validity.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_document.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
