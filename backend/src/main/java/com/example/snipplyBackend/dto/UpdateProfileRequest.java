package com.example.snipplyBackend.dto;

import lombok.Data;

@Data
public class UpdateProfileRequest {
    private String username;
    private String bio;
    private String githubUsername;
    private String profilePicture;
}
