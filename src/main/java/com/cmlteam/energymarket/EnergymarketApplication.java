package com.cmlteam.energymarket;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@SpringBootApplication
@ComponentScan(basePackages = "com.cmlteam.energymarket")
@Configuration
@EnableAutoConfiguration
public class EnergymarketApplication {
	public static void main(String[] args) {
		SpringApplication.run(EnergymarketApplication.class, args);
	}
}
