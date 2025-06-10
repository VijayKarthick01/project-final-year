package com.example.ProjectFinalYear.security;

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// import org.springframework.security.config.http.SessionCreationPolicy;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
// import org.springframework.security.crypto.password.PasswordEncoder;
// import org.springframework.security.web.SecurityFilterChain;

// @Configuration
// @EnableWebSecurity
// public class SecurityConfig {

//     @Bean
//     public PasswordEncoder passwordEncoder() {
//         return new BCryptPasswordEncoder();
//     }

//     // @Bean
//     // public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//     //     http
//     //         .csrf().disable() // Disable CSRF for testing
//     //         .authorizeHttpRequests(auth -> auth
//     //             .requestMatchers("/api/form-metadata/**").permitAll() // Allow access to form metadata
//     //             .requestMatchers("/api/auth/**").permitAll() // Allow authentication APIs
//     //             .anyRequest().authenticated() // Protect other routes
//     //         )
//     //         .httpBasic(); // Use Basic Auth (or replace with JWT)

//     //     return http.build();
//     // }
//        @Bean
//     public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//         http
//             .csrf().disable() // Disable CSRF for APIs
//             .authorizeHttpRequests(auth -> auth
//                 .requestMatchers("/api/form-metadata/**", "/api/auth/**").permitAll() // Public routes
//                 .requestMatchers("/api/admin/**").hasRole("ADMIN") // Admin-only routes
//                 .requestMatchers("/api/student/**").hasRole("STUDENT") // Student-only routes
//                 .anyRequest().authenticated() // All other routes require authentication
//             )
//             .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // Stateless JWT authentication
//             .httpBasic(); // Use Basic Auth (or replace with JWT)

//         return http.build();
//     }
// }
///
/// package com.example.ProjectFinalYear.security;
/// //////

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.authentication.AuthenticationManager;
// import org.springframework.security.authentication.ProviderManager;
// import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
// import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// import org.springframework.security.config.http.SessionCreationPolicy;
// import org.springframework.security.core.userdetails.UserDetailsService;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
// import org.springframework.security.crypto.password.PasswordEncoder;
// import org.springframework.security.web.SecurityFilterChain;

// @Configuration
// @EnableWebSecurity
// public class SecurityConfig {

//     @Bean
//     public PasswordEncoder passwordEncoder() {
//         return new BCryptPasswordEncoder();
//     }

//     @Bean
//     public AuthenticationManager authenticationManager(UserDetailsService userDetailsService) {
//         DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
//         authProvider.setUserDetailsService(userDetailsService);
//         authProvider.setPasswordEncoder(passwordEncoder());
//         return new ProviderManager(authProvider);
//     }

//     @Bean
//     public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//         http
//             .csrf(csrf -> csrf.disable()) // Disable CSRF for APIs
//             .authorizeHttpRequests(auth -> auth
//                 .requestMatchers("/api/form-metadata/**", "/api/auth/**").permitAll() // Public routes
//                 .requestMatchers("/api/admin/**").hasAuthority("ADMIN") // Admin-only routes
//                 .requestMatchers("/api/student/**").hasAuthority("STUDENT") // Student-only routes
//                 .anyRequest().authenticated() // Protect other routes
//             )
//             .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)); // Stateless JWT authentication

//         return http.build();
//     }
// }

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(UserDetailsService userDetailsService) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return new ProviderManager(authProvider);
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.and()) // ✅ Explicitly allow CORS before security
            .csrf(csrf -> csrf.disable()) // ❌ Disable CSRF for REST API
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**", "/api/form-metadata/**").permitAll() // 🔹 Public endpoints
                .requestMatchers("/api/auth/**", "/api/staff/forms/**").permitAll()
                .requestMatchers("/api/auth/**", "/api/student-form/**").permitAll() 
                // 🔹 Public endpoints
                 .requestMatchers("/api/student/**").hasAuthority("STUDENT")

                .requestMatchers("/api/admin/**").hasAuthority("ROLE_ADMIN") // ✅ Secure admin routes
                .requestMatchers("/api/staff/**").hasAuthority("STAFF") // ✅ Secure staff routes (Fixed)
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class); // ✅ Ensure JWT Filter is before authentication
    
        return http.build();
    }
    
    

    // @Bean
    // public CorsFilter corsFilter() {
    //     UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    //     CorsConfiguration config = new CorsConfiguration();
    //     config.setAllowCredentials(true);
    //     config.setAllowedOrigins(List.of("http://localhost:62153")); // ✅ Explicitly allow frontend
    //     config.setAllowedHeaders(List.of("*"));
    //     config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    //     source.registerCorsConfiguration("/**", config);
    //     return new CorsFilter(source);
    // }
   @Bean
public CorsFilter corsFilter() {
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowCredentials(true);
    config.setAllowedOriginPatterns(List.of("*")); // allow all origins for development
    config.setAllowedHeaders(List.of("*"));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    source.registerCorsConfiguration("/**", config);
    return new CorsFilter(source);
}


}
