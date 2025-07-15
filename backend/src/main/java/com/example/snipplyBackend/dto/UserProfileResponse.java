package com.example.snipplyBackend.dto;

import lombok.Data;

@Data
public class UserProfileResponse {
    private String username;
    private String email;
    private String role;
    private String bio;
    private String githubUsername;
    private String profilePicture;
    private boolean isVerified;
}
