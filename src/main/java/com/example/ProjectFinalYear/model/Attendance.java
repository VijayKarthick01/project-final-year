package com.example.ProjectFinalYear.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "attendance")
@Data
public class Attendance {
    @Id
    private String id;
    private String studentId;
    private String date;  // Format: YYYY-MM-DD
    private String status; // Present, Absent, Late
    private String section; // Section A, B, or C

}
