package com.example.ProjectFinalYear.repositories;

import com.example.ProjectFinalYear.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);

    // New method to count active users
    long countByIsActive(boolean isActive);
}
