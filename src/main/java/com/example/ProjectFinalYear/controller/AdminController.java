// package com.example.ProjectFinalYear.controller;

// import com.example.ProjectFinalYear.model.User;
// import com.example.ProjectFinalYear.service.AdminService;
// import org.springframework.http.ResponseEntity;
// import org.springframework.security.access.prepost.PreAuthorize;
// import org.springframework.web.bind.annotation.*;

// import java.util.List;
// import java.util.Map;

// @RestController
// @RequestMapping("/api/admin")
// @PreAuthorize("hasAuthority('ADMIN')")
// public class AdminController {

//     private final AdminService adminService;

//     public AdminController(AdminService adminService) {
//         this.adminService = adminService;
//     }
// // Check the role of the authenticated user
// @GetMapping("/check-role")
// public ResponseEntity<Map<String, String>> checkRole(@RequestHeader("Authorization") String token) {
//     // Extract role from the JWT token
//     String role = adminService.getUserRoleFromToken(token); // Implement this method in service
//     return ResponseEntity.ok(Map.of("role", role));
// }

//     // Get all users
//     @GetMapping("/users")
//     public ResponseEntity<List<User>> getAllUsers() {
//         return ResponseEntity.ok(adminService.getAllUsers());
//     }

//     // Approve or Block a User
//     @PutMapping("/users/{userId}/status")
//     public ResponseEntity<String> updateUserStatus(@PathVariable String userId, @RequestParam boolean isActive) {
//         return ResponseEntity.ok(adminService.updateUserStatus(userId, isActive));
//     }

//     // Delete a User
//     @DeleteMapping("/users/{userId}")
//     public ResponseEntity<String> deleteUser(@PathVariable String userId) {
//         return ResponseEntity.ok(adminService.deleteUser(userId));
//     }

//     // Get Dashboard Statistics
//     @GetMapping("/dashboard")
//     public ResponseEntity<Map<String, Object>> getDashboardStats() {
//         return ResponseEntity.ok(adminService.getDashboardStats());
//     }
// }
// package com.example.ProjectFinalYear.controller;

// import com.example.ProjectFinalYear.model.User;
// import com.example.ProjectFinalYear.service.AdminService;
// import org.springframework.http.ResponseEntity;
// import org.springframework.security.access.prepost.PreAuthorize;
// import org.springframework.web.bind.annotation.*;

// import java.util.List;
// import java.util.Map;

// @RestController
// @RequestMapping("/api/admin")
// @PreAuthorize("hasAuthority('ADMIN')") // ✅ Ensure correct role checking based on token format
// public class AdminController {

//     private final AdminService adminService;

//     public AdminController(AdminService adminService) {
//         this.adminService = adminService;
//     }

//     // Check the role of the authenticated user
//     @GetMapping("/check-role")
//     public ResponseEntity<Map<String, String>> checkRole(@RequestHeader("Authorization") String token) {
//         if (token != null && token.startsWith("Bearer ")) {
//             token = token.substring(7); // ✅ Remove "Bearer " prefix before processing
//         }
//         String role = adminService.getUserRoleFromToken(token);
//         return ResponseEntity.ok(Map.of("role", role));
//     }

//     // Get all users
//     @GetMapping("/users")
//     public ResponseEntity<List<User>> getAllUsers() {
//         return ResponseEntity.ok(adminService.getAllUsers());
//     }

//     // Approve or Block a User
//     @PutMapping("/users/{userId}/status")
//     public ResponseEntity<String> updateUserStatus(@PathVariable String userId, @RequestParam boolean isActive) {
//         return ResponseEntity.ok(adminService.updateUserStatus(userId, isActive));
//     }

//     // Delete a User
//     @DeleteMapping("/users/{userId}")
//     public ResponseEntity<String> deleteUser(@PathVariable String userId) {
//         return ResponseEntity.ok(adminService.deleteUser(userId));
//     }

//     // Get Dashboard Statistics
//     @GetMapping("/dashboard")
//     public ResponseEntity<Map<String, Object>> getDashboardStats() {
//         return ResponseEntity.ok(adminService.getDashboardStats());
//     }
// }

package com.example.ProjectFinalYear.controller;

import com.example.ProjectFinalYear.model.User;
import com.example.ProjectFinalYear.service.AdminService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasAuthority('ROLE_ADMIN')")
@CrossOrigin(origins = "http://192.168.201.189:53696") // ✅ Explicitly allow frontend
public class AdminController {
    
    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    // ✅ Check authenticated user's role
    @PutMapping("/users/{userId}/promote")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<String> promoteUserToAdmin(@PathVariable String userId) {
        return ResponseEntity.ok(adminService.promoteUserToAdmin(userId));
    }
    @GetMapping("/check-role")
    @CrossOrigin(origins = "http://192.168.201.189:53696") // ✅ Explicitly allow CORS for this endpoint
    public ResponseEntity<Map<String, String>> checkRole(@RequestHeader("Authorization") String token) {
        String jwtToken = token.replace("Bearer ", ""); // Remove "Bearer " prefix
        String role = adminService.getUserRoleFromToken(jwtToken);
        System.out.println("✅ Admin access confirmed!");

        return ResponseEntity.ok(Map.of("role", role));
    }

    // ✅ Get all users
    @GetMapping("/users")
    @CrossOrigin(origins = "http://192.168.201.189:53696") // ✅ Explicitly allow CORS for this endpoint
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok(adminService.getAllUsers());
    }

    // ✅ Approve or Block a User
    @PutMapping("/users/{userId}/status")
    @CrossOrigin(origins = "http://192.168.201.189:53696") // ✅ Explicitly allow CORS for this endpoint
    public ResponseEntity<String> updateUserStatus(@PathVariable String userId, @RequestParam boolean isActive) {
        return ResponseEntity.ok(adminService.updateUserStatus(userId, isActive));
    }

    // ✅ Delete a User
    @DeleteMapping("/users/{userId}")
    @CrossOrigin(origins = "http://192.168.201.189:53696") // ✅ Explicitly allow CORS for this endpoint
    public ResponseEntity<String> deleteUser(@PathVariable String userId) {
        return ResponseEntity.ok(adminService.deleteUser(userId));
    }

    // ✅ Get Dashboard Statistics
    @GetMapping("/dashboard")
    @CrossOrigin(origins = "http://192.168.201.189:53696") // ✅ Explicitly allow CORS for this endpoint
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        return ResponseEntity.ok(adminService.getDashboardStats());
    }
}
