package io.mosip.idrepository.remap.util;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;

/**
 * @author Manoj SP
 *
 */
@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
@ComponentScan(basePackages = { "io.mosip.idrepository.remap.util.*" })
public class RemapMainApplication {

	public static void main(String[] args) throws Exception {
		SpringApplication.run(RemapMainApplication.class, args);
	}

}
