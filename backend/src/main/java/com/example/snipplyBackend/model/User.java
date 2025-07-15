package com.example.snipplyBackend.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "users") // maps to mongo
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    private String id;

    private String username;
    private String email;
    private String password;

    private String role; // USER / ADMIN
    private String profilePicture;
    private String bio;
    private boolean isVerified;
    private String githubUsername;

    private Date createdAt = new Date();
    private Date updatedAt = new Date();
}
