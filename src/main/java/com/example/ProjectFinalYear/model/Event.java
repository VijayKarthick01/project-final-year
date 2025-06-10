package com.example.ProjectFinalYear.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "events")
@Data
public class Event {
    @Id
    private String id;
    private String title;
    private String description;
    private String date; // Format: YYYY-MM-DD
}
