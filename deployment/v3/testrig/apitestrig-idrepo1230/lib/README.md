# idrepo1230-cache-force.jar

Tiny Spring `ApplicationContextInitializer` that runs **after** config-server bootstrap and:

1. `addFirst`s `spring.cache.type=none` + PascalCase `*cache*names*` / size / expire maps
2. Replaces the `cacheManager` bean with a **dynamic** `ConcurrentMapCacheManager`

This is required on qa11new because remote config beats `-D` / `--` / `SPRING_APPLICATION_JSON`
(actuator shows both `spring.cache.type=none` and `=simple`).

## Rebuild

```bash
# from a machine with JDK 11+
cd /tmp && mkdir -p cf/{src/io/mosip/idrepo1230,classes,META-INF}
cp $REPO/deployment/v3/testrig/apitestrig-idrepo1230/lib/src/io/mosip/idrepo1230/CacheForceInitializer.java \
  cf/src/io/mosip/idrepo1230/
cp $REPO/deployment/v3/testrig/apitestrig-idrepo1230/lib/src/spring.factories cf/META-INF/
# download spring-context 5.0.6 (+ deps) then:
javac --release 11 -cp 'spring-*.jar' -d cf/classes cf/src/io/mosip/idrepo1230/CacheForceInitializer.java
cp cf/META-INF/spring.factories cf/classes/META-INF/
jar cf idrepo1230-cache-force.jar -C cf/classes .
cp idrepo1230-cache-force.jar $REPO/deployment/v3/testrig/apitestrig-idrepo1230/lib/
```

Installed by `../apply-cache-cmdline.sh` (base64-decoded into the pod’s `loader.path`).
