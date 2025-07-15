package com.example.snipplyBackend.dto;

import lombok.Data;

@Data
//It keeps your DTO (Data Transfer Object) class clean by avoiding boilerplate code...The @Data annotation automatically generates, getter setter toString etc...
public class LoginRequest {
    private String email;
    private String password;
}

