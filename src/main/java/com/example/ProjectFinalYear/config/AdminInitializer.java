package com.example.ProjectFinalYear.config;

import com.example.ProjectFinalYear.model.User;
import com.example.ProjectFinalYear.repositories.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class AdminInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminInitializer(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        // Check if Admin exists, if not create one
        userRepository.findByEmail("admin1@college.com").ifPresentOrElse(
            admin -> System.out.println("Admin already exists."),
            () -> {
                User admin = new User();
                admin.setName("Admin");
                admin.setEmail("admin1@college.com");
                admin.setPassword(passwordEncoder.encode("admin1234")); // Default password
                admin.setRole("ROLE_ADMIN");
                userRepository.save(admin);
                System.out.println("Admin account created.");
            }
        );
    }
}
