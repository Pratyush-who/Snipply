package com.example.snipplyBackend.controller;

import com.example.snipplyBackend.dto.LoginRequest;
import com.example.snipplyBackend.dto.SignupRequest;
import com.example.snipplyBackend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@Valid @RequestBody SignupRequest req) {
        try {
            String message = userService.registerUser(req);
            return ResponseEntity.ok(message);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req) { //When the client sends a POST request to /api/auth/login with JSON data in the body, take that JSON and convert it into a Java object of type LoginRequest DTO
        try {
            return ResponseEntity.ok(userService.login(req));
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body(e.getMessage());
        }
    }

    @GetMapping("/all")
    public ResponseEntity<?> getAll() {
        try {
            return ResponseEntity.ok(userService.getAllUsers());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Something went wrong: " + e.getMessage());
        }
    }
}
