package io.mosip.idrepository.remap.util.vid.repository;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import io.mosip.idrepository.remap.util.vid.entity.VidUinHashSalt;

/**
 * The Interface UinHashSaltRepo.
 *
 * @author Prem Kumar
 */
public interface VidUinHashSaltRepo extends JpaRepository<VidUinHashSalt, Integer> {
	
	/**
	 * The Query to retrieve salt by passing id as parameter.
	 *
	 * @param id the id
	 * @return String salt
	 */
	@Cacheable(cacheNames = "uin_hash_salt")
	@Query("select salt from VidUinHashSalt where id = :id")
	public String retrieveSaltById(@Param("id") int id);
}
