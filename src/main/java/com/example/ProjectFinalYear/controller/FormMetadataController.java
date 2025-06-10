package com.example.ProjectFinalYear.controller;

import com.example.ProjectFinalYear.model.RegisterFormField;
import com.example.ProjectFinalYear.model.LoginFormField;
import com.example.ProjectFinalYear.service.FormMetadataService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/form-metadata")
// @CrossOrigin(origins = "*") // Allows frontend to fetch data
@CrossOrigin(origins = "http://192.168.201.189:53696")
public class FormMetadataController {
    private final FormMetadataService formMetadataService;

    public FormMetadataController(FormMetadataService formMetadataService) {
        this.formMetadataService = formMetadataService;
    }

    @GetMapping("/register")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public List<RegisterFormField> getRegisterFormFields() {
        return formMetadataService.getRegisterFormFields();
    }

    @GetMapping("/login")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public List<LoginFormField> getLoginFormFields() {
        return formMetadataService.getLoginFormFields();
    }
}
