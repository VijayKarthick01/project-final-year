package com.example.ProjectFinalYear.repositories;


import com.example.ProjectFinalYear.model.LoginFormField;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LoginMetadataRepository extends MongoRepository<LoginFormField, String> {
}
