INSERT INTO pms.policy_group (id,"name",descr,user_id,is_active,cr_by,cr_dtimes,upd_by,upd_dtimes,is_deleted,del_dtimes) VALUES 
('470049','ABIS Policy','ABIS Policy','110118',true,'110118','2020-06-17 06:06:36.649','110118','2020-06-17 06:06:36.649',NULL,NULL) ON CONFLICT DO NOTHING;

INSERT INTO pms.auth_policy (id,policy_group_id,name,descr,policy_file_id,policy_type,"version",policy_schema,valid_from_date,valid_to_date,is_active,cr_by,cr_dtimes,upd_by,upd_dtimes,is_deleted,del_dtimes) VALUES 
('96025','470049','DataShare','DataShare','{"shareableAttributes":[{"encrypted":false,"format":null,"attributeName":"fullName"},{"encrypted":false,"format":null,"attributeName":"dateOfBirth"}],"dataSharePolicies":{"typeOfShare":"direct","transactionsAllowed":"2","shareDomain":"minibox.mosip.net","encryptionType":"none","validForInMinutes":"60"}}','DataShare','1.0','https://schemas.mosip.io/v1/auth-policy','2020-09-22 16:40:53.950','2025-03-21 16:41:36.253',true,'110124','2020-09-22 16:40:53.950','110124','2020-09-22 16:41:36.253',false,NULL) ON CONFLICT DO NOTHING;

INSERT INTO pms.partner_type (code,partner_description,is_active,cr_by,cr_dtimes,upd_by,upd_dtimes,is_deleted,del_dtimes,is_policy_required)
   SELECT 'Auth_Partner','Auth_Partner',true,'system','2020-09-08 02:19:56.000',NULL,NULL,NULL,NULL,true
WHERE 'Auth_Partner'NOT IN (
  SELECT code FROM pms.partner_type where code ='Auth_Partner'
) ON CONFLICT DO NOTHING;

INSERT INTO pms.partner (id,policy_group_id,name,address,contact_no,email_id,certificate_alias,user_id,partner_type_code,approval_status,is_active,cr_by,cr_dtimes,upd_by,upd_dtimes,is_deleted,del_dtimes) VALUES 
('748757','470049','ABIS','Bangalore','9878787878','xyz@myz.com',NULL,'110124','Auth_Partner','Activated',true,'110124','2020-09-22 16:43:13.370',NULL,NULL,NULL,NULL) ON CONFLICT DO NOTHING;

INSERT INTO pms.partner_policy_request (id,part_id,policy_id,request_datetimes,request_detail,status_code,cr_by,cr_dtimes,upd_by,upd_dtimes,is_deleted,del_dtimes) VALUES 
('218973','748757','470049','2020-06-04 07:22:03.464','ABIS Policy','Approved','110118','2020-06-04 07:21:17.736','110118','2020-06-04 07:22:34.203',NULL,NULL) ON CONFLICT DO NOTHING;

INSERT INTO pms.partner_policy (policy_api_key,part_id,policy_id,valid_from_datetime,valid_to_datetime,is_active,cr_by,cr_dtimes,upd_by,upd_dtimes,is_deleted,del_dtimes) VALUES 
('9418294','748757','96025','2020-06-04 07:22:34.203','2029-08-03 07:22:34.203',true,'110118','2020-06-04 07:21:17.736',NULL,NULL,NULL,NULL) ON CONFLICT DO NOTHING;
