package com.example.snipplyBackend.config;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.example.snipplyBackend.service.Env;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MongoConfig {

    @Bean
    public MongoClient mongoClient() {
        String uri = Env.get("MONGODB_URI");
        return MongoClients.create(uri);
    }
}
