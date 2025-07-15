package com.example.snipplyBackend.service;

import com.example.snipplyBackend.dto.LoginRequest;
import com.example.snipplyBackend.dto.SignupRequest;
import com.example.snipplyBackend.dto.UpdateProfileRequest;
import com.example.snipplyBackend.dto.UserProfileResponse;
import com.example.snipplyBackend.model.User;
import com.example.snipplyBackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final com.example.snipplyBackend.service.JwtService jwtService;

    public String registerUser(SignupRequest req) {
        if (userRepo.existsByEmail(req.getEmail())) {
            throw new RuntimeException("Email already in use");
        }

        User user = User.builder()
                .username(req.getUsername())
                .email(req.getEmail())
                .password(passwordEncoder.encode(req.getPassword()))
                .role(req.getRole())
                .profilePicture(req.getProfilePicture() != null ? req.getProfilePicture() : null)
                .bio(req.getBio() != null ? req.getBio() : "")
                .githubUsername(req.getGithubUsername() != null ? req.getGithubUsername() : null)
                .isVerified(false)
                .createdAt(new Date())
                .updatedAt(new Date())
                .build();

        userRepo.save(user);
        return "User registered successfully";
    }


    public Map<String, String> login(LoginRequest req) {
        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        if (!passwordEncoder.matches(req.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        String token = jwtService.generateToken(user.getEmail());

        return Map.of(
                "message", "Login successful",
                "token", token
        );
    }

    public UserProfileResponse getCurrentUserProfile(String token) {
        String email = jwtService.extractUserEmail(token.substring(7)); // remove "Bearer "
        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserProfileResponse response = new UserProfileResponse();
        response.setUsername(user.getUsername());
        response.setEmail(user.getEmail());
        response.setRole(user.getRole());
        response.setBio(user.getBio());
        response.setGithubUsername(user.getGithubUsername());
        response.setProfilePicture(user.getProfilePicture());

        return response;
    }

    public String updateUserProfile(String token, UpdateProfileRequest req) {
        String email = jwtService.extractUserEmail(token.substring(7));
        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (req.getUsername() != null && !req.getUsername().isBlank()) {
            user.setUsername(req.getUsername());
        }
        if (req.getBio() != null) {
            user.setBio(req.getBio());
        }
        if (req.getGithubUsername() != null) {
            user.setGithubUsername(req.getGithubUsername());
        }
        if (req.getProfilePicture() != null) {
            user.setProfilePicture(req.getProfilePicture());
        }

        user.setUpdatedAt(new Date());
        userRepo.save(user);
        return "Profile updated successfully";
    }


    public List<User> getAllUsers() {
        return userRepo.findAll();
    }
}
