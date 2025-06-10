package com.example.ProjectFinalYear.repositories;


import com.example.ProjectFinalYear.model.RegisterFormField;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RegisterMetadataRepository extends MongoRepository<RegisterFormField, String> {
}


