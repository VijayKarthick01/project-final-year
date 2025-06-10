package com.example.ProjectFinalYear.model;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LoginFormField {
    private String id;
    private String fieldName;
    private String type;  // email, password
    private String hintText;
    private String label;
    private boolean required;
}
