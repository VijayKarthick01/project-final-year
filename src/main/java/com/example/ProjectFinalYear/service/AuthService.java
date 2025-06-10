package com.example.ProjectFinalYear.service;

// package com.example.ProjectFinalYear.service;

// import com.example.ProjectFinalYear.dtos.LoginRequest;
// import com.example.ProjectFinalYear.dtos.RegisterRequest;
// import com.example.ProjectFinalYear.model.User;
// import com.example.ProjectFinalYear.repositories.UserRepository;
// import com.example.ProjectFinalYear.security.JwtUtil;
// import lombok.extern.slf4j.Slf4j;
// import org.springframework.http.HttpStatus;
// import org.springframework.security.crypto.password.PasswordEncoder;
// import org.springframework.stereotype.Service;
// import org.springframework.web.server.ResponseStatusException;

// import java.util.Optional;

// @Slf4j
// @Service
// public class AuthService {
//     private final UserRepository userRepository;
//     private final PasswordEncoder passwordEncoder;
//     private final JwtUtil jwtUtil;

//     public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
//         this.userRepository = userRepository;
//         this.passwordEncoder = passwordEncoder;
//         this.jwtUtil = jwtUtil;
//     }

  
//     public String registerUser(RegisterRequest request) {
//         log.info("Registering user: {}", request.getEmail());
    
//         Optional<User> existingUser = userRepository.findByEmail(request.getEmail());
//         if (existingUser.isPresent()) {
//             log.warn("Email already exists: {}", request.getEmail());
//             throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already exists! Please use a different email.");
//         }
    
//         // Prevent registration with ADMIN role
//         if ("ADMIN".equalsIgnoreCase(request.getRole()) || "ROLE_ADMIN".equalsIgnoreCase(request.getRole())) {
//             log.warn("Attempt to register with ADMIN role: {}", request.getEmail());
//             throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You cannot register as an ADMIN.");
//         }
    
//         User user = new User();
//         user.setEmail(request.getEmail());
//         user.setPassword(passwordEncoder.encode(request.getPassword()));
    
//         // Ensure name is not null or empty
//         if (request.getName() == null || request.getName().trim().isEmpty()) {
//             user.setName("Unknown"); // Default value if no name is provided
//         } else {
//             user.setName(request.getName());
//         }
    
//         // Set default role to STUDENT if not specified or invalid role
//         String role = request.getRole() != null && !request.getRole().equalsIgnoreCase("ADMIN") 
//                         ? request.getRole() 
//                         : "STUDENT";
//         user.setRole(role);
    
//         userRepository.save(user);
//         log.info("User registered successfully: {}", user.getEmail());
    
//         return "User registered successfully!";
//     }
    


//     public String login(LoginRequest request) {
//         log.info("Login attempt for email: {}", request.getEmail());
    
//         // Find user in the database
//         Optional<User> userOpt = userRepository.findByEmail(request.getEmail());
//         if (userOpt.isEmpty()) {
//             log.warn("User not found: {}", request.getEmail());
//             throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials!");
//         }
    
//         User user = userOpt.get();
    
//         // Verify password
//         if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
//             log.warn("Invalid password for user: {}", request.getEmail());
//             throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials!");
//         }
    
//         // Generate JWT token using the correct method
//         String token = jwtUtil.generateJwtToken(user.getEmail(), user.getRole());
//         log.info("Login successful for: {} with role: {}", request.getEmail(), user.getRole());
    
//         return token;
//     }
    
    
// }


///////////////
/// package com.example.ProjectFinalYear.service;

import com.example.ProjectFinalYear.dtos.LoginRequest;
import com.example.ProjectFinalYear.dtos.RegisterRequest;
import com.example.ProjectFinalYear.model.User;
import com.example.ProjectFinalYear.repositories.UserRepository;
import com.example.ProjectFinalYear.security.JwtUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@Slf4j
@Service
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    // Register user (Student or Staff)
    public String registerUser(RegisterRequest request) {
        log.info("Registering user: {}", request.getEmail());

        Optional<User> existingUser = userRepository.findByEmail(request.getEmail());
        if (existingUser.isPresent()) {
            log.warn("Email already exists: {}", request.getEmail());
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already exists! Please use a different email.");
        }

        // Prevent direct registration as ADMIN
        if ("ADMIN".equalsIgnoreCase(request.getRole()) || "ROLE_ADMIN".equalsIgnoreCase(request.getRole())) {
            log.warn("Attempt to register with ADMIN role: {}", request.getEmail());
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You cannot register as an ADMIN.");
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        // Set default name if not provided
        user.setName(request.getName() != null && !request.getName().trim().isEmpty() ? request.getName() : "Unknown");

        // Allow only STUDENT or STAFF roles
        String role = request.getRole() != null && (request.getRole().equalsIgnoreCase("STAFF") || request.getRole().equalsIgnoreCase("STUDENT"))
                ? request.getRole()
                : "STUDENT";
        user.setRole(role);

        userRepository.save(user);
        log.info("User registered successfully: {} as {}", user.getEmail(), user.getRole());

        return "User registered successfully!";
    }


    // Register staff (Admins only)
    public String registerStaff(RegisterRequest request) {
        log.info("Registering staff: {}", request.getEmail());

        Optional<User> existingUser = userRepository.findByEmail(request.getEmail());
        if (existingUser.isPresent()) {
            log.warn("Email already exists: {}", request.getEmail());
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already exists! Please use a different email.");
        }

        // Ensure staff role is assigned properly
        if (!"STAFF".equalsIgnoreCase(request.getRole())) {
            request.setRole("STAFF"); // Force role to STAFF
        }

        User staff = new User();
        staff.setName(request.getName());
        staff.setEmail(request.getEmail());
        staff.setPassword(passwordEncoder.encode(request.getPassword()));
        staff.setRole("STAFF");  // ✅ Ensure this is set correctly
        userRepository.save(staff);
        
        log.info("Staff registered successfully: {}", staff.getEmail());

        return "Staff registered successfully!";
    }


    // User login (Student or Staff)
    // public String login(LoginRequest request) {
    //     log.info("Login attempt for email: {}", request.getEmail());

    //     Optional<User> userOpt = userRepository.findByEmail(request.getEmail());
    //     if (userOpt.isEmpty()) {
    //         log.warn("User not found: {}", request.getEmail());
    //         throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials!");
    //     }

    //     User user = userOpt.get();

    //     // Verify password
    //     if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
    //         log.warn("Invalid password for user: {}", request.getEmail());
    //         throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials!");
    //     }

    //     // Generate JWT token
    //     String token = jwtUtil.generateJwtToken(user.getEmail(), user.getRole());
    //     log.info("Login successful for: {} with role: {}", request.getEmail(), user.getRole());

    //     return token;
    // }


    public String login(LoginRequest request) {
        log.info("Login attempt for email: {}", request.getEmail());
    
        Optional<User> userOpt = userRepository.findByEmail(request.getEmail());
        if (userOpt.isEmpty()) {
            log.warn("User not found: {}", request.getEmail());
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials!");
        }
    
        User user = userOpt.get();
    
        // Verify password
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            log.warn("Invalid password for user: {}", request.getEmail());
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials!");
        }
    
        // Role-based login handling
        String role = user.getRole().toUpperCase();
        if (!role.equals("STUDENT") && !role.equals("STAFF") && !role.equals("ADMIN")) {
            log.warn("Unauthorized role attempt: {}", role);
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Invalid role access!");
        }
    
        // Generate JWT token
        String token = jwtUtil.generateJwtToken(user.getEmail(), user.getRole());
        log.info("Login successful for: {} with role: {}", request.getEmail(), user.getRole());
    
        return token;
    }
    
}
