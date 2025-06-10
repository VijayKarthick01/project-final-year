package com.example.ProjectFinalYear.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "users")
public class User {
    @Id
    private String id;
     @Field("name") // Ensures proper mapping in MongoDB
    private String name;
    private String email;
    private String password;
    private String role;
    private boolean isActive = true; // Default to active
    
}
