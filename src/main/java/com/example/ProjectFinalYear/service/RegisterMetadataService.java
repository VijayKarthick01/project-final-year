package com.example.ProjectFinalYear.service;



import com.example.ProjectFinalYear.model.RegisterFormField;
import com.example.ProjectFinalYear.repositories.RegisterMetadataRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RegisterMetadataService {
    private final RegisterMetadataRepository repository;

    public RegisterMetadataService(RegisterMetadataRepository repository) {
        this.repository = repository;
    }

    public List<RegisterFormField> getRegisterMetadata() {
        return repository.findAll();
    }
}

