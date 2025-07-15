package com.example.snipplyBackend.controller;

import com.example.snipplyBackend.dto.UpdateProfileRequest;
import com.example.snipplyBackend.dto.UserProfileResponse;
import com.example.snipplyBackend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final UserService userService;

    @GetMapping("/user")
    public ResponseEntity<UserProfileResponse> getMyProfile(@RequestHeader("Authorization") String token) {
        UserProfileResponse profile = userService.getCurrentUserProfile(token);
        return ResponseEntity.ok(profile);
    }

    @PutMapping("/updateuser")
    public ResponseEntity<?> updateProfile(@RequestHeader("Authorization") String token,
                                           @Valid @RequestBody UpdateProfileRequest req) {
        String result = userService.updateUserProfile(token, req);
        return ResponseEntity.ok(result);
    }
}
