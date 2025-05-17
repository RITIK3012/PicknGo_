package com.pickngo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EntityScan("com.pickngo.model")
@EnableJpaRepositories("com.pickngo.repository")
public class PicknGoApplication {

    public static void main(String[] args) {
        SpringApplication.run(PicknGoApplication.class, args);
    }
} 