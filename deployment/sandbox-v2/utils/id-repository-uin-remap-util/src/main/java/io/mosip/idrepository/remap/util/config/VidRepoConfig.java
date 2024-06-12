package io.mosip.idrepository.remap.util.config;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.orm.jpa.hibernate.SpringImplicitNamingStrategy;
import org.springframework.boot.orm.jpa.hibernate.SpringPhysicalNamingStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 *
 * @author Manoj SP
 */
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(basePackages = {
"io.mosip.idrepository.remap.util.vid.repository" }, entityManagerFactoryRef = "vidEntityManager", transactionManagerRef = "vidJpaTransactionManager")
public class VidRepoConfig {

	/** The env. */
	@Autowired
	private Environment env;
	
	/**
	 * Entity manager factory.
	 *
	 * @return the local container entity manager factory bean
	 */
	@Bean("vidEntityManager")
	@Qualifier("vidEntityManager")
	public LocalContainerEntityManagerFactoryBean entityManagerFactory(@Qualifier("vidDataSource") DataSource vidDataSource) {
		LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
		em.setDataSource(vidDataSource);
		em.setJpaVendorAdapter(new HibernateJpaVendorAdapter());
		em.setPackagesToScan("io.mosip.idrepository.remap.util.vid.entity");
		em.setJpaPropertyMap(additionalProperties());
		return em;
	}

	/**
	 * Data source.
	 *
	 * @return the data source
	 */
	@Bean
	@Qualifier("vidDataSource")
	public DataSource dataSource() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setUrl(env.getProperty("mosip.idrepository.vid.db.url"));
		dataSource.setUsername(env.getProperty("mosip.idrepository.vid.db.username"));
		dataSource.setPassword(env.getProperty("mosip.idrepository.vid.db.password"));
		dataSource.setDriverClassName(env.getProperty("mosip.idrepository.vid.db.driverClassName"));
		dataSource.setSchema(env.getProperty("mosip.idrepository.vid.db.schemaName"));
		return dataSource;
	}

	/**
	 * Jpa transaction manager.
	 *
	 * @param emf the emf
	 * @return the jpa transaction manager
	 */
	@Bean("vidJpaTransactionManager")
	@Qualifier("vidJpaTransactionManager")
	public JpaTransactionManager jpaTransactionManager(EntityManagerFactory emf, @Qualifier("vidDataSource") DataSource vidDataSource) {
		JpaTransactionManager jpaTransactionManager = new JpaTransactionManager();
		jpaTransactionManager.setEntityManagerFactory(entityManagerFactory(vidDataSource).getObject());
		jpaTransactionManager.setDataSource(dataSource());
		return jpaTransactionManager;
	}

	/**
	 * Additional properties.
	 *
	 * @return the map
	 */
	private Map<String, Object> additionalProperties() {
		Map<String, Object> jpaProperties = new HashMap<>();
		jpaProperties.put("hibernate.implicit_naming_strategy", SpringImplicitNamingStrategy.class.getName());
		jpaProperties.put("hibernate.physical_naming_strategy", SpringPhysicalNamingStrategy.class.getName());
		jpaProperties.put("hibernate.dialect", "org.hibernate.dialect.PostgreSQL92Dialect");
		return jpaProperties;
	}

}
