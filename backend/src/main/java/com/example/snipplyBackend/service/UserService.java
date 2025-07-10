package com.example.snipplyBackend.service;

import com.example.snipplyBackend.dto.LoginRequest;
import com.example.snipplyBackend.dto.SignupRequest;
import com.example.snipplyBackend.model.User;
import com.example.snipplyBackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final com.example.snipplyBackend.service.JwtService jwtService;

    public String registerUser(SignupRequest req) {
        if (userRepo.existsByEmail(req.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User user = User.builder()
                .username(req.getUsername())
                .email(req.getEmail())
                .password(passwordEncoder.encode(req.getPassword()))
                .role(req.getRole())
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
}
