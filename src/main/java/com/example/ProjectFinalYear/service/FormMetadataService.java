package com.example.ProjectFinalYear.service;

import com.example.ProjectFinalYear.model.RegisterFormField;
import com.example.ProjectFinalYear.model.LoginFormField;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Arrays;

@Service
public class FormMetadataService {
    public List<RegisterFormField> getRegisterFormFields() {
        return Arrays.asList(
            new RegisterFormField("id1", "name", "text", "Enter your name", "Name", true, null),
            new RegisterFormField("id2", "email", "email", "Enter your email", "Email", true, null),
            new RegisterFormField("id3", "password", "password", "Enter a strong password", "Password", true, null),
            new RegisterFormField("id4", "role", "dropdown", "Select your role", "Role", true, 
                Arrays.asList("STUDENT")) // Dropdown options for roles
        );
    }

    public List<LoginFormField> getLoginFormFields() {
        return Arrays.asList(
            new LoginFormField("id5", "email", "email", "Enter your email", "Email", true),
            new LoginFormField("id6", "password", "password", "Enter your password", "Password", true)
        );
    }
}
