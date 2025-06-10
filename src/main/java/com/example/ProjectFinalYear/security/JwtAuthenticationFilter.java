// package com.example.ProjectFinalYear.security;

// import jakarta.servlet.FilterChain;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import lombok.extern.slf4j.Slf4j;
// import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
// import org.springframework.security.core.context.SecurityContextHolder;
// import org.springframework.security.core.userdetails.UserDetails;
// import org.springframework.security.core.userdetails.UserDetailsService;
// import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
// import org.springframework.web.filter.OncePerRequestFilter;
// import java.io.IOException;

// @Slf4j
// public class JwtAuthenticationFilter extends OncePerRequestFilter {

//     private final JwtUtil jwtUtil;
//     private final UserDetailsService userDetailsService;

//     public JwtAuthenticationFilter(JwtUtil jwtUtil, UserDetailsService userDetailsService) {
//         this.jwtUtil = jwtUtil;
//         this.userDetailsService = userDetailsService;
//     }

//     @Override
//     protected void doFilterInternal(
//         HttpServletRequest request, 
//         HttpServletResponse response, 
//         FilterChain filterChain
//     ) throws ServletException, IOException {
        
//         String token = getTokenFromRequest(request);

//         if (token == null) {
//             log.warn("❌ JWT Token is missing in request");
//             filterChain.doFilter(request, response);
//             return;
//         }

//         String username = jwtUtil.extractUsername(token);

//         if (username == null) {
//             log.error("❌ Invalid JWT token: Unable to extract username");
//             filterChain.doFilter(request, response);
//             return;
//         }

//         if (SecurityContextHolder.getContext().getAuthentication() == null) {
//             UserDetails userDetails = userDetailsService.loadUserByUsername(username);

//             if (jwtUtil.validateToken(token, userDetails.getUsername())) { // ✅ FIXED
//                 UsernamePasswordAuthenticationToken authentication = 
//                     new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
//                 authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

//                 SecurityContextHolder.getContext().setAuthentication(authentication);
//                 log.info("✅ User {} authenticated successfully!", username);
//             } else {
//                 log.warn("❌ JWT Token is invalid or expired");
//             }
//         }

//         filterChain.doFilter(request, response);
//     }

//     private String getTokenFromRequest(HttpServletRequest request) {
//         String authHeader = request.getHeader("Authorization");
//         if (authHeader != null && authHeader.startsWith("Bearer ")) {
//             return authHeader.substring(7); // Remove "Bearer " prefix
//         }
//         return null;
//     }
// }
////////////////
// package com.example.ProjectFinalYear.security;

// import jakarta.servlet.FilterChain;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import lombok.extern.slf4j.Slf4j;
// import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
// import org.springframework.security.core.context.SecurityContextHolder;
// import org.springframework.security.core.userdetails.UserDetails;
// import org.springframework.security.core.userdetails.UserDetailsService;
// import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
// import org.springframework.web.filter.OncePerRequestFilter;
// import io.jsonwebtoken.ExpiredJwtException;
// import java.io.IOException;

// @Slf4j
// public class JwtAuthenticationFilter extends OncePerRequestFilter {

//     private final JwtUtil jwtUtil;
//     private final UserDetailsService userDetailsService;

//     public JwtAuthenticationFilter(JwtUtil jwtUtil, UserDetailsService userDetailsService) {
//         this.jwtUtil = jwtUtil;
//         this.userDetailsService = userDetailsService;
//     }

//     @Override
//     protected void doFilterInternal(
//         HttpServletRequest request, 
//         HttpServletResponse response, 
//         FilterChain filterChain
//     ) throws ServletException, IOException {
        
//         String token = getTokenFromRequest(request);

//         if (token == null) {
//             log.warn("❌ JWT Token is missing in request");
//             filterChain.doFilter(request, response);
//             return;
//         }

//         String username = null;
//         try {
//             username = jwtUtil.extractUsername(token);
//         } catch (ExpiredJwtException e) {
//             log.error("❌ JWT Token expired at: {}", e.getClaims().getExpiration());
//             filterChain.doFilter(request, response);
//             return;
//         } catch (Exception e) {
//             log.error("❌ Invalid JWT token: {}", e.getMessage());
//             filterChain.doFilter(request, response);
//             return;
//         }

//         if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
//             UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            
//             if (jwtUtil.validateToken(token, userDetails.getUsername())) {
//                 UsernamePasswordAuthenticationToken authentication = 
//                     new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
//                 authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                
//                 SecurityContextHolder.getContext().setAuthentication(authentication);
//                 log.info("✅ User '{}' authenticated successfully with roles: {}", username, userDetails.getAuthorities());
//             } else {
//                 log.warn("❌ JWT Token is invalid or expired");
//             }
//         }

//         filterChain.doFilter(request, response);
//     }

//     private String getTokenFromRequest(HttpServletRequest request) {
//         String authHeader = request.getHeader("Authorization");
//         if (authHeader != null && authHeader.startsWith("Bearer ")) {
//             return authHeader.substring(7); // Remove "Bearer " prefix
//         }
//         return null;
//     }
// }
package com.example.ProjectFinalYear.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

@Slf4j
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtUtil jwtUtil, UserDetailsService userDetailsService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(
        HttpServletRequest request, 
        HttpServletResponse response, 
        FilterChain filterChain
    ) throws ServletException, IOException {
        try {
            // ✅ Skip authentication for login and public routes
            if (shouldNotFilter(request)) {
                filterChain.doFilter(request, response);
                return;
            }

            String token = getTokenFromRequest(request);
            if (token == null) {
                log.debug("ℹ️ No JWT token found in request");
                filterChain.doFilter(request, response);
                return;
            }

            String username = jwtUtil.extractUsername(token);
            if (username == null) {
                log.error("❌ Invalid JWT: Cannot extract username");
                filterChain.doFilter(request, response);
                return;
            }

            if (SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                if (jwtUtil.validateToken(token, userDetails.getUsername())) {
                    UsernamePasswordAuthenticationToken authentication = 
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    log.info("✅ Extracted Role: {}", userDetails.getAuthorities());

                } else {
                    log.warn("❌ JWT Token invalid or expired");
                }
            }
        } catch (Exception e) {
            log.error("❌ Authentication error: {}", e.getMessage(), e);
        }

        filterChain.doFilter(request, response);
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7); // Remove "Bearer " prefix
        }
        return null;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/api/auth/login") || path.startsWith("/api/public");
    }
}
