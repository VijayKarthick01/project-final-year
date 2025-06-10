package com.example.ProjectFinalYear.service;


import com.example.ProjectFinalYear.model.LoginFormField;
import com.example.ProjectFinalYear.repositories.LoginMetadataRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LoginMetadataService {
    private final LoginMetadataRepository repository;

    public LoginMetadataService(LoginMetadataRepository repository) {
        this.repository = repository;
    }

    public List<LoginFormField> getLoginMetadata() {
        return repository.findAll();
    }
}
