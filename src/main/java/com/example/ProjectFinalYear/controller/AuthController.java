 package com.example.ProjectFinalYear.controller;

// import com.example.ProjectFinalYear.dtos.LoginRequest;
// import com.example.ProjectFinalYear.dtos.RegisterRequest;
// import com.example.ProjectFinalYear.security.UserDetailsImpl;
// import com.example.ProjectFinalYear.service.AuthService;
// import com.google.api.Authentication;

// import java.util.HashMap;
// import java.util.Map;

// import org.springframework.http.ResponseEntity;
// import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
// import org.springframework.security.core.context.SecurityContextHolder;
// import org.springframework.web.bind.annotation.*;

// @RestController
// @RequestMapping("/api/auth")
// public class AuthController {
//     private final AuthService authService;

//     public AuthController(AuthService authService) {
//         this.authService = authService;
//     }

//     @PostMapping("/register")
//     public ResponseEntity<String> register(@RequestBody RegisterRequest request) {
//         String response = authService.registerUser(request);
//         return ResponseEntity.ok(response);
//     }

//     // @PostMapping("/login")
//     // public ResponseEntity<String> login(@RequestBody LoginRequest request) {
//     //     String token = authService.login(request);
//     //     return ResponseEntity.ok(token);
//     // }
//     @PostMapping("/login")
// public ResponseEntity<?> loginUser(@RequestBody LoginRequest loginRequest) {
//     Authentication authentication = authenticationManager.authenticate(
//         new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
//     );

//     SecurityContextHolder.getContext().setAuthentication(authentication);
//     String token = jwtUtils.generateJwtToken(authentication);

//     UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();  // ✅ Fix here
//     String role = userDetails.getAuthorities().iterator().next().getAuthority();

//     Map<String, Object> response = new HashMap<>();
//     response.put("token", token);
//     response.put("role", role);

//     return ResponseEntity.ok(response);
// }

// }
//////
/// package com.example.ProjectFinalYear.controller;

import com.example.ProjectFinalYear.dtos.LoginRequest;
import com.example.ProjectFinalYear.dtos.RegisterRequest;
import com.example.ProjectFinalYear.security.UserDetailsImpl;
import com.example.ProjectFinalYear.service.AuthService;
import com.example.ProjectFinalYear.security.JwtUtil;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

import java.util.HashMap;
import java.util.Map;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://192.168.201.189:53696")
public class AuthController {

    private final AuthService authService;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtils;

    public AuthController(AuthService authService, AuthenticationManager authenticationManager, JwtUtil jwtUtils) {
        this.authService = authService;
        this.authenticationManager = authenticationManager;
        this.jwtUtils = jwtUtils;
    }

    // @PostMapping("/register")
    // @CrossOrigin(origins = "http://192.168.201.189:65087")
    // public ResponseEntity<String> register(@RequestBody RegisterRequest request) {
    //     String response = authService.registerUser(request);
    //     return ResponseEntity.ok(response);
    // }
    ////
    // @PostMapping("/register")
    // @CrossOrigin(origins = "http://192.168.201.189:53696")
    // public ResponseEntity<String> register(@RequestBody RegisterRequest request) {
    //     // Prevent students from registering as admin
    //     if (request.getRole() != null && request.getRole().equals("ROLE_ADMIN")) {
    //         return ResponseEntity.status(403).body("You are not authorized to register as an admin.");
    //     }
        
    //     try {
    //         String response = authService.registerUser(request);
    //         return ResponseEntity.ok(response);
    //     } catch (Exception e) {
    //         return ResponseEntity.status(500).body("Registration failed: " + e.getMessage());
    //     }
    // }
    // @PostMapping("/register")
    // @CrossOrigin(origins = "http://192.168.201.189:53696")
    // public ResponseEntity<String> register(@RequestBody RegisterRequest request) {
    //     // Prevent students from registering as admin
    //     if ("ROLE_ADMIN".equals(request.getRole())) {
    //         return ResponseEntity.status(403).body("You are not authorized to register as an admin.");
    //     }
    
    //     // Ensure name is not null or empty
    //     if (request.getName() == null || request.getName().trim().isEmpty()) {
    //         return ResponseEntity.status(400).body("Name cannot be empty.");
    //     }
    
    //     // Ensure role is valid (default to STUDENT if missing or invalid)
    //     if (request.getRole() == null || request.getRole().trim().isEmpty() || 
    //         (!"STUDENT".equals(request.getRole()) && !"ADMIN".equals(request.getRole()))) {
    //         request.setRole("STUDENT");
    //     }
    
    //     // Basic validation for email format (you may want to add more advanced email validation)
    //     if (request.getEmail() != null && !request.getEmail().matches("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$")) {
    //         return ResponseEntity.status(400).body("Invalid email format.");
    //     }
    
    //     try {
    //         String response = authService.registerUser(request);
    //         return ResponseEntity.ok(response);
    //     } catch (Exception e) {
    //         return ResponseEntity.status(500).body("Registration failed: " + e.getMessage());
    //     }
    // }
    

    @PostMapping("/register")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<String> register(@RequestBody RegisterRequest request) {
        // Print role before assigning
        System.out.println("Received role: " + request.getRole());
    
        // Prevent users from registering as admin
        if ("ROLE_ADMIN".equalsIgnoreCase(request.getRole())) {
            return ResponseEntity.status(403).body("You are not authorized to register as an admin.");
        }
    
        // Ensure role is valid
        String role = request.getRole();
        if (role == null || role.trim().isEmpty() || 
            (!role.equalsIgnoreCase("ROLE_STUDENT") && !role.equalsIgnoreCase("STAFF"))) {
            role = "ROLE_STUDENT"; // Default to student
        }
    
        // Ensure the role is stored in uppercase
        request.setRole(role.toUpperCase());
        System.out.println("Final stored role: " + request.getRole());
    
        try {
            // Call the correct service method based on role
            String response;
            if ("STAFF".equals(request.getRole())) {
                response = authService.registerStaff(request);
            } else {
                response = authService.registerUser(request);
            }
    
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Registration failed: " + e.getMessage());
        }
    }
    

    
   @PostMapping("/login")
@CrossOrigin(origins = "http://192.168.201.189:53696")
public ResponseEntity<?> loginUser(@RequestBody LoginRequest loginRequest) {
    try {
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        String role = userDetails.getAuthorities().iterator().next().getAuthority();

        // Generate token using email and role
        String token = jwtUtils.generateJwtToken(userDetails.getUsername(), role);

        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("role", role);

        return ResponseEntity.ok(response);

    } catch (DisabledException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(Map.of("message", "Your account is blocked. Please contact the administrator."));
    } catch (BadCredentialsException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(Map.of("message", "Invalid email or password."));
    } catch (Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(Map.of("message", "Something went wrong: " + ex.getMessage()));
    }
}

}
