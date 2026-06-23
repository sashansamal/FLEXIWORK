package com.flexiwork;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * FlexiWork — temporary workforce management platform for Sri Lanka.
 *
 * <p>Single Spring Boot application exposing a stateless JWT REST API (consumed by the
 * React frontend) and a session-based Thymeleaf admin panel. JPA auditing and caching
 * are enabled application-wide here.
 */
@SpringBootApplication
@EnableJpaAuditing(auditorAwareRef = "auditorAware")
@EnableCaching
@EnableScheduling
public class FlexiWorkApplication {

    public static void main(String[] args) {
        SpringApplication.run(FlexiWorkApplication.class, args);
    }
}
