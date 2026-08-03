package io.mosip.idrepo1230;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;

/**
 * Force cache overrides after Spring Cloud Config bootstrap inserts remote
 * properties (which beat -D / -- / SPRING_APPLICATION_JSON on qa11new).
 *
 * 1) addFirst property source: spring.cache.type=none + PascalCase names/maps
 * 2) BFPP: replace cacheManager bean with a dynamic ConcurrentMapCacheManager
 *    so @Cacheable("Online_Verification_Partners") always resolves.
 */
public class CacheForceInitializer
    implements ApplicationContextInitializer<ConfigurableApplicationContext>, Ordered {

  public static final String PROPERTY_SOURCE = "idrepo1230CacheForce";

  private static final String CACHE_NAMES =
      "Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,"
          + "DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction,"
          + "online_verification_partners,partner_extractor_formats,datashare_policies";

  private static final String CACHE_SIZE =
      "{ 'Online_Verification_Partners': 200, 'id_attributes': 200, 'uin_hash_salt': 100,"
          + " 'uin_encrypt_salt': 100, 'DATASHARE_POLICIES': 200, 'PARTNER_EXTRACTOR_FORMATS': 200,"
          + " 'topics': 200, 'credential_transaction': 200, 'online_verification_partners': 200,"
          + " 'partner_extractor_formats': 200, 'datashare_policies': 200 }";

  private static final String CACHE_EXPIRE =
      "{ 'Online_Verification_Partners': 86400, 'id_attributes': 86400, 'uin_hash_salt': 86400,"
          + " 'uin_encrypt_salt': 86400, 'DATASHARE_POLICIES': 86400, 'PARTNER_EXTRACTOR_FORMATS': 86400,"
          + " 'topics': 86400, 'credential_transaction': 86400, 'online_verification_partners': 86400,"
          + " 'partner_extractor_formats': 86400, 'datashare_policies': 86400 }";

  @Override
  public void initialize(ConfigurableApplicationContext applicationContext) {
    ConfigurableEnvironment env = applicationContext.getEnvironment();
    MutablePropertySources sources = env.getPropertySources();

    Map<String, Object> map = new HashMap<String, Object>();
    // Prefer none so Boot NoOp / our BFPP dynamic manager wins over SimpleCacheConfig.
    map.put("spring.cache.type", "none");
    map.put("spring.cache.cache-names", CACHE_NAMES);
    map.put("mosip.idrepo.cache.names", CACHE_NAMES);
    map.put("mosip.idrepo.cache.size", CACHE_SIZE);
    map.put("mosip.idrepo.cache.expire-in-seconds", CACHE_EXPIRE);
    // Keep cloud-config from re-asserting remote over this source mid-refresh.
    map.put("spring.cloud.config.allow-override", "true");
    map.put("spring.cloud.config.override-none", "true");
    map.put("spring.cloud.config.override-system-properties", "false");

    if (sources.contains(PROPERTY_SOURCE)) {
      sources.remove(PROPERTY_SOURCE);
    }
    sources.addFirst(new MapPropertySource(PROPERTY_SOURCE, map));
    System.out.println("idrepo1230CacheForce: property source installed (spring.cache.type=none)");

    applicationContext.addBeanFactoryPostProcessor(new DynamicCacheManagerPostProcessor());
  }

  @Override
  public int getOrder() {
    // Run after PropertySourceBootstrapConfiguration so addFirst beats config-server.
    return Ordered.LOWEST_PRECEDENCE;
  }

  /**
   * Replace any cacheManager bean with a dynamic ConcurrentMapCacheManager.
   * Dynamic mode creates caches on demand — name case cannot fail.
   */
  static final class DynamicCacheManagerPostProcessor implements BeanFactoryPostProcessor, Ordered {
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory)
        throws BeansException {
      if (!(beanFactory instanceof BeanDefinitionRegistry)) {
        return;
      }
      BeanDefinitionRegistry registry = (BeanDefinitionRegistry) beanFactory;
      // Remove known CacheManager bean def names from Boot / SimpleCacheConfig / Redis.
      String[] candidates = new String[] {
          "cacheManager", "simpleCacheManager", "redisCacheManager"
      };
      for (String name : candidates) {
        if (registry.containsBeanDefinition(name)) {
          registry.removeBeanDefinition(name);
          System.out.println("idrepo1230CacheForce: removed bean definition '" + name + "'");
        }
      }
      RootBeanDefinition bd = new RootBeanDefinition(ConcurrentMapCacheManager.class);
      // Default ConcurrentMapCacheManager is dynamic (no preset names).
      registry.registerBeanDefinition("cacheManager", bd);
      System.out.println("idrepo1230CacheForce: registered dynamic ConcurrentMapCacheManager");
    }

    @Override
    public int getOrder() {
      return Ordered.LOWEST_PRECEDENCE;
    }
  }
}
