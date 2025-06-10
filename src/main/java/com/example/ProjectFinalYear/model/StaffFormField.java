package com.example.ProjectFinalYear.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.List;

@Data
@AllArgsConstructor
public class StaffFormField {
    private String id;
    private String name;
    private String type; // text, dropdown, checkbox, etc.
    private String placeholder;
    private String label;
    private boolean required;
    private List<String> options; // For dropdowns and checkboxes
}
    