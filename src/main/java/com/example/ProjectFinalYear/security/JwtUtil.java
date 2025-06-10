package com.example.ProjectFinalYear.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtUtil {

    @Value("${jwt.secret}") 
    private String secretKey;

    @Value("${jwt.expiration}")
    private long expirationTime;

    private Key signingKey;

    @PostConstruct
    public void init() {
        this.signingKey = Keys.hmacShaKeyFor(secretKey.getBytes());
    }

    public String generateJwtToken(String email, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role); // 🔹 No "ROLE_" prefix here

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    public String extractUsername(String token) {
        return extractAllClaims(token).getSubject();
    }
    public String extractRole(String token) {
        return extractAllClaims(token).get("role", String.class).trim(); // Return role as stored
    }
    
    

    public boolean validateToken(String token, String email) {
        try {
            return email.equals(extractUsername(token)) && !isTokenExpired(token);
        } catch (JwtException e) {
            System.out.println("❌ JWT Token error: " + e.getMessage());
        }
        return false;
    }

    private boolean isTokenExpired(String token) {
        return extractAllClaims(token).getExpiration().before(new Date());
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
