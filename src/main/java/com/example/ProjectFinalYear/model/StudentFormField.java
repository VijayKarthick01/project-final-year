package com.example.ProjectFinalYear.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.List;

@Data
@AllArgsConstructor
public class StudentFormField {
    private String id;
    private String name;
    private String type;
    private String hint;
    private String label;
    private boolean required;
    private List<String> options; // null if not a dropdown
}