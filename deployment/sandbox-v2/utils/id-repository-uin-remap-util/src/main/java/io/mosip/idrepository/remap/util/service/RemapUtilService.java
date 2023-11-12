package io.mosip.idrepository.remap.util.service;

import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import io.mosip.idrepository.remap.util.identity.entity.Uin;
import io.mosip.idrepository.remap.util.identity.repository.UinHashSaltRepo;
import io.mosip.idrepository.remap.util.identity.repository.UinRepo;
import io.mosip.idrepository.remap.util.vid.entity.Vid;
import io.mosip.idrepository.remap.util.vid.repository.VidRepo;
import io.mosip.idrepository.remap.util.vid.repository.VidUinHashSaltRepo;
import io.mosip.kernel.core.exception.BaseUncheckedException;
import io.mosip.kernel.core.util.CryptoUtil;
import io.mosip.kernel.core.util.DateUtils;
import io.mosip.kernel.core.util.HMACUtils2;

/**
 * @author Manoj SP
 *
 */
@Service
@Transactional
public class RemapUtilService {

	public static final String SPLITTER = "_";
	
	@Value("${mosip.idrepo.vid-type-to-remap}")
	private String vidType;
	
	@Value("${mosip.idrepo.active-uin-status}")
	private String activeUinStatus;
	
	@Value("${mosip.idrepo.uin-status-to-update}")
	private String uinStatusToUpdate;
	
	@Value("${mosip.idrepo.updated-by}")
	private String updatedBy;
	
	@Autowired
	private Environment env;
	
	@Autowired
	private UinHashSaltRepo uinHashSaltRepo;

	@Autowired
	private VidUinHashSaltRepo vidHashSaltRepo;
	
	@Autowired
	private UinRepo uinRepo;
	
	@Autowired
	private VidRepo vidRepo;

	public Map<String, List<String>> remap(String primaryUin, List<String> uinToDeactivate) {
		// get vid from vidrepo based on vid - uinhash
		String primaryUinHash = generateHash(primaryUin, false);
		Vid findByUinHash = vidRepo.findFirstByUinHash(primaryUinHash);
		String encryptedUin = findByUinHash.getUin();
		Set<String> uinHashList = uinToDeactivate.stream().map(uin -> generateHash(uin, false))
				.collect(Collectors.toSet());
		// update vid records of all vids mapped to uins which needs to be deactivated
		List<Vid> vidObjectList = vidRepo.findByUinHashIn(uinHashList);
		for (Vid vid : vidObjectList) {
			vid.setUinHash(primaryUinHash);
			vid.setUin(encryptedUin);
			vid.setUpdatedDTimes(DateUtils.getUTCCurrentDateTime());
			vid.setUpdatedBy(updatedBy);
			vid.setVidTypeCode(vidType);
		}
		vidRepo.saveAll(vidObjectList);
		deactivateUin(uinToDeactivate);
		return Map.of("uinsDeactivated", uinToDeactivate, "vidsRemapped",
				vidObjectList.stream().map(Vid::getVid).collect(Collectors.toList()));
	}

	private void deactivateUin(List<String> uinToDeactivate) {
		Map<String, String> uinHashMap = uinToDeactivate.stream().distinct()
				.collect(Collectors.toMap(uin -> generateHash(uin, true), uin -> uin));
		List<Uin> uinObjectList = uinRepo.findByUinHashIn(uinHashMap.keySet());
		for(Uin uinObj : uinObjectList) {
			if (!uinObj.getStatusCode().contentEquals(activeUinStatus)) {
				throw new BaseUncheckedException("", "Uin is already deactivated - " + uinHashMap.get(uinObj.getUinHash()));
			}
			uinObj.setStatusCode(uinStatusToUpdate);
			uinObj.setUpdatedDateTime(DateUtils.getUTCCurrentDateTime());
			uinObj.setUpdatedBy(updatedBy);
		}
		uinRepo.saveAll(uinObjectList);
	}

	private String generateHash(String uin, boolean isUin) {
		try {
			int saltId = this.getSaltKeyForId(uin);
			String hashSalt = isUin ? uinHashSaltRepo.retrieveSaltById(saltId) : vidHashSaltRepo.retrieveSaltById(saltId);
			return String.valueOf(saltId) + SPLITTER
					+ this.hashwithSalt(uin.getBytes(), isUin ? hashSalt.getBytes() : CryptoUtil.decodePlainBase64(hashSalt));
		} catch (NoSuchAlgorithmException e) {
			throw new BaseUncheckedException("", "Failed to generate Hash for uin - " + uin, e);
		}
	}

	public int getSaltKeyForId(String id) {
		Integer saltKeyLength = env.getProperty("mosip.identity.salt.key.length", Integer.class, 3);
		return RemapUtilService.getIdvidModulo(id, saltKeyLength);
	}
	
	public static final int getIdvidModulo(String idvid, int substrigLen) {
		Assert.isTrue(substrigLen > 0, "divisor should be positive integer");
		int length = idvid.length();
		return length <= substrigLen ? Integer.parseInt(idvid)
				: Integer.parseInt(idvid.substring(length - substrigLen));
	}

	public String hashwithSalt(final byte[] data, final byte[] salt) throws NoSuchAlgorithmException {
		return HMACUtils2.digestAsPlainTextWithSalt(data, salt);
	}
}
