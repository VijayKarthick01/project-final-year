// package com.example.ProjectFinalYear.config;

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.web.servlet.config.annotation.CorsRegistry;
// import org.springframework.web.servlet.config.annotation.EnableWebMvc;
// import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
// @Configuration
// @EnableWebMvc
// public class corsconfig {
//     @Bean
//     public WebMvcConfigurer corsConfigurer() {
//         return new WebMvcConfigurer() {
//             @Override
//             public void addCorsMappings(CorsRegistry registry) {
//                 // registry.addMapping("/**")
//                 //         .allowedOrigins(
//                 //             "http://localhost:62153", // ✅ Localhost
//                 //             "http://192.168.201.189:62153" // ✅ IP address (if frontend runs with IP)
//                 //         )
//                 //         .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
//                 //         .allowedHeaders("*")
//                 //         .allowCredentials(true); // ✅ Allow credentials (JWT)
//                 registry.addMapping("/**")
//         .allowedOrigins("*")  // allow all origins (for dev only)
//         .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
//         .allowedHeaders("*")
//         .allowCredentials(true);

//             }
//         };
//     }
// }
package com.example.ProjectFinalYear.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
public class corsconfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                    .allowedOriginPatterns("*")  // allow all origins with credentials
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                    .allowedHeaders("*")
                    .allowCredentials(true);
            }
        };
    }
}

