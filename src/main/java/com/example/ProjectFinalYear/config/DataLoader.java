package com.example.ProjectFinalYear.config;

import com.example.ProjectFinalYear.model.User;
import com.example.ProjectFinalYear.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class DataLoader {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public CommandLineRunner initStaffUsers() {
        return args -> {
            String defaultEmail = "staff1@college.com";
            if (userRepository.findByEmail(defaultEmail).isEmpty()) {
                User staff = new User();
                staff.setName("Default Staff");
                staff.setEmail(defaultEmail);
                staff.setPassword(passwordEncoder.encode("password123")); // 🔐 Set a strong password in real use
                staff.setRole("STAFF");
                userRepository.save(staff);
                log.info("Default staff user created: {}", defaultEmail);
            } else {
                log.info("Default staff user already exists: {}", defaultEmail);
            }
        };
    }
}
