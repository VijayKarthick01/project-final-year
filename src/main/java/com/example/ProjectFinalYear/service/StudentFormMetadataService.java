package com.example.ProjectFinalYear.service;

import com.example.ProjectFinalYear.model.StudentFormField;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class StudentFormMetadataService {

    public List<StudentFormField> getComplaintFormFields() {
        return Arrays.asList(
            new StudentFormField("field1", "studentId", "text", "Enter your Student ID", "Student ID", true, null),
            new StudentFormField("field2", "message", "textarea", "Describe your complaint", "Complaint Message", true, null)
        );
    }
}
