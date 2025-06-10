package com.example.ProjectFinalYear.model;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterFormField {
    private String id;
    private String fieldName;
    private String type;  // text, email, password, dropdown
    private String hintText;
    private String label;
    private boolean required;
    private List<String> options; // For dropdowns
}
