// package com.example.ProjectFinalYear.service;

// import com.example.ProjectFinalYear.model.User;
// import com.example.ProjectFinalYear.repositories.UserRepository;
// import io.jsonwebtoken.Claims;
// import io.jsonwebtoken.Jwts;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.stereotype.Service;

// import java.util.HashMap;
// import java.util.List;
// import java.util.Map;

// @Service
// public class AdminService {

//     private final UserRepository userRepository;

//     @Value("${jwt.secret}") // Ensure this is set in application.properties
//     private String jwtSecret;

//     public AdminService(UserRepository userRepository) {
//         this.userRepository = userRepository;
//     }

//     // Get all users
//     public List<User> getAllUsers() {
//         return userRepository.findAll();
//     }

//     // Activate or Deactivate a User
//     public String updateUserStatus(String userId, boolean isActive) {
//         User user = userRepository.findById(userId)
//                 .orElseThrow(() -> new RuntimeException("User not found"));

//         user.setActive(isActive);
//         userRepository.save(user);

//         return "User status updated successfully!";
//     }

//     // Delete a User
//     public String deleteUser(String userId) {
//         if (!userRepository.existsById(userId)) {
//             throw new RuntimeException("User not found");
//         }
//         userRepository.deleteById(userId);
//         return "User deleted successfully!";
//     }

//     // Dashboard Statistics
//     public Map<String, Object> getDashboardStats() {
//         long totalUsers = userRepository.count();
//         long activeUsers = userRepository.countByIsActive(true); // Ensure this method exists in UserRepository
//         long inactiveUsers = totalUsers - activeUsers;

//         Map<String, Object> stats = new HashMap<>();
//         stats.put("totalUsers", totalUsers);
//         stats.put("activeUsers", activeUsers);
//         stats.put("inactiveUsers", inactiveUsers);

//         return stats;
//     }

//     // Extract user role from JWT token
//     public String getUserRoleFromToken(String token) {
//         try {
//             Claims claims = Jwts.parser()
//                     .setSigningKey(jwtSecret.getBytes())
//                     .parseClaimsJws(token.replace("Bearer ", ""))
//                     .getBody();

//             return claims.get("role", String.class); // Extracts role from JWT
//         } catch (Exception e) {
//             return "UNKNOWN";
//         }
//     }
// }
package com.example.ProjectFinalYear.service;

import com.example.ProjectFinalYear.model.User;
import com.example.ProjectFinalYear.repositories.UserRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {

    private final UserRepository userRepository;

    @Value("${jwt.secret}") // Ensure this is set in application.properties
    private String jwtSecret;

    public AdminService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Get all users
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    public String promoteUserToAdmin(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            throw new RuntimeException("User is already an ADMIN.");
        }

        user.setRole("ADMIN");
        userRepository.save(user);
        return "User promoted to ADMIN successfully!";
    }
    // Activate or Deactivate a User
    public String updateUserStatus(String userId, boolean isActive) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setActive(isActive);
        userRepository.save(user);

        return "User status updated successfully!";
    }

    // Delete a User
    public String deleteUser(String userId) {
        if (!userRepository.existsById(userId)) {
            throw new RuntimeException("User not found");
        }
        userRepository.deleteById(userId);
        return "User deleted successfully!";
    }

    // Dashboard Statistics
    public Map<String, Object> getDashboardStats() {
        long totalUsers = userRepository.count();
        long activeUsers = userRepository.countByIsActive(true); // Ensure this method exists in UserRepository
        long inactiveUsers = totalUsers - activeUsers;

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", totalUsers);
        stats.put("activeUsers", activeUsers);
        stats.put("inactiveUsers", inactiveUsers);

        return stats;
    }

    // Extract user role from JWT token
// ✅ Extract user role from JWT token
public String getUserRoleFromToken(String token) {
    try {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8)))
                .build()
                .parseClaimsJws(token.replace("Bearer ", ""))
                .getBody();

        String role = claims.get("role", String.class);
        System.out.println("✅ Extracted Role from Token: " + role); // ✅ Print role for debugging
        return role;
    } catch (ExpiredJwtException e) {
        System.out.println("❌ JWT Token expired on: " + e.getClaims().getExpiration());
        return "EXPIRED";
    } catch (Exception e) {
        System.out.println("❌ ERROR: " + e.getMessage());
        return "ERROR";
    }
}

}

