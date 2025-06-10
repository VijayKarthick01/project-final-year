package com.example.ProjectFinalYear.controller;

import com.example.ProjectFinalYear.model.StudentFormField;
import com.example.ProjectFinalYear.service.StudentFormMetadataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
@RequestMapping("/api/student-form")

@RestController
public class StudentFormMetadataController {

    @Autowired
    private StudentFormMetadataService formMetadataService;

    @GetMapping("/student/complaint")
    public List<StudentFormField> getComplaintFormFields() {
        return formMetadataService.getComplaintFormFields();
    }
}
