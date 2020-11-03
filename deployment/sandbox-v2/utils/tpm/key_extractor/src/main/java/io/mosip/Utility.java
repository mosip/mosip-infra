package io.mosip;

import org.apache.commons.codec.binary.Base64;
import tss.Tpm;
import tss.TpmFactory;
import tss.tpm.CreatePrimaryResponse;
import tss.tpm.*;

import java.net.InetAddress;
import java.security.MessageDigest;


public class Utility {

    private static final byte[] NULL_VECTOR = new byte[0];
    private static Tpm tpm;
    private static MessageDigest messageDigest;

    private static String TEMPLATE = "{\"machineName\" : \"%s\", \"publicKey\" : \"%s\", \"signingPublicKey\": \"%s\", \"keyIndex\": \"%s\", \"signingKeyIndex\": \"%s\" }";

    public static void main(String[] args) throws Exception {
        messageDigest = MessageDigest.getInstance("SHA-256");

        tpm = TpmFactory.platformTpm();
        String machineName = InetAddress.getLocalHost().getHostName();

        String publicKey = createRSAKey();
        String keyIndex = str2Hex(messageDigest.digest(Base64.decodeBase64(publicKey))).replaceAll("..(?!$)", "$0:");

        String signingPublicKey = createSigningKey();
        String signingKeyIndex = str2Hex(messageDigest.digest(Base64.decodeBase64(signingPublicKey))).replaceAll("..(?!$)", "$0:");

        System.out.println(String.format(TEMPLATE, machineName, publicKey, signingPublicKey, keyIndex, signingKeyIndex));
    }


    /**
     * Note: If either the seed or the template changes, a completely different primary key is created
     *
     * @return
     */
    private static String createSigningKey() {
        TPMT_PUBLIC template = new TPMT_PUBLIC(TPM_ALG_ID.SHA1,
                new TPMA_OBJECT(TPMA_OBJECT.fixedTPM, TPMA_OBJECT.fixedParent, TPMA_OBJECT.sign,
                        TPMA_OBJECT.sensitiveDataOrigin, TPMA_OBJECT.userWithAuth),
                new byte[0],
                new TPMS_RSA_PARMS(new TPMT_SYM_DEF_OBJECT(TPM_ALG_ID.NULL, 0, TPM_ALG_ID.NULL),
                        new TPMS_SIG_SCHEME_RSASSA(TPM_ALG_ID.SHA256), 2048, 65537),
                new TPM2B_PUBLIC_KEY_RSA());

        TPM_HANDLE primaryHandle = TPM_HANDLE.from(TPM_RH.ENDORSEMENT);

        TPMS_SENSITIVE_CREATE dataToBeSealedWithAuth = new TPMS_SENSITIVE_CREATE(NULL_VECTOR, NULL_VECTOR);

        //everytime this is called key never changes until unless either seed / template change.
        CreatePrimaryResponse signingPrimaryResponse = tpm.CreatePrimary(primaryHandle, dataToBeSealedWithAuth, template,
                NULL_VECTOR, new TPMS_PCR_SELECTION[0]);

        return Base64.encodeBase64URLSafeString(signingPrimaryResponse.outPublic.toTpm());
    }

    /**
     * Note: If either the seed or the template changes, a completely different primary key is created
     * @return
     */
    private static String createRSAKey() {
        // This policy is a "standard" policy that is used with vendor-provided
        // EKs
        byte[] standardEKPolicy = new byte[] { (byte) 0x83, 0x71, (byte) 0x97, 0x67, 0x44, (byte) 0x84, (byte) 0xb3,
                (byte) 0xf8, 0x1a, (byte) 0x90, (byte) 0xcc, (byte) 0x8d, 0x46, (byte) 0xa5, (byte) 0xd7, 0x24,
                (byte) 0xfd, 0x52, (byte) 0xd7, 0x6e, 0x06, 0x52, 0x0b, 0x64, (byte) 0xf2, (byte) 0xa1, (byte) 0xda,
                0x1b, 0x33, 0x14, 0x69, (byte) 0xaa };

        TPMT_PUBLIC template = new TPMT_PUBLIC(TPM_ALG_ID.SHA256,
                new TPMA_OBJECT(TPMA_OBJECT.fixedTPM, TPMA_OBJECT.fixedParent,
                        TPMA_OBJECT.decrypt, TPMA_OBJECT.sensitiveDataOrigin, TPMA_OBJECT.userWithAuth),
                standardEKPolicy,
                new TPMS_RSA_PARMS(new TPMT_SYM_DEF_OBJECT(TPM_ALG_ID.NULL, 0, TPM_ALG_ID.NULL),
                        new TPMS_ENC_SCHEME_OAEP(TPM_ALG_ID.SHA256), 2048, 65537),
                new TPM2B_PUBLIC_KEY_RSA());

        TPMS_SENSITIVE_CREATE dataToBeSealedWithAuth = new TPMS_SENSITIVE_CREATE(NULL_VECTOR, NULL_VECTOR);
        TPM_HANDLE primaryHandle = TPM_HANDLE.from(TPM_RH.ENDORSEMENT);
        CreatePrimaryResponse encPrimaryResponse = tpm.CreatePrimary(primaryHandle, dataToBeSealedWithAuth, template,
                null, null);
        return Base64.encodeBase64URLSafeString(encPrimaryResponse.outPublic.toTpm());
    }

    private static String str2Hex(byte[] bytes) {
        char[] digital = "0123456789ABCDEF".toCharArray();
        StringBuffer sb = new StringBuffer("");
        for (int i = 0; i < bytes.length; i++) {
            int bit = (bytes[i] & 0xF0) >> 4;
            sb.append(digital[bit]);
            bit = bytes[i] & 0xF;
            sb.append(digital[bit]);
        }
        return sb.toString();
    }

} 
